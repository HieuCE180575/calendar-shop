using CalendarShop.Api.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Controllers;

[Authorize(Roles = "Admin")]
public class AdminDashboardController : AppControllerBase
{
    private readonly AppDbContext _db;

    public AdminDashboardController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var deliveredOrders = _db.Orders.Where(x => x.Status == "Delivered");
        var totalRevenue = await deliveredOrders.SumAsync(x => x.TotalAmount);
        var totalOrders = await _db.Orders.CountAsync();
        var totalProductsSold = await _db.OrderItems
            .Where(x => x.Order != null && x.Order.Status == "Delivered")
            .SumAsync(x => (int?)x.Quantity) ?? 0;

        var ordersByStatus = await _db.Orders
            .GroupBy(x => x.Status)
            .Select(x => new { Status = x.Key, Total = x.Count() })
            .ToListAsync();

        var bestSelling = await _db.OrderItems
            .Where(x => x.Order != null && x.Order.Status == "Delivered")
            .GroupBy(x => new { x.ProductId, x.ProductName })
            .Select(x => new { x.Key.ProductId, x.Key.ProductName, TotalSold = x.Sum(i => i.Quantity) })
            .OrderByDescending(x => x.TotalSold)
            .Take(5)
            .ToListAsync();

        return Ok(new { totalRevenue, totalOrders, totalProductsSold, ordersByStatus, bestSelling });
    }
}
