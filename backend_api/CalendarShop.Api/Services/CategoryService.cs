using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class CategoryService : ICategoryService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public CategoryService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public IQueryable<CategoryDto> GetAllCategoriesQuery()
    {
        return _db.Categories
            .OrderBy(x => x.CategoryName)
            .ProjectTo<CategoryDto>(_mapper.ConfigurationProvider);
    }

    public async Task<CategoryDto> CreateCategoryAsync(CategoryCreateUpdateDto request)
    {
        var category = _mapper.Map<Category>(request);
        _db.Categories.Add(category);
        await _db.SaveChangesAsync();
        return _mapper.Map<CategoryDto>(category);
    }

    public async Task UpdateCategoryAsync(int id, CategoryCreateUpdateDto request)
    {
        var category = await _db.Categories.FindAsync(id);
        if (category == null)
        {
            throw new KeyNotFoundException("Không tìm thấy danh mục.");
        }

        _mapper.Map(request, category);
        category.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }

    public async Task DeleteCategoryAsync(int id)
    {
        var category = await _db.Categories.FindAsync(id);
        if (category == null)
        {
            throw new KeyNotFoundException("Không tìm thấy danh mục.");
        }
        category.Status = "Hidden";
        category.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }
}
