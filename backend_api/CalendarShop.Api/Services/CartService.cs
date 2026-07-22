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
    private readonly IDiscountService _discountService;
    private readonly IRepository<Discount> _discountRepository;

    public CartService(IRepository<CartItem> cartItemRepository, IRepository<Product> productRepository, IMapper mapper, IDiscountService discountService, IRepository<Discount> discountRepository)
    {
        _cartItemRepository = cartItemRepository;
        _productRepository = productRepository;
        _mapper = mapper;
        _discountService = discountService;
        _discountRepository = discountRepository;
    }

    public IQueryable<CartItemDto> GetCartQuery(int userId)
    {
        var cartItems = _cartItemRepository.Entities
            .Include(x => x.Product)
                .ThenInclude(p => p.Category)
            .Include(x => x.Product)
                .ThenInclude(p => p.Discount)
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ToList();

        var dtos = _mapper.Map<List<CartItemDto>>(cartItems);
        
        foreach (var dto in dtos)
        {
            var cartItem = cartItems.First(x => x.CartItemId == dto.CartItemId);
            if (cartItem.Product != null)
            {
                var product = cartItem.Product;
                var discountedPrice = _discountService.GetDiscountedPrice(product);
                dto.Price = discountedPrice;
                dto.LineTotal = discountedPrice * dto.Quantity;
                dto.ProductStatus = product.Status;
                dto.IsAvailable = !product.IsDeleted 
                    && product.Status == "Active" 
                    && (product.Category == null || product.Category.Status == "Active");
            }
            else
            {
                dto.ProductStatus = "Deleted";
                dto.IsAvailable = false;
            }
        }

        return dtos.AsQueryable();
    }

    public async Task AddToCartAsync(int userId, AddToCartRequest request)
    {
        var product = await _productRepository.Entities
            .Include(x => x.Category)
            .FirstOrDefaultAsync(x => x.ProductId == request.ProductId);
        if (product == null ||
            product.IsDeleted ||
            product.Status != "Active" ||
            product.Category?.Status != "Active")
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
            // Kiểm tra tổng số lượng sau khi cộng thêm có vượt quá tồn kho không
            if (item.Quantity + request.Quantity > product.StockQuantity)
            {
                throw new BadHttpRequestException($"Không đủ tồn kho. Số lượng trong giỏ ({item.Quantity}) + thêm ({request.Quantity}) vượt quá hàng tồn hiện có ({product.StockQuantity}).");
            }
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

        // Kiểm tra tồn kho sản phẩm trước khi cập nhật số lượng
        var product = await _productRepository.Entities
            .Include(x => x.Category)
            .FirstOrDefaultAsync(x => x.ProductId == item.ProductId);
        if (product == null ||
            product.IsDeleted ||
            product.Status != "Active" ||
            product.Category?.Status != "Active")
        {
            throw new BadHttpRequestException("Sản phẩm không khả dụng.");
        }
        if (product.StockQuantity < request.Quantity)
        {
            throw new BadHttpRequestException($"Không đủ hàng tồn kho. Chỉ còn {product.StockQuantity} sản phẩm.");
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
