namespace CalendarShop.Api.Dtos;

public record CreateReviewRequest(int OrderItemId, int Rating, string? Comment);

public record UpdateReviewRequest(int Rating, string? Comment);

public class ReviewDto
{
    public int ReviewId { get; set; }
    public int UserId { get; set; }
    public string UserFullName { get; set; } = string.Empty;
    public string? UserAvatarUrl { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public int OrderItemId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public string Status { get; set; } = "Visible";
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public class ProductRatingSummaryDto
{
    public int ProductId { get; set; }
    public double AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public int Star1 { get; set; }
    public int Star2 { get; set; }
    public int Star3 { get; set; }
    public int Star4 { get; set; }
    public int Star5 { get; set; }
}
