using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IUserService
{
    IQueryable<UserDto> GetUsersQuery(string? search, string? role, string? status);
    Task<UserDto> GetUserByIdAsync(int id);
    Task UpdateUserStatusAsync(int currentAdminId, int id, UpdateUserStatusRequest request);
    Task UpdateUserRoleAsync(int currentAdminId, int id, UpdateUserRoleRequest request);
}
