using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface ICartService
{
    Task<CartSummaryDto> GetCartAsync(int userId);
    Task AddToCartAsync(int userId, AddToCartRequest request);
    Task UpdateCartItemAsync(int userId, int cartItemId, UpdateCartItemRequest request);
    Task DeleteCartItemAsync(int userId, int cartItemId);
}
