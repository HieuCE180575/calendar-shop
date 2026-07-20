namespace CalendarShop.Api.Dtos;

public class DiscountDto
{
    public int DiscountId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string DiscountType { get; set; } = "Percent";
    public decimal DiscountValue { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Status { get; set; } = "Active";
    public DateTime CreatedAt { get; set; }
    public List<int> ProductIds { get; set; } = new List<int>();
}

public record DiscountCreateUpdateDto(
    string Name,
    string DiscountType,
    decimal DiscountValue,
    DateTime StartDate,
    DateTime EndDate,
    string Status,
    string Scope, // "Product" or "Category"
    List<int> TargetIds
);
