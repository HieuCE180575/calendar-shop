using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IFavoriteService
{
    Task<FavoriteDto> AddFavoriteAsync(int userId, AddFavoriteRequest request);
    Task RemoveFavoriteAsync(int userId, int productId);
    IQueryable<FavoriteDto> GetMyFavoritesQuery(int userId);
    Task<bool> IsFavoriteAsync(int userId, int productId);
}
