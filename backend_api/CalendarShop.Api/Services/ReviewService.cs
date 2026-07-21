using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class ReviewService : IReviewService
{
    private readonly IRepository<Review> _reviewRepository;
    private readonly IRepository<OrderItem> _orderItemRepository;
    private readonly IRepository<Order> _orderRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public ReviewService(
        IRepository<Review> reviewRepository,
        IRepository<OrderItem> orderItemRepository,
        IRepository<Order> orderRepository,
        IRepository<Product> productRepository,
        IMapper mapper)
    {
        _reviewRepository = reviewRepository;
        _orderItemRepository = orderItemRepository;
        _orderRepository = orderRepository;
        _productRepository = productRepository;
        _mapper = mapper;
    }

    public async Task<ReviewDto> CreateReviewAsync(int userId, CreateReviewRequest request)
    {
        // 1. Tìm OrderItem
        var orderItem = await _orderItemRepository.Entities
            .Include(x => x.Order)
            .FirstOrDefaultAsync(x => x.OrderItemId == request.OrderItemId);

        if (orderItem == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm trong đơn hàng.");
        }

        // 2. Kiểm tra đơn hàng thuộc về user hiện tại
        if (orderItem.Order == null || orderItem.Order.UserId != userId)
        {
            throw new UnauthorizedAccessException("Bạn không có quyền đánh giá sản phẩm trong đơn hàng này.");
        }

        // 3. Kiểm tra đơn hàng đã giao thành công
        if (orderItem.Order.Status != "Delivered")
        {
            throw new BadHttpRequestException("Chỉ được đánh giá sản phẩm khi đơn hàng đã giao thành công.");
        }

        // 4. Kiểm tra sản phẩm tồn tại
        var product = await _productRepository.GetByIdAsync(orderItem.ProductId);
        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        // 5. Kiểm tra đã đánh giá OrderItem này chưa (UNIQUE constraint: UserId, ProductId, OrderItemId)
        var existingReview = await _reviewRepository.Entities
            .FirstOrDefaultAsync(x => x.UserId == userId
                        && x.ProductId == orderItem.ProductId
                        && x.OrderItemId == request.OrderItemId);

        if (existingReview != null)
        {
            if (existingReview.Status == "Visible")
            {
                throw new BadHttpRequestException("Bạn đã đánh giá sản phẩm này trong đơn hàng này rồi.");
            }
            else
            {
                // Khôi phục đánh giá đã xóa (Hidden -> Visible)
                existingReview.Status = "Visible";
                existingReview.Rating = request.Rating;
                existingReview.Comment = request.Comment?.Trim();
                existingReview.CreatedAt = DateTime.UtcNow;
                existingReview.UpdatedAt = DateTime.UtcNow;

                _reviewRepository.Update(existingReview);
                await _reviewRepository.SaveChangesAsync();

                return await _reviewRepository.Entities
                    .Include(x => x.User)
                    .Include(x => x.Product)
                    .Where(x => x.ReviewId == existingReview.ReviewId)
                    .ProjectTo<ReviewDto>(_mapper.ConfigurationProvider)
                    .FirstAsync();
            }
        }

        // 6. Tạo review mới nếu chưa có
        var review = new Review
        {
            UserId = userId,
            ProductId = orderItem.ProductId,
            OrderId = orderItem.OrderId,
            OrderItemId = orderItem.OrderItemId,
            Rating = request.Rating,
            Comment = request.Comment?.Trim(),
            Status = "Visible",
            CreatedAt = DateTime.UtcNow
        };

        await _reviewRepository.AddAsync(review);
        await _reviewRepository.SaveChangesAsync();

        // 7. Trả về DTO với thông tin đầy đủ
        return await _reviewRepository.Entities
            .Include(x => x.User)
            .Include(x => x.Product)
            .Where(x => x.ReviewId == review.ReviewId)
            .ProjectTo<ReviewDto>(_mapper.ConfigurationProvider)
            .FirstAsync();
    }

    public async Task<ReviewDto> UpdateReviewAsync(int userId, int reviewId, UpdateReviewRequest request)
    {
        var review = await _reviewRepository.Entities
            .FirstOrDefaultAsync(x => x.ReviewId == reviewId);

        if (review == null)
        {
            throw new KeyNotFoundException("Không tìm thấy đánh giá.");
        }

        // Chỉ chủ review mới được sửa
        if (review.UserId != userId)
        {
            throw new UnauthorizedAccessException("Bạn không có quyền chỉnh sửa đánh giá này.");
        }

        // Không cho sửa review đã bị ẩn
        if (review.Status == "Hidden")
        {
            throw new BadHttpRequestException("Không thể chỉnh sửa đánh giá đã bị ẩn.");
        }

        review.Rating = request.Rating;
        review.Comment = request.Comment?.Trim();
        review.UpdatedAt = DateTime.UtcNow;

        _reviewRepository.Update(review);
        await _reviewRepository.SaveChangesAsync();

        return await _reviewRepository.Entities
            .Where(x => x.ReviewId == review.ReviewId)
            .ProjectTo<ReviewDto>(_mapper.ConfigurationProvider)
            .FirstAsync();
    }

    public async Task DeleteReviewAsync(int userId, string userRole, int reviewId)
    {
        var review = await _reviewRepository.GetByIdAsync(reviewId);

        if (review == null)
        {
            throw new KeyNotFoundException("Không tìm thấy đánh giá.");
        }

        // Chỉ chủ review hoặc Admin mới được xóa
        if (review.UserId != userId && userRole != "Admin")
        {
            throw new UnauthorizedAccessException("Bạn không có quyền xóa đánh giá này.");
        }

        // Soft delete: chuyển Status sang Hidden
        review.Status = "Hidden";
        review.UpdatedAt = DateTime.UtcNow;

        _reviewRepository.Update(review);
        await _reviewRepository.SaveChangesAsync();
    }

    public IQueryable<ReviewDto> GetProductReviewsQuery(int productId)
    {
        return _reviewRepository.Entities
            .Where(x => x.ProductId == productId && x.Status == "Visible")
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<ReviewDto>(_mapper.ConfigurationProvider);
    }

    public async Task<ProductRatingSummaryDto> GetProductRatingSummaryAsync(int productId)
    {
        // Kiểm tra sản phẩm tồn tại
        var product = await _productRepository.GetByIdAsync(productId);
        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        var reviews = await _reviewRepository.Entities
            .Where(x => x.ProductId == productId && x.Status == "Visible")
            .ToListAsync();

        return new ProductRatingSummaryDto
        {
            ProductId = productId,
            AverageRating = reviews.Count > 0 ? Math.Round(reviews.Average(x => x.Rating), 1) : 0,
            TotalReviews = reviews.Count,
            Star1 = reviews.Count(x => x.Rating == 1),
            Star2 = reviews.Count(x => x.Rating == 2),
            Star3 = reviews.Count(x => x.Rating == 3),
            Star4 = reviews.Count(x => x.Rating == 4),
            Star5 = reviews.Count(x => x.Rating == 5)
        };
    }

    public IQueryable<ReviewDto> GetMyReviewsQuery(int userId)
    {
        return _reviewRepository.Entities
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<ReviewDto>(_mapper.ConfigurationProvider);
    }
}
