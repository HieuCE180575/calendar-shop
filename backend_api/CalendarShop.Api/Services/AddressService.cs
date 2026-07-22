using System;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services
{
    public class AddressService : IAddressService
    {
        private readonly IRepository<UserAddress> _addressRepository;
        private readonly IMapper _mapper;

        public AddressService(IRepository<UserAddress> addressRepository, IMapper mapper)
        {
            _addressRepository = addressRepository;
            _mapper = mapper;
        }

        public IQueryable<AddressDto> GetUserAddressesQuery(int userId)
        {
            return _addressRepository.Entities
                .Where(a => a.UserId == userId)
                .ProjectTo<AddressDto>(_mapper.ConfigurationProvider);
        }

        public async Task<AddressDto> GetAddressByIdAsync(int userId, int addressId)
        {
            var address = await _addressRepository.GetByIdAsync(addressId);
            if (address == null || address.UserId != userId)
            {
                throw new Exception("Address not found.");
            }

            return _mapper.Map<AddressDto>(address);
        }

        public async Task<AddressDto> CreateAddressAsync(int userId, CreateAddressDto request)
        {
            var address = _mapper.Map<UserAddress>(request);
            address.UserId = userId;
            address.CreatedAt = DateTime.UtcNow;

            var existingAddresses = await _addressRepository.Entities
                .Where(a => a.UserId == userId)
                .ToListAsync();
            
            if (!existingAddresses.Any())
            {
                address.IsDefault = true;
            }
            else if (address.IsDefault)
            {
                var currentDefault = existingAddresses.FirstOrDefault(a => a.IsDefault);
                if (currentDefault != null)
                {
                    currentDefault.IsDefault = false;
                    currentDefault.UpdatedAt = DateTime.UtcNow;
                    _addressRepository.Update(currentDefault);
                }
            }

            await _addressRepository.AddAsync(address);
            await _addressRepository.SaveChangesAsync();
            
            return _mapper.Map<AddressDto>(address);
        }

        public async Task<AddressDto> UpdateAddressAsync(int userId, int addressId, UpdateAddressDto request)
        {
            var address = await _addressRepository.GetByIdAsync(addressId);
            if (address == null || address.UserId != userId)
            {
                throw new Exception("Address not found.");
            }

            _mapper.Map(request, address);
            address.UpdatedAt = DateTime.UtcNow;

            if (address.IsDefault)
            {
                var existingAddresses = await _addressRepository.Entities
                    .Where(a => a.UserId == userId && a.AddressId != addressId)
                    .ToListAsync();
                    
                var currentDefault = existingAddresses.FirstOrDefault(a => a.IsDefault);
                if (currentDefault != null)
                {
                    currentDefault.IsDefault = false;
                    currentDefault.UpdatedAt = DateTime.UtcNow;
                    _addressRepository.Update(currentDefault);
                }
            }
            else
            {
                var existingAddresses = await _addressRepository.Entities
                    .Where(a => a.UserId == userId && a.AddressId != addressId)
                    .ToListAsync();
                    
                if (!existingAddresses.Any(a => a.IsDefault))
                {
                    address.IsDefault = true;
                }
            }

            _addressRepository.Update(address);
            await _addressRepository.SaveChangesAsync();
            
            return _mapper.Map<AddressDto>(address);
        }

        public async Task DeleteAddressAsync(int userId, int addressId)
        {
            var address = await _addressRepository.GetByIdAsync(addressId);
            if (address == null || address.UserId != userId)
            {
                throw new Exception("Address not found.");
            }

            _addressRepository.Delete(address);

            if (address.IsDefault)
            {
                var remainingAddresses = await _addressRepository.Entities
                    .Where(a => a.UserId == userId && a.AddressId != addressId)
                    .ToListAsync();
                    
                var newDefault = remainingAddresses.OrderByDescending(a => a.CreatedAt).FirstOrDefault();
                if (newDefault != null)
                {
                    newDefault.IsDefault = true;
                    newDefault.UpdatedAt = DateTime.UtcNow;
                    _addressRepository.Update(newDefault);
                }
            }
            
            await _addressRepository.SaveChangesAsync();
        }

        public async Task SetDefaultAddressAsync(int userId, int addressId)
        {
            var existingAddresses = await _addressRepository.Entities
                .Where(a => a.UserId == userId)
                .ToListAsync();
            
            var targetAddress = existingAddresses.FirstOrDefault(a => a.AddressId == addressId);
            if (targetAddress == null)
            {
                throw new Exception("Address not found.");
            }

            foreach (var addr in existingAddresses)
            {
                if (addr.AddressId == addressId)
                {
                    if (!addr.IsDefault)
                    {
                        addr.IsDefault = true;
                        addr.UpdatedAt = DateTime.UtcNow;
                        _addressRepository.Update(addr);
                    }
                }
                else if (addr.IsDefault)
                {
                    addr.IsDefault = false;
                    addr.UpdatedAt = DateTime.UtcNow;
                    _addressRepository.Update(addr);
                }
            }
            
            await _addressRepository.SaveChangesAsync();
        }
    }
}
