using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class ProductService : IProductService
{
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public ProductService(IRepository<Product> productRepository, IMapper mapper)
    {
        _productRepository = productRepository;
        _mapper = mapper;
    }

    public IQueryable<ProductDto> GetAllProductsQuery(bool includeHidden)
    {
        var query = _productRepository.Entities.Where(x => !x.IsDeleted);

        if (!includeHidden)
            query = query.Where(x => x.Status == "Active");

        return query.ProjectTo<ProductDto>(_mapper.ConfigurationProvider);
    }

    public async Task<ProductDto> GetProductByIdAsync(int id)
    {
        var product = await _productRepository.Entities
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
        await _productRepository.AddAsync(product);
        await _productRepository.SaveChangesAsync();
        return await GetProductByIdAsync(product.ProductId);
    }

    public async Task UpdateProductAsync(int id, ProductCreateUpdateDto request)
    {
        var product = await _productRepository.GetByIdAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        _mapper.Map(request, product);
        product.UpdatedAt = DateTime.UtcNow;
        _productRepository.Update(product);
        await _productRepository.SaveChangesAsync();
    }

    public async Task UpdateStockAsync(int id, int stockQuantity)
    {
        var product = await _productRepository.GetByIdAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.StockQuantity = stockQuantity;
        product.Status = stockQuantity <= 0 ? "OutOfStock" : product.Status;
        product.UpdatedAt = DateTime.UtcNow;
        _productRepository.Update(product);
        await _productRepository.SaveChangesAsync();
    }

    public async Task UpdateStatusAsync(int id, string status)
    {
        var product = await _productRepository.GetByIdAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.Status = status;
        product.UpdatedAt = DateTime.UtcNow;
        _productRepository.Update(product);
        await _productRepository.SaveChangesAsync();
    }

    public async Task DeleteProductAsync(int id)
    {
        var product = await _productRepository.GetByIdAsync(id);
        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        product.IsDeleted = true;
        product.Status = "Hidden";
        product.UpdatedAt = DateTime.UtcNow;
        _productRepository.Update(product);
        await _productRepository.SaveChangesAsync();
    }
}
