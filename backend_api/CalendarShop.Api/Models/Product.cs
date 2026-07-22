using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CalendarShop.Api.Models;

public class Product
{
    public int ProductId { get; set; }
    public int CategoryId { get; set; }
    public int? DiscountId { get; set; }

    [Required]
    [MaxLength(200)]
    public string ProductName { get; set; } = string.Empty;

    public string? Description { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Price { get; set; }

    public int StockQuantity { get; set; } = 0;

    [MaxLength(500)]
    public string? ImageUrl { get; set; }

    [Required]
    [MaxLength(50)]
    public string CalendarType { get; set; } = string.Empty;

    [MaxLength(20)]
    public string Status { get; set; } = "Active";

    public bool IsDeleted { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    // Navigation properties
    public Category? Category { get; set; }
    public Discount? Discount { get; set; }
}
