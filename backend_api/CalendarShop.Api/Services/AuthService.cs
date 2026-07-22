using AutoMapper;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Options;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Net;
using System.Security.Claims;
using System.Security.Cryptography;

namespace CalendarShop.Api.Services;

public class AuthService : IAuthService
{
    private const int RefreshTokenDays = 7;
    private const int PasswordResetMinutes = 30;
    private const int EmailConfirmationMinutes = 24 * 60;

    private readonly IRepository<User> _userRepository;
    private readonly IRepository<RefreshToken> _refreshTokenRepository;
    private readonly IRepository<PasswordResetToken> _passwordResetTokenRepository;
    private readonly PasswordService _passwordService;
    private readonly JwtService _jwtService;
    private readonly IEmailService _emailService;
    private readonly EmailSettings _emailSettings;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IMapper _mapper;

    public AuthService(
        IRepository<User> userRepository,
        IRepository<RefreshToken> refreshTokenRepository,
        IRepository<PasswordResetToken> passwordResetTokenRepository,
        PasswordService passwordService,
        JwtService jwtService,
        IEmailService emailService,
        IOptions<EmailSettings> emailSettings,
        IHttpContextAccessor httpContextAccessor,
        IMapper mapper)
    {
        _userRepository = userRepository;
        _refreshTokenRepository = refreshTokenRepository;
        _passwordResetTokenRepository = passwordResetTokenRepository;
        _passwordService = passwordService;
        _jwtService = jwtService;
        _emailService = emailService;
        _emailSettings = emailSettings.Value;
        _httpContextAccessor = httpContextAccessor;
        _mapper = mapper;
    }

    public async Task<RegisterResponse> RegisterAsync(RegisterRequest request)
    {
        var email = NormalizeEmail(request.Email);
        var phone = NormalizePhone(request.Phone);

        if (string.IsNullOrWhiteSpace(email))
        {
            throw new BadHttpRequestException("Email là bắt buộc để gửi mail xác nhận kích hoạt tài khoản.");
        }

        var exists = await _userRepository.Entities.AnyAsync(x =>
            x.Email == email ||
            (!string.IsNullOrEmpty(phone) && x.Phone == phone));

        if (exists)
        {
            throw new BadHttpRequestException("Email hoặc số điện thoại đã tồn tại.");
        }

        var rawConfirmToken = GenerateSecurityToken();
        var user = _mapper.Map<User>(request);
        user.FullName = request.FullName.Trim();
        user.Email = email;
        user.Phone = phone;
        user.PasswordHash = _passwordService.Hash(request.Password);
        user.Role = "Customer";
        user.Status = "Pending";
        user.IsEmailConfirmed = false;
        user.EmailConfirmationTokenHash = _passwordService.Hash(rawConfirmToken);
        user.EmailConfirmationTokenExpiredAt = DateTime.UtcNow.AddMinutes(EmailConfirmationMinutes);
        user.CreatedAt = DateTime.UtcNow;

        await _userRepository.AddAsync(user);
        await _userRepository.SaveChangesAsync();

        await SendEmailConfirmationAsync(user, rawConfirmToken);

        return new RegisterResponse("Đăng ký thành công. Vui lòng kiểm tra email để xác nhận và kích hoạt tài khoản.");
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        var login = request.Login.Trim();
        var emailLogin = NormalizeEmail(login);
        var phoneLogin = NormalizePhone(login);
        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.Email == emailLogin || x.Phone == phoneLogin);

        if (user == null || !_passwordService.Verify(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Sai tài khoản hoặc mật khẩu.");
        }

        EnsureCanLogin(user);

        var refreshTokenValue = await CreateRefreshTokenAsync(user.UserId);
        await _refreshTokenRepository.SaveChangesAsync();

        return ToAuthResponse(user, refreshTokenValue);
    }

    public async Task<AuthResponse> GoogleLoginAsync(GoogleLoginRequest request)
    {
        var email = NormalizeEmail(request.Email ?? string.Empty);
        if (string.IsNullOrWhiteSpace(email))
        {
            throw new BadHttpRequestException("Email Google không hợp lệ.");
        }

        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.Email == email);

