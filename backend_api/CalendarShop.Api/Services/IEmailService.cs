namespace CalendarShop.Api.Services;

public interface IEmailService
{
    Task SendAsync(string to, string subject, string htmlBody, string? textBody = null);
}
