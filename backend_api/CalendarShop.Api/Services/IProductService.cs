using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IProductService
{
    Task<List<ProductDto>> GetAllProductsAsync(
        int? categoryId,
        string? search,
        decimal? minPrice,
        decimal? maxPrice,
        string? calendarType,
        string? sort,
        bool includeHidden,
        int? top = null,
        int? skip = null);
    Task<ProductDto> GetProductByIdAsync(int id);
    Task<ProductDto> CreateProductAsync(ProductCreateUpdateDto request);
    Task UpdateProductAsync(int id, ProductCreateUpdateDto request);
    Task UpdateStockAsync(int id, int stockQuantity);
    Task UpdateStatusAsync(int id, string status);
    Task DeleteProductAsync(int id);
}
