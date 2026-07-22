namespace CalendarShop.Api.Dtos.AdminStats;

public class AdminDiscountStatsDto
{
    public int TotalDiscounts { get; set; }
    public int ActiveDiscounts { get; set; }
    public int ExpiredDiscounts { get; set; }

    public List<DiscountTypeDistributionDto> TypeDistribution { get; set; } = new();
    public List<TopDiscountDto> TopDiscounts { get; set; } = new();
}

public class DiscountTypeDistributionDto
{
    public string Type { get; set; } = string.Empty;
    public int Total { get; set; }
    public double Percentage { get; set; }
}

public class TopDiscountDto
{
    public int DiscountId { get; set; }
    public string Code { get; set; } = string.Empty;
    public int UsageCount { get; set; }
}
