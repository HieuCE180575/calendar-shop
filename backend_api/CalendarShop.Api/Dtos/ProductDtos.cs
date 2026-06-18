namespace CalendarShop.Api.Dtos;

public record CategoryDto(int CategoryId, string CategoryName, string? Description, string Status);

public record CategoryCreateUpdateDto(string CategoryName, string? Description, string Status);

public record ProductDto(
    int ProductId,
    int CategoryId,
    string? CategoryName,
    string ProductName,
    string? Description,
    decimal Price,
    int StockQuantity,
    string? ImageUrl,
    string CalendarType,
    string Status,
    DateTime CreatedAt
);

public record ProductCreateUpdateDto(
    int CategoryId,
    string ProductName,
    string? Description,
    decimal Price,
    int StockQuantity,
    string? ImageUrl,
    string CalendarType,
    string Status
);
