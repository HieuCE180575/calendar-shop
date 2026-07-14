namespace CalendarShop.Api.Dtos;

public record AddFavoriteRequest(int ProductId);

public class FavoriteDto
{
    public int FavoriteId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string? ImageUrl { get; set; }
    public decimal Price { get; set; }
    public string CalendarType { get; set; } = string.Empty;
    public string ProductStatus { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}
