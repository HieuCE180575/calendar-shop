using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Services;

public interface IDiscountService
{
    decimal GetDiscountedPrice(Product product);
    
    IQueryable<DiscountDto> GetAllDiscountsQuery();
    Task<DiscountDto> GetDiscountByIdAsync(int id);
    Task<DiscountDto> CreateDiscountAsync(DiscountCreateUpdateDto request);
    Task UpdateDiscountAsync(int id, DiscountCreateUpdateDto request);
    Task UpdateDiscountStatusAsync(int id, UpdateDiscountStatusRequest request);
    Task DeleteDiscountAsync(int id);
    Task<CalendarShop.Api.Dtos.AdminStats.AdminDiscountStatsDto> GetAdminDiscountStatsAsync();
}
