using CalendarShop.Api.Dtos;
using FluentValidation;

namespace CalendarShop.Api.Validators;

public class DiscountCreateUpdateDtoValidator : AbstractValidator<DiscountCreateUpdateDto>
{
    public DiscountCreateUpdateDtoValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Tên giảm giá không được để trống.");

        RuleFor(x => x.DiscountType)
            .Must(type => type == "Percent" || type == "FixedAmount")
            .WithMessage("Loại giảm giá phải là 'Percent' hoặc 'FixedAmount'.");

        RuleFor(x => x.DiscountValue)
            .GreaterThan(0).WithMessage("Giá trị giảm giá phải lớn hơn 0.");

        RuleFor(x => x.DiscountValue)
            .LessThanOrEqualTo(100)
            .When(x => x.DiscountType == "Percent")
            .WithMessage("Giá trị giảm theo phần trăm phải nhỏ hơn hoặc bằng 100.");

        RuleFor(x => x.StartDate)
            .LessThan(x => x.EndDate).WithMessage("Ngày bắt đầu phải nhỏ hơn ngày kết thúc.");

        RuleFor(x => x.Status)
            .Must(status => status == "Active" || status == "Inactive")
            .WithMessage("Trạng thái phải là 'Active' hoặc 'Inactive'.");

        RuleFor(x => x.Scope)
            .Must(scope => scope == "Product" || scope == "Category")
            .WithMessage("Phạm vi áp dụng phải là 'Product' hoặc 'Category'.");

        RuleFor(x => x.TargetIds)
            .NotEmpty().WithMessage("Phải chọn ít nhất một đối tượng áp dụng giảm giá.");
    }
}
