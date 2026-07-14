using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class FavoriteService : IFavoriteService
{
    private readonly IRepository<Favorite> _favoriteRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IMapper _mapper;

    public FavoriteService(
        IRepository<Favorite> favoriteRepository,
        IRepository<Product> productRepository,
        IMapper mapper)
    {
        _favoriteRepository = favoriteRepository;
        _productRepository = productRepository;
        _mapper = mapper;
    }

    public async Task<FavoriteDto> AddFavoriteAsync(int userId, AddFavoriteRequest request)
    {
        // 1. Kiểm tra sản phẩm tồn tại và đang hoạt động
        var product = await _productRepository.Entities
            .FirstOrDefaultAsync(x => x.ProductId == request.ProductId && !x.IsDeleted);

        if (product == null)
        {
            throw new KeyNotFoundException("Không tìm thấy sản phẩm.");
        }

        if (product.Status == "Hidden")
        {
            throw new BadHttpRequestException("Sản phẩm này hiện không khả dụng.");
        }

        // 2. Kiểm tra đã yêu thích chưa (UNIQUE constraint: UserId, ProductId)
        var existing = await _favoriteRepository.Entities
            .AnyAsync(x => x.UserId == userId && x.ProductId == request.ProductId);

        if (existing)
        {
            throw new BadHttpRequestException("Sản phẩm đã có trong danh sách yêu thích.");
        }

        // 3. Thêm yêu thích
        var favorite = new Favorite
        {
            UserId = userId,
            ProductId = request.ProductId,
            CreatedAt = DateTime.UtcNow
        };

        await _favoriteRepository.AddAsync(favorite);
        await _favoriteRepository.SaveChangesAsync();

        // 4. Trả về DTO
        return await _favoriteRepository.Entities
            .Include(x => x.Product)
            .Where(x => x.FavoriteId == favorite.FavoriteId)
            .ProjectTo<FavoriteDto>(_mapper.ConfigurationProvider)
            .FirstAsync();
    }

    public async Task RemoveFavoriteAsync(int userId, int productId)
    {
        var favorite = await _favoriteRepository.Entities
            .FirstOrDefaultAsync(x => x.UserId == userId && x.ProductId == productId);

        if (favorite == null)
        {
            throw new KeyNotFoundException("Sản phẩm không có trong danh sách yêu thích.");
        }

        _favoriteRepository.Delete(favorite);
        await _favoriteRepository.SaveChangesAsync();
    }

    public IQueryable<FavoriteDto> GetMyFavoritesQuery(int userId)
    {
        return _favoriteRepository.Entities
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<FavoriteDto>(_mapper.ConfigurationProvider);
    }

    public async Task<bool> IsFavoriteAsync(int userId, int productId)
    {
        return await _favoriteRepository.Entities
            .AnyAsync(x => x.UserId == userId && x.ProductId == productId);
    }
}
