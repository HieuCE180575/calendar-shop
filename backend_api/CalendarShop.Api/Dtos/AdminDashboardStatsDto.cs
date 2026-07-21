using System;
using System.Collections.Generic;

namespace CalendarShop.Api.Dtos;

public class AdminDashboardStatsDto
{
    public int TotalUsers { get; set; }
    public decimal TotalRevenue { get; set; }
    public int TotalOrders { get; set; }
    public int TotalProductsSold { get; set; }
    public List<StatusCountDto> OrdersByStatus { get; set; } = new();
    public List<BestSellingProductDto> BestSelling { get; set; } = new();
    public List<RevenueByDayDto> RevenueByDay { get; set; } = new();
    public List<RevenueByMonthDto> RevenueByMonth { get; set; } = new();
    public List<RecentOrderDto> RecentOrders { get; set; } = new();
    public List<LowStockProductDto> LowStockProducts { get; set; } = new();
}

public class RecentOrderDto
{
    public int OrderId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal TotalAmount { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}

public class LowStockProductDto
{
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public int StockQuantity { get; set; }
}

public class RevenueByDayDto
{
    public DateTime Date { get; set; }
    public decimal Revenue { get; set; }
    public int OrderCount { get; set; }
}

public class RevenueByMonthDto
{
    public int Year { get; set; }
    public int Month { get; set; }
    public decimal Revenue { get; set; }
    public int OrderCount { get; set; }
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
