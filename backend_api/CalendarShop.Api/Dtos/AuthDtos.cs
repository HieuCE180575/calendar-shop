namespace CalendarShop.Api.Dtos;

public record RegisterRequest(string FullName, string? Email, string? Phone, string Password);
public record RegisterResponse(string Message);
public record LoginRequest(string Login, string Password);
public record GoogleLoginRequest(string? Email, string? FullName, string? PhotoUrl, string? IdToken);
public record ChangePasswordRequest(string OldPassword, string NewPassword);
public record UpdateProfileRequest(
    string FullName,
    string? Email,
    string? Phone,
    string? AvatarUrl,
    string? Gender,
    DateTime? DateOfBirth
);

public record LogoutRequest(string? RefreshToken);
public record RefreshTokenRequest(string Token, string RefreshToken);

public record ForgotPasswordRequest(string Login);
public record ForgotPasswordResponse(string Message, DateTime? ExpiredAt);
public record VerifyResetCodeRequest(string ResetCode);
public record ResetPasswordRequest(string ResetToken, string NewPassword);
public record ConfirmEmailRequest(string Token);
public record ResendEmailConfirmationRequest(string Email);
public record MessageResponse(string Message);

public record UserDto(
    int UserId,
    string FullName,
    string? Email,
    string? Phone,
    string Role,
    string Status,
    bool IsEmailConfirmed,
    DateTime? EmailConfirmedAt,
    string? AvatarUrl,
    string? Gender,
    DateTime? DateOfBirth,
    DateTime CreatedAt,
    DateTime? UpdatedAt
);

public record AuthResponse(string Token, string RefreshToken, UserDto User);

public record UpdateUserStatusRequest(string Status);
public record UpdateUserRoleRequest(string Role);
