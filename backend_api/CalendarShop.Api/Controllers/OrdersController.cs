using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

[Authorize]
public class OrdersController : AppControllerBase
{
    private readonly IOrderService _orderService;

    public OrdersController(IOrderService orderService)
    {
        _orderService = orderService;
    }

    [HttpPost]
    public async Task<ActionResult<OrderDto>> Create(CreateOrderRequest request)
    {
        var order = await _orderService.CreateOrderAsync(CurrentUserId, request);
        return Ok(order);
    }

    [HttpGet("mine")]
    public async Task<ActionResult<List<OrderDto>>> Mine()
    {
        var orders = await _orderService.GetMyOrdersAsync(CurrentUserId);
        return Ok(orders);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<OrderDto>> GetById(int id)
    {
        var order = await _orderService.GetOrderByIdAsync(CurrentUserId, id);
        return Ok(order);
    }

    [HttpPut("{id:int}/cancel")]
    public async Task<IActionResult> Cancel(int id, CancelOrderRequest request)
    {
        await _orderService.CancelOrderAsync(CurrentUserId, id, request);
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpGet("admin")]
    public async Task<ActionResult<List<OrderDto>>> AdminGetAll(string? status, string? search)
    {
        var orders = await _orderService.AdminGetAllOrdersAsync(status, search);
        return Ok(orders);
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("admin/{id:int}/status")]
    public async Task<IActionResult> AdminUpdateStatus(int id, UpdateOrderStatusRequest request)
    {
        await _orderService.AdminUpdateOrderStatusAsync(id, request);
        return NoContent();
    }
}
