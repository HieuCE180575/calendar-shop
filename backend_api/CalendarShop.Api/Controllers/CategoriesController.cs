using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using AutoMapper.QueryableExtensions;

namespace CalendarShop.Api.Controllers;

public class CategoriesController : AppControllerBase
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public CategoriesController(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<List<CategoryDto>>> GetAll()
    {
        var categories = await _db.Categories
            .OrderBy(x => x.CategoryName)
            .ProjectTo<CategoryDto>(_mapper.ConfigurationProvider)
            .ToListAsync();

        return Ok(categories);
    }

    [Authorize(Roles = "Admin")]
    [HttpPost]
    public async Task<ActionResult<CategoryDto>> Create(CategoryCreateUpdateDto request)
    {
        var category = _mapper.Map<Category>(request);
        _db.Categories.Add(category);
        await _db.SaveChangesAsync();
        return Ok(_mapper.Map<CategoryDto>(category));
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, CategoryCreateUpdateDto request)
    {
        var category = await _db.Categories.FindAsync(id);
        if (category == null) return NotFound();

        _mapper.Map(request, category);
        category.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [Authorize(Roles = "Admin")]
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var category = await _db.Categories.FindAsync(id);
        if (category == null) return NotFound();
        category.Status = "Hidden";
        category.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
