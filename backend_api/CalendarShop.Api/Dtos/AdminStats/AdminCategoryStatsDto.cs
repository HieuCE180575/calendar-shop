namespace CalendarShop.Api.Dtos.AdminStats;

public class AdminCategoryStatsDto
{
    public int TotalCategories { get; set; }
    public int ActiveCategories { get; set; }
    public int HiddenCategories { get; set; }

    public List<CategoryProductDistributionDto> ProductDistribution { get; set; } = new();
}

public class CategoryProductDistributionDto
{
    public string CategoryName { get; set; } = string.Empty;
    public int ProductCount { get; set; }
    public double Percentage { get; set; }
}
