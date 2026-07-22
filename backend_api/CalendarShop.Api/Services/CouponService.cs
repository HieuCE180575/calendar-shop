using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class CouponService : ICouponService
{
    private readonly IRepository<Coupon> _couponRepository;
    private readonly IMapper _mapper;

    public CouponService(IRepository<Coupon> couponRepository, IMapper mapper)
    {
        _couponRepository = couponRepository;
        _mapper = mapper;
    }

    public IQueryable<CouponDto> GetAllCouponsQuery()
    {
        return _couponRepository.Entities
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<CouponDto>(_mapper.ConfigurationProvider);
    }

    public async Task<CouponDto> GetCouponByIdAsync(int id)
    {
        var coupon = await _couponRepository.Entities
            .Where(x => x.CouponId == id)
            .ProjectTo<CouponDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (coupon == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        return coupon;
    }

    public async Task<CouponDto> CreateCouponAsync(CouponCreateUpdateDto request)
    {
        var normalizedCode = NormalizeCode(request.Code);
        await EnsureCouponCodeUniqueAsync(normalizedCode, null);

        var coupon = _mapper.Map<Coupon>(request);
        coupon.Code = normalizedCode;
        coupon.CreatedAt = DateTime.UtcNow;
        coupon.UpdatedAt = null;

        await _couponRepository.AddAsync(coupon);
        await _couponRepository.SaveChangesAsync();

        return await GetCouponByIdAsync(coupon.CouponId);
    }

    public async Task UpdateCouponAsync(int id, CouponCreateUpdateDto request)
    {
        var coupon = await _couponRepository.GetByIdAsync(id);
        if (coupon == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        var normalizedCode = NormalizeCode(request.Code);
        await EnsureCouponCodeUniqueAsync(normalizedCode, id);

        _mapper.Map(request, coupon);
        coupon.Code = normalizedCode;
        coupon.UpdatedAt = DateTime.UtcNow;

        if (coupon.UsageLimit.HasValue && coupon.UsedCount > coupon.UsageLimit.Value)
        {
            throw new InvalidOperationException("Giới hạn sử dụng không được nhỏ hơn số lượt đã dùng.");
        }

        _couponRepository.Update(coupon);
        await _couponRepository.SaveChangesAsync();
    }

    public async Task UpdateCouponStatusAsync(int id, string status)
    {
        var coupon = await _couponRepository.GetByIdAsync(id);
        if (coupon == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        coupon.Status = status;
        coupon.UpdatedAt = DateTime.UtcNow;
        _couponRepository.Update(coupon);
        await _couponRepository.SaveChangesAsync();
    }

    public async Task<CouponDto> CheckCouponAsync(string code, decimal subTotal)
    {
        if (subTotal <= 0)
        {
            throw new InvalidOperationException("Giá trị đơn hàng phải lớn hơn 0.");
        }

        var normalizedCode = NormalizeCode(code);
        var coupon = await _couponRepository.Entities
            .FirstOrDefaultAsync(x => x.Code == normalizedCode && x.Status == "Active");

        if (coupon == null)
        {
            throw new InvalidOperationException("Mã giảm giá không tồn tại hoặc không hợp lệ.");
        }

        if (DateTime.UtcNow < coupon.StartDate || DateTime.UtcNow > coupon.EndDate)
        {
            throw new InvalidOperationException("Mã giảm giá đã hết hạn hoặc chưa có hiệu lực.");
        }

        if (subTotal < coupon.MinOrderValue)
        {
            throw new InvalidOperationException("Đơn hàng chưa đạt giá trị tối thiểu để sử dụng mã này.");
        }

        if (coupon.UsageLimit.HasValue && coupon.UsedCount >= coupon.UsageLimit.Value)
        {
            throw new InvalidOperationException("Mã giảm giá đã hết lượt sử dụng.");
        }

        return _mapper.Map<CouponDto>(coupon);
    }

    private async Task EnsureCouponCodeUniqueAsync(string code, int? excludeCouponId)
    {
        var exists = await _couponRepository.Entities.AnyAsync(x =>
            x.Code == code && (!excludeCouponId.HasValue || x.CouponId != excludeCouponId.Value));

        if (exists)
        {
            throw new InvalidOperationException("Mã giảm giá đã tồn tại.");
        }
    }

    private static string NormalizeCode(string code)
    {
        return code.Trim().ToUpperInvariant();
    }
}
