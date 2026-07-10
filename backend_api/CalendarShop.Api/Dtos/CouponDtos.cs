namespace CalendarShop.Api.Dtos;

public class CouponDto
{
    public int CouponId { get; set; }
    public string Code { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string DiscountType { get; set; } = "Percent";
    public decimal DiscountValue { get; set; }
    public decimal MinOrderValue { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public int? UsageLimit { get; set; }
    public int UsedCount { get; set; }
    public string Status { get; set; } = "Active";
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public record CouponCreateUpdateDto(
    string Code,
    string? Description,
    string DiscountType,
    decimal DiscountValue,
    decimal MinOrderValue,
    DateTime StartDate,
    DateTime EndDate,
    int? UsageLimit,
    string Status
);

public record CouponStatusUpdateDto(string Status);
