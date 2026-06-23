namespace CalendarShop.Api.Dtos;

public class CategoryDto
{
    public int CategoryId { get; set; }
    public string CategoryName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Status { get; set; } = "Active";
}

public record CategoryCreateUpdateDto(string CategoryName, string? Description, string Status);

public class ProductDto
{
    public int ProductId { get; set; }
    public int CategoryId { get; set; }
    public string? CategoryName { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal Price { get; set; }
    public int StockQuantity { get; set; }
    public string? ImageUrl { get; set; }
    public string CalendarType { get; set; } = string.Empty;
    public string Status { get; set; } = "Active";
    public DateTime CreatedAt { get; set; }
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
