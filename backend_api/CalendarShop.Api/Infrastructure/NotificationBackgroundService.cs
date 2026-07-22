using CalendarShop.Api.Services;

namespace CalendarShop.Api.Infrastructure;

public class NotificationBackgroundService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<NotificationBackgroundService> _logger;

    public NotificationBackgroundService(IServiceProvider serviceProvider, ILogger<NotificationBackgroundService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Notification Background Service is starting...");

        // Vòng lặp chạy ngầm trong suốt thời gian API chạy
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                _logger.LogInformation("Notification Background Service is scanning for daily holiday events...");

                // Do BackgroundService là Singleton, còn DbContext/Repositories là Scoped,
                // ta cần tạo một Scope mới để gọi Scoped Services.
                using (var scope = _serviceProvider.CreateScope())
                {
                    var notificationService = scope.ServiceProvider.GetRequiredService<INotificationService>();
                    await notificationService.SendDailyHolidayRemindersAsync();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred executing daily holiday reminders background task.");
            }

            // Chờ 24 giờ trước khi thực hiện lần quét tiếp theo
            // Mỗi ngày hệ thống sẽ tự động quét vào lúc khởi động API và lặp lại sau mỗi 24 giờ.
            await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
        }
    }
}
