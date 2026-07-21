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

    [HttpPost("verify-reset-code")]
    public async Task<ActionResult<MessageResponse>> VerifyResetCode(VerifyResetCodeRequest request)
    {
        var response = await _authService.VerifyResetCodeAsync(request);
        return Ok(response);
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(ResetPasswordRequest request)
    {
        await _authService.ResetPasswordAsync(request);
        return NoContent();
    }

    [AllowAnonymous]
    [HttpGet("reset-password-page")]
    public IActionResult ResetPasswordPage([FromQuery] string? token)
    {
        var safeToken = token ?? string.Empty;
        var errorMsg = string.IsNullOrWhiteSpace(safeToken) ? "Token đặt lại mật khẩu không hợp lệ hoặc bị thiếu." : null;
        var html = BuildResetPasswordHtml(safeToken, errorMsg, null);
        return Content(html, "text/html; charset=utf-8");
    }

    [AllowAnonymous]
    [HttpPost("reset-password-form")]
    public async Task<IActionResult> ResetPasswordForm([FromForm] string token, [FromForm] string newPassword, [FromForm] string confirmPassword)
    {
        var safeToken = token ?? string.Empty;
        if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
        {
            var html = BuildResetPasswordHtml(safeToken, "Mật khẩu mới phải có ít nhất 6 ký tự.", null);
            return Content(html, "text/html; charset=utf-8");
        }

        if (newPassword != confirmPassword)
        {
            var html = BuildResetPasswordHtml(safeToken, "Mật khẩu nhập lại không khớp.", null);
            return Content(html, "text/html; charset=utf-8");
        }

        try
        {
            await _authService.ResetPasswordAsync(new ResetPasswordRequest(safeToken, newPassword));
            var html = BuildResetPasswordHtml(safeToken, null, "Đặt lại mật khẩu thành công! Bạn có thể quay lại ứng dụng Calendar Shop để đăng nhập.");
            return Content(html, "text/html; charset=utf-8");
        }
        catch (Exception ex)
        {
            var html = BuildResetPasswordHtml(safeToken, ex.Message, null);
            return Content(html, "text/html; charset=utf-8");
        }
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

    private static string BuildResetPasswordHtml(string token, string? errorMsg, string? successMsg)
    {
        var safeToken = WebUtility.HtmlEncode(token ?? string.Empty);
        var errorHtml = string.IsNullOrWhiteSpace(errorMsg)
            ? string.Empty
            : $"<div style=\"background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:12px;border-radius:10px;font-size:14px;margin-bottom:18px;\">{WebUtility.HtmlEncode(errorMsg)}</div>";
        var successHtml = string.IsNullOrWhiteSpace(successMsg)
            ? string.Empty
            : $"<div style=\"background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;padding:16px;border-radius:10px;font-size:14px;text-align:center;line-height:1.5;\">{WebUtility.HtmlEncode(successMsg)}</div>";

        var formContent = !string.IsNullOrWhiteSpace(successMsg)
            ? successHtml
            : $"""
            {errorHtml}
            <form action="/api/auth/reset-password-form" method="post">
                <input type="hidden" name="token" value="{safeToken}" />
                <div style="margin-bottom:18px;">
                    <label style="display:block;font-size:14px;font-weight:600;margin-bottom:6px;color:#334155;">Mật khẩu mới</label>
                    <input type="password" name="newPassword" required minlength="6" placeholder="Nhập mật khẩu mới..." style="width:100%;box-sizing:border-box;padding:12px 14px;border:1px solid #cbd5e1;border-radius:10px;font-size:15px;outline:none;" />
                </div>
                <div style="margin-bottom:22px;">
                    <label style="display:block;font-size:14px;font-weight:600;margin-bottom:6px;color:#334155;">Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" required minlength="6" placeholder="Nhập lại mật khẩu mới..." style="width:100%;box-sizing:border-box;padding:12px 14px;border:1px solid #cbd5e1;border-radius:10px;font-size:15px;outline:none;" />
                </div>
                <button type="submit" style="width:100%;background:#0056c6;color:#fff;border:none;padding:14px;border-radius:10px;font-size:15px;font-weight:600;cursor:pointer;">Cập nhật mật khẩu mới</button>
            </form>
            """;

        return $"""
        <!doctype html>
        <html lang="vi">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Đặt lại mật khẩu - Calendar Shop</title>
        </head>
        <body style="font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif;background:#f8fafc;color:#0f172a;margin:0;padding:24px;">
            <div style="max-width:440px;margin:40px auto;background:#fff;border-radius:16px;padding:32px;box-shadow:0 10px 25px -5px rgba(0,0,0,0.08);border:1px solid #e2e8f0;">
                <h2 style="color:#0056c6;margin-top:0;font-size:22px;text-align:center;">Đặt lại mật khẩu</h2>
                <p style="text-align:center;color:#64748b;font-size:14px;margin-bottom:24px;">Calendar Shop</p>
                {formContent}
            </div>
        </body>
        </html>
        """;
    }
}
