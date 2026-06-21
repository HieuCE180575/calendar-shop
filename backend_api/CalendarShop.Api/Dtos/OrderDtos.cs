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

public class OrderItemDto
{
    public int OrderItemId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string? ProductImageUrl { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal TotalPrice { get; set; }
}

public class OrderDto
{
    public int OrderId { get; set; }
    public int UserId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public string CustomerPhone { get; set; } = string.Empty;
    public string ShippingAddress { get; set; } = string.Empty;
    public decimal SubTotal { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal ShippingFee { get; set; }
    public decimal TotalAmount { get; set; }
    public string PaymentMethod { get; set; } = string.Empty;
    public string Status { get; set; } = "Pending";
    public string? Note { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<OrderItemDto> Items { get; set; } = new();
}
