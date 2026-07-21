using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using ClosedXML.Excel;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class AdminDashboardService : IAdminDashboardService
{
    private readonly IRepository<Order> _orderRepository;
    private readonly IRepository<OrderItem> _orderItemRepository;
    private readonly IRepository<User> _userRepository;
    private readonly IRepository<Product> _productRepository;

    public AdminDashboardService(
        IRepository<Order> orderRepository,
        IRepository<OrderItem> orderItemRepository,
        IRepository<User> userRepository,
        IRepository<Product> productRepository)
    {
        _orderRepository = orderRepository;
        _orderItemRepository = orderItemRepository;
        _userRepository = userRepository;
        _productRepository = productRepository;
    }

    public async Task<AdminDashboardStatsDto> GetDashboardStatsAsync()
    {
        var deliveredOrders = _orderRepository.Entities.Where(x => x.Status == "Delivered");
        var totalRevenue = await deliveredOrders.SumAsync(x => (decimal?)x.TotalAmount) ?? 0;
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

        var revenueByDay = await _orderRepository.Entities
            .Where(x => x.Status == "Delivered")
            .GroupBy(x => x.CreatedAt.Date)
            .Select(g => new RevenueByDayDto
            {
                Date = g.Key,
                Revenue = g.Sum(x => x.TotalAmount),
                OrderCount = g.Count()
            })
            .OrderBy(x => x.Date)
            .ToListAsync();

        var revenueByMonth = await _orderRepository.Entities
            .Where(x => x.Status == "Delivered")
            .GroupBy(x => new { Year = x.CreatedAt.Year, Month = x.CreatedAt.Month })
            .Select(g => new RevenueByMonthDto
            {
                Year = g.Key.Year,
                Month = g.Key.Month,
                Revenue = g.Sum(x => x.TotalAmount),
                OrderCount = g.Count()
            })
            .OrderBy(x => x.Year).ThenBy(x => x.Month)
            .ToListAsync();

        var totalUsers = await _userRepository.Entities.CountAsync(u => u.Role == "Customer");

        var lowStockProducts = await _productRepository.Entities
            .Where(p => p.StockQuantity < 10 && !p.IsDeleted)
            .Select(p => new LowStockProductDto { ProductId = p.ProductId, ProductName = p.ProductName, StockQuantity = p.StockQuantity })
            .OrderBy(p => p.StockQuantity)
            .Take(10)
            .ToListAsync();

        var recentOrders = await _orderRepository.Entities
            .OrderByDescending(o => o.CreatedAt)
            .Select(o => new RecentOrderDto
            {
                OrderId = o.OrderId,
                CustomerName = o.CustomerName ?? string.Empty,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                CreatedAt = o.CreatedAt
            })
            .Take(5)
            .ToListAsync();

        return new AdminDashboardStatsDto
        {
            TotalUsers = totalUsers,
            TotalRevenue = totalRevenue,
            TotalOrders = totalOrders,
            TotalProductsSold = totalProductsSold,
            OrdersByStatus = ordersByStatus,
            BestSelling = bestSelling,
            RevenueByDay = revenueByDay,
            RevenueByMonth = revenueByMonth,
            RecentOrders = recentOrders,
            LowStockProducts = lowStockProducts
        };
    }

    public async Task<byte[]> ExportRevenueExcelAsync()
    {
        var stats = await GetDashboardStatsAsync();

        using var workbook = new XLWorkbook();

        // --- Sheet 1: Tổng Quan ---
        var wsOverview = workbook.Worksheets.Add("Tổng Quan");
        wsOverview.Cell(1, 1).Value = "BÁO CÁO THỐNG KÊ TỔNG QUAN";
        wsOverview.Range("A1:B1").Merge().Style.Font.SetBold().Font.FontSize = 14;

        wsOverview.Cell(3, 1).Value = "Tổng Khách Hàng";
        wsOverview.Cell(3, 2).Value = stats.TotalUsers;
        wsOverview.Cell(4, 1).Value = "Tổng Doanh Thu";
        wsOverview.Cell(4, 2).Value = stats.TotalRevenue;
        wsOverview.Cell(5, 1).Value = "Tổng Đơn Hàng";
        wsOverview.Cell(5, 2).Value = stats.TotalOrders;
        wsOverview.Cell(6, 1).Value = "Tổng Sản Phẩm Đã Bán";
        wsOverview.Cell(6, 2).Value = stats.TotalProductsSold;

        wsOverview.Range("A3:A6").Style.Font.SetBold();
        wsOverview.Columns().AdjustToContents();

        // --- Sheet 2: Doanh Thu ---
        var wsRevenue = workbook.Worksheets.Add("Doanh Thu");
        wsRevenue.Cell(1, 1).Value = "DOANH THU THEO THÁNG";
        wsRevenue.Range("A1:C1").Merge().Style.Font.SetBold().Font.FontSize = 12;

        wsRevenue.Cell(2, 1).Value = "Tháng/Năm";
        wsRevenue.Cell(2, 2).Value = "Số Đơn Hàng";
        wsRevenue.Cell(2, 3).Value = "Doanh Thu";
        wsRevenue.Range("A2:C2").Style.Font.SetBold().Fill.BackgroundColor = XLColor.LightGray;

        int row = 3;
        foreach (var month in stats.RevenueByMonth)
        {
            wsRevenue.Cell(row, 1).Value = $"{month.Month}/{month.Year}";
            wsRevenue.Cell(row, 2).Value = month.OrderCount;
            wsRevenue.Cell(row, 3).Value = month.Revenue;
            row++;
        }

        row += 2;
        wsRevenue.Cell(row, 1).Value = "DOANH THU THEO NGÀY";
        wsRevenue.Range(row, 1, row, 3).Merge().Style.Font.SetBold().Font.FontSize = 12;
        row++;

        wsRevenue.Cell(row, 1).Value = "Ngày";
        wsRevenue.Cell(row, 2).Value = "Số Đơn Hàng";
        wsRevenue.Cell(row, 3).Value = "Doanh Thu";
        wsRevenue.Range(row, 1, row, 3).Style.Font.SetBold().Fill.BackgroundColor = XLColor.LightGray;
        row++;

        foreach (var day in stats.RevenueByDay)
        {
            wsRevenue.Cell(row, 1).Value = day.Date.ToString("dd/MM/yyyy");
            wsRevenue.Cell(row, 2).Value = day.OrderCount;
            wsRevenue.Cell(row, 3).Value = day.Revenue;
            row++;
        }
        wsRevenue.Columns().AdjustToContents();

        // --- Sheet 3: Đơn Hàng ---
        var wsOrders = workbook.Worksheets.Add("Đơn Hàng");
        wsOrders.Cell(1, 1).Value = "CHI TIẾT ĐƠN HÀNG THÀNH CÔNG";
        wsOrders.Range("A1:E1").Merge().Style.Font.SetBold().Font.FontSize = 12;

        wsOrders.Cell(2, 1).Value = "Mã Đơn";
        wsOrders.Cell(2, 2).Value = "Tên Khách Hàng";
        wsOrders.Cell(2, 3).Value = "SĐT";
        wsOrders.Cell(2, 4).Value = "Ngày Tạo";
        wsOrders.Cell(2, 5).Value = "Tổng Tiền";
        wsOrders.Range("A2:E2").Style.Font.SetBold().Fill.BackgroundColor = XLColor.LightGray;

        var deliveredOrders = await _orderRepository.Entities
            .Where(x => x.Status == "Delivered")
            .OrderBy(x => x.CreatedAt)
            .ToListAsync();

        row = 3;
        foreach (var order in deliveredOrders)
        {
            wsOrders.Cell(row, 1).Value = order.OrderId;
            wsOrders.Cell(row, 2).Value = order.CustomerName ?? "";
            wsOrders.Cell(row, 3).Value = order.CustomerPhone ?? "";
            wsOrders.Cell(row, 4).Value = order.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss");
            wsOrders.Cell(row, 5).Value = order.TotalAmount;
            row++;
        }
        wsOrders.Columns().AdjustToContents();

        // Xuất ra byte array
        using var stream = new MemoryStream();
        workbook.SaveAs(stream);
        return stream.ToArray();
    }
}
