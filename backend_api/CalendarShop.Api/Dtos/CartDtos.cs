namespace CalendarShop.Api.Dtos;

public record AddToCartRequest(int ProductId, int Quantity);
public record UpdateCartItemRequest(int Quantity, bool IsSelected);

public record CartItemDto(
    int CartItemId,
    int ProductId,
    string ProductName,
    string? ImageUrl,
    decimal Price,
    int Quantity,
    int StockQuantity,
    bool IsSelected,
    decimal LineTotal
);

public record CartSummaryDto(List<CartItemDto> Items, decimal TotalAmount);
