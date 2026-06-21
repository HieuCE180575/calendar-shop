using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterRequest request);
    Task<AuthResponse> LoginAsync(LoginRequest request);
    Task<UserDto> GetMeAsync(int userId);
    Task ChangePasswordAsync(int userId, ChangePasswordRequest request);
    Task<AuthResponse> RefreshAsync(RefreshTokenRequest request);
}
