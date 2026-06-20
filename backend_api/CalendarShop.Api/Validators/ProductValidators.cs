using FluentValidation;
using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Validators
{
    public class CategoryCreateUpdateDtoValidator : AbstractValidator<CategoryCreateUpdateDto>
    {
        public CategoryCreateUpdateDtoValidator()
        {
            RuleFor(x => x.CategoryName)
                .NotEmpty().WithMessage("Tên danh mục là bắt buộc.")
                .MaximumLength(100).WithMessage("Tên danh mục không quá 100 ký tự.");

            RuleFor(x => x.Description)
                .MaximumLength(500).WithMessage("Mô tả không quá 500 ký tự.");

            RuleFor(x => x.Status)
                .NotEmpty().WithMessage("Trạng thái là bắt buộc.")
                .Must(x => x == "Active" || x == "Hidden")
                .WithMessage("Trạng thái danh mục phải là Active hoặc Hidden.");
        }
    }

    public class ProductCreateUpdateDtoValidator : AbstractValidator<ProductCreateUpdateDto>
    {
        public ProductCreateUpdateDtoValidator()
        {
            RuleFor(x => x.CategoryId)
                .GreaterThan(0).WithMessage("Danh mục không hợp lệ.");

            RuleFor(x => x.ProductName)
                .NotEmpty().WithMessage("Tên sản phẩm là bắt buộc.")
                .MaximumLength(200).WithMessage("Tên sản phẩm không quá 200 ký tự.");

            RuleFor(x => x.Price)
                .GreaterThanOrEqualTo(0).WithMessage("Giá sản phẩm phải từ 0đ trở lên.");

            RuleFor(x => x.StockQuantity)
                .GreaterThanOrEqualTo(0).WithMessage("Số lượng tồn kho phải từ 0 trở lên.");

            RuleFor(x => x.CalendarType)
                .NotEmpty().WithMessage("Loại lịch là bắt buộc.")
                .MaximumLength(50).WithMessage("Loại lịch không quá 50 ký tự.");

            RuleFor(x => x.Status)
                .NotEmpty().WithMessage("Trạng thái là bắt buộc.")
                .Must(x => x == "Active" || x == "OutOfStock" || x == "Hidden")
                .WithMessage("Trạng thái sản phẩm phải là Active, OutOfStock hoặc Hidden.");
        }
    }
}
