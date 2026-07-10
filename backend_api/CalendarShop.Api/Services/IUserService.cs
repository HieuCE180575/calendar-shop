using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IUserService
{
    Task<IReadOnlyList<UserDto>> GetUsersAsync(string? search, string? role, string? status);
    Task<UserDto> GetUserByIdAsync(int id);
    Task UpdateUserStatusAsync(int currentAdminId, int id, UpdateUserStatusRequest request);
    Task UpdateUserRoleAsync(int currentAdminId, int id, UpdateUserRoleRequest request);
}
