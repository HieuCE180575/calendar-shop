using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators
{
    public class AddToCartRequestValidator : AbstractValidator<AddToCartRequest>
    {
        public AddToCartRequestValidator()
        {
            RuleFor(x => x.ProductId)
                .GreaterThan(0).WithMessage("ProductId không hợp lệ.");

            RuleFor(x => x.Quantity)
                .GreaterThan(0).WithMessage("Số lượng mua phải lớn hơn 0.");
        }
    }

    public class UpdateCartItemRequestValidator : AbstractValidator<UpdateCartItemRequest>
    {
        public UpdateCartItemRequestValidator()
        {
            RuleFor(x => x.Quantity)
                .GreaterThan(0).WithMessage("Số lượng mua phải lớn hơn 0.");
        }
    }
}
