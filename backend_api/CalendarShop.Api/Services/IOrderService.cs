using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IOrderService
{
    Task<OrderDto> CreateOrderAsync(int userId, CreateOrderRequest request);
    Task<List<OrderDto>> GetMyOrdersAsync(int userId);
    Task<OrderDto> GetOrderByIdAsync(int userId, int id);
    Task CancelOrderAsync(int userId, int id, CancelOrderRequest request);
    Task<List<OrderDto>> AdminGetAllOrdersAsync(string? status, string? search);
    Task AdminUpdateOrderStatusAsync(int id, UpdateOrderStatusRequest request);
}
