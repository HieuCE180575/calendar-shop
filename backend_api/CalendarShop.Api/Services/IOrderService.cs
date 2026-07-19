using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IOrderService
{
    Task<OrderDto> CreateOrderAsync(int userId, CreateOrderRequest request);
    IQueryable<OrderDto> GetMyOrdersQuery(int userId);
    Task<OrderDto> GetOrderByIdAsync(int userId, int id);
    Task CancelOrderAsync(int userId, int id, CancelOrderRequest request);
    IQueryable<OrderDto> AdminGetAllOrdersQuery();
    Task AdminUpdateOrderStatusAsync(int id, UpdateOrderStatusRequest request);
    Task<(bool IsSignatureValid, bool IsSuccess)> HandlePaymentCallbackAsync(Dictionary<string, string> vnpayData);
}
