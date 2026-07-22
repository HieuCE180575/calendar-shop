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
    private readonly IDiscountService _discountService;
    private readonly IRepository<Discount> _discountRepository;
    private readonly IMapper _mapper;
    private readonly IConfiguration _configuration;
    private readonly ILogger<OrderService> _logger;
    private readonly INotificationService _notificationService;

    public OrderService(
        IRepository<Order> orderRepository,
        IRepository<CartItem> cartItemRepository,
        IRepository<Product> productRepository,
        IRepository<Coupon> couponRepository,
        IMapper mapper,
        IConfiguration configuration,
        ILogger<OrderService> logger,
        IDiscountService discountService,
        IRepository<Discount> discountRepository,
        INotificationService notificationService)
    {
        _orderRepository = orderRepository;
        _cartItemRepository = cartItemRepository;
        _productRepository = productRepository;
        _couponRepository = couponRepository;
        _discountService = discountService;
        _discountRepository = discountRepository;
        _mapper = mapper;
        _configuration = configuration;
        _logger = logger;
        _notificationService = notificationService;
    }

    public async Task<OrderDto> CreateOrderAsync(int userId, CreateOrderRequest request)
    {
        var cartItems = await _cartItemRepository.Entities
            .Include(x => x.Product)
                .ThenInclude(p => p.Discount)
            .Where(x => x.UserId == userId && x.IsSelected)
            .ToListAsync();

        if (!cartItems.Any())
        {
            throw new BadHttpRequestException("Giỏ hàng chưa chọn sản phẩm.");
        }

        decimal subTotal = 0;
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
            var discountedPrice = _discountService.GetDiscountedPrice(item.Product);
            subTotal += discountedPrice * item.Quantity;
        }
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
            var discountedPrice = _discountService.GetDiscountedPrice(product);
            order.OrderItems.Add(new OrderItem
            {
                ProductId = product.ProductId,
                ProductName = product.ProductName,
                ProductImageUrl = product.ImageUrl,
                UnitPrice = discountedPrice,
                Quantity = item.Quantity,
                TotalPrice = discountedPrice * item.Quantity
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
        var order = await _orderRepository.Entities
            .Include(x => x.OrderItems)
            .FirstOrDefaultAsync(x => x.OrderId == id && x.UserId == userId);
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

        await RestoreCouponUsageIfNeededAsync(order);
        await _orderRepository.SaveChangesAsync();

        await _notificationService.CreateNotificationAsync(
            userId,
            "Hủy đơn hàng thành công",
            $"Đơn hàng #{order.OrderId} của bạn đã được hủy thành công. Lý do: {request.Reason}",
            "OrderUpdate"
        );
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

        string title = "Cập nhật trạng thái đơn hàng";
        string content = request.Status switch
        {
            "Confirmed" => $"Đơn hàng #{order.OrderId} của bạn đã được xác nhận và đang chuẩn bị đóng gói.",
            "Shipping" => $"Đơn hàng #{order.OrderId} của bạn đang trên đường giao tới bạn.",
            "Delivered" => $"Đơn hàng #{order.OrderId} của bạn đã được giao thành công.",
            "Cancelled" => $"Đơn hàng #{order.OrderId} của bạn đã bị hủy bởi quản trị viên.",
            _ => $"Đơn hàng #{order.OrderId} của bạn đã chuyển sang trạng thái: {request.Status}."
        };
        await _notificationService.CreateNotificationAsync(
            order.UserId,
            title,
            content,
            "OrderUpdate"
        );
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
        var vnp_TransactionStatus = pay.GetResponseData("vnp_TransactionStatus");
        var vnp_Amount = pay.GetResponseData("vnp_Amount");
        var vnp_TmnCode = pay.GetResponseData("vnp_TmnCode");
        var expectedTmnCode = _configuration["VNPay:TmnCode"] ?? string.Empty;

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

        if (!string.IsNullOrWhiteSpace(expectedTmnCode) && vnp_TmnCode != expectedTmnCode)
        {
            _logger.LogWarning("VNPay callback rejected because terminal code does not match for OrderId {OrderId}.", orderId);
            return (true, false);
        }

        bool isSuccess = vnp_ResponseCode == "00" && vnp_TransactionStatus == "00";
        if (isSuccess)
        {
            _logger.LogInformation("Payment success for OrderId {OrderId}.", orderId);
        }
        else
        {
            _logger.LogInformation("Payment failed/cancelled for OrderId {OrderId}.", orderId);
        }

        var order = await _orderRepository.Entities
            .Include(x => x.OrderItems)
            .FirstOrDefaultAsync(x => x.OrderId == orderId);
        if (order == null)
        {
            _logger.LogWarning("Order {OrderId} not found.", orderId);
            return (true, isSuccess);
        }

        if (order.PaymentMethod != "VNPay")
        {
            _logger.LogWarning("VNPay callback rejected for non-VNPay OrderId {OrderId}.", orderId);
            return (true, false);
        }

        if (!IsVNPayAmountValid(vnp_Amount, order.TotalAmount))
        {
            _logger.LogWarning("VNPay callback amount mismatch for OrderId {OrderId}.", orderId);
            return (true, false);
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
            await RestoreCouponUsageIfNeededAsync(order);
            _logger.LogInformation("Stock restored for OrderId {OrderId}.", orderId);
        }

        order.UpdatedAt = DateTime.UtcNow;
        _orderRepository.Update(order);

        try
        {
            await _orderRepository.SaveChangesAsync();
            _logger.LogInformation("Order {OrderId} updated to {Status}.", orderId, order.Status);

            string cbTitle = isSuccess ? "Thanh toán thành công" : "Thanh toán thất bại";
            string cbContent = isSuccess 
                ? $"Đơn hàng #{order.OrderId} đã được thanh toán thành công qua VNPay và được xác nhận."
                : $"Thanh toán cho đơn hàng #{order.OrderId} qua VNPay không thành công. Đơn hàng đã bị hủy.";
            await _notificationService.CreateNotificationAsync(
                order.UserId,
                cbTitle,
                cbContent,
                "OrderUpdate"
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "SaveChanges exception for OrderId {OrderId}", orderId);
            throw;
        }

        return (true, isSuccess);
    }

    private async Task RestoreCouponUsageIfNeededAsync(Order order)
    {
        if (!order.CouponId.HasValue)
        {
            return;
        }

        var coupon = await _couponRepository.Entities
            .FirstOrDefaultAsync(x => x.CouponId == order.CouponId.Value);
        if (coupon == null || coupon.UsedCount <= 0)
        {
            return;
        }

        coupon.UsedCount--;
        _couponRepository.Update(coupon);
    }

    private static bool IsVNPayAmountValid(string amountText, decimal orderTotal)
    {
        if (!long.TryParse(amountText, out var callbackAmount))
        {
            return false;
        }

        var expectedAmount = decimal.ToInt64(orderTotal * 100);
        return callbackAmount == expectedAmount;
    }

    public async Task ReorderAsync(int userId, int orderId)
    {
        var order = await _orderRepository.Entities
            .Include(x => x.OrderItems)
            .FirstOrDefaultAsync(x => x.OrderId == orderId && x.UserId == userId);

        if (order == null)
            throw new KeyNotFoundException($"Không tìm thấy đơn hàng. UserId={userId}, OrderId={orderId}");

        // Fetch existing cart
        var existingCart = await _cartItemRepository.Entities.Where(x => x.UserId == userId).ToListAsync();

        // Add order items back to cart or update existing
        foreach (var item in order.OrderItems)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId);
            if (product == null || product.IsDeleted || product.Status != "Active")
                continue;

            var existingItem = existingCart.FirstOrDefault(x => x.ProductId == item.ProductId);
            
            if (existingItem != null)
            {
                // Update existing item quantity (capping at stock) and select it
                var newQty = existingItem.Quantity + item.Quantity;
                existingItem.Quantity = Math.Min(newQty, product.StockQuantity);
                existingItem.IsSelected = true;
                _cartItemRepository.Update(existingItem);
            }
            else
            {
                // Add new item to cart
                var qty = Math.Min(item.Quantity, product.StockQuantity);
                if (qty <= 0) continue;

                await _cartItemRepository.AddAsync(new CartItem
                {
                    UserId = userId,
                    ProductId = item.ProductId,
                    Quantity = qty,
                    IsSelected = true
                });
            }
        }

        await _cartItemRepository.SaveChangesAsync();
    }
}
