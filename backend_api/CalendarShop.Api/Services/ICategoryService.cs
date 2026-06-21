using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface ICategoryService
{
    IQueryable<CategoryDto> GetAllCategoriesQuery();
    Task<CategoryDto> CreateCategoryAsync(CategoryCreateUpdateDto request);
    Task UpdateCategoryAsync(int id, CategoryCreateUpdateDto request);
    Task DeleteCategoryAsync(int id);
}
