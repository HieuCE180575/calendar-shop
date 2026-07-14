using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators;

public class AddFavoriteRequestValidator : AbstractValidator<AddFavoriteRequest>
{
    public AddFavoriteRequestValidator()
    {
        RuleFor(x => x.ProductId)
            .GreaterThan(0).WithMessage("Mã sản phẩm không hợp lệ.");
    }
}
