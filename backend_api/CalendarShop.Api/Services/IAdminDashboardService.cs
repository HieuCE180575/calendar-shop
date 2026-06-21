using System.Threading.Tasks;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IAdminDashboardService
{
    Task<AdminDashboardStatsDto> GetDashboardStatsAsync();
}
