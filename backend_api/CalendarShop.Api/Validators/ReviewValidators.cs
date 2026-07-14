using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators;

public class CreateReviewRequestValidator : AbstractValidator<CreateReviewRequest>
{
    public CreateReviewRequestValidator()
    {
        RuleFor(x => x.OrderItemId)
            .GreaterThan(0).WithMessage("Mã sản phẩm trong đơn hàng không hợp lệ.");

        RuleFor(x => x.Rating)
            .InclusiveBetween(1, 5).WithMessage("Đánh giá phải từ 1 đến 5 sao.");

        RuleFor(x => x.Comment)
            .MaximumLength(1000).WithMessage("Bình luận không được vượt quá 1000 ký tự.");
    }
}

public class UpdateReviewRequestValidator : AbstractValidator<UpdateReviewRequest>
{
    public UpdateReviewRequestValidator()
    {
        RuleFor(x => x.Rating)
            .InclusiveBetween(1, 5).WithMessage("Đánh giá phải từ 1 đến 5 sao.");

        RuleFor(x => x.Comment)
            .MaximumLength(1000).WithMessage("Bình luận không được vượt quá 1000 ký tự.");
    }
}
