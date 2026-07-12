using CalendarShop.Api.Dtos;
using FluentValidation;

namespace CalendarShop.Api.Validators;

public class CouponCreateUpdateDtoValidator : AbstractValidator<CouponCreateUpdateDto>
{
    public CouponCreateUpdateDtoValidator()
    {
        RuleFor(x => x.Code)
            .NotEmpty().WithMessage("Mã giảm giá là bắt buộc.")
            .MaximumLength(50).WithMessage("Mã giảm giá không quá 50 ký tự.");

        RuleFor(x => x.Description)
            .MaximumLength(500).WithMessage("Mô tả không quá 500 ký tự.");

        RuleFor(x => x.DiscountType)
            .Must(x => x == "Percent" || x == "Amount")
            .WithMessage("Loại giảm giá phải là Percent hoặc Amount.");

        RuleFor(x => x.DiscountValue)
            .GreaterThan(0).WithMessage("Giá trị giảm phải lớn hơn 0.");

        RuleFor(x => x)
            .Must(x => x.DiscountType != "Percent" || x.DiscountValue <= 100)
            .WithMessage("Giảm theo phần trăm không được vượt quá 100.");

        RuleFor(x => x.MinOrderValue)
            .GreaterThanOrEqualTo(0).WithMessage("Đơn tối thiểu phải từ 0 trở lên.");

        RuleFor(x => x.EndDate)
            .GreaterThan(x => x.StartDate)
            .WithMessage("Ngày kết thúc phải lớn hơn ngày bắt đầu.");

        RuleFor(x => x.UsageLimit)
            .GreaterThan(0).When(x => x.UsageLimit.HasValue)
            .WithMessage("Giới hạn sử dụng phải lớn hơn 0 nếu có nhập.");

        RuleFor(x => x.Status)
            .Must(x => x == "Active" || x == "Inactive")
            .WithMessage("Trạng thái mã giảm giá phải là Active hoặc Inactive.");
    }
}

public class CouponStatusUpdateDtoValidator : AbstractValidator<CouponStatusUpdateDto>
{
    public CouponStatusUpdateDtoValidator()
    {
        RuleFor(x => x.Status)
            .Must(x => x == "Active" || x == "Inactive")
            .WithMessage("Trạng thái mã giảm giá phải là Active hoặc Inactive.");
    }
}
