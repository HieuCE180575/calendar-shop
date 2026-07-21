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
        var timeZoneById = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
        var timeNow = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timeZoneById);
        var tick = DateTime.UtcNow.Ticks.ToString();
        var pay = new VNPayLibrary();

        pay.AddRequestData("vnp_Version", "2.1.0");
        pay.AddRequestData("vnp_Command", "pay");
        pay.AddRequestData("vnp_TmnCode", _configuration["VNPay:TmnCode"] ?? string.Empty);
        pay.AddRequestData("vnp_Amount", (order.TotalAmount * 100).ToString("0"));
        pay.AddRequestData("vnp_CreateDate", timeNow.ToString("yyyyMMddHHmmss"));
        pay.AddRequestData("vnp_CurrCode", "VND");
        pay.AddRequestData("vnp_IpAddr", VNPayLibrary.GetIpAddress(context));
        pay.AddRequestData("vnp_Locale", "vn");
        pay.AddRequestData("vnp_OrderInfo", $"Thanh toan don hang {order.OrderId}");
        pay.AddRequestData("vnp_OrderType", "other");
        pay.AddRequestData("vnp_ReturnUrl", _configuration["VNPay:ReturnUrl"] ?? string.Empty);
        pay.AddRequestData("vnp_TxnRef", order.OrderId.ToString());

        var paymentUrl = pay.CreateRequestUrl(_configuration["VNPay:Url"] ?? string.Empty, _configuration["VNPay:HashSecret"] ?? string.Empty);

        _logger.LogInformation("--- VNPAY URL GENERATION ---");
        _logger.LogInformation("URL: {Url}", paymentUrl);
        _logger.LogInformation("SecureHash: {Hash}", pay.SecureHash);
        _logger.LogInformation("RawQueryString: {Query}", pay.RawQueryString);
        foreach(var kv in pay.GetRequestDataMap())
        {
            _logger.LogInformation("Param: {Key} = {Value}", kv.Key, kv.Value);
        }

        return paymentUrl;
    }
}
