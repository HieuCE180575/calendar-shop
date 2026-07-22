using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class NotificationsController : AppControllerBase
{
    private readonly INotificationService _notificationService;

    public NotificationsController(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    [HttpGet]
    [EnableQuery]
    public ActionResult<IQueryable<NotificationDto>> GetAllNotifications()
    {
        var query = _notificationService.GetNotificationsQuery(CurrentUserId);
        return Ok(query);
    }

    [HttpPut("{id:int}/read")]
    public async Task<IActionResult> MarkAsRead(int id)
    {
        await _notificationService.MarkAsReadAsync(CurrentUserId, id);
        return NoContent();
    }

    [HttpPut("read-all")]
    public async Task<IActionResult> MarkAllAsRead()
    {
        await _notificationService.MarkAllAsReadAsync(CurrentUserId);
        return NoContent();
    }

    [HttpPost("register-token")]
    public async Task<IActionResult> RegisterToken([FromBody] RegisterFcmTokenRequest request)
    {
        await _notificationService.RegisterFcmTokenAsync(CurrentUserId, request.FcmToken);
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpPost("trigger-holiday")]
    public async Task<IActionResult> TriggerHolidayReminders()
    {
        await _notificationService.SendDailyHolidayRemindersAsync();
        return Ok(new { Message = "Đã chạy kiểm tra nhắc nhở ngày lễ thành công." });
    }
}
