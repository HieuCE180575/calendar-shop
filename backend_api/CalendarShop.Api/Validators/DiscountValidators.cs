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
            .WithMessage("Loại giảm giá (DiscountType) không hợp lệ, phải là 'Percent' hoặc 'FixedAmount'.");

        RuleFor(x => x.DiscountValue)
            .GreaterThan(0).WithMessage("Giá trị giảm giá phải lớn hơn 0.");

        RuleFor(x => x.StartDate)
            .LessThan(x => x.EndDate).WithMessage("Ngày bắt đầu phải nhỏ hơn ngày kết thúc.");

        RuleFor(x => x.Status)
            .Must(status => status == "Active" || status == "Inactive")
            .WithMessage("Trạng thái (Status) không hợp lệ.");

        RuleFor(x => x.Scope)
            .Must(scope => scope == "Product" || scope == "Category")
            .WithMessage("Phạm vi áp dụng (Scope) không hợp lệ, phải là 'Product' hoặc 'Category'.");

        RuleFor(x => x.TargetIds)
            .NotNull().WithMessage("Danh sách TargetIds không được để trống.");
    }
}
