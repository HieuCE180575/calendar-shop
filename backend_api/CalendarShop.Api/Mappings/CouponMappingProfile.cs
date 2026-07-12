using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class CouponMappingProfile : Profile
{
    public CouponMappingProfile()
    {
        CreateMap<Coupon, CouponDto>();
        CreateMap<CouponCreateUpdateDto, Coupon>()
            .ForMember(dest => dest.Code, opt => opt.MapFrom(src => src.Code.Trim().ToUpper()));
    }
}
