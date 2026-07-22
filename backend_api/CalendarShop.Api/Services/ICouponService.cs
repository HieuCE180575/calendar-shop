using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface ICouponService
{
    IQueryable<CouponDto> GetAllCouponsQuery();
    Task<CouponDto> GetCouponByIdAsync(int id);
    Task<CouponDto> CreateCouponAsync(CouponCreateUpdateDto request);
    Task UpdateCouponAsync(int id, CouponCreateUpdateDto request);
    Task UpdateCouponStatusAsync(int id, string status);
    Task<CouponDto> CheckCouponAsync(string code, decimal subTotal);
}
