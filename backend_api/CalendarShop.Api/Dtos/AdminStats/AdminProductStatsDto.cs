using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Dtos.AdminStats;
public class AdminProductStatsDto
{
    public int TotalProducts { get; set; }
    public double TotalProductsGrowth { get; set; }
    public int InBusiness { get; set; }
    public double InBusinessGrowth { get; set; }
    public int LowStock { get; set; }
    public int TotalCategories { get; set; }

    public List<BestSellingProductDto> BestSelling { get; set; } = new();
    public List<CategoryStockDistributionDto> StockByCategory { get; set; } = new();
    public List<LowStockProductDto> LowStockProducts { get; set; } = new();
}

public class CategoryStockDistributionDto
{
    public string CategoryName { get; set; } = string.Empty;
    public int TotalStock { get; set; }
    public double Percentage { get; set; }
}
