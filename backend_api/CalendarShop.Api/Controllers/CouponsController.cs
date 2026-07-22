using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

[Authorize(Roles = "Admin")]
public class CouponsController : AppControllerBase
{
    private readonly ICouponService _couponService;

    public CouponsController(ICouponService couponService)
    {
        _couponService = couponService;
    }

    [HttpGet]
    [EnableQuery]
    public ActionResult<IQueryable<CouponDto>> GetAll()
    {
        return Ok(_couponService.GetAllCouponsQuery());
    }

    [HttpGet("check")]
    [AllowAnonymous]
    public async Task<ActionResult<CouponDto>> CheckCoupon([FromQuery] string code, [FromQuery] decimal subTotal)
    {
        if (string.IsNullOrWhiteSpace(code))
        {
            return BadRequest("Mã giảm giá không được để trống.");
        }
        
        try
        {
            var coupon = await _couponService.CheckCouponAsync(code, subTotal);
            return Ok(coupon);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<CouponDto>> GetById(int id)
    {
        var coupon = await _couponService.GetCouponByIdAsync(id);
        return Ok(coupon);
    }

    [HttpPost]
    public async Task<ActionResult<CouponDto>> Create(CouponCreateUpdateDto request)
    {
        var coupon = await _couponService.CreateCouponAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = coupon.CouponId }, coupon);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, CouponCreateUpdateDto request)
    {
        await _couponService.UpdateCouponAsync(id, request);
        return NoContent();
    }

    [HttpPatch("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, CouponStatusUpdateDto request)
    {
        await _couponService.UpdateCouponStatusAsync(id, request.Status);
        return NoContent();
    }

    [HttpGet("stats")]
    public async Task<ActionResult<CalendarShop.Api.Dtos.AdminStats.AdminCouponStatsDto>> GetStats([FromQuery] int days = 7)
    {
        var stats = await _couponService.GetAdminCouponStatsAsync(days);
        return Ok(stats);
    }
}
