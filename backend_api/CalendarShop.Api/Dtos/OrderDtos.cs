namespace CalendarShop.Api.Dtos;

public record CreateOrderRequest(
    string CustomerName,
    string CustomerPhone,
    string ShippingAddress,
    string PaymentMethod,
    string? CouponCode,
    string? Note
);

public record UpdateOrderStatusRequest(string Status, string? Note);
public record CancelOrderRequest(string? Reason);

public record OrderItemDto(
    int OrderItemId,
    int ProductId,
    string ProductName,
    string? ProductImageUrl,
    decimal UnitPrice,
    int Quantity,
    decimal TotalPrice
);

public record OrderDto(
    int OrderId,
    int UserId,
    string CustomerName,
    string CustomerPhone,
    string ShippingAddress,
    decimal SubTotal,
    decimal DiscountAmount,
    decimal ShippingFee,
    decimal TotalAmount,
    string PaymentMethod,
    string Status,
    string? Note,
    DateTime CreatedAt,
    List<OrderItemDto> Items
);
