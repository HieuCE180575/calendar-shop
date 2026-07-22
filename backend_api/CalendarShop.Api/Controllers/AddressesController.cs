using System.Linq;
using System.Threading.Tasks;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers
{
    [Authorize]
    public class AddressesController : AppControllerBase
    {
        private readonly IAddressService _addressService;

        public AddressesController(IAddressService addressService)
        {
            _addressService = addressService;
        }

        [HttpGet]
        [EnableQuery]
        public ActionResult<IQueryable<AddressDto>> GetAll()
        {
            var addresses = _addressService.GetUserAddressesQuery(CurrentUserId);
            return Ok(addresses);
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<AddressDto>> GetById(int id)
        {
            try
            {
                var address = await _addressService.GetAddressByIdAsync(CurrentUserId, id);
                return Ok(address);
            }
            catch (System.Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPost]
        public async Task<ActionResult<AddressDto>> Create([FromBody] CreateAddressDto request)
        {
            var createdAddress = await _addressService.CreateAddressAsync(CurrentUserId, request);
            return CreatedAtAction(nameof(GetById), new { id = createdAddress.AddressId }, createdAddress);
        }

        [HttpPut("{id:int}")]
        public async Task<ActionResult<AddressDto>> Update(int id, [FromBody] UpdateAddressDto request)
        {
            try
            {
                var updatedAddress = await _addressService.UpdateAddressAsync(CurrentUserId, id, request);
                return Ok(updatedAddress);
            }
            catch (System.Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                await _addressService.DeleteAddressAsync(CurrentUserId, id);
                return NoContent();
            }
            catch (System.Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPatch("{id:int}/default")]
        public async Task<IActionResult> SetDefault(int id)
        {
            try
            {
                await _addressService.SetDefaultAddressAsync(CurrentUserId, id);
                return NoContent();
            }
            catch (System.Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
