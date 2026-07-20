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
    private readonly IRepository<Category> _categoryRepository;
    private readonly IMapper _mapper;

    public DiscountService(
        IRepository<Discount> discountRepository,
        IRepository<Product> productRepository,
        IRepository<Category> categoryRepository,
        IMapper mapper)
    {
        _discountRepository = discountRepository;
        _productRepository = productRepository;
        _categoryRepository = categoryRepository;
        _mapper = mapper;
    }

    public decimal GetDiscountedPrice(Product product)
    {
        if (product.Discount == null || product.Discount.Status != "Active" || 
            product.Discount.StartDate > DateTime.UtcNow || product.Discount.EndDate < DateTime.UtcNow)
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

        if (currentPrice < 0) currentPrice = 0;

        return currentPrice;
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
            throw new KeyNotFoundException("Không tìm thấy discount.");

        return discount;
    }

    public async Task<DiscountDto> CreateDiscountAsync(DiscountCreateUpdateDto request)
    {
        ValidateDiscountRequest(request);

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
            throw new KeyNotFoundException("Không tìm thấy discount.");

        ValidateDiscountRequest(request);

        discount.Name = request.Name;
        discount.DiscountType = request.DiscountType;
        discount.DiscountValue = request.DiscountValue;
        discount.StartDate = request.StartDate;
        discount.EndDate = request.EndDate;
        discount.Status = request.Status;

        discount.Products.Clear();

        await AssignTargetsAsync(discount, request.Scope, request.TargetIds);

        _discountRepository.Update(discount);
        await _discountRepository.SaveChangesAsync();
    }

    public async Task DeleteDiscountAsync(int id)
    {
        var discount = await _discountRepository.GetByIdAsync(id);
        if (discount == null)
            throw new KeyNotFoundException("Không tìm thấy discount.");

        _discountRepository.Delete(discount);
        await _discountRepository.SaveChangesAsync();
    }

    private void ValidateDiscountRequest(DiscountCreateUpdateDto request)
    {
        if (request.StartDate > request.EndDate)
            throw new BadHttpRequestException("Ngày bắt đầu phải nhỏ hơn ngày kết thúc.");

        if (request.DiscountType != "Percent" && request.DiscountType != "FixedAmount")
            throw new BadHttpRequestException("DiscountType không hợp lệ.");

        if (request.Scope != "Product" && request.Scope != "Category")
            throw new BadHttpRequestException("Scope không hợp lệ.");
    }

    private async Task AssignTargetsAsync(Discount discount, string scope, List<int> targetIds)
    {
        if (scope == "Product")
        {
            var products = await _productRepository.Entities
                .Where(p => targetIds.Contains(p.ProductId)).ToListAsync();
            discount.Products = products;
        }
        else
        {
            var products = await _productRepository.Entities
                .Where(p => targetIds.Contains(p.CategoryId)).ToListAsync();
            discount.Products = products;
        }
    }
}
