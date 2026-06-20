using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class ProductService : IProductService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public ProductService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<List<ProductDto>> GetAllProductsAsync(
        int? categoryId,
        string? search,
        decimal? minPrice,
        decimal? maxPrice,
        string? calendarType,
        string? sort,
        bool includeHidden)
    {
        var query = _db.Products.Where(x => !x.IsDeleted);

        if (!includeHidden)
            query = query.Where(x => x.Status == "Active");

        if (categoryId.HasValue)
            query = query.Where(x => x.CategoryId == categoryId);

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(x => x.ProductName.Contains(search));

        if (minPrice.HasValue)
            query = query.Where(x => x.Price >= minPrice.Value);

        if (maxPrice.HasValue)
            query = query.Where(x => x.Price <= maxPrice.Value);

        if (!string.IsNullOrWhiteSpace(calendarType))
            query = query.Where(x => x.CalendarType == calendarType);

        query = sort switch
        {
            "price_asc" => query.OrderBy(x => x.Price),
            "price_desc" => query.OrderByDescending(x => x.Price),
            _ => query.OrderByDescending(x => x.CreatedAt)
        };

        return await query.ProjectTo<ProductDto>(_mapper.ConfigurationProvider).ToListAsync();
    }

    public async Task<ProductDto> GetProductByIdAsync(int id)
    {
        var product = await _db.Products
            .Where(x => x.ProductId == id && !x.IsDeleted)
            .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        return product;
    }

    public async Task<ProductDto> CreateProductAsync(ProductCreateUpdateDto request)
    {
        var product = _mapper.Map<Product>(request);
        _db.Products.Add(product);
        await _db.SaveChangesAsync();
        return await GetProductByIdAsync(product.ProductId);
    }

    public async Task UpdateProductAsync(int id, ProductCreateUpdateDto request)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        _mapper.Map(request, product);
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }

    public async Task UpdateStockAsync(int id, int stockQuantity)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.StockQuantity = stockQuantity;
        product.Status = stockQuantity <= 0 ? "OutOfStock" : product.Status;
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }

    public async Task UpdateStatusAsync(int id, string status)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.Status = status;
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }

    public async Task DeleteProductAsync(int id)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.IsDeleted = true;
        product.Status = "Hidden";
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
    }
}
