namespace CalendarShop.Api.Models;

public class Discount
{
    public int DiscountId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string DiscountType { get; set; } = "Percent";
    public decimal DiscountValue { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Status { get; set; } = "Active";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<Product> Products { get; set; } = new List<Product>();
}
