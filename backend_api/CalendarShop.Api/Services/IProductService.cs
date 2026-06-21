using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IProductService
{
    IQueryable<ProductDto> GetAllProductsQuery(bool includeHidden);
    Task<ProductDto> GetProductByIdAsync(int id);
    Task<ProductDto> CreateProductAsync(ProductCreateUpdateDto request);
    Task UpdateProductAsync(int id, ProductCreateUpdateDto request);
    Task UpdateStockAsync(int id, int stockQuantity);
    Task UpdateStatusAsync(int id, string status);
    Task DeleteProductAsync(int id);
}
