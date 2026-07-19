using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using CalendarShop.Api.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace CalendarShop.Api.Services;

public class OrderService : IOrderService
{
    private readonly IRepository<Order> _orderRepository;
    private readonly IRepository<CartItem> _cartItemRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IRepository<Coupon> _couponRepository;
    private readonly IMapper _mapper;
    private readonly IConfiguration _configuration;
    private readonly ILogger<OrderService> _logger;

    public OrderService(
        IRepository<Order> orderRepository,
        IRepository<CartItem> cartItemRepository,
        IRepository<Product> productRepository,
        IRepository<Coupon> couponRepository,
        IMapper mapper,
        IConfiguration configuration,
        ILogger<OrderService> logger)
    {
        _orderRepository = orderRepository;
        _cartItemRepository = cartItemRepository;
        _productRepository = productRepository;
        _couponRepository = couponRepository;
        _mapper = mapper;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task<OrderDto> CreateOrderAsync(int userId, CreateOrderRequest request)
    {
        var cartItems = await _cartItemRepository.Entities
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
            coupon = await _couponRepository.Entities.FirstOrDefaultAsync(x => x.Code == request.CouponCode && x.Status == "Active");
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
            _productRepository.Update(product);
        }

        if (coupon != null)
        {
            coupon.UsedCount++;
            _couponRepository.Update(coupon);
        }

        await _orderRepository.AddAsync(order);
        _cartItemRepository.RemoveRange(cartItems);
        await _orderRepository.SaveChangesAsync();

        return await GetOrderByIdAsync(userId, order.OrderId);
    }

    public IQueryable<OrderDto> GetMyOrdersQuery(int userId)
    {
        return _orderRepository.Entities
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<OrderDto>(_mapper.ConfigurationProvider);
    }

    public async Task<OrderDto> GetOrderByIdAsync(int userId, int id)
    {
        var order = await _orderRepository.Entities
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
        var order = await _orderRepository.Entities.Include(x => x.OrderItems).FirstOrDefaultAsync(x => x.OrderId == id && x.UserId == userId);
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
        _orderRepository.Update(order);

        foreach (var item in order.OrderItems)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId);
            if (product != null)
            {
                product.StockQuantity += item.Quantity;
                if (product.Status == "OutOfStock")
                {
                    product.Status = "Active";
                }
                _productRepository.Update(product);
            }
        }

        await _orderRepository.SaveChangesAsync();
    }

    public IQueryable<OrderDto> AdminGetAllOrdersQuery()
    {
        return _orderRepository.Entities
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<OrderDto>(_mapper.ConfigurationProvider);
    }

    public async Task AdminUpdateOrderStatusAsync(int id, UpdateOrderStatusRequest request)
    {
        var order = await _orderRepository.GetByIdAsync(id);
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
        _orderRepository.Update(order);
        await _orderRepository.SaveChangesAsync();
    }

    public async Task<(bool IsSignatureValid, bool IsSuccess)> HandlePaymentCallbackAsync(Dictionary<string, string> vnpayData)
    {
        _logger.LogInformation("VNPay callback received.");

        var pay = new VNPayLibrary();
        foreach (var (key, value) in vnpayData)
        {
            if (!string.IsNullOrEmpty(key) && key.StartsWith("vnp_"))
            {
                pay.AddResponseData(key, value);
            }
        }

        var vnp_TxnRef = pay.GetResponseData("vnp_TxnRef");
        var vnp_SecureHash = vnpayData.TryGetValue("vnp_SecureHash", out var hash) ? hash : string.Empty;
        var vnp_ResponseCode = pay.GetResponseData("vnp_ResponseCode");

        bool isSignatureValid = pay.ValidateSignature(vnp_SecureHash, _configuration["VNPay:HashSecret"] ?? string.Empty);
        
        _logger.LogInformation("VNPay signature validation result: {IsValid}", isSignatureValid);

        if (!isSignatureValid)
        {
            return (false, false);
        }

        if (string.IsNullOrEmpty(vnp_TxnRef) || !int.TryParse(vnp_TxnRef, out int orderId))
        {
            _logger.LogWarning("Invalid orderId from VNPay callback.");
            return (true, false);
        }

        bool isSuccess = vnp_ResponseCode == "00";
        if (isSuccess)
        {
            _logger.LogInformation("Payment success for OrderId {OrderId}.", orderId);
        }
        else
        {
            _logger.LogInformation("Payment failed/cancelled for OrderId {OrderId}.", orderId);
        }

        var order = await _orderRepository.Entities.Include(x => x.OrderItems).FirstOrDefaultAsync(x => x.OrderId == orderId);
        if (order == null)
        {
            _logger.LogWarning("Order {OrderId} not found.", orderId);
            return (true, isSuccess);
        }
        
        if (order.Status != "Pending")
        {
            _logger.LogInformation("Order {OrderId} status is {Status}, no update needed.", orderId, order.Status);
            return (true, isSuccess);
        }

        if (isSuccess)
        {
            order.Status = "Confirmed";
        }
        else
        {
            order.Status = "Cancelled";
            
            foreach (var item in order.OrderItems)
            {
                var product = await _productRepository.GetByIdAsync(item.ProductId);
                if (product != null)
                {
                    product.StockQuantity += item.Quantity;
                    if (product.Status == "OutOfStock" && product.StockQuantity > 0)
                    {
                        product.Status = "Active";
                    }
                    _productRepository.Update(product);
                }
            }
            _logger.LogInformation("Stock restored for OrderId {OrderId}.", orderId);
        }
        
        order.UpdatedAt = DateTime.UtcNow;
        _orderRepository.Update(order);
        
        try
        {
            await _orderRepository.SaveChangesAsync();
            _logger.LogInformation("Order {OrderId} updated to {Status}.", orderId, order.Status);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "SaveChanges exception for OrderId {OrderId}", orderId);
            throw;
        }

        return (true, isSuccess);
    }
}
