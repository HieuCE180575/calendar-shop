using CalendarShop.Api.Dtos;
using CalendarShop.Api.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace CalendarShop.Api.Services;

public class VNPayService : IVNPayService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<VNPayService> _logger;

    public VNPayService(IConfiguration configuration, ILogger<VNPayService> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public string CreatePaymentUrl(OrderDto order, HttpContext context)
    {
        var vnpayUrl = _configuration["VNPay:Url"];
        var tmnCode = _configuration["VNPay:TmnCode"];
        var hashSecret = _configuration["VNPay:HashSecret"];
        var returnUrl = _configuration["VNPay:ReturnUrl"];

        if (string.IsNullOrWhiteSpace(vnpayUrl) ||
            string.IsNullOrWhiteSpace(tmnCode) ||
            string.IsNullOrWhiteSpace(hashSecret) ||
            string.IsNullOrWhiteSpace(returnUrl))
        {
            throw new InvalidOperationException("VNPay configuration is incomplete.");
        }

        var timeZoneById = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
        var timeNow = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timeZoneById);
        var pay = new VNPayLibrary();

        pay.AddRequestData("vnp_Version", "2.1.0");
        pay.AddRequestData("vnp_Command", "pay");
        pay.AddRequestData("vnp_TmnCode", tmnCode);
        pay.AddRequestData("vnp_Amount", (order.TotalAmount * 100).ToString("0"));
        pay.AddRequestData("vnp_CreateDate", timeNow.ToString("yyyyMMddHHmmss"));
        pay.AddRequestData("vnp_CurrCode", "VND");
        pay.AddRequestData("vnp_IpAddr", VNPayLibrary.GetIpAddress(context));
        pay.AddRequestData("vnp_Locale", "vn");
        pay.AddRequestData("vnp_OrderInfo", $"Thanh toan don hang {order.OrderId}");
        pay.AddRequestData("vnp_OrderType", "other");
        pay.AddRequestData("vnp_ReturnUrl", returnUrl);
        pay.AddRequestData("vnp_TxnRef", order.OrderId.ToString());

        var paymentUrl = pay.CreateRequestUrl(vnpayUrl, hashSecret);

        _logger.LogInformation("Generated VNPay payment URL for order {OrderId}.", order.OrderId);

        return paymentUrl;
    }
}
