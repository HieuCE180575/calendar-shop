using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class FavoriteMappingProfile : Profile
{
    public FavoriteMappingProfile()
    {
        CreateMap<Favorite, FavoriteDto>()
            .ForMember(dest => dest.ProductName, opt => opt.MapFrom(src => src.Product != null ? src.Product.ProductName : string.Empty))
            .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.Product != null ? src.Product.ImageUrl : null))
            .ForMember(dest => dest.Price, opt => opt.MapFrom(src => src.Product != null ? src.Product.Price : 0))
            .ForMember(dest => dest.CalendarType, opt => opt.MapFrom(src => src.Product != null ? src.Product.CalendarType : string.Empty))
            .ForMember(dest => dest.ProductStatus, opt => opt.MapFrom(src => src.Product != null ? src.Product.Status : string.Empty));
    }
}
