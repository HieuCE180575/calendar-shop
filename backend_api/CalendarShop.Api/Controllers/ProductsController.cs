using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using AutoMapper.QueryableExtensions;

namespace CalendarShop.Api.Controllers;

public class ProductsController : AppControllerBase
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public ProductsController(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<List<ProductDto>>> GetAll(
        int? categoryId,
        string? search,
        decimal? minPrice,
        decimal? maxPrice,
        string? calendarType,
        string? sort = "newest",
        bool includeHidden = false)
    {
        var query = _db.Products.Where(x => !x.IsDeleted);

        if (!includeHidden)
            query = query.Where(x => x.Status == "Active");

        if (categoryId.HasValue)
            query = query.Where(x => x.CategoryId == categoryId);

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(x => x.ProductName.Contains(search));

        if (minPrice.HasValue)
            query = query.Where(x => x.Price >= minPrice.Value);

        if (maxPrice.HasValue)
            query = query.Where(x => x.Price <= maxPrice.Value);

        if (!string.IsNullOrWhiteSpace(calendarType))
            query = query.Where(x => x.CalendarType == calendarType);

        query = sort switch
        {
            "price_asc" => query.OrderBy(x => x.Price),
            "price_desc" => query.OrderByDescending(x => x.Price),
            _ => query.OrderByDescending(x => x.CreatedAt)
        };

        var products = await query.ProjectTo<ProductDto>(_mapper.ConfigurationProvider).ToListAsync();
        return Ok(products);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ProductDto>> GetById(int id)
    {
        var product = await _db.Products
            .Where(x => x.ProductId == id && !x.IsDeleted)
            .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (product == null) return NotFound();
        return Ok(product);
    }

    [Authorize(Roles = "Admin")]
    [HttpPost]
    public async Task<ActionResult<ProductDto>> Create(ProductCreateUpdateDto request)
    {
        var product = _mapper.Map<Product>(request);
        _db.Products.Add(product);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = product.ProductId }, await GetProductDto(product.ProductId));
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, ProductCreateUpdateDto request)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted) return NotFound();

        _mapper.Map(request, product);
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpPatch("{id:int}/stock")]
    public async Task<IActionResult> UpdateStock(int id, [FromBody] int stockQuantity)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted) return NotFound();
        product.StockQuantity = stockQuantity;
        product.Status = stockQuantity <= 0 ? "OutOfStock" : product.Status;
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpPatch("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] string status)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null || product.IsDeleted) return NotFound();
        product.Status = status;
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var product = await _db.Products.FindAsync(id);
        if (product == null) return NotFound();
        product.IsDeleted = true;
        product.Status = "Hidden";
        product.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    private async Task<ProductDto?> GetProductDto(int id)
    {
        return await _db.Products
            .Where(x => x.ProductId == id)
            .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();
    }
}
