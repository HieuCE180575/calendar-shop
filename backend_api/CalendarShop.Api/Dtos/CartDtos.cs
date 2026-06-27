namespace CalendarShop.Api.Dtos;

public record AddToCartRequest(int ProductId, int Quantity);
public record UpdateCartItemRequest(int Quantity, bool IsSelected);

public class CartItemDto
{
    public int CartItemId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = null!;
    public string? ImageUrl { get; set; }
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public int StockQuantity { get; set; }
    public bool IsSelected { get; set; }
    public decimal LineTotal { get; set; }
}

public record CartSummaryDto(List<CartItemDto> Items, decimal TotalAmount);
