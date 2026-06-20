using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AutoMapper;

namespace CalendarShop.Api.Controllers;

public class AuthController : AppControllerBase
{
    private readonly AppDbContext _db;
    private readonly PasswordService _passwordService;
    private readonly JwtService _jwtService;
    private readonly IMapper _mapper;

    public AuthController(AppDbContext db, PasswordService passwordService, JwtService jwtService, IMapper mapper)
    {
        _db = db;
        _passwordService = passwordService;
        _jwtService = jwtService;
        _mapper = mapper;
    }

    [HttpPost("register")]
    public async Task<ActionResult<AuthResponse>> Register(RegisterRequest request)
    {
        var exists = await _db.Users.AnyAsync(x =>
            (!string.IsNullOrEmpty(request.Email) && x.Email == request.Email) ||
            (!string.IsNullOrEmpty(request.Phone) && x.Phone == request.Phone));

        if (exists) return BadRequest("Email hoặc số điện thoại đã tồn tại.");

        var user = _mapper.Map<User>(request);
        user.PasswordHash = _passwordService.Hash(request.Password);

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
        return Ok(_mapper.Map<UserDto>(user));
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
        return new AuthResponse(_jwtService.GenerateToken(user), _mapper.Map<UserDto>(user));
    }
}
