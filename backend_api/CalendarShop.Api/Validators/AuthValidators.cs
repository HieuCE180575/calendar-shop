using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators
{
    public class RegisterRequestValidator : AbstractValidator<RegisterRequest>
    {
        public RegisterRequestValidator()
        {
            RuleFor(x => x.FullName)
                .NotEmpty().WithMessage("Họ và tên là bắt buộc.")
                .MaximumLength(100).WithMessage("Họ và tên không quá 100 ký tự.");

            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email là bắt buộc để xác nhận tài khoản.")
                .EmailAddress().WithMessage("Email không đúng định dạng.")
                .MaximumLength(255).WithMessage("Email không quá 255 ký tự.");

            RuleFor(x => x.Phone)
                .Matches(@"^\d{10,11}$").WithMessage("Số điện thoại phải có từ 10 đến 11 số.")
                .When(x => !string.IsNullOrWhiteSpace(x.Phone));

            RuleFor(x => x.Password)
                .NotEmpty().WithMessage("Mật khẩu là bắt buộc.")
                .MinimumLength(6).WithMessage("Mật khẩu phải có ít nhất 6 ký tự.")
                .MaximumLength(50).WithMessage("Mật khẩu không quá 50 ký tự.");
        }
    }

    public class LoginRequestValidator : AbstractValidator<LoginRequest>
    {
        public LoginRequestValidator()
        {
            RuleFor(x => x.Login)
                .NotEmpty().WithMessage("Email hoặc số điện thoại đăng nhập là bắt buộc.");

            RuleFor(x => x.Password)
                .NotEmpty().WithMessage("Mật khẩu là bắt buộc.");
        }
    }

    public class UpdateProfileRequestValidator : AbstractValidator<UpdateProfileRequest>
    {
        public UpdateProfileRequestValidator()
        {
            RuleFor(x => x.FullName)
                .NotEmpty().WithMessage("Họ và tên là bắt buộc.")
                .MaximumLength(100).WithMessage("Họ và tên không quá 100 ký tự.");

            RuleFor(x => x)
                .Must(x => !string.IsNullOrWhiteSpace(x.Email) || !string.IsNullOrWhiteSpace(x.Phone))
                .WithMessage("Email hoặc số điện thoại là bắt buộc.");

            RuleFor(x => x.Email)
                .EmailAddress().WithMessage("Email không đúng định dạng.")
                .MaximumLength(255).WithMessage("Email không quá 255 ký tự.")
                .When(x => !string.IsNullOrWhiteSpace(x.Email));

            RuleFor(x => x.Phone)
                .Matches(@"^\d{10,11}$").WithMessage("Số điện thoại phải có từ 10 đến 11 số.")
                .When(x => !string.IsNullOrWhiteSpace(x.Phone));

            RuleFor(x => x.AvatarUrl)
                .MaximumLength(500).WithMessage("Avatar URL không quá 500 ký tự.")
                .When(x => !string.IsNullOrWhiteSpace(x.AvatarUrl));

            RuleFor(x => x.Gender)
                .MaximumLength(20).WithMessage("Giới tính không quá 20 ký tự.")
                .When(x => !string.IsNullOrWhiteSpace(x.Gender));
        }
    }

    public class ChangePasswordRequestValidator : AbstractValidator<ChangePasswordRequest>
    {
        public ChangePasswordRequestValidator()
        {
            RuleFor(x => x.OldPassword)
                .NotEmpty().WithMessage("Mật khẩu cũ là bắt buộc.");

            RuleFor(x => x.NewPassword)
                .NotEmpty().WithMessage("Mật khẩu mới là bắt buộc.")
                .MinimumLength(6).WithMessage("Mật khẩu mới phải có ít nhất 6 ký tự.")
                .MaximumLength(50).WithMessage("Mật khẩu mới không quá 50 ký tự.")
                .NotEqual(x => x.OldPassword).WithMessage("Mật khẩu mới phải khác mật khẩu cũ.");
        }
    }

    public class ForgotPasswordRequestValidator : AbstractValidator<ForgotPasswordRequest>
    {
        public ForgotPasswordRequestValidator()
        {
            RuleFor(x => x.Login)
                .NotEmpty().WithMessage("Email hoặc số điện thoại là bắt buộc.");
        }
    }

    public class ResetPasswordRequestValidator : AbstractValidator<ResetPasswordRequest>
    {
        public ResetPasswordRequestValidator()
        {
            RuleFor(x => x.ResetToken)
                .NotEmpty().WithMessage("Token đặt lại mật khẩu là bắt buộc.");

            RuleFor(x => x.NewPassword)
                .NotEmpty().WithMessage("Mật khẩu mới là bắt buộc.")
                .MinimumLength(6).WithMessage("Mật khẩu mới phải có ít nhất 6 ký tự.")
                .MaximumLength(50).WithMessage("Mật khẩu mới không quá 50 ký tự.");
        }
    }


    public class ConfirmEmailRequestValidator : AbstractValidator<ConfirmEmailRequest>
    {
        public ConfirmEmailRequestValidator()
        {
            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email là bắt buộc.")
                .EmailAddress().WithMessage("Email không đúng định dạng.");

            RuleFor(x => x.Otp)
                .NotEmpty().WithMessage("Mã OTP là bắt buộc.")
                .Matches(@"^\d{6}$").WithMessage("Mã OTP phải gồm đúng 6 chữ số.");
        }
    }

    public class ResendEmailConfirmationRequestValidator : AbstractValidator<ResendEmailConfirmationRequest>
    {
        public ResendEmailConfirmationRequestValidator()
        {
            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email là bắt buộc.")
                .EmailAddress().WithMessage("Email không đúng định dạng.")
                .MaximumLength(255).WithMessage("Email không quá 255 ký tự.");
        }
    }

    public class LogoutRequestValidator : AbstractValidator<LogoutRequest>
    {
        public LogoutRequestValidator()
        {
            RuleFor(x => x.RefreshToken)
                .MaximumLength(500).WithMessage("Refresh token không quá 500 ký tự.")
                .When(x => !string.IsNullOrWhiteSpace(x.RefreshToken));
        }
    }

    public class UpdateUserStatusRequestValidator : AbstractValidator<UpdateUserStatusRequest>
    {
        public UpdateUserStatusRequestValidator()
        {
            RuleFor(x => x.Status)
                .NotEmpty().WithMessage("Trạng thái là bắt buộc.")
                .Must(x => x == "Active" || x == "Locked" || x == "Pending")
                .WithMessage("Trạng thái phải là Active, Locked hoặc Pending.");
        }
    }

    public class UpdateUserRoleRequestValidator : AbstractValidator<UpdateUserRoleRequest>
    {
        public UpdateUserRoleRequestValidator()
        {
            RuleFor(x => x.Role)
                .NotEmpty().WithMessage("Quyền là bắt buộc.")
                .Must(x => x == "Customer" || x == "Admin")
                .WithMessage("Quyền phải là Customer hoặc Admin.");
        }
    }
}
