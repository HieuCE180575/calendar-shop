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
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public CategoryService(
        IRepository<Category> categoryRepository,
        IRepository<Product> productRepository,
        IMapper mapper)
    {
        _categoryRepository = categoryRepository;
        _productRepository = productRepository;
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

        if (category.Status == "Hidden")
        {
            await HideActiveProductsInCategoryAsync(id);
        }

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

        await HideActiveProductsInCategoryAsync(id);

        await _categoryRepository.SaveChangesAsync();
    }

    private async Task HideActiveProductsInCategoryAsync(int categoryId)
    {
        var activeProducts = await _productRepository.Entities
            .Where(x => x.CategoryId == categoryId && !x.IsDeleted && x.Status == "Active")
            .ToListAsync();

        foreach (var product in activeProducts)
        {
            product.Status = "Hidden";
            product.UpdatedAt = DateTime.UtcNow;
            _productRepository.Update(product);
        }
    }
}
