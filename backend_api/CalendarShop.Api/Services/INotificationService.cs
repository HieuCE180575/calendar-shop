using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;

namespace CalendarShop.Api.Services;

public interface INotificationService
{
    IQueryable<NotificationDto> GetNotificationsQuery(int userId);
    Task MarkAsReadAsync(int userId, int notificationId);
    Task MarkAllAsReadAsync(int userId);
    Task<NotificationDto> CreateNotificationAsync(int userId, string title, string content, string type);
    Task RegisterFcmTokenAsync(int userId, string fcmToken);
    Task SendDailyHolidayRemindersAsync();
}
