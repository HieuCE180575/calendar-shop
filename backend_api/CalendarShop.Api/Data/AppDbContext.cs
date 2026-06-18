using CalendarShop.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Product> Products => Set<Product>();
    public DbSet<CartItem> CartItems => Set<CartItem>();
    public DbSet<Favorite> Favorites => Set<Favorite>();
    public DbSet<Coupon> Coupons => Set<Coupon>();
    public DbSet<Order> Orders => Set<Order>();
    public DbSet<OrderItem> OrderItems => Set<OrderItem>();
    public DbSet<Review> Reviews => Set<Review>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>()
            .HasIndex(x => x.Email)
            .IsUnique()
            .HasFilter("[Email] IS NOT NULL");

        modelBuilder.Entity<User>()
            .HasIndex(x => x.Phone)
            .IsUnique()
            .HasFilter("[Phone] IS NOT NULL");

        modelBuilder.Entity<Category>()
            .HasIndex(x => x.CategoryName)
            .IsUnique();

        modelBuilder.Entity<Product>()
            .Property(x => x.Price)
            .HasPrecision(18, 2);

        modelBuilder.Entity<CartItem>()
            .HasIndex(x => new { x.UserId, x.ProductId })
            .IsUnique();

        modelBuilder.Entity<Favorite>()
            .HasIndex(x => new { x.UserId, x.ProductId })
            .IsUnique();

        modelBuilder.Entity<Coupon>()
            .HasIndex(x => x.Code)
            .IsUnique();

        modelBuilder.Entity<Coupon>()
            .Property(x => x.DiscountValue)
            .HasPrecision(18, 2);

        modelBuilder.Entity<Coupon>()
            .Property(x => x.MinOrderValue)
            .HasPrecision(18, 2);

        modelBuilder.Entity<Order>()
            .Property(x => x.SubTotal)
            .HasPrecision(18, 2);
        modelBuilder.Entity<Order>()
            .Property(x => x.DiscountAmount)
            .HasPrecision(18, 2);
        modelBuilder.Entity<Order>()
            .Property(x => x.ShippingFee)
            .HasPrecision(18, 2);
        modelBuilder.Entity<Order>()
            .Property(x => x.TotalAmount)
            .HasPrecision(18, 2);

        modelBuilder.Entity<OrderItem>()
            .Property(x => x.UnitPrice)
            .HasPrecision(18, 2);
        modelBuilder.Entity<OrderItem>()
            .Property(x => x.TotalPrice)
            .HasPrecision(18, 2);

        modelBuilder.Entity<Order>()
            .HasMany(x => x.OrderItems)
            .WithOne(x => x.Order)
            .HasForeignKey(x => x.OrderId);
    }
}
