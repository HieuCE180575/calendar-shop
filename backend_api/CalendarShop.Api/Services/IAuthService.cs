using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IAuthService
{
    Task<RegisterResponse> RegisterAsync(RegisterRequest request);
    Task<AuthResponse> LoginAsync(LoginRequest request);
    Task<AuthResponse> GoogleLoginAsync(GoogleLoginRequest request);
    Task<UserDto> GetMeAsync(int userId);
    Task<UserDto> UpdateProfileAsync(int userId, UpdateProfileRequest request);
    Task ChangePasswordAsync(int userId, ChangePasswordRequest request);
    Task LogoutAsync(int userId, LogoutRequest request);
    Task<AuthResponse> RefreshAsync(RefreshTokenRequest request);
    Task<ForgotPasswordResponse> ForgotPasswordAsync(ForgotPasswordRequest request);
    Task<MessageResponse> VerifyResetCodeAsync(VerifyResetCodeRequest request);
    Task ResetPasswordAsync(ResetPasswordRequest request);
    Task<MessageResponse> ConfirmEmailAsync(string token);
    Task<MessageResponse> ResendEmailConfirmationAsync(ResendEmailConfirmationRequest request);
}