        if (user != null)
        {
            if (user.Status == "Locked")
            {
                throw new BadHttpRequestException("Tài khoản của bạn đã bị khóa.");
            }

            user.IsEmailConfirmed = true;
            user.EmailConfirmedAt ??= DateTime.UtcNow;
            if (user.Status == "Pending")
            {
                user.Status = "Active";
            }
            if (string.IsNullOrEmpty(user.AvatarUrl) && !string.IsNullOrWhiteSpace(request.PhotoUrl))
            {
                user.AvatarUrl = request.PhotoUrl.Trim();
            }
            user.UpdatedAt = DateTime.UtcNow;
            _userRepository.Update(user);
        }
        else
        {
            var fullName = !string.IsNullOrWhiteSpace(request.FullName)
                ? request.FullName.Trim()
                : email.Split('@')[0];

            user = new User
            {
                FullName = fullName,
                Email = email,
                PasswordHash = _passwordService.Hash(Guid.NewGuid().ToString("N") + "!1Aa"),
                AvatarUrl = NormalizeNullable(request.PhotoUrl),
                Role = "Customer",
                Status = "Active",
                IsEmailConfirmed = true,
                EmailConfirmedAt = DateTime.UtcNow,
                CreatedAt = DateTime.UtcNow
            };

            await _userRepository.AddAsync(user);
        }

        await _userRepository.SaveChangesAsync();

        var refreshTokenValue = await CreateRefreshTokenAsync(user.UserId);
        await _refreshTokenRepository.SaveChangesAsync();

