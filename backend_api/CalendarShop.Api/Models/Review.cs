namespace CalendarShop.Api.Models;

public class Review
{
    public int ReviewId { get; set; }
    public int UserId { get; set; }
    public int ProductId { get; set; }
    public int OrderId { get; set; }
    public int OrderItemId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public string Status { get; set; } = "Visible";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    public User? User { get; set; }
    public Product? Product { get; set; }
    public Order? Order { get; set; }
    public OrderItem? OrderItem { get; set; }
}
