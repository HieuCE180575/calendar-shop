using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface ICategoryService
{
    Task<List<CategoryDto>> GetAllCategoriesAsync();
    Task<CategoryDto> CreateCategoryAsync(CategoryCreateUpdateDto request);
    Task UpdateCategoryAsync(int id, CategoryCreateUpdateDto request);
    Task DeleteCategoryAsync(int id);
}
