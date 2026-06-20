using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators
{
    public class CreateOrderRequestValidator : AbstractValidator<CreateOrderRequest>
    {
        public CreateOrderRequestValidator()
        {
            RuleFor(x => x.CustomerName)
                .NotEmpty().WithMessage("Tên người nhận là bắt buộc.")
                .MaximumLength(100).WithMessage("Tên người nhận không quá 100 ký tự.");

            RuleFor(x => x.CustomerPhone)
                .NotEmpty().WithMessage("Số điện thoại người nhận là bắt buộc.")
                .Matches(@"^\d{10,11}$").WithMessage("Số điện thoại không đúng định dạng (10-11 số).");

            RuleFor(x => x.ShippingAddress)
                .NotEmpty().WithMessage("Địa chỉ giao hàng là bắt buộc.")
                .MaximumLength(500).WithMessage("Địa chỉ giao hàng không quá 500 ký tự.");

            RuleFor(x => x.PaymentMethod)
                .NotEmpty().WithMessage("Phương thức thanh toán là bắt buộc.")
                .Must(x => x == "COD" || x == "Banking" || x == "Momo" || x == "VNPay")
                .WithMessage("Phương thức thanh toán phải là COD, Banking, Momo hoặc VNPay.");

            RuleFor(x => x.Note)
                .MaximumLength(500).WithMessage("Ghi chú không quá 500 ký tự.");
        }
    }

    public class UpdateOrderStatusRequestValidator : AbstractValidator<UpdateOrderStatusRequest>
    {
        public UpdateOrderStatusRequestValidator()
        {
            RuleFor(x => x.Status)
                .NotEmpty().WithMessage("Trạng thái đơn hàng là bắt buộc.")
                .Must(x => x == "Pending" || x == "Confirmed" || x == "Shipping" || x == "Delivered" || x == "Cancelled")
                .WithMessage("Trạng thái đơn hàng không hợp lệ.");

            RuleFor(x => x.Note)
                .MaximumLength(500).WithMessage("Ghi chú trạng thái không quá 500 ký tự.");
        }
    }

    public class CancelOrderRequestValidator : AbstractValidator<CancelOrderRequest>
    {
        public CancelOrderRequestValidator()
        {
            RuleFor(x => x.Reason)
                .NotEmpty().WithMessage("Lý do hủy đơn hàng là bắt buộc.")
                .MaximumLength(500).WithMessage("Lý do hủy đơn không quá 500 ký tự.");
        }
    }
}
