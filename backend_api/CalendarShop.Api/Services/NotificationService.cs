using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class NotificationService : INotificationService
{
    private readonly IRepository<Notification> _notificationRepository;
    private readonly IRepository<User> _userRepository;
    private readonly IMapper _mapper;
    private readonly ILogger<NotificationService> _logger;

    public NotificationService(
        IRepository<Notification> notificationRepository,
        IRepository<User> userRepository,
        IMapper mapper,
        ILogger<NotificationService> logger)
    {
        _notificationRepository = notificationRepository;
        _userRepository = userRepository;
        _mapper = mapper;
        _logger = logger;
    }

    public IQueryable<NotificationDto> GetNotificationsQuery(int userId)
    {
        return _notificationRepository.Entities
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAt)
            .ProjectTo<NotificationDto>(_mapper.ConfigurationProvider);
    }

    public async Task MarkAsReadAsync(int userId, int notificationId)
    {
        var notification = await _notificationRepository.Entities
            .FirstOrDefaultAsync(n => n.NotificationId == notificationId && n.UserId == userId);

        if (notification == null)
        {
            throw new KeyNotFoundException("Không tìm thấy thông báo.");
        }

        notification.IsRead = true;
        _notificationRepository.Update(notification);
        await _notificationRepository.SaveChangesAsync();
    }

    public async Task MarkAllAsReadAsync(int userId)
    {
        var unreadNotifications = await _notificationRepository.Entities
            .Where(n => n.UserId == userId && !n.IsRead)
            .ToListAsync();

        foreach (var notification in unreadNotifications)
        {
            notification.IsRead = true;
            _notificationRepository.Update(notification);
        }

        if (unreadNotifications.Any())
        {
            await _notificationRepository.SaveChangesAsync();
        }
    }

    public async Task<NotificationDto> CreateNotificationAsync(int userId, string title, string content, string type)
    {
        var user = await _userRepository.Entities.FirstOrDefaultAsync(u => u.UserId == userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        var notification = new Notification
        {
            UserId = userId,
            Title = title,
            Content = content,
            Type = type,
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        };

        await _notificationRepository.AddAsync(notification);
        await _notificationRepository.SaveChangesAsync();

        // Giả lập gửi push notification qua Firebase Cloud Messaging (FCM).
        if (!string.IsNullOrWhiteSpace(user.FcmToken))
        {
            _logger.LogInformation(
                "Simulating FCM send: Token={Token}, Title={Title}, Content={Content}",
                user.FcmToken,
                title,
                content);
        }

        return _mapper.Map<NotificationDto>(notification);
    }

    public async Task RegisterFcmTokenAsync(int userId, string fcmToken)
    {
        if (string.IsNullOrWhiteSpace(fcmToken))
        {
            throw new BadHttpRequestException("FCM token không được để trống.");
        }

        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        user.FcmToken = fcmToken;
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();

        _logger.LogInformation("Đăng ký FCM token thành công cho UserId: {UserId}", userId);
    }

    public async Task SendDailyHolidayRemindersAsync()
    {
        var today = DateTime.Today;
        var holidayName = GetHolidayName(today);
        if (holidayName == null)
        {
            _logger.LogInformation(
                "Hôm nay {Date:dd/MM/yyyy} không có ngày lễ cấu hình, bỏ qua gửi nhắc nhở.",
                today);
            return;
        }

        var activeUsers = await _userRepository.Entities
            .Where(u => u.Status == "Active")
            .ToListAsync();

        var createdCount = 0;

        foreach (var user in activeUsers)
        {
            var alreadySentToday = await _notificationRepository.Entities.AnyAsync(n =>
                n.UserId == user.UserId &&
                n.Type == "Holiday" &&
                n.CreatedAt.Date == today &&
                n.Title == $"📅 Nhắc nhở ngày lễ: {holidayName}");

            if (alreadySentToday)
            {
                continue;
            }

            await CreateNotificationAsync(
                user.UserId,
                $"📅 Nhắc nhở ngày lễ: {holidayName}",
                $"Hôm nay là dịp {holidayName}. Hãy mở app để xem các mẫu lịch thiết kế đặc biệt và tạo lịch cá nhân hóa cho gia đình nhé!",
                "Holiday");

            createdCount++;
        }

        _logger.LogInformation(
            "Đã quét nhắc nhở ngày lễ '{Holiday}' và tạo {Count} thông báo mới.",
            holidayName,
            createdCount);
    }

    private static string? GetHolidayName(DateTime date)
    {
        if (date.Month == 1 && date.Day == 1) return "Tết Dương lịch";
        if (date.Month == 2 && date.Day == 14) return "Lễ Tình Nhân (Valentine's Day)";
        if (date.Month == 3 && date.Day == 8) return "Quốc tế Phụ nữ (8/3)";
        if (date.Month == 4 && date.Day == 30) return "Ngày Giải phóng Miền Nam";
        if (date.Month == 5 && date.Day == 1) return "Ngày Quốc tế Lao động";
        if (date.Month == 9 && date.Day == 2) return "Ngày Quốc khánh Việt Nam";
        if (date.Month == 10 && date.Day == 20) return "Ngày Phụ nữ Việt Nam";
        if (date.Month == 11 && date.Day == 20) return "Ngày Nhà giáo Việt Nam";
        if (date.Month == 12 && date.Day == 24) return "Đêm Giáng Sinh (Noel)";
        if (date.Month == 12 && date.Day == 25) return "Ngày Giáng Sinh (Noel)";
        return null;
    }
}
