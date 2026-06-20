using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Controllers;

public class AuthController : AppControllerBase
{
    private readonly AppDbContext _db;
    private readonly PasswordService _passwordService;
    private readonly JwtService _jwtService;

    public AuthController(AppDbContext db, PasswordService passwordService, JwtService jwtService)
    {
        _db = db;
        _passwordService = passwordService;
        _jwtService = jwtService;
    }

    [HttpPost("register")]
    public async Task<ActionResult<AuthResponse>> Register(RegisterRequest request)
    {
        var exists = await _db.Users.AnyAsync(x =>
            (!string.IsNullOrEmpty(request.Email) && x.Email == request.Email) ||
            (!string.IsNullOrEmpty(request.Phone) && x.Phone == request.Phone));

        if (exists) return BadRequest("Email hoặc số điện thoại đã tồn tại.");

        var user = new User
        {
            FullName = request.FullName,
            Email = request.Email,
            Phone = request.Phone,
            PasswordHash = _passwordService.Hash(request.Password),
            Role = "Customer",
            Status = "Active"
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        return Ok(ToAuthResponse(user));
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResponse>> Login(LoginRequest request)
    {
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Email == request.Login || x.Phone == request.Login);
        if (user == null) return Unauthorized("Sai tài khoản hoặc mật khẩu.");
        if (user.Status == "Locked") return Forbid("Tài khoản đã bị khóa.");
        if (!_passwordService.Verify(request.Password, user.PasswordHash)) return Unauthorized("Sai tài khoản hoặc mật khẩu.");

        return Ok(ToAuthResponse(user));
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<ActionResult<UserDto>> Me()
    {
        var user = await _db.Users.FindAsync(CurrentUserId);
        if (user == null) return NotFound();
        return Ok(ToUserDto(user));
    }

    [Authorize]
    [HttpPut("change-password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest request)
    {
        var user = await _db.Users.FindAsync(CurrentUserId);
        if (user == null) return NotFound();
        if (!_passwordService.Verify(request.OldPassword, user.PasswordHash)) return BadRequest("Mật khẩu cũ không đúng.");

        user.PasswordHash = _passwordService.Hash(request.NewPassword);
        user.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    private AuthResponse ToAuthResponse(User user)
    {
        return new AuthResponse(_jwtService.GenerateToken(user), ToUserDto(user));
    }

    private static UserDto ToUserDto(User user)
    {
        return new UserDto(user.UserId, user.FullName, user.Email, user.Phone, user.Role, user.Status, user.AvatarUrl);
    }
}
