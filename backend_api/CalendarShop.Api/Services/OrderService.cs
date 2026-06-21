using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class OrderService : IOrderService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public OrderService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<OrderDto> CreateOrderAsync(int userId, CreateOrderRequest request)
    {
        var cartItems = await _db.CartItems
            .Include(x => x.Product)
            .Where(x => x.UserId == userId && x.IsSelected)
            .ToListAsync();

        if (!cartItems.Any())
        {
            throw new BadHttpRequestException("Giỏ hàng chưa chọn sản phẩm.");
        }

        foreach (var item in cartItems)
        {
            if (item.Product == null || item.Product.Status != "Active" || item.Product.IsDeleted)
            {
                throw new BadHttpRequestException($"Sản phẩm {item.ProductId} không khả dụng.");
            }
            if (item.Product.StockQuantity < item.Quantity)
            {
                throw new BadHttpRequestException($"Sản phẩm {item.Product.ProductName} không đủ tồn kho.");
            }
        }

        var subTotal = cartItems.Sum(x => x.Product!.Price * x.Quantity);
        decimal discountAmount = 0;
        Coupon? coupon = null;

        if (!string.IsNullOrWhiteSpace(request.CouponCode))
        {
            coupon = await _db.Coupons.FirstOrDefaultAsync(x => x.Code == request.CouponCode && x.Status == "Active");
            if (coupon == null)
            {
                throw new BadHttpRequestException("Mã giảm giá không hợp lệ.");
            }
            if (DateTime.UtcNow < coupon.StartDate || DateTime.UtcNow > coupon.EndDate)
            {
                throw new BadHttpRequestException("Mã giảm giá đã hết hạn hoặc chưa có hiệu lực.");
            }
            if (subTotal < coupon.MinOrderValue)
            {
                throw new BadHttpRequestException("Đơn hàng chưa đạt giá trị tối thiểu.");
            }
            if (coupon.UsageLimit.HasValue && coupon.UsedCount >= coupon.UsageLimit.Value)
            {
                throw new BadHttpRequestException("Mã giảm giá đã hết lượt sử dụng.");
            }

            discountAmount = coupon.DiscountType == "Percent"
                ? subTotal * coupon.DiscountValue / 100
                : coupon.DiscountValue;
        }

        var shippingFee = subTotal >= 300000 ? 0 : 30000;
        var order = new Order
        {
            UserId = userId,
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
            if (product.StockQuantity <= 0)
            {
                product.Status = "OutOfStock";
            }
        }

        if (coupon != null)
        {
            coupon.UsedCount++;
        }

        _db.Orders.Add(order);
        _db.CartItems.RemoveRange(cartItems);
        await _db.SaveChangesAsync();

        return await GetOrderByIdAsync(userId, order.OrderId);
    }

    public IQueryable<OrderDto> GetMyOrdersQuery(int userId)
    {
        return _db.Orders
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<OrderDto>(_mapper.ConfigurationProvider);
    }

    public async Task<OrderDto> GetOrderByIdAsync(int userId, int id)
    {
        var order = await _db.Orders
            .Where(x => x.OrderId == id && x.UserId == userId)
            .ProjectTo<OrderDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (order == null)
        {
            throw new KeyNotFoundException("Không tìm thấy đơn hàng.");
        }

        return order;
    }

    public async Task CancelOrderAsync(int userId, int id, CancelOrderRequest request)
    {
        var order = await _db.Orders.Include(x => x.OrderItems).FirstOrDefaultAsync(x => x.OrderId == id && x.UserId == userId);
        if (order == null)
        {
            throw new KeyNotFoundException("Không tìm thấy đơn hàng.");
        }
        if (order.Status != "Pending")
        {
            throw new BadHttpRequestException("Chỉ được hủy đơn khi đơn đang Pending.");
        }

        order.Status = "Cancelled";
        order.CancelReason = request.Reason;
        order.UpdatedAt = DateTime.UtcNow;

        foreach (var item in order.OrderItems)
        {
            var product = await _db.Products.FindAsync(item.ProductId);
            if (product != null)
            {
                product.StockQuantity += item.Quantity;
                if (product.Status == "OutOfStock")
                {
                    product.Status = "Active";
                }
            }
        }

        await _db.SaveChangesAsync();
    }

    public IQueryable<OrderDto> AdminGetAllOrdersQuery()
    {
        return _db.Orders
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<OrderDto>(_mapper.ConfigurationProvider);
    }

    public async Task AdminUpdateOrderStatusAsync(int id, UpdateOrderStatusRequest request)
    {
        var order = await _db.Orders.FindAsync(id);
        if (order == null)
        {
            throw new KeyNotFoundException("Không tìm thấy đơn hàng.");
        }

        var valid = (order.Status, request.Status) switch
        {
            ("Pending", "Confirmed") => true,
            ("Confirmed", "Shipping") => true,
            ("Shipping", "Delivered") => true,
            ("Pending", "Cancelled") => true,
            _ => false
        };

        if (!valid)
        {
            throw new BadHttpRequestException($"Không thể chuyển trạng thái từ {order.Status} sang {request.Status}.");
        }

        order.Status = request.Status;
        order.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }
}
