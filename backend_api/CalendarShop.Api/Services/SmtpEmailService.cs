using System.Net;
using System.Net.Mail;
using System.Text;
using CalendarShop.Api.Options;
using Microsoft.Extensions.Options;

namespace CalendarShop.Api.Services;

public class SmtpEmailService : IEmailService
{
    private readonly EmailSettings _settings;
    private readonly ILogger<SmtpEmailService> _logger;

    public SmtpEmailService(IOptions<EmailSettings> settings, ILogger<SmtpEmailService> logger)
    {
        _settings = settings.Value;
        _logger = logger;
    }

    public async Task SendAsync(string to, string subject, string htmlBody, string? textBody = null)
    {
        if (!_settings.Enabled)
        {
            _logger.LogWarning("SMTP email is disabled. Email not sent. To={To}, Subject={Subject}, Body={Body}", to, subject, textBody ?? htmlBody);
            return;
        }

        ValidateSettings();

        var smtpPassword = (_settings.Password ?? string.Empty).Replace(" ", string.Empty);

        using var message = new MailMessage
        {
            From = new MailAddress(_settings.FromEmail, _settings.FromName, Encoding.UTF8),
            Subject = subject,
            Body = htmlBody,
            IsBodyHtml = true,
            BodyEncoding = Encoding.UTF8,
            SubjectEncoding = Encoding.UTF8
        };
        message.To.Add(new MailAddress(to));

        using var client = new SmtpClient(_settings.Host, _settings.Port)
        {
            EnableSsl = _settings.EnableSsl,
            UseDefaultCredentials = false,
            DeliveryMethod = SmtpDeliveryMethod.Network,
            Credentials = new NetworkCredential(_settings.UserName, smtpPassword),
            Timeout = 20000
        };

        try
        {
            _logger.LogInformation("Sending SMTP email. Host={Host}, Port={Port}, EnableSsl={EnableSsl}, From={From}, To={To}, Subject={Subject}",
                _settings.Host, _settings.Port, _settings.EnableSsl, _settings.FromEmail, to, subject);

            await client.SendMailAsync(message);

            _logger.LogInformation("SMTP email sent successfully. To={To}, Subject={Subject}", to, subject);
        }
        catch (SmtpException ex)
        {
            _logger.LogError(ex, "SMTP send failed. StatusCode={StatusCode}, Host={Host}, Port={Port}, UserName={UserName}, From={From}, To={To}",
                ex.StatusCode, _settings.Host, _settings.Port, _settings.UserName, _settings.FromEmail, to);
            throw new InvalidOperationException("Gửi email thất bại. Kiểm tra Email:Enabled, Gmail App Password, tài khoản gửi và kết nối SMTP trong appsettings.Development.json.", ex);
        }
    }

    private void ValidateSettings()
    {
        if (string.IsNullOrWhiteSpace(_settings.Host) ||
            string.IsNullOrWhiteSpace(_settings.UserName) ||
            string.IsNullOrWhiteSpace(_settings.Password) ||
            string.IsNullOrWhiteSpace(_settings.FromEmail))
        {
            throw new InvalidOperationException("Chưa cấu hình SMTP. Vui lòng cập nhật Email trong appsettings.Development.json.");
        }
    }
}
