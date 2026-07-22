using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators
{
    public class CreateAddressValidator : AbstractValidator<CreateAddressDto>
    {
        public CreateAddressValidator()
        {
            RuleFor(x => x.ReceiverName)
                .NotEmpty().WithMessage("Ten nguoi nhan khong duoc de trong.")
                .MaximumLength(100).WithMessage("Ten nguoi nhan khong vuot qua 100 ky tu.");

            RuleFor(x => x.ReceiverPhone)
                .NotEmpty().WithMessage("So dien thoai khong duoc de trong.")
                .MaximumLength(20).WithMessage("So dien thoai khong vuot qua 20 ky tu.");

            RuleFor(x => x.Province)
                .NotEmpty().WithMessage("Tinh/Thanh pho khong duoc de trong.")
                .MaximumLength(100).WithMessage("Tinh/Thanh pho khong vuot qua 100 ky tu.");

            RuleFor(x => x.District)
                .NotEmpty().WithMessage("Quan/Huyen khong duoc de trong.")
                .MaximumLength(100).WithMessage("Quan/Huyen khong vuot qua 100 ky tu.");

            RuleFor(x => x.Ward)
                .MaximumLength(100).WithMessage("Phuong/Xa khong vuot qua 100 ky tu.");

            RuleFor(x => x.AddressLine)
                .NotEmpty().WithMessage("Dia chi chi tiet khong duoc de trong.")
                .MaximumLength(255).WithMessage("Dia chi chi tiet khong vuot qua 255 ky tu.");
        }
    }

    public class UpdateAddressValidator : AbstractValidator<UpdateAddressDto>
    {
        public UpdateAddressValidator()
        {
            RuleFor(x => x.ReceiverName)
                .NotEmpty().WithMessage("Ten nguoi nhan khong duoc de trong.")
                .MaximumLength(100).WithMessage("Ten nguoi nhan khong vuot qua 100 ky tu.");

            RuleFor(x => x.ReceiverPhone)
                .NotEmpty().WithMessage("So dien thoai khong duoc de trong.")
                .MaximumLength(20).WithMessage("So dien thoai khong vuot qua 20 ky tu.");

            RuleFor(x => x.Province)
                .NotEmpty().WithMessage("Tinh/Thanh pho khong duoc de trong.")
                .MaximumLength(100).WithMessage("Tinh/Thanh pho khong vuot qua 100 ky tu.");

            RuleFor(x => x.District)
                .NotEmpty().WithMessage("Quan/Huyen khong duoc de trong.")
                .MaximumLength(100).WithMessage("Quan/Huyen khong vuot qua 100 ky tu.");

            RuleFor(x => x.Ward)
                .MaximumLength(100).WithMessage("Phuong/Xa khong vuot qua 100 ky tu.");

            RuleFor(x => x.AddressLine)
                .NotEmpty().WithMessage("Dia chi chi tiet khong duoc de trong.")
                .MaximumLength(255).WithMessage("Dia chi chi tiet khong vuot qua 255 ky tu.");
        }
    }
}
