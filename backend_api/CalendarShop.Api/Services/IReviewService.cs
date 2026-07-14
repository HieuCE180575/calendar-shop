using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IReviewService
{
    Task<ReviewDto> CreateReviewAsync(int userId, CreateReviewRequest request);
    Task<ReviewDto> UpdateReviewAsync(int userId, int reviewId, UpdateReviewRequest request);
    Task DeleteReviewAsync(int userId, string userRole, int reviewId);
    IQueryable<ReviewDto> GetProductReviewsQuery(int productId);
    Task<ProductRatingSummaryDto> GetProductRatingSummaryAsync(int productId);
    IQueryable<ReviewDto> GetMyReviewsQuery(int userId);
}
