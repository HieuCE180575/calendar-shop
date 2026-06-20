using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class CartMappingProfile : Profile
{
    public CartMappingProfile()
    {
        CreateMap<CartItem, CartItemDto>()
            .ForMember(dest => dest.ProductName, opt => opt.MapFrom(src => src.Product != null ? src.Product.ProductName : string.Empty))
            .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.Product != null ? src.Product.ImageUrl : null))
            .ForMember(dest => dest.Price, opt => opt.MapFrom(src => src.Product != null ? src.Product.Price : 0))
            .ForMember(dest => dest.StockQuantity, opt => opt.MapFrom(src => src.Product != null ? src.Product.StockQuantity : 0))
            .ForMember(dest => dest.LineTotal, opt => opt.MapFrom(src => src.Product != null ? src.Product.Price * src.Quantity : 0));
    }
}
