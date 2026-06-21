using AutoMapper;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace CalendarShop.Api.Services;

public class AuthService : IAuthService
{
    private readonly IRepository<User> _userRepository;
    private readonly IRepository<RefreshToken> _refreshTokenRepository;
    private readonly PasswordService _passwordService;
    private readonly JwtService _jwtService;
    private readonly IMapper _mapper;

    public AuthService(
        IRepository<User> userRepository,
        IRepository<RefreshToken> refreshTokenRepository,
        PasswordService passwordService,
        JwtService jwtService,
        IMapper mapper)
    {
        _userRepository = userRepository;
        _refreshTokenRepository = refreshTokenRepository;
        _passwordService = passwordService;
        _jwtService = jwtService;
        _mapper = mapper;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        var exists = await _userRepository.Entities.AnyAsync(x =>
            (!string.IsNullOrEmpty(request.Email) && x.Email == request.Email) ||
            (!string.IsNullOrEmpty(request.Phone) && x.Phone == request.Phone));

        if (exists)
        {
            throw new BadHttpRequestException("Email hoặc số điện thoại đã tồn tại.");
        }

        var user = _mapper.Map<User>(request);
        user.PasswordHash = _passwordService.Hash(request.Password);

        await _userRepository.AddAsync(user);
        await _userRepository.SaveChangesAsync();

        // Sinh Refresh Token mới
        var refreshTokenValue = _jwtService.GenerateRefreshToken();
        var refreshToken = new RefreshToken
        {
            UserId = user.UserId,
            Token = refreshTokenValue,
            ExpiredAt = DateTime.UtcNow.AddDays(7),
            IsRevoked = false
        };
        await _refreshTokenRepository.AddAsync(refreshToken);
        await _refreshTokenRepository.SaveChangesAsync();

        return ToAuthResponse(user, refreshTokenValue);
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        var user = await _userRepository.Entities.FirstOrDefaultAsync(x => x.Email == request.Login || x.Phone == request.Login);
        
        if (user == null)
        {
            throw new UnauthorizedAccessException("Sai tài khoản hoặc mật khẩu.");
        }
        
        if (user.Status == "Locked")
        {
            throw new BadHttpRequestException("Tài khoản đã bị khóa.");
        }
        
        if (!_passwordService.Verify(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Sai tài khoản hoặc mật khẩu.");
        }

        // Sinh Refresh Token mới mỗi khi đăng nhập thành công
        var refreshTokenValue = _jwtService.GenerateRefreshToken();
        var refreshToken = new RefreshToken
        {
            UserId = user.UserId,
            Token = refreshTokenValue,
            ExpiredAt = DateTime.UtcNow.AddDays(7),
            IsRevoked = false
        };
        await _refreshTokenRepository.AddAsync(refreshToken);
        await _refreshTokenRepository.SaveChangesAsync();

        return ToAuthResponse(user, refreshTokenValue);
    }

    public async Task<UserDto> GetMeAsync(int userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }
        return _mapper.Map<UserDto>(user);
    }

    public async Task ChangePasswordAsync(int userId, ChangePasswordRequest request)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        if (!_passwordService.Verify(request.OldPassword, user.PasswordHash))
        {
            throw new BadHttpRequestException("Mật khẩu cũ không đúng.");
        }

        user.PasswordHash = _passwordService.Hash(request.NewPassword);
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();
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

        if (user.Status == "Locked")
        {
            throw new BadHttpRequestException("Tài khoản đã bị khóa.");
        }

        // Tìm token cũ đang hoạt động
        var storedRefreshToken = await _refreshTokenRepository.Entities
            .FirstOrDefaultAsync(x => x.UserId == userId && x.Token == request.RefreshToken && !x.IsRevoked && x.ExpiredAt > DateTime.UtcNow);

        if (storedRefreshToken == null)
        {
            throw new BadHttpRequestException("Token làm mới không hợp lệ hoặc đã hết hạn.");
        }

        // Thu hồi token cũ
        storedRefreshToken.IsRevoked = true;
        _refreshTokenRepository.Update(storedRefreshToken);

        // Sinh cặp token mới
        var newAccessToken = _jwtService.GenerateToken(user);
        var newRefreshTokenValue = _jwtService.GenerateRefreshToken();

        var newRefreshToken = new RefreshToken
        {
            UserId = user.UserId,
            Token = newRefreshTokenValue,
            ExpiredAt = DateTime.UtcNow.AddDays(7),
            IsRevoked = false
        };
        await _refreshTokenRepository.AddAsync(newRefreshToken);
        await _refreshTokenRepository.SaveChangesAsync();

        return new AuthResponse(newAccessToken, newRefreshTokenValue, _mapper.Map<UserDto>(user));
    }

    private AuthResponse ToAuthResponse(User user, string refreshToken)
    {
        return new AuthResponse(_jwtService.GenerateToken(user), refreshToken, _mapper.Map<UserDto>(user));
    }
}
