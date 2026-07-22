using AutoMapper;
using AutoMapper.QueryableExtensions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class UserService : IUserService
{
    private static readonly string[] ValidRoles = { "Customer", "Admin" };
    private static readonly string[] ValidStatuses = { "Active", "Locked", "Pending" };

    private readonly IRepository<User> _userRepository;
    private readonly IRepository<RefreshToken> _refreshTokenRepository;
    private readonly IMapper _mapper;

    public UserService(IRepository<User> userRepository, IRepository<RefreshToken> refreshTokenRepository, IMapper mapper)
    {
        _userRepository = userRepository;
        _refreshTokenRepository = refreshTokenRepository;
        _mapper = mapper;
    }

    public IQueryable<UserDto> GetUsersQuery(string? search, string? role, string? status)
    {
        var query = _userRepository.Entities.AsNoTracking();
        var keyword = search?.Trim();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            query = query.Where(x =>
                x.FullName.Contains(keyword) ||
                (x.Email != null && x.Email.Contains(keyword)) ||
                (x.Phone != null && x.Phone.Contains(keyword)));
        }

        if (!string.IsNullOrWhiteSpace(role))
        {
            query = query.Where(x => x.Role == role.Trim());
        }

        if (!string.IsNullOrWhiteSpace(status))
        {
            query = query.Where(x => x.Status == status.Trim());
        }

        return query
            .OrderByDescending(x => x.CreatedAt)
            .ProjectTo<UserDto>(_mapper.ConfigurationProvider);
    }

    public async Task<UserDto> GetUserByIdAsync(int id)
    {
        var user = await _userRepository.Entities
            .AsNoTracking()
            .Where(x => x.UserId == id)
            .ProjectTo<UserDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();

        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        return user;
    }

    public async Task UpdateUserStatusAsync(int currentAdminId, int id, UpdateUserStatusRequest request)
    {
        var status = NormalizeStatus(request.Status);
        var user = await GetUserEntityOrThrowAsync(id);

        if (currentAdminId == id && status == "Locked")
        {
            throw new BadHttpRequestException("Không thể tự khóa tài khoản admin đang đăng nhập.");
        }

        user.Status = status;
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);

        if (status == "Locked")
        {
            await RevokeActiveRefreshTokensAsync(id);
        }

        await _userRepository.SaveChangesAsync();
    }

    public async Task UpdateUserRoleAsync(int currentAdminId, int id, UpdateUserRoleRequest request)
    {
        var role = NormalizeRole(request.Role);
        var user = await GetUserEntityOrThrowAsync(id);

        if (currentAdminId == id && role != "Admin")
        {
            throw new BadHttpRequestException("Không thể tự hạ quyền tài khoản admin đang đăng nhập.");
        }

        user.Role = role;
        user.UpdatedAt = DateTime.UtcNow;
        _userRepository.Update(user);
        await _userRepository.SaveChangesAsync();
    }

    private async Task<User> GetUserEntityOrThrowAsync(int id)
    {
        var user = await _userRepository.GetByIdAsync(id);
        if (user == null)
        {
            throw new KeyNotFoundException("Không tìm thấy người dùng.");
        }

        return user;
    }

    private async Task RevokeActiveRefreshTokensAsync(int userId)
    {
        var tokens = await _refreshTokenRepository.Entities
            .Where(x => x.UserId == userId && !x.IsRevoked && x.ExpiredAt > DateTime.UtcNow)
            .ToListAsync();

        foreach (var token in tokens)
        {
            token.IsRevoked = true;
            _refreshTokenRepository.Update(token);
        }
    }

    private static string NormalizeStatus(string value)
    {
        var status = value.Trim();
        if (!ValidStatuses.Contains(status))
        {
            throw new BadHttpRequestException("Trạng thái người dùng phải là Active, Locked hoặc Pending.");
        }

        return status;
    }

    private static string NormalizeRole(string value)
    {
        var role = value.Trim();
        if (!ValidRoles.Contains(role))
        {
            throw new BadHttpRequestException("Quyền người dùng phải là Customer hoặc Admin.");
        }

        return role;
    }

    public async Task<CalendarShop.Api.Dtos.AdminStats.AdminCustomerStatsDto> GetAdminCustomerStatsAsync(int days = 7)
    {
        var now = DateTime.UtcNow;
        var currentStartDate = now.AddDays(-days);
        var prevStartDate = now.AddDays(-days * 2);

        var totalCustomers = await _userRepository.Entities.CountAsync(u => u.Role == "Customer" && u.CreatedAt <= now);
        var prevTotalCustomers = await _userRepository.Entities.CountAsync(u => u.Role == "Customer" && u.CreatedAt <= currentStartDate);
        double totalCustomersGrowth = prevTotalCustomers == 0 ? (totalCustomers > 0 ? 100 : 0) : Math.Round(((double)(totalCustomers - prevTotalCustomers) / prevTotalCustomers) * 100, 1);

        var newCustomers = await _userRepository.Entities.CountAsync(u => u.Role == "Customer" && u.CreatedAt >= currentStartDate && u.CreatedAt <= now);
        var prevNewCustomers = await _userRepository.Entities.CountAsync(u => u.Role == "Customer" && u.CreatedAt >= prevStartDate && u.CreatedAt < currentStartDate);
        double newCustomersGrowth = prevNewCustomers == 0 ? (newCustomers > 0 ? 100 : 0) : Math.Round(((double)(newCustomers - prevNewCustomers) / prevNewCustomers) * 100, 1);

        var lockedAccounts = await _userRepository.Entities.CountAsync(u => u.Role == "Customer" && u.Status == "Locked");
        
        // Calculate Ranks
        var customersWithOrders = await _userRepository.Entities
            .Where(u => u.Role == "Customer")
            .Select(u => new
            {
                u.UserId,
                u.FullName,
                u.Email,
                TotalOrders = u.Orders.Count(o => o.Status == "Delivered"),
                TotalSpent = u.Orders.Where(o => o.Status == "Delivered").Sum(o => o.TotalAmount)
            })
            .ToListAsync();

        var rankedCustomers = customersWithOrders.Select(c => new
        {
            c.UserId,
            c.FullName,
            c.Email,
            c.TotalOrders,
            c.TotalSpent,
            Rank = GetRank((double)c.TotalSpent)
        }).ToList();

        var loyalCustomers = rankedCustomers.Count(c => c.Rank == "Kim cương" || c.Rank == "Vàng" || c.Rank == "Bạc");

        var rankGroups = rankedCustomers.GroupBy(c => c.Rank).ToList();
        var rankDistribution = new List<CalendarShop.Api.Dtos.AdminStats.CustomerRankDistributionDto>();
        var rankNames = new[] { "Kim cương", "Vàng", "Bạc", "Đồng", "Thường" };
        foreach (var r in rankNames)
        {
            var total = rankGroups.FirstOrDefault(g => g.Key == r)?.Count() ?? 0;
            rankDistribution.Add(new CalendarShop.Api.Dtos.AdminStats.CustomerRankDistributionDto
            {
                Rank = r,
                Total = total,
                Percentage = totalCustomers > 0 ? Math.Round((double)total / totalCustomers * 100, 1) : 0
            });
        }

        var topCustomers = rankedCustomers
            .OrderByDescending(c => c.TotalSpent)
            .Take(5)
            .Select(c => new CalendarShop.Api.Dtos.AdminStats.TopCustomerDto
            {
                UserId = c.UserId,
                FullName = c.FullName ?? "Khách hàng",
                Email = c.Email ?? "",
                Rank = c.Rank,
                TotalOrders = c.TotalOrders,
                TotalSpent = (double)c.TotalSpent
            })
            .ToList();

        return new CalendarShop.Api.Dtos.AdminStats.AdminCustomerStatsDto
        {
            TotalCustomers = totalCustomers,
            TotalCustomersGrowth = totalCustomersGrowth,
            NewCustomers = newCustomers,
            NewCustomersGrowth = newCustomersGrowth,
            LoyalCustomers = loyalCustomers,
            LockedAccounts = lockedAccounts,
            RankDistribution = rankDistribution,
            TopCustomers = topCustomers
        };
    }

    private string GetRank(double totalSpent)
    {
        if (totalSpent >= 1000000) return "Kim cương";
        if (totalSpent >= 500000) return "Vàng";
        if (totalSpent >= 200000) return "Bạc";
        if (totalSpent >= 50000) return "Đồng";
        return "Thường";
    }
}
