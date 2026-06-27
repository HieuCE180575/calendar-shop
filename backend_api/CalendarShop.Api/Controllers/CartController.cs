using System.Linq;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class CartController : AppControllerBase
{
    private readonly ICartService _cartService;

    public CartController(ICartService cartService)
    {
        _cartService = cartService;
    }

    [HttpGet]
    [EnableQuery]
    public ActionResult<IQueryable<CartItemDto>> GetCartItems()
    {
        var query = _cartService.GetCartQuery(CurrentUserId);
        return Ok(query);
    }

    [HttpPost]
    public async Task<IActionResult> Add(AddToCartRequest request)
    {
        await _cartService.AddToCartAsync(CurrentUserId, request);
        return NoContent();
    }

    [HttpPut("{cartItemId:int}")]
    public async Task<IActionResult> Update(int cartItemId, UpdateCartItemRequest request)
    {
        await _cartService.UpdateCartItemAsync(CurrentUserId, cartItemId, request);
        return NoContent();
    }

    [HttpDelete("{cartItemId:int}")]
    public async Task<IActionResult> Delete(int cartItemId)
    {
        await _cartService.DeleteCartItemAsync(CurrentUserId, cartItemId);
        return NoContent();
    }
}
