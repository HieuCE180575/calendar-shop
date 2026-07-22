using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class DiscountService : IDiscountService
{
    private readonly IRepository<Discount> _discountRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public DiscountService(
        IRepository<Discount> discountRepository,
        IRepository<Product> productRepository,
        IMapper mapper)
    {
        _discountRepository = discountRepository;
        _productRepository = productRepository;
        _mapper = mapper;
    }

    public decimal GetDiscountedPrice(Product product)
    {
        if (product.Discount == null ||
            product.Discount.Status != "Active" ||
            product.Discount.StartDate > DateTime.UtcNow ||
            product.Discount.EndDate < DateTime.UtcNow)
        {
            return product.Price;
        }

        var discount = product.Discount;
        var currentPrice = product.Price;

        if (discount.DiscountType == "Percent")
        {
            currentPrice = product.Price * (100 - discount.DiscountValue) / 100;
        }
        else if (discount.DiscountType == "FixedAmount")
        {
            currentPrice = product.Price - discount.DiscountValue;
        }

        return currentPrice < 0 ? 0 : currentPrice;
    }

    public IQueryable<DiscountDto> GetAllDiscountsQuery()
    {
        return _discountRepository.Entities.ProjectTo<DiscountDto>(_mapper.ConfigurationProvider);
    }

    public async Task<DiscountDto> GetDiscountByIdAsync(int id)
    {
        var discount = await _discountRepository.Entities
            .Where(d => d.DiscountId == id)
            .ProjectTo<DiscountDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (discount == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        return discount;
    }

    public async Task<DiscountDto> CreateDiscountAsync(DiscountCreateUpdateDto request)
    {
        var discount = new Discount
        {
            Name = request.Name,
            DiscountType = request.DiscountType,
            DiscountValue = request.DiscountValue,
            StartDate = request.StartDate,
            EndDate = request.EndDate,
            Status = request.Status,
            CreatedAt = DateTime.UtcNow
        };

        await AssignTargetsAsync(discount, request.Scope, request.TargetIds);

        await _discountRepository.AddAsync(discount);
        await _discountRepository.SaveChangesAsync();

        return await GetDiscountByIdAsync(discount.DiscountId);
    }

    public async Task UpdateDiscountAsync(int id, DiscountCreateUpdateDto request)
    {
        var discount = await _discountRepository.Entities
            .Include(d => d.Products)
            .FirstOrDefaultAsync(d => d.DiscountId == id);

        if (discount == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        discount.Name = request.Name;
        discount.DiscountType = request.DiscountType;
        discount.DiscountValue = request.DiscountValue;
        discount.StartDate = request.StartDate;
        discount.EndDate = request.EndDate;
        discount.Status = request.Status;

        discount.Products.Clear();

        await AssignTargetsAsync(discount, request.Scope, request.TargetIds, discount.DiscountId);

        _discountRepository.Update(discount);
        await _discountRepository.SaveChangesAsync();
    }

    public async Task UpdateDiscountStatusAsync(int id, UpdateDiscountStatusRequest request)
    {
        var discount = await _discountRepository.Entities
            .Include(d => d.Products)
            .FirstOrDefaultAsync(d => d.DiscountId == id);
        if (discount == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        if (request.Status == "Active")
        {
            var productIds = discount.Products
                .Where(p => !p.IsDeleted && p.Status != "Hidden")
                .Select(p => p.ProductId)
                .ToList();

            var overlappingProducts = await _productRepository.Entities
                .Include(p => p.Discount)
                .Where(p =>
                    productIds.Contains(p.ProductId) &&
                    p.DiscountId.HasValue &&
                    p.DiscountId.Value != discount.DiscountId &&
                    p.Discount != null &&
                    p.Discount.Status == "Active" &&
                    p.Discount.StartDate <= discount.EndDate &&
                    p.Discount.EndDate >= discount.StartDate)
                .Select(p => p.ProductName)
                .ToListAsync();

            if (overlappingProducts.Count > 0)
            {
                throw new BadHttpRequestException(
                    $"Các sản phẩm đang có discount khác còn hiệu lực: {string.Join(", ", overlappingProducts)}.");
            }
        }

        discount.Status = request.Status;
        _discountRepository.Update(discount);
        await _discountRepository.SaveChangesAsync();
    }

    public async Task DeleteDiscountAsync(int id)
    {
        var discount = await _discountRepository.GetByIdAsync(id);
        if (discount == null)
        {
            throw new KeyNotFoundException("Không tìm thấy mã giảm giá.");
        }

        _discountRepository.Delete(discount);
        await _discountRepository.SaveChangesAsync();
    }

    private async Task AssignTargetsAsync(Discount discount, string scope, List<int> targetIds, int? currentDiscountId = null)
    {
        if (targetIds.Count == 0)
        {
            throw new BadHttpRequestException("Phải chọn ít nhất một đối tượng áp dụng giảm giá.");
        }

        IQueryable<Product> query = scope == "Product"
            ? _productRepository.Entities.Where(p => targetIds.Contains(p.ProductId))
            : _productRepository.Entities.Where(p => targetIds.Contains(p.CategoryId));

        var products = await query
            .Where(p => !p.IsDeleted && p.Status != "Hidden")
            .ToListAsync();
        if (products.Count == 0)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm phù hợp với mã giảm giá.");
        }

        if (discount.Status == "Active")
        {
            var productIds = products.Select(p => p.ProductId).ToList();
            var overlappingProducts = await _productRepository.Entities
                .Include(p => p.Discount)
                .Where(p =>
                    productIds.Contains(p.ProductId) &&
                    p.DiscountId.HasValue &&
                    (!currentDiscountId.HasValue || p.DiscountId.Value != currentDiscountId.Value) &&
                    p.Discount != null &&
                    p.Discount.Status == "Active" &&
                    p.Discount.StartDate <= discount.EndDate &&
                    p.Discount.EndDate >= discount.StartDate)
                .Select(p => p.ProductName)
                .ToListAsync();

            if (overlappingProducts.Count > 0)
            {
                throw new BadHttpRequestException(
                    $"Các sản phẩm đang có discount khác còn hiệu lực: {string.Join(", ", overlappingProducts)}.");
            }
        }

        foreach (var product in products)
        {
            discount.Products.Add(product);
        }
    }
}
