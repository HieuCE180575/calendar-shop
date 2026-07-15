using CalendarShop.Api.Dtos;
using Microsoft.AspNetCore.Http;

namespace CalendarShop.Api.Services;

public interface IVNPayService
{
    string CreatePaymentUrl(OrderDto order, HttpContext context);
}
