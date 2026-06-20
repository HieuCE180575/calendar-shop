using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class CartController : AppControllerBase
{
    private readonly AppDbContext _db;

    public CartController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<CartSummaryDto>> GetCart()
    {
        var items = await _db.CartItems
            .Include(x => x.Product)
            .Where(x => x.UserId == CurrentUserId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new CartItemDto(
                x.CartItemId,
                x.ProductId,
                x.Product!.ProductName,
                x.Product.ImageUrl,
                x.Product.Price,
                x.Quantity,
                x.Product.StockQuantity,
                x.IsSelected,
                x.Product.Price * x.Quantity
            ))
            .ToListAsync();

        return Ok(new CartSummaryDto(items, items.Where(x => x.IsSelected).Sum(x => x.LineTotal)));
    }

    [HttpPost]
    public async Task<IActionResult> Add(AddToCartRequest request)
    {
        var product = await _db.Products.FindAsync(request.ProductId);
        if (product == null || product.IsDeleted || product.Status != "Active") return BadRequest("Sản phẩm không khả dụng.");
        if (product.StockQuantity < request.Quantity) return BadRequest("Không đủ tồn kho.");

        var item = await _db.CartItems.FirstOrDefaultAsync(x => x.UserId == CurrentUserId && x.ProductId == request.ProductId);
        if (item == null)
        {
            item = new CartItem { UserId = CurrentUserId, ProductId = request.ProductId, Quantity = request.Quantity };
            _db.CartItems.Add(item);
        }
        else
        {
            item.Quantity += request.Quantity;
            item.UpdatedAt = DateTime.UtcNow;
        }

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpPut("{cartItemId:int}")]
    public async Task<IActionResult> Update(int cartItemId, UpdateCartItemRequest request)
    {
        var item = await _db.CartItems.FirstOrDefaultAsync(x => x.CartItemId == cartItemId && x.UserId == CurrentUserId);
        if (item == null) return NotFound();

        item.Quantity = request.Quantity;
        item.IsSelected = request.IsSelected;
        item.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{cartItemId:int}")]
    public async Task<IActionResult> Delete(int cartItemId)
    {
        var item = await _db.CartItems.FirstOrDefaultAsync(x => x.CartItemId == cartItemId && x.UserId == CurrentUserId);
        if (item == null) return NotFound();
        _db.CartItems.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