        return ToAuthResponse(user, refreshTokenValue);
    }

    public async Task<UserDto> GetMeAsync(int userId)
    {
        var user = await GetUserOrThrowAsync(userId);
        return _mapper.Map<UserDto>(user);
    }

    public async Task<UserDto> UpdateProfileAsync(int userId, UpdateProfileRequest request)
    {
        var user = await GetUserOrThrowAsync(userId);
        var email = NormalizeEmail(request.Email);
        var phone = NormalizePhone(request.Phone);

        if (string.IsNullOrWhiteSpace(email) && string.IsNullOrWhiteSpace(phone))
        {
            throw new BadHttpRequestException("Email hoặc số điện thoại là bắt buộc.");
        }

        var exists = await _userRepository.Entities.AnyAsync(x =>
            x.UserId != userId &&
            ((!string.IsNullOrEmpty(email) && x.Email == email) ||
             (!string.IsNullOrEmpty(phone) && x.Phone == phone)));

        if (exists)
        {
            throw new BadHttpRequestException("Email hoặc số điện thoại đã được sử dụng bởi tài khoản khác.");
        }

        user.FullName = request.FullName.Trim();
        user.Phone = phone;
        user.AvatarUrl = NormalizeNullable(request.AvatarUrl);
        user.Gender = NormalizeNullable(request.Gender);
        user.DateOfBirth = request.DateOfBirth;
        user.UpdatedAt = DateTime.UtcNow;

        if (!string.Equals(user.Email, email, StringComparison.OrdinalIgnoreCase))
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                throw new BadHttpRequestException("Email là bắt buộc để xác nhận tài khoản.");
            }

            var rawConfirmToken = GenerateSecurityToken();
            user.Email = email;
            user.IsEmailConfirmed = false;
            user.EmailConfirmedAt = null;
            user.EmailConfirmationTokenHash = _passwordService.Hash(rawConfirmToken);
            user.EmailConfirmationTokenExpiredAt = DateTime.UtcNow.AddMinutes(EmailConfirmationMinutes);
            user.Status = "Pending";
            _userRepository.Update(user);
            await RevokeActiveRefreshTokensAsync(user.UserId);
            await _userRepository.SaveChangesAsync();
            await SendEmailConfirmationAsync(user, rawConfirmToken);
            return _mapper.Map<UserDto>(user);
        }

        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();

        return _mapper.Map<UserDto>(user);
    }

    public async Task ChangePasswordAsync(int userId, ChangePasswordRequest request)
    {
        var user = await GetUserOrThrowAsync(userId);

        if (!_passwordService.Verify(request.OldPassword, user.PasswordHash))
        {
            throw new BadHttpRequestException("Mật khẩu cũ không đúng.");
        }

        user.PasswordHash = _passwordService.Hash(request.NewPassword);
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);

        await RevokeActiveRefreshTokensAsync(user.UserId);
        await _userRepository.SaveChangesAsync();
    }

    public async Task LogoutAsync(int userId, LogoutRequest request)
    {
        var refreshToken = NormalizeNullable(request.RefreshToken);

        if (string.IsNullOrEmpty(refreshToken))
        {
            await RevokeActiveRefreshTokensAsync(userId);
        }
        else
        {
            var storedRefreshToken = await _refreshTokenRepository.Entities
                .FirstOrDefaultAsync(x => x.UserId == userId && x.Token == refreshToken && !x.IsRevoked);

            if (storedRefreshToken != null)
            {
                storedRefreshToken.IsRevoked = true;
                _refreshTokenRepository.Update(storedRefreshToken);
            }
        }

        await _refreshTokenRepository.SaveChangesAsync();
    }

    public async Task<AuthResponse> RefreshAsync(RefreshTokenRequest request)
    {
        var principal = _jwtService.GetPrincipalFromExpiredToken(request.Token);
        if (principal == null)
        {
            throw new BadHttpRequestException("Token truy cập không hợp lệ.");
        }

        var userIdClaim = principal.FindFirst(ClaimTypes.NameIdentifier);
        if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out var userId))
        {
            throw new BadHttpRequestException("Token truy cập không hợp lệ.");
        }

        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new BadHttpRequestException("Người dùng không khả dụng.");
        }

        EnsureCanLogin(user);

        var storedRefreshToken = await _refreshTokenRepository.Entities
            .FirstOrDefaultAsync(x => x.UserId == userId && x.Token == request.RefreshToken && !x.IsRevoked && x.ExpiredAt > DateTime.UtcNow);

        if (storedRefreshToken == null)
        {
            throw new BadHttpRequestException("Token làm mới không hợp lệ hoặc đã hết hạn.");
        }

        storedRefreshToken.IsRevoked = true;
        _refreshTokenRepository.Update(storedRefreshToken);

        var newAccessToken = _jwtService.GenerateToken(user);
        var newRefreshTokenValue = await CreateRefreshTokenAsync(user.UserId);
        await _refreshTokenRepository.SaveChangesAsync();

        return new AuthResponse(newAccessToken, newRefreshTokenValue, _mapper.Map<UserDto>(user));
    }

    public async Task<ForgotPasswordResponse> ForgotPasswordAsync(ForgotPasswordRequest request)
    {
        var login = request.Login.Trim();
        var emailLogin = NormalizeEmail(login);
        var phoneLogin = NormalizePhone(login);
        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.Email == emailLogin || x.Phone == phoneLogin);

        if (user == null)
        {
            return new ForgotPasswordResponse("Nếu tài khoản tồn tại, hệ thống sẽ gửi email hướng dẫn đặt lại mật khẩu.", null);
        }

        if (user.Status == "Locked")
        {
            throw new BadHttpRequestException("Tài khoản đã bị khóa.");
        }

        if (string.IsNullOrWhiteSpace(user.Email))
        {
            throw new BadHttpRequestException("Tài khoản chưa có email nên không thể gửi token đặt lại mật khẩu.");
        }

        if (!user.IsEmailConfirmed)
        {
            throw new BadHttpRequestException("Email của tài khoản chưa được xác nhận. Vui lòng xác nhận email trước.");
        }

        var oldTokens = await _passwordResetTokenRepository.Entities
            .Where(x => x.UserId == user.UserId && !x.IsUsed && x.ExpiredAt > DateTime.UtcNow)
            .ToListAsync();

        foreach (var oldToken in oldTokens)
        {
            oldToken.IsUsed = true;
            _passwordResetTokenRepository.Update(oldToken);
        }

        var rawToken = GenerateOtpCode();
        var expiresAt = DateTime.UtcNow.AddMinutes(PasswordResetMinutes);
        var resetToken = new PasswordResetToken
        {
            UserId = user.UserId,
            Token = _passwordService.Hash(rawToken),
            ExpiredAt = expiresAt,
            IsUsed = false,
            CreatedAt = DateTime.UtcNow
        };

        await _passwordResetTokenRepository.AddAsync(resetToken);
        await _passwordResetTokenRepository.SaveChangesAsync();

        await SendResetPasswordEmailAsync(user, rawToken, expiresAt);

        return new ForgotPasswordResponse("Mã OTP đặt lại mật khẩu đã được gửi về email của bạn.", expiresAt);
    }

    public async Task<MessageResponse> VerifyResetCodeAsync(VerifyResetCodeRequest request)
    {
        var rawCode = request.ResetCode.Trim();
        if (string.IsNullOrWhiteSpace(rawCode))
        {
            throw new BadHttpRequestException("Mã OTP không được để trống.");
        }

        var hashedCode = _passwordService.Hash(rawCode);
        var resetToken = await _passwordResetTokenRepository.Entities
            .FirstOrDefaultAsync(x => x.Token == hashedCode && !x.IsUsed && x.ExpiredAt > DateTime.UtcNow);

        if (resetToken == null)
        {
            throw new BadHttpRequestException("Mã OTP không hợp lệ hoặc đã hết hạn.");
        }

        return new MessageResponse("Mã OTP hợp lệ.");
    }

    public async Task ResetPasswordAsync(ResetPasswordRequest request)
    {
        var hashedToken = _passwordService.Hash(request.ResetToken.Trim());
        var resetToken = await _passwordResetTokenRepository.Entities
            .Include(x => x.User)
            .FirstOrDefaultAsync(x => x.Token == hashedToken && !x.IsUsed && x.ExpiredAt > DateTime.UtcNow);

        if (resetToken == null || resetToken.User == null)
        {
            throw new BadHttpRequestException("Token đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
        }

        resetToken.User.PasswordHash = _passwordService.Hash(request.NewPassword);
        resetToken.User.UpdatedAt = DateTime.UtcNow;
        resetToken.IsUsed = true;

        _userRepository.Update(resetToken.User);
        _passwordResetTokenRepository.Update(resetToken);
        await RevokeActiveRefreshTokensAsync(resetToken.UserId);
        await _passwordResetTokenRepository.SaveChangesAsync();
    }

    public async Task<MessageResponse> ConfirmEmailAsync(string token)
    {
        var rawToken = NormalizeNullable(token);
        if (string.IsNullOrWhiteSpace(rawToken))
        {
            throw new BadHttpRequestException("Token xác nhận email là bắt buộc.");
        }

        var hashedToken = _passwordService.Hash(rawToken);
        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.EmailConfirmationTokenHash == hashedToken);
        if (user == null)
        {
            throw new BadHttpRequestException("Token xác nhận email không hợp lệ.");
        }

        if (user.EmailConfirmationTokenExpiredAt == null || user.EmailConfirmationTokenExpiredAt <= DateTime.UtcNow)
        {
            throw new BadHttpRequestException("Token xác nhận email đã hết hạn. Vui lòng yêu cầu gửi lại email xác nhận.");
        }

        user.IsEmailConfirmed = true;
        user.EmailConfirmedAt = DateTime.UtcNow;
        user.EmailConfirmationTokenHash = null;
        user.EmailConfirmationTokenExpiredAt = null;
        if (user.Status == "Pending")
        {
            user.Status = "Active";
        }
        user.UpdatedAt = DateTime.UtcNow;

        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();

        return new MessageResponse("Email đã được xác nhận. Tài khoản đã được kích hoạt.");
    }

    public async Task<MessageResponse> ResendEmailConfirmationAsync(ResendEmailConfirmationRequest request)
    {
        var email = NormalizeEmail(request.Email);
        if (string.IsNullOrWhiteSpace(email))
        {
            throw new BadHttpRequestException("Email là bắt buộc.");
        }

        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.Email == email);
        if (user == null)
        {
            return new MessageResponse("Nếu email tồn tại, hệ thống sẽ gửi lại mail xác nhận.");
        }

        if (user.IsEmailConfirmed)
        {
            return new MessageResponse("Email này đã được xác nhận. Bạn có thể đăng nhập.");
        }

        var rawConfirmToken = GenerateSecurityToken();
        user.EmailConfirmationTokenHash = _passwordService.Hash(rawConfirmToken);
        user.EmailConfirmationTokenExpiredAt = DateTime.UtcNow.AddMinutes(EmailConfirmationMinutes);
        user.Status = "Pending";
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();

        await SendEmailConfirmationAsync(user, rawConfirmToken);
        return new MessageResponse("Email xác nhận đã được gửi lại. Vui lòng kiểm tra hộp thư.");
    }

    private async Task<User> GetUserOrThrowAsync(int userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        return user;
    }

    private async Task<string> CreateRefreshTokenAsync(int userId)
    {
        var refreshTokenValue = _jwtService.GenerateRefreshToken();
        var refreshToken = new RefreshToken
        {
            UserId = userId,
            Token = refreshTokenValue,
            ExpiredAt = DateTime.UtcNow.AddDays(RefreshTokenDays),
            IsRevoked = false
        };
        await _refreshTokenRepository.AddAsync(refreshToken);
        return refreshTokenValue;
    }

    private async Task RevokeActiveRefreshTokensAsync(int userId)
    {
        var tokens = await _refreshTokenRepository.Entities
            .Where(x => x.UserId == userId && !x.IsRevoked && x.ExpiredAt > DateTime.UtcNow)
            .ToListAsync();

        foreach (var token in tokens)
        {
            token.IsRevoked = true;
            _refreshTokenRepository.Update(token);
        }
    }

    private AuthResponse ToAuthResponse(User user, string refreshToken)
    {
        return new AuthResponse(_jwtService.GenerateToken(user), refreshToken, _mapper.Map<UserDto>(user));
    }

    private void EnsureCanLogin(User user)
    {
        if (user.Status == "Locked")
        {
            throw new BadHttpRequestException("Tài khoản đã bị khóa.");
        }

        if (!user.IsEmailConfirmed || user.Status == "Pending")
        {
            throw new BadHttpRequestException("Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email để xác nhận tài khoản.");
        }

        if (user.Status != "Active")
        {
            throw new BadHttpRequestException("Tài khoản không ở trạng thái hoạt động.");
        }
    }

    private async Task SendEmailConfirmationAsync(User user, string rawToken)
    {
        if (string.IsNullOrWhiteSpace(user.Email))
        {
            return;
        }

        var confirmUrl = $"{GetApiBaseUrl()}/api/auth/confirm-email?token={Uri.EscapeDataString(rawToken)}";
        var safeName = WebUtility.HtmlEncode(user.FullName);
        var safeUrl = WebUtility.HtmlEncode(confirmUrl);
        var html = $"""
        <div style="font-family:Arial,sans-serif;line-height:1.6;color:#0f172a">
            <h2>Xác nhận tài khoản Calendar Shop</h2>
            <p>Xin chào <strong>{safeName}</strong>,</p>
            <p>Bạn vừa đăng ký tài khoản tại Calendar Shop. Vui lòng bấm nút bên dưới để xác nhận email và kích hoạt tài khoản.</p>
            <p><a href="{safeUrl}" style="display:inline-block;padding:12px 18px;background:#2563eb;color:#fff;text-decoration:none;border-radius:8px">Xác nhận email</a></p>
            <p>Nếu nút không hoạt động, copy link này vào trình duyệt:</p>
            <p><a href="{safeUrl}">{safeUrl}</a></p>
            <p>Link hết hạn sau 24 giờ.</p>
        </div>
        """;

        try
        {
            await _emailService.SendAsync(user.Email, "Xác nhận tài khoản Calendar Shop", html, $"Xác nhận email: {confirmUrl}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[Warning] Could not send confirmation email to {user.Email}: {ex.Message}");
        }
    }

    private async Task SendResetPasswordEmailAsync(User user, string rawToken, DateTime expiresAt)
    {
        if (string.IsNullOrWhiteSpace(user.Email))
        {
            return;
        }

        var appResetUrl = BuildOptionalAppResetUrl(rawToken);
        var safeName = WebUtility.HtmlEncode(user.FullName);
        var safeToken = WebUtility.HtmlEncode(rawToken);
        var safeAppResetUrl = WebUtility.HtmlEncode(appResetUrl ?? string.Empty);
        var resetLinkHtml = string.IsNullOrWhiteSpace(appResetUrl)
            ? string.Empty
            : $"<p><a href=\"{safeAppResetUrl}\" style=\"display:inline-block;padding:12px 18px;background:#2563eb;color:#fff;text-decoration:none;border-radius:8px\">Mở màn hình đặt lại mật khẩu</a></p>";

        var html = $"""
        <div style="font-family:Arial,sans-serif;line-height:1.6;color:#0f172a">
            <h2>Đặt lại mật khẩu Calendar Shop</h2>
            <p>Xin chào <strong>{safeName}</strong>,</p>
            <p>Mã OTP đặt lại mật khẩu của bạn là:</p>
            <p style="font-size:28px;font-weight:bold;letter-spacing:6px;color:#2563eb;background:#f1f5f9;padding:16px;text-align:center;border-radius:8px">{safeToken}</p>
            <p>Nhập mã OTP 6 số này trong ứng dụng di động để tiến hành đặt lại mật khẩu.</p>
            {resetLinkHtml}
            <p>Mã OTP hết hạn lúc {expiresAt:yyyy-MM-dd HH:mm:ss} UTC.</p>
            <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>
        </div>
        """;

        await _emailService.SendAsync(user.Email, "Mã OTP đặt lại mật khẩu Calendar Shop", html, $"Mã OTP: {rawToken}");
    }

    private string GetApiBaseUrl()
    {
        if (!string.IsNullOrWhiteSpace(_emailSettings.ApiBaseUrl))
        {
            return _emailSettings.ApiBaseUrl.TrimEnd('/');
        }

        var request = _httpContextAccessor.HttpContext?.Request;
        if (request != null)
        {
            return $"{request.Scheme}://{request.Host}";
        }

        return string.Empty;
    }

    private string? BuildOptionalAppResetUrl(string rawToken)
    {
        var encodedToken = Uri.EscapeDataString(rawToken);

        if (!string.IsNullOrWhiteSpace(_emailSettings.AppBaseUrl))
        {
            var baseUrl = _emailSettings.AppBaseUrl.TrimEnd('/');
            if (baseUrl.Contains("/api/auth/reset-password-page"))
            {
                return $"{baseUrl}?token={encodedToken}";
            }

            if (!baseUrl.Contains("localhost:3000"))
            {
                return $"{baseUrl}/#/reset-password?token={encodedToken}";
            }
        }

        return $"{GetApiBaseUrl()}/api/auth/reset-password-page?token={encodedToken}";
    }

    private string GenerateOtpCode()
    {
        return RandomNumberGenerator.GetInt32(100000, 1000000).ToString();
    }

    private string GenerateSecurityToken()
    {
        return _jwtService.GenerateRefreshToken();
    }

    private static string? NormalizeEmail(string? email)
    {
        var value = NormalizeNullable(email);
        return value?.ToLowerInvariant();
    }

    private static string? NormalizePhone(string? phone)
    {
        return NormalizeNullable(phone)?.Replace(" ", string.Empty);
    }

    private static string? NormalizeNullable(string? value)
    {
        var trimmed = value?.Trim();
        return string.IsNullOrWhiteSpace(trimmed) ? null : trimmed;
    }
}
