using System.ComponentModel.DataAnnotations;

namespace CalendarShop.Api.Dtos;

public class NotificationDto
{
    public int NotificationId { get; set; }
    public int UserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public bool IsRead { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class RegisterFcmTokenRequest
{
    [Required(ErrorMessage = "Token FCM không được để trống.")]
    public string FcmToken { get; set; } = string.Empty;
}
