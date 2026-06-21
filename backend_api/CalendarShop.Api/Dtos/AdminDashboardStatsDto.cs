using System.Collections.Generic;

namespace CalendarShop.Api.Dtos;

public class AdminDashboardStatsDto
{
    public decimal TotalRevenue { get; set; }
    public int TotalOrders { get; set; }
    public int TotalProductsSold { get; set; }
    public List<StatusCountDto> OrdersByStatus { get; set; } = new();
    public List<BestSellingProductDto> BestSelling { get; set; } = new();
}

public class StatusCountDto
{
    public string Status { get; set; } = string.Empty;
    public int Total { get; set; }
}

public class BestSellingProductDto
{
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public int TotalSold { get; set; }
}
