using CalendarShop.Api.Services;

namespace CalendarShop.Api.Infrastructure;

public class VNPayPendingOrderCleanupService : BackgroundService
{
    private static readonly TimeSpan CleanupInterval = TimeSpan.FromMinutes(5);

    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<VNPayPendingOrderCleanupService> _logger;

    public VNPayPendingOrderCleanupService(
        IServiceScopeFactory scopeFactory,
        ILogger<VNPayPendingOrderCleanupService> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(CleanupInterval);

        while (!stoppingToken.IsCancellationRequested &&
               await timer.WaitForNextTickAsync(stoppingToken))
        {
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var orderService = scope.ServiceProvider.GetRequiredService<IOrderService>();
                var expiredCount = await orderService.ExpirePendingVNPayOrdersAsync(stoppingToken);

                if (expiredCount > 0)
                {
                    _logger.LogInformation("Expired {Count} pending VNPay orders.", expiredCount);
                }
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                return;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to expire pending VNPay orders.");
            }
        }
    }
}
