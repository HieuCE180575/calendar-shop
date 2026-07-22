using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class DiscountMappingProfile : Profile
{
    public DiscountMappingProfile()
    {
        CreateMap<Discount, DiscountDto>()
            .ForMember(dest => dest.ProductIds, opt => opt.MapFrom(src => src.Products.Select(p => p.ProductId)));
    }
}
