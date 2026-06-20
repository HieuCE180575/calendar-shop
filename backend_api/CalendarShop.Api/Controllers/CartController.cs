using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
    public async Task<ActionResult<CartSummaryDto>> GetCart()
    {
        var summary = await _cartService.GetCartAsync(CurrentUserId);
        return Ok(summary);
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
