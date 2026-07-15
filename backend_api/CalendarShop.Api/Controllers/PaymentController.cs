using CalendarShop.Api.Infrastructure;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

public class PaymentController : AppControllerBase
{
    private readonly IVNPayService _vnpayService;
    private readonly IOrderService _orderService;
<<<<<<< HEAD
    private readonly ILogger<PaymentController> _logger;

    public PaymentController(
        IVNPayService vnpayService,
        IOrderService orderService,
        ILogger<PaymentController> logger)
    {
        _vnpayService = vnpayService;
        _orderService = orderService;
        _logger = logger;
=======
    private readonly IConfiguration _configuration;

    public PaymentController(IVNPayService vnpayService, IOrderService orderService, IConfiguration configuration)
    {
        _vnpayService = vnpayService;
        _orderService = orderService;
        _configuration = configuration;
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
    }

    [Authorize]
    [HttpGet("vnpay/{orderId}")]
    public async Task<IActionResult> GenerateVNPayUrl(int orderId)
    {
        var order = await _orderService.GetOrderByIdAsync(CurrentUserId, orderId);
        if (order == null) return NotFound();

        var paymentUrl = _vnpayService.CreatePaymentUrl(order, HttpContext);
        return Ok(new { Url = paymentUrl });
    }

    [HttpGet("vnpay-return")]
    public async Task<IActionResult> VNPayReturn()
    {
<<<<<<< HEAD
        var vnpayData = Request.Query.ToDictionary(k => k.Key, v => v.Value.ToString());

        bool isSignatureValid = false;
        bool isSuccess = false;

        try
        {
            var result = await _orderService.HandlePaymentCallbackAsync(vnpayData);
            isSignatureValid = result.IsSignatureValid;
            isSuccess = result.IsSuccess;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to process VNPay return callback.");
            return Content(BuildPaymentResultHtml(false), "text/html; charset=utf-8");
        }

        if (!isSignatureValid)
=======
        var vnpayData = Request.Query;
        var pay = new VNPayLibrary();
        
        foreach (var (key, value) in vnpayData)
        {
            if (!string.IsNullOrEmpty(key) && key.StartsWith("vnp_"))
            {
                pay.AddResponseData(key, value.ToString());
            }
        }
        
        var vnp_TxnRef = pay.GetResponseData("vnp_TxnRef");
        if (string.IsNullOrEmpty(vnp_TxnRef) || !int.TryParse(vnp_TxnRef, out int orderId))
        {
            return Content("<html><body><h3>Dữ liệu thanh toán không hợp lệ</h3></body></html>", "text/html");
        }

        var vnp_SecureHash = Request.Query["vnp_SecureHash"].ToString();
        var vnp_ResponseCode = pay.GetResponseData("vnp_ResponseCode");

        bool checkSignature = pay.ValidateSignature(vnp_SecureHash, _configuration["VNPay:HashSecret"] ?? string.Empty);

        if (!checkSignature)
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
        {
            return Content("<html><body><h3>Chữ ký không hợp lệ</h3></body></html>", "text/html");
        }

<<<<<<< HEAD
        return Content(BuildPaymentResultHtml(isSuccess), "text/html; charset=utf-8");
    }

    private static string BuildPaymentResultHtml(bool isSuccess)
    {
        return $@"
=======
        try
        {
            await _orderService.HandlePaymentCallbackAsync(orderId, vnp_ResponseCode == "00");
        }
        catch (Exception ex)
        {
            return Content(
                $"<pre>{ex}\n\nINNER:\n{ex.InnerException}</pre>",
                "text/html");
        }

        string htmlContent = $@"
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
<!DOCTYPE html>
<html>
<head>
    <meta charset=""utf-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1"">
    <title>Kết quả thanh toán</title>
    <style>
        body {{ font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background: #f4f7f6; margin: 0; }}
        .card {{ background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; max-width: 400px; }}
        .success {{ color: #28a745; }}
        .error {{ color: #dc3545; }}
        h2 {{ margin-bottom: 10px; }}
        p {{ color: #555; margin-bottom: 20px; line-height: 1.5; }}
        .btn {{ display: inline-block; background: #ff5722; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; text-decoration: none; font-size: 16px; font-weight: bold; }}
    </style>
</head>
<body>
    <div class=""card"">
<<<<<<< HEAD
        {(isSuccess 
=======
        {(vnp_ResponseCode == "00" 
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            ? "<h2 class='success'>✅ Thanh toán thành công!</h2><p>Đơn hàng của bạn đã được xác nhận. Cảm ơn bạn đã mua sắm.</p>" 
            : "<h2 class='error'>❌ Thanh toán thất bại!</h2><p>Giao dịch chưa hoàn tất hoặc đã bị hủy. Vui lòng thử lại sau.</p>")}
        <button class=""btn"" onclick=""window.close()"">Quay lại ứng dụng</button>
    </div>
    <script>
<<<<<<< HEAD
=======
        // Thử tự động đóng tab sau 3 giây
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
        setTimeout(function() {{
            window.close();
        }}, 3000);
    </script>
</body>
</html>";
<<<<<<< HEAD
=======

        return Content(htmlContent, "text/html; charset=utf-8");
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
    }
}
