namespace CalendarShop.Api.Dtos;

public record RegisterRequest(string FullName, string? Email, string? Phone, string Password);
public record LoginRequest(string Login, string Password);
public record ChangePasswordRequest(string OldPassword, string NewPassword);

public record UserDto(
    int UserId,
    string FullName,
    string? Email,
    string? Phone,
    string Role,
    string Status,
    string? AvatarUrl
);

public record AuthResponse(string Token, UserDto User);
