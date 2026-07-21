using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

[Authorize(Roles = "Admin")]
public class AdminDashboardController : AppControllerBase
{
    private readonly IAdminDashboardService _dashboardService;

    public AdminDashboardController(IAdminDashboardService dashboardService)
    {
        _dashboardService = dashboardService;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var stats = await _dashboardService.GetDashboardStatsAsync();
        return Ok(stats);
    }

    [HttpGet("export-revenue")]
    public async Task<IActionResult> ExportRevenueExcel()
    {
        var fileBytes = await _dashboardService.ExportRevenueExcelAsync();
        var contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        var fileName = $"Revenue_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";
        return File(fileBytes, contentType, fileName);
    }
}
