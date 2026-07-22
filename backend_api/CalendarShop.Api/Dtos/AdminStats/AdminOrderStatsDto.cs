using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Dtos.AdminStats;
public class AdminOrderStatsDto
{
    public int TotalOrders { get; set; }
    public double TotalOrdersGrowth { get; set; }
    public int PendingOrders { get; set; }
    public int DeliveringOrders { get; set; }
    public int CompletedOrders { get; set; }
    public double RevenueGrowth { get; set; }
    public int CancelledOrders { get; set; }

    public List<OrderStatusDistributionDto> StatusDistribution { get; set; } = new();
    public List<RevenueByDayDto> RevenueByDay { get; set; } = new();
}

public class OrderStatusDistributionDto
{
    public string Status { get; set; } = string.Empty;
    public int Total { get; set; }
    public double Percentage { get; set; }
}
