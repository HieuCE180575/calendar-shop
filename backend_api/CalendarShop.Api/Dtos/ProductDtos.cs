namespace CalendarShop.Api.Dtos;

public class CategoryDto
{
    public int CategoryId { get; set; }
    public string CategoryName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Status { get; set; } = "Active";
}

public record CategoryCreateUpdateDto(string CategoryName, string? Description, string Status);

public record ProductDto
{
    public int ProductId { get; init; }
    public int CategoryId { get; init; }
    public string? CategoryName { get; init; }
    public string ProductName { get; init; } = string.Empty;
    public string? Description { get; init; }
    public decimal Price { get; init; }
    public int StockQuantity { get; init; }
    public string? ImageUrl { get; init; }
    public string CalendarType { get; init; } = string.Empty;
    public string Status { get; init; } = "Active";
    public DateTime CreatedAt { get; init; }
}

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
