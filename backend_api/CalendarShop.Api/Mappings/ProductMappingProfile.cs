using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class ProductMappingProfile : Profile
{
    public ProductMappingProfile()
    {
        // Category Mappings
        CreateMap<Category, CategoryDto>().ReverseMap();
        CreateMap<CategoryCreateUpdateDto, Category>();

        // Product Mappings
        CreateMap<Product, ProductDto>()
            .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category != null ? src.Category.CategoryName : null));
        CreateMap<ProductCreateUpdateDto, Product>();
    }
}
