using System.Security.Claims;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;

namespace CalendarShop.Api.Controllers;

public class ReviewsController : AppControllerBase
{
    private readonly IReviewService _reviewService;

    public ReviewsController(IReviewService reviewService)
    {
        _reviewService = reviewService;
    }

    /// <summary>
    /// Lấy danh sách đánh giá của một sản phẩm (Public).
    /// </summary>
    [HttpGet("product/{productId:int}")]
    [EnableQuery]
    public ActionResult<IQueryable<ReviewDto>> GetByProduct(int productId)
    {
        var reviews = _reviewService.GetProductReviewsQuery(productId);
        return Ok(reviews);
    }

    /// <summary>
    /// Lấy thống kê đánh giá sao của một sản phẩm (Public).
    /// </summary>
    [HttpGet("product/{productId:int}/summary")]
    public async Task<ActionResult<ProductRatingSummaryDto>> GetSummary(int productId)
    {
        var summary = await _reviewService.GetProductRatingSummaryAsync(productId);
        return Ok(summary);
    }

    /// <summary>
    /// Lấy danh sách đánh giá của tôi (Authenticated).
    /// </summary>
    [Authorize]
    [HttpGet("my")]
    [EnableQuery]
    public ActionResult<IQueryable<ReviewDto>> GetMyReviews()
    {
        var reviews = _reviewService.GetMyReviewsQuery(CurrentUserId);
        return Ok(reviews);
    }

    /// <summary>
    /// Tạo đánh giá mới - chỉ cho phép đánh giá sản phẩm đã mua và giao thành công.
    /// </summary>
    [Authorize]
    [HttpPost]
    public async Task<ActionResult<ReviewDto>> Create(CreateReviewRequest request)
    {
        var review = await _reviewService.CreateReviewAsync(CurrentUserId, request);
        return CreatedAtAction(nameof(GetByProduct), new { productId = review.ProductId }, review);
    }

    /// <summary>
    /// Cập nhật đánh giá - chỉ chủ đánh giá mới được sửa.
    /// </summary>
    [Authorize]
    [HttpPut("{id:int}")]
    public async Task<ActionResult<ReviewDto>> Update(int id, UpdateReviewRequest request)
    {
        var review = await _reviewService.UpdateReviewAsync(CurrentUserId, id, request);
        return Ok(review);
    }

    /// <summary>
    /// Xóa (ẩn) đánh giá - chủ đánh giá hoặc Admin.
    /// </summary>
    [Authorize]
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var userRole = User.FindFirstValue(ClaimTypes.Role) ?? "Customer";
        await _reviewService.DeleteReviewAsync(CurrentUserId, userRole, id);
        return NoContent();
    }
}
