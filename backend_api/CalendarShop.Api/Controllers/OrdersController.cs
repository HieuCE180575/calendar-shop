using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class OrdersController : AppControllerBase
{
    private readonly AppDbContext _db;

    public OrdersController(AppDbContext db)
    {
        _db = db;
    }

    [HttpPost]
    public async Task<ActionResult<OrderDto>> Create(CreateOrderRequest request)
    {
        var cartItems = await _db.CartItems
            .Include(x => x.Product)
            .Where(x => x.UserId == CurrentUserId && x.IsSelected)
            .ToListAsync();

        if (!cartItems.Any()) return BadRequest("Giỏ hàng chưa chọn sản phẩm.");

        foreach (var item in cartItems)
        {
            if (item.Product == null || item.Product.Status != "Active" || item.Product.IsDeleted)
                return BadRequest($"Sản phẩm {item.ProductId} không khả dụng.");
            if (item.Product.StockQuantity < item.Quantity)
                return BadRequest($"Sản phẩm {item.Product.ProductName} không đủ tồn kho.");
        }

        var subTotal = cartItems.Sum(x => x.Product!.Price * x.Quantity);
        decimal discountAmount = 0;
        Coupon? coupon = null;

        if (!string.IsNullOrWhiteSpace(request.CouponCode))
        {
            coupon = await _db.Coupons.FirstOrDefaultAsync(x => x.Code == request.CouponCode && x.Status == "Active");
            if (coupon == null) return BadRequest("Mã giảm giá không hợp lệ.");
            if (DateTime.UtcNow < coupon.StartDate || DateTime.UtcNow > coupon.EndDate) return BadRequest("Mã giảm giá đã hết hạn hoặc chưa có hiệu lực.");
            if (subTotal < coupon.MinOrderValue) return BadRequest("Đơn hàng chưa đạt giá trị tối thiểu.");
            if (coupon.UsageLimit.HasValue && coupon.UsedCount >= coupon.UsageLimit.Value) return BadRequest("Mã giảm giá đã hết lượt sử dụng.");

            discountAmount = coupon.DiscountType == "Percent"
                ? subTotal * coupon.DiscountValue / 100
                : coupon.DiscountValue;
        }

        var shippingFee = subTotal >= 300000 ? 0 : 30000;
        var order = new Order
        {
            UserId = CurrentUserId,
            CouponId = coupon?.CouponId,
            CustomerName = request.CustomerName,
            CustomerPhone = request.CustomerPhone,
            ShippingAddress = request.ShippingAddress,
            SubTotal = subTotal,
            DiscountAmount = discountAmount,
            ShippingFee = shippingFee,
            TotalAmount = subTotal - discountAmount + shippingFee,
            PaymentMethod = request.PaymentMethod,
            Status = "Pending",
            Note = request.Note
        };

        foreach (var item in cartItems)
        {
            var product = item.Product!;
            order.OrderItems.Add(new OrderItem
            {
                ProductId = product.ProductId,
                ProductName = product.ProductName,
                ProductImageUrl = product.ImageUrl,
                UnitPrice = product.Price,
                Quantity = item.Quantity,
                TotalPrice = product.Price * item.Quantity
            });

            product.StockQuantity -= item.Quantity;
            if (product.StockQuantity <= 0) product.Status = "OutOfStock";
        }

        if (coupon != null) coupon.UsedCount++;
        _db.Orders.Add(order);
        _db.CartItems.RemoveRange(cartItems);
        await _db.SaveChangesAsync();

        return Ok(await GetOrderDto(order.OrderId));
    }

    [HttpGet("mine")]
    public async Task<ActionResult<List<OrderDto>>> Mine()
    {
        var orders = await _db.Orders
            .Include(x => x.OrderItems)
            .Where(x => x.UserId == CurrentUserId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        return Ok(orders.Select(ToDto).ToList());
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<OrderDto>> GetById(int id)
    {
        var order = await _db.Orders
            .Include(x => x.OrderItems)
            .FirstOrDefaultAsync(x => x.OrderId == id && x.UserId == CurrentUserId);
        if (order == null) return NotFound();
        return Ok(ToDto(order));
    }

    [HttpPut("{id:int}/cancel")]
    public async Task<IActionResult> Cancel(int id, CancelOrderRequest request)
    {
        var order = await _db.Orders.Include(x => x.OrderItems).FirstOrDefaultAsync(x => x.OrderId == id && x.UserId == CurrentUserId);
        if (order == null) return NotFound();
        if (order.Status != "Pending") return BadRequest("Chỉ được hủy đơn khi đơn đang Pending.");

        order.Status = "Cancelled";
        order.CancelReason = request.Reason;
        order.UpdatedAt = DateTime.UtcNow;

        foreach (var item in order.OrderItems)
        {
            var product = await _db.Products.FindAsync(item.ProductId);
            if (product != null)
            {
                product.StockQuantity += item.Quantity;
                if (product.Status == "OutOfStock") product.Status = "Active";
            }
        }

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpGet("admin")]
    public async Task<ActionResult<List<OrderDto>>> AdminGetAll(string? status, string? search)
    {
        var query = _db.Orders.Include(x => x.OrderItems).AsQueryable();
        if (!string.IsNullOrWhiteSpace(status)) query = query.Where(x => x.Status == status);
        if (!string.IsNullOrWhiteSpace(search)) query = query.Where(x => x.CustomerName.Contains(search) || x.CustomerPhone.Contains(search));
        var orders = await query.OrderByDescending(x => x.CreatedAt).ToListAsync();
        return Ok(orders.Select(ToDto).ToList());
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("admin/{id:int}/status")]
    public async Task<IActionResult> AdminUpdateStatus(int id, UpdateOrderStatusRequest request)
    {
        var order = await _db.Orders.FindAsync(id);
        if (order == null) return NotFound();

        var valid = (order.Status, request.Status) switch
        {
            ("Pending", "Confirmed") => true,
            ("Confirmed", "Shipping") => true,
            ("Shipping", "Delivered") => true,
            ("Pending", "Cancelled") => true,
            _ => false
        };

        if (!valid) return BadRequest($"Không thể chuyển trạng thái từ {order.Status} sang {request.Status}.");
        order.Status = request.Status;
        order.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    private async Task<OrderDto> GetOrderDto(int orderId)
    {
        var order = await _db.Orders.Include(x => x.OrderItems).FirstAsync(x => x.OrderId == orderId);
        return ToDto(order);
    }

    private static OrderDto ToDto(Order order)
    {
        return new OrderDto(
            order.OrderId,
            order.UserId,
            order.CustomerName,
            order.CustomerPhone,
            order.ShippingAddress,
            order.SubTotal,
            order.DiscountAmount,
            order.ShippingFee,
            order.TotalAmount,
            order.PaymentMethod,
            order.Status,
            order.Note,
            order.CreatedAt,
            order.OrderItems.Select(i => new OrderItemDto(i.OrderItemId, i.ProductId, i.ProductName, i.ProductImageUrl, i.UnitPrice, i.Quantity, i.TotalPrice)).ToList()
        );
    }
}
