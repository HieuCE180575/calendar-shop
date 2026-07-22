using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Mappings
{
    public class AddressMappingProfile : Profile
    {
        public AddressMappingProfile()
        {
            CreateMap<UserAddress, AddressDto>();
            CreateMap<CreateAddressDto, UserAddress>();
            CreateMap<UpdateAddressDto, UserAddress>();
        }
    }
}
