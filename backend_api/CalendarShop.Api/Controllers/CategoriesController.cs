using CalendarShop.Api.Data;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Controllers;

public class CategoriesController : AppControllerBase
{
    private readonly AppDbContext _db;

    public CategoriesController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<List<CategoryDto>>> GetAll()
    {
        var categories = await _db.Categories
            .OrderBy(x => x.CategoryName)
            .Select(x => new CategoryDto(x.CategoryId, x.CategoryName, x.Description, x.Status))
            .ToListAsync();

        return Ok(categories);
    }

    [Authorize(Roles = "Admin")]
    [HttpPost]
    public async Task<ActionResult<CategoryDto>> Create(CategoryCreateUpdateDto request)
    {
        var category = new Category
        {
            CategoryName = request.CategoryName,
            Description = request.Description,
            Status = request.Status
        };
        _db.Categories.Add(category);
        await _db.SaveChangesAsync();
        return Ok(new CategoryDto(category.CategoryId, category.CategoryName, category.Description, category.Status));
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, CategoryCreateUpdateDto request)
    {
        var category = await _db.Categories.FindAsync(id);
        if (category == null) return NotFound();
        category.CategoryName = request.CategoryName;
        category.Description = request.Description;
        category.Status = request.Status;
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
