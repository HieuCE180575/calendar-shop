using AutoMapper;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class AuthService : IAuthService
{
    private readonly IRepository<User> _userRepository;
    private readonly PasswordService _passwordService;
    private readonly JwtService _jwtService;
    private readonly IMapper _mapper;

    public AuthService(IRepository<User> userRepository, PasswordService passwordService, JwtService jwtService, IMapper mapper)
    {
        _userRepository = userRepository;
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

        return ToAuthResponse(user);
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

        return ToAuthResponse(user);
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

    private AuthResponse ToAuthResponse(User user)
    {
        return new AuthResponse(_jwtService.GenerateToken(user), _mapper.Map<UserDto>(user));
    }
}
