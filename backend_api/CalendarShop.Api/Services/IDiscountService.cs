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
    Task DeleteDiscountAsync(int id);
}
