using System.Linq;
using System.Threading.Tasks;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services
{
    public interface IAddressService
    {
        IQueryable<AddressDto> GetUserAddressesQuery(int userId);
        Task<AddressDto> GetAddressByIdAsync(int userId, int addressId);
        Task<AddressDto> CreateAddressAsync(int userId, CreateAddressDto request);
        Task<AddressDto> UpdateAddressAsync(int userId, int addressId, UpdateAddressDto request);
        Task DeleteAddressAsync(int userId, int addressId);
        Task SetDefaultAddressAsync(int userId, int addressId);
    }
}
