using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class AdminDashboardService : IAdminDashboardService
{
    private readonly IRepository<Order> _orderRepository;
    private readonly IRepository<OrderItem> _orderItemRepository;

    public AdminDashboardService(IRepository<Order> orderRepository, IRepository<OrderItem> orderItemRepository)
    {
        _orderRepository = orderRepository;
        _orderItemRepository = orderItemRepository;
    }

    public async Task<AdminDashboardStatsDto> GetDashboardStatsAsync()
    {
        var deliveredOrders = _orderRepository.Entities.Where(x => x.Status == "Delivered");
        var totalRevenue = await deliveredOrders.SumAsync(x => x.TotalAmount);
        var totalOrders = await _orderRepository.Entities.CountAsync();
        var totalProductsSold = await _orderItemRepository.Entities
            .Where(x => x.Order != null && x.Order.Status == "Delivered")
            .SumAsync(x => (int?)x.Quantity) ?? 0;

        var ordersByStatus = await _orderRepository.Entities
            .GroupBy(x => x.Status)
            .Select(x => new StatusCountDto { Status = x.Key, Total = x.Count() })
            .ToListAsync();

        var bestSelling = await _orderItemRepository.Entities
            .Where(x => x.Order != null && x.Order.Status == "Delivered")
            .GroupBy(x => new { x.ProductId, x.ProductName })
            .Select(x => new BestSellingProductDto { ProductId = x.Key.ProductId, ProductName = x.Key.ProductName, TotalSold = x.Sum(i => i.Quantity) })
            .OrderByDescending(x => x.TotalSold)
            .Take(5)
            .ToListAsync();

        return new AdminDashboardStatsDto
        {
            TotalRevenue = totalRevenue,
            TotalOrders = totalOrders,
            TotalProductsSold = totalProductsSold,
            OrdersByStatus = ordersByStatus,
            BestSelling = bestSelling
        };
    }
}
