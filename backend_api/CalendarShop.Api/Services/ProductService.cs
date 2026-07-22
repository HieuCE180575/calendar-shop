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
    private readonly IDiscountService _discountService;
    private readonly IRepository<Discount> _discountRepository;
    private readonly IRepository<Category> _categoryRepository;

    public ProductService(
        IRepository<Product> productRepository,
        IMapper mapper,
        IDiscountService discountService,
        IRepository<Discount> discountRepository,
        IRepository<Category> categoryRepository)
    {
        _productRepository = productRepository;
        _mapper = mapper;
        _discountService = discountService;
        _discountRepository = discountRepository;
        _categoryRepository = categoryRepository;
    }

    public IQueryable<ProductDto> GetAllProductsQuery(bool includeHidden)
    {
        var query = _productRepository.Entities
            .Include(x => x.Category)
            .Include(x => x.Discount)
            .Where(x => !x.IsDeleted);

        if (!includeHidden)
        {
            query = query.Where(x => x.Status == "Active" && x.Category != null && x.Category.Status == "Active");
        }

        var products = query.ToList();
        var dtos = _mapper.Map<List<ProductDto>>(products);
        
        foreach (var dto in dtos)
        {
            var product = products.First(x => x.ProductId == dto.ProductId);
            var discountedPrice = _discountService.GetDiscountedPrice(product);
            if (discountedPrice < product.Price)
            {
                dto.OriginalPrice = product.Price;
                dto.Price = discountedPrice;
            }
        }

        return dtos.AsQueryable();
    }

    public async Task<ProductDto> GetProductByIdAsync(int id, bool includeHidden = false)
    {
        var query = _productRepository.Entities
            .Include(x => x.Category)
            .Include(x => x.Discount)
            .Where(x => x.ProductId == id && !x.IsDeleted);

        if (!includeHidden)
        {
            query = query.Where(x => x.Status == "Active" && x.Category != null && x.Category.Status == "Active");
        }

        var product = await query.FirstOrDefaultAsync();

        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        var dto = _mapper.Map<ProductDto>(product);
        var discountedPrice = _discountService.GetDiscountedPrice(product);
        if (discountedPrice < product.Price)
        {
            dto.OriginalPrice = product.Price;
            dto.Price = discountedPrice;
        }

        return dto;
    }

    public async Task<ProductDto> CreateProductAsync(ProductCreateUpdateDto request)
    {
        var product = _mapper.Map<Product>(request);
        EnsureProductStatusMatchesStock(product);
        await EnsureCategoryCanBeUsedAsync(product.CategoryId, product.Status);
        await _productRepository.AddAsync(product);
        await _productRepository.SaveChangesAsync();
        return await GetProductByIdAsync(product.ProductId, includeHidden: true);
    }

    public async Task UpdateProductAsync(int id, ProductCreateUpdateDto request)
    {
        var product = await _productRepository.GetByIdAsync(id);
        if (product == null || product.IsDeleted)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        _mapper.Map(request, product);
        EnsureProductStatusMatchesStock(product);
        await EnsureCategoryCanBeUsedAsync(product.CategoryId, product.Status);
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
        if (stockQuantity <= 0)
        {
            product.Status = "OutOfStock";
        }
        else if (product.Status == "OutOfStock")
        {
            var category = await _categoryRepository.GetByIdAsync(product.CategoryId);
            product.Status = category?.Status == "Active" ? "Active" : "Hidden";
        }
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

        if (status == "Active" && product.StockQuantity <= 0)
        {
            throw new BadHttpRequestException("Không thể bật bán sản phẩm khi tồn kho bằng 0.");
        }

        if (status == "OutOfStock" && product.StockQuantity > 0)
        {
            throw new BadHttpRequestException("Sản phẩm còn tồn kho nên không thể chuyển sang OutOfStock.");
        }

        await EnsureCategoryCanBeUsedAsync(product.CategoryId, status);

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

    private async Task EnsureCategoryCanBeUsedAsync(int categoryId, string productStatus)
    {
        var category = await _categoryRepository.GetByIdAsync(categoryId);
        if (category == null)
        {
            throw new KeyNotFoundException("Không tìm thấy danh mục.");
        }

        if (productStatus == "Active" && category.Status != "Active")
        {
            throw new BadHttpRequestException("Không thể bật bán sản phẩm trong danh mục đang ẩn.");
        }
    }

    private static void EnsureProductStatusMatchesStock(Product product)
    {
        if (product.StockQuantity <= 0 && product.Status == "Active")
        {
            product.Status = "OutOfStock";
        }

        if (product.StockQuantity > 0 && product.Status == "OutOfStock")
        {
            throw new BadHttpRequestException("Sản phẩm còn tồn kho nên không thể đặt trạng thái OutOfStock.");
        }
    }

    public async Task<CalendarShop.Api.Dtos.AdminStats.AdminProductStatsDto> GetAdminProductStatsAsync(int days = 7)
    {
        var now = DateTime.UtcNow;
        var currentStartDate = now.AddDays(-days);
        var prevStartDate = now.AddDays(-days * 2);

        var productsQuery = _productRepository.Entities
            .Include(p => p.Category)
            .Where(p => !p.IsDeleted)
            .AsNoTracking();

        var totalProducts = await productsQuery.CountAsync(p => p.CreatedAt <= now);
        var prevTotalProducts = await productsQuery.CountAsync(p => p.CreatedAt <= currentStartDate);
        double totalProductsGrowth = prevTotalProducts == 0 ? (totalProducts > 0 ? 100 : 0) : Math.Round(((double)(totalProducts - prevTotalProducts) / prevTotalProducts) * 100, 1);

        var inBusiness = await productsQuery.CountAsync(p => p.Status != "Hidden" && p.CreatedAt <= now);
        var prevInBusiness = await productsQuery.CountAsync(p => p.Status != "Hidden" && p.CreatedAt <= currentStartDate);
        double inBusinessGrowth = prevInBusiness == 0 ? (inBusiness > 0 ? 100 : 0) : Math.Round(((double)(inBusiness - prevInBusiness) / prevInBusiness) * 100, 1);

        var lowStock = await productsQuery.CountAsync(p => p.StockQuantity <= 10);
        var totalCategories = await _categoryRepository.Entities.CountAsync();

        // Best Selling (Mocked here since no OrderItems nav property, AdminDashboardService handles real logic)
        var bestSelling = await _productRepository.Entities
            .Where(p => !p.IsDeleted)
            .Take(5)
            .Select(p => new CalendarShop.Api.Dtos.BestSellingProductDto
            {
                ProductId = p.ProductId,
                ProductName = p.ProductName,
                TotalSold = 0
            })
            .ToListAsync();

        // Stock By Category
        var stockByCategory = await productsQuery
            .Where(p => p.Category != null)
            .GroupBy(p => p.Category!.CategoryName)
            .Select(g => new CalendarShop.Api.Dtos.AdminStats.CategoryStockDistributionDto
            {
                CategoryName = g.Key,
                TotalStock = g.Sum(p => p.StockQuantity)
            })
            .ToListAsync();

        var totalStockAll = stockByCategory.Sum(c => c.TotalStock);
        foreach (var item in stockByCategory)
        {
            item.Percentage = totalStockAll > 0 ? Math.Round((double)item.TotalStock / totalStockAll * 100, 1) : 0;
        }

        // Low Stock Products
        var lowStockProductsList = await productsQuery
            .Where(p => p.StockQuantity <= 10)
            .Select(p => new CalendarShop.Api.Dtos.LowStockProductDto
            {
                ProductId = p.ProductId,
                ProductName = p.ProductName,
                StockQuantity = p.StockQuantity
            })
            .OrderBy(p => p.StockQuantity)
            .Take(10)
            .ToListAsync();

        return new CalendarShop.Api.Dtos.AdminStats.AdminProductStatsDto
        {
            TotalProducts = totalProducts,
            TotalProductsGrowth = totalProductsGrowth,
            InBusiness = inBusiness,
            InBusinessGrowth = inBusinessGrowth,
            LowStock = lowStock,
            TotalCategories = totalCategories,
            BestSelling = bestSelling,
            StockByCategory = stockByCategory,
            LowStockProducts = lowStockProductsList
        };
    }
}
