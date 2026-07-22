namespace CalendarShop.Api.Dtos.AdminStats;

public class AdminCouponStatsDto
{
    public int TotalCoupons { get; set; }
    public double TotalCouponsGrowth { get; set; }
    public int ActiveCoupons { get; set; }
    public double ActiveCouponsGrowth { get; set; }
}
