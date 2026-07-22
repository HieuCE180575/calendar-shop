using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
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
        var userExists = await _userRepository.Entities.AnyAsync(u => u.UserId == userId);
        if (!userExists)
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

        // Giả lập gửi Push Notification qua Firebase Cloud Messaging (FCM)
        var user = await _userRepository.Entities.FirstOrDefaultAsync(u => u.UserId == userId);
        if (user != null && !string.IsNullOrEmpty(user.FcmToken))
        {
            _logger.LogInformation("Simulating FCM Send: Token={Token}, Title={Title}, Content={Content}", 
                user.FcmToken, title, content);
            // Ở đây trong môi trường production thực tế, bạn sẽ khởi tạo HttpClient 
            // và POST lên Firebase HTTP v1 API Endpoint (https://fcm.googleapis.com/v1/projects/{your-project-id}/messages:send)
        }

        return _mapper.Map<NotificationDto>(notification);
    }

    public async Task RegisterFcmTokenAsync(int userId, string fcmToken)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        user.FcmToken = fcmToken;
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();
        
        _logger.LogInformation("Đăng ký FCM Token thành công cho UserId: {UserId}", userId);
    }

    public async Task SendDailyHolidayRemindersAsync()
    {
        var today = DateTime.Today;
        string? holidayName = null;

        // Định nghĩa một số ngày lễ chính trong năm
        if (today.Month == 1 && today.Day == 1) holidayName = "Tết Dương Lịch";
        else if (today.Month == 2 && today.Day == 14) holidayName = "Lễ Tình Nhân (Valentine's Day)";
        else if (today.Month == 3 && today.Day == 8) holidayName = "Quốc tế Phụ nữ (8/3)";
        else if (today.Month == 4 && today.Day == 30) holidayName = "Ngày Giải phóng Miền Nam";
        else if (today.Month == 5 && today.Day == 1) holidayName = "Ngày Quốc tế Lao động";
        else if (today.Month == 9 && today.Day == 2) holidayName = "Ngày Quốc khánh Việt Nam";
        else if (today.Month == 10 && today.Day == 20) holidayName = "Ngày Phụ nữ Việt Nam";
        else if (today.Month == 11 && today.Day == 20) holidayName = "Ngày Nhà giáo Việt Nam";
        else if (today.Month == 12 && today.Day == 24) holidayName = "Đêm Giáng Sinh (Noel)";
        else if (today.Month == 12 && today.Day == 25) holidayName = "Ngày Giáng Sinh (Noel)";

        // Để test, nếu không có ngày lễ nào hôm nay thì chúng ta có thể giả lập nhắc nhở chuẩn bị Tết
        if (holidayName == null)
        {
             holidayName = "Chuẩn bị sắm lịch Tết Ất Tỵ 2025";
        }

        var activeUsers = await _userRepository.Entities
            .Where(u => u.Status == "Active")
            .ToListAsync();

        foreach (var user in activeUsers)
        {
            await CreateNotificationAsync(
                user.UserId, 
                $"📅 Nhắc nhở ngày lễ: {holidayName}", 
                $"Hôm nay là dịp {holidayName}. Hãy mở app để xem các mẫu lịch thiết kế đặc biệt và tạo lịch cá nhân hóa cho gia đình nhé!",
                "Holiday"
            );
        }

        _logger.LogInformation("Đã quét và tạo nhắc nhở ngày lễ '{Holiday}' cho {Count} người dùng.", holidayName, activeUsers.Count);
    }
}
