namespace CalendarShop.Api.Options;

public class EmailSettings
{
    public bool Enabled { get; set; }
    public string Host { get; set; } = string.Empty;
    public int Port { get; set; } = 587;
    public bool EnableSsl { get; set; } = true;
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string FromEmail { get; set; } = string.Empty;
    public string FromName { get; set; } = "Calendar Shop";
    public string ApiBaseUrl { get; set; } = string.Empty;
    public string AppBaseUrl { get; set; } = string.Empty;
}
