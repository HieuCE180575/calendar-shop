using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class CategoryService : ICategoryService
{
    private readonly IRepository<Category> _categoryRepository;
    private readonly IMapper _mapper;

    public CategoryService(IRepository<Category> categoryRepository, IMapper mapper)
    {
        _categoryRepository = categoryRepository;
        _mapper = mapper;
    }

    public IQueryable<CategoryDto> GetAllCategoriesQuery()
    {
        return _categoryRepository.Entities
            .OrderBy(x => x.CategoryName)
            .ProjectTo<CategoryDto>(_mapper.ConfigurationProvider);
    }

    public async Task<CategoryDto> CreateCategoryAsync(CategoryCreateUpdateDto request)
    {
        var category = _mapper.Map<Category>(request);
        await _categoryRepository.AddAsync(category);
        await _categoryRepository.SaveChangesAsync();
        return _mapper.Map<CategoryDto>(category);
    }

    public async Task UpdateCategoryAsync(int id, CategoryCreateUpdateDto request)
    {
        var category = await _categoryRepository.GetByIdAsync(id);
        if (category == null)
        {
            throw new KeyNotFoundException("Không tìm thấy danh mục.");
        }

        _mapper.Map(request, category);
        category.UpdatedAt = DateTime.UtcNow;
        _categoryRepository.Update(category);
        await _categoryRepository.SaveChangesAsync();
    }

    public async Task DeleteCategoryAsync(int id)
    {
        var category = await _categoryRepository.GetByIdAsync(id);
        if (category == null)
        {
            throw new KeyNotFoundException("Không tìm thấy danh mục.");
        }
        category.Status = "Hidden";
        category.UpdatedAt = DateTime.UtcNow;
        _categoryRepository.Update(category);
        await _categoryRepository.SaveChangesAsync();
    }
}
