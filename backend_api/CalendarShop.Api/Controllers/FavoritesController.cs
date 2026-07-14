using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class FavoritesController : AppControllerBase
{
    private readonly IFavoriteService _favoriteService;

    public FavoritesController(IFavoriteService favoriteService)
    {
        _favoriteService = favoriteService;
    }

    /// <summary>
    /// Lấy danh sách sản phẩm yêu thích của tôi.
    /// </summary>
    [HttpGet]
    [EnableQuery]
    public ActionResult<IQueryable<FavoriteDto>> GetMyFavorites()
    {
        var favorites = _favoriteService.GetMyFavoritesQuery(CurrentUserId);
        return Ok(favorites);
    }

    /// <summary>
    /// Kiểm tra sản phẩm có trong danh sách yêu thích không.
    /// </summary>
    [HttpGet("check/{productId:int}")]
    public async Task<ActionResult<bool>> CheckFavorite(int productId)
    {
        var isFavorite = await _favoriteService.IsFavoriteAsync(CurrentUserId, productId);
        return Ok(isFavorite);
    }

    /// <summary>
    /// Thêm sản phẩm vào danh sách yêu thích.
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<FavoriteDto>> AddFavorite(AddFavoriteRequest request)
    {
        var favorite = await _favoriteService.AddFavoriteAsync(CurrentUserId, request);
        return CreatedAtAction(nameof(GetMyFavorites), favorite);
    }

    /// <summary>
    /// Xóa sản phẩm khỏi danh sách yêu thích.
    /// </summary>
    [HttpDelete("{productId:int}")]
    public async Task<IActionResult> RemoveFavorite(int productId)
    {
        await _favoriteService.RemoveFavoriteAsync(CurrentUserId, productId);
        return NoContent();
    }
}
