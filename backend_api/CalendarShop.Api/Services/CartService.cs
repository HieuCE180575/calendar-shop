using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class CartService : ICartService
{
    private readonly IRepository<CartItem> _cartItemRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public CartService(IRepository<CartItem> cartItemRepository, IRepository<Product> productRepository, IMapper mapper)
    {
        _cartItemRepository = cartItemRepository;
        _productRepository = productRepository;
        _mapper = mapper;
    }

    public async Task<CartSummaryDto> GetCartAsync(int userId)
    {
        var items = await _cartItemRepository.Entities
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<CartItemDto>(_mapper.ConfigurationProvider)
            .ToListAsync();

        return new CartSummaryDto(items, items.Where(x => x.IsSelected).Sum(x => x.LineTotal));
    }

    public async Task AddToCartAsync(int userId, AddToCartRequest request)
    {
        var product = await _productRepository.GetByIdAsync(request.ProductId);
        if (product == null || product.IsDeleted || product.Status != "Active")
        {
            throw new BadHttpRequestException("Sản phẩm không khả dụng.");
        }
        if (product.StockQuantity < request.Quantity)
        {
            throw new BadHttpRequestException("Không đủ tồn kho.");
        }

        var item = await _cartItemRepository.Entities.FirstOrDefaultAsync(x => x.UserId == userId && x.ProductId == request.ProductId);
        if (item == null)
        {
            item = new CartItem { UserId = userId, ProductId = request.ProductId, Quantity = request.Quantity };
            await _cartItemRepository.AddAsync(item);
        }
        else
        {
            item.Quantity += request.Quantity;
            item.UpdatedAt = DateTime.UtcNow;
            _cartItemRepository.Update(item);
        }

        await _cartItemRepository.SaveChangesAsync();
    }

    public async Task UpdateCartItemAsync(int userId, int cartItemId, UpdateCartItemRequest request)
    {
        var item = await _cartItemRepository.Entities.FirstOrDefaultAsync(x => x.CartItemId == cartItemId && x.UserId == userId);
        if (item == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm trong giỏ hàng.");
        }

        item.Quantity = request.Quantity;
        item.IsSelected = request.IsSelected;
        item.UpdatedAt = DateTime.UtcNow;
        _cartItemRepository.Update(item);
        await _cartItemRepository.SaveChangesAsync();
    }

    public async Task DeleteCartItemAsync(int userId, int cartItemId)
    {
        var item = await _cartItemRepository.Entities.FirstOrDefaultAsync(x => x.CartItemId == cartItemId && x.UserId == userId);
        if (item == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm trong giỏ hàng.");
        }
        _cartItemRepository.Delete(item);
        await _cartItemRepository.SaveChangesAsync();
    }
}
