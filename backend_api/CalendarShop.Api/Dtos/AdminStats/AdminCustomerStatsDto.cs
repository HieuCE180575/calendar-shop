namespace CalendarShop.Api.Dtos.AdminStats;

public class AdminCustomerStatsDto
{
    public int TotalCustomers { get; set; }
    public double TotalCustomersGrowth { get; set; } // new
    public int NewCustomers { get; set; } 
    public double NewCustomersGrowth { get; set; } // new
    public int LoyalCustomers { get; set; } 
    public int LockedAccounts { get; set; }

    public List<CustomerRankDistributionDto> RankDistribution { get; set; } = new();
    public List<TopCustomerDto> TopCustomers { get; set; } = new();
}

public class CustomerRankDistributionDto
{
    public string Rank { get; set; } = string.Empty;
    public int Total { get; set; }
    public double Percentage { get; set; }
}

public class TopCustomerDto
{
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Rank { get; set; } = string.Empty;
    public int TotalOrders { get; set; }
    public double TotalSpent { get; set; }
}
