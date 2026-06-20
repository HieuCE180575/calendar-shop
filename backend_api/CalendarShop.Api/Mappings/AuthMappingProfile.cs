using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings;

public class AuthMappingProfile : Profile
{
    public AuthMappingProfile()
    {
        CreateMap<User, UserDto>();
        CreateMap<RegisterRequest, User>()
            .ForMember(dest => dest.PasswordHash, opt => opt.Ignore())
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => "Customer"))
            .ForMember(dest => dest.Status, opt => opt.MapFrom(src => "Active"));
    }
}
