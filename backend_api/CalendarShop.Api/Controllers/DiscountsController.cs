using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

[Authorize(Roles = "Admin")]
public class DiscountsController : AppControllerBase
{
    private readonly IDiscountService _discountService;

    public DiscountsController(IDiscountService discountService)
    {
        _discountService = discountService;
    }

    [HttpGet]
    [EnableQuery]
    public ActionResult<IQueryable<DiscountDto>> GetAll()
    {
        var query = _discountService.GetAllDiscountsQuery();
        return Ok(query);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<DiscountDto>> GetById(int id)
    {
        var discount = await _discountService.GetDiscountByIdAsync(id);
        return Ok(discount);
    }

    [HttpPost]
    public async Task<ActionResult<DiscountDto>> Create(DiscountCreateUpdateDto request)
    {
        var discount = await _discountService.CreateDiscountAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = discount.DiscountId }, discount);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, DiscountCreateUpdateDto request)
    {
        await _discountService.UpdateDiscountAsync(id, request);
        return NoContent();
    }

    [HttpPut("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, UpdateDiscountStatusRequest request)
    {
        await _discountService.UpdateDiscountStatusAsync(id, request);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _discountService.DeleteDiscountAsync(id);
        return NoContent();
    }

    [HttpGet("stats")]
    public async Task<ActionResult<CalendarShop.Api.Dtos.AdminStats.AdminDiscountStatsDto>> GetStats()
    {
        var stats = await _discountService.GetAdminDiscountStatsAsync();
        return Ok(stats);
    }
}
