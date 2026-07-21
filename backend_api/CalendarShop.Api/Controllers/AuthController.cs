using System.Net;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

public class AuthController : AppControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("register")]
    public async Task<ActionResult<RegisterResponse>> Register(RegisterRequest request)
    {
        var response = await _authService.RegisterAsync(request);
        return Ok(response);
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResponse>> Login(LoginRequest request)
    {
        var response = await _authService.LoginAsync(request);
        return Ok(response);
    }

    [AllowAnonymous]
    [HttpGet("confirm-email")]
    public async Task<IActionResult> ConfirmEmailByLink([FromQuery] string token)
    {
        try
        {
            var response = await _authService.ConfirmEmailAsync(token);
            var html = BuildConfirmEmailHtml("Xác nhận email thành công", response.Message, true);
            return Content(html, "text/html; charset=utf-8");
        }
        catch (Exception ex)
        {
            var html = BuildConfirmEmailHtml("Xác nhận email thất bại", ex.Message, false);
            return Content(html, "text/html; charset=utf-8");
        }
    }

    [HttpPost("confirm-email")]
    public async Task<ActionResult<MessageResponse>> ConfirmEmail(ConfirmEmailRequest request)
    {
        var response = await _authService.ConfirmEmailAsync(request.Token);
        return Ok(response);
    }

    [HttpPost("resend-email-confirmation")]
    public async Task<ActionResult<MessageResponse>> ResendEmailConfirmation(ResendEmailConfirmationRequest request)
    {
        var response = await _authService.ResendEmailConfirmationAsync(request);
        return Ok(response);
    }

    [Authorize]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout(LogoutRequest request)
    {
        await _authService.LogoutAsync(CurrentUserId, request);
        return NoContent();
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<ActionResult<UserDto>> Me()
    {
        var user = await _authService.GetMeAsync(CurrentUserId);
        return Ok(user);
    }

    [Authorize]
    [HttpPut("profile")]
    public async Task<ActionResult<UserDto>> UpdateProfile(UpdateProfileRequest request)
    {
        var user = await _authService.UpdateProfileAsync(CurrentUserId, request);
        return Ok(user);
    }

    [Authorize]
    [HttpPut("change-password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest request)
    {
        await _authService.ChangePasswordAsync(CurrentUserId, request);
        return NoContent();
    }

    [HttpPost("forgot-password")]
    public async Task<ActionResult<ForgotPasswordResponse>> ForgotPassword(ForgotPasswordRequest request)
    {
        var response = await _authService.ForgotPasswordAsync(request);
        return Ok(response);
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(ResetPasswordRequest request)
    {
        await _authService.ResetPasswordAsync(request);
        return NoContent();
    }

    [HttpPost("refresh")]
    public async Task<ActionResult<AuthResponse>> Refresh(RefreshTokenRequest request)
    {
        var response = await _authService.RefreshAsync(request);
        return Ok(response);
    }

    private static string BuildConfirmEmailHtml(string title, string message, bool success)
    {
        var color = success ? "#166534" : "#b91c1c";
        return $"""
        <!doctype html>
        <html lang="vi">
        <head><meta charset="utf-8"><title>{WebUtility.HtmlEncode(title)}</title></head>
        <body style="font-family:Arial,sans-serif;padding:32px;background:#f8fafc;color:#0f172a">
            <div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:24px;box-shadow:0 8px 24px rgba(15,23,42,.08)">
                <h2 style="color:{color};margin-top:0">{WebUtility.HtmlEncode(title)}</h2>
                <p>{WebUtility.HtmlEncode(message)}</p>
                <p>Bạn có thể quay lại ứng dụng Calendar Shop để đăng nhập.</p>
            </div>
        </body>
        </html>
        """;
    }
}
