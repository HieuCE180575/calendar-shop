using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;

namespace CalendarShop.Api.Services;

public class ChatAssistantService : IChatAssistantService
{
    private static readonly HashSet<string> StopWords =
    [
        "co", "khong", "la", "nay", "kia", "do", "cua", "toi", "minh", "ma", "no",
        "gi", "nao", "o", "va", "hay", "cho", "xin", "tu", "mot", "nhung", "nhi",
        "voi", "ve", "duoc", "khach", "hang", "shop", "calendar", "hien", "tai", "dang"
    ];

    private static readonly Dictionary<string, string> PhraseSynonyms = new()
    {
        ["cuon"] = "lich",
        ["quyen"] = "lich",
        ["ma giam"] = "coupon",
        ["giam gia"] = "coupon",
        ["khuyen mai"] = "coupon",
        ["uu dai"] = "sale",
        ["dang sale"] = "sale",
        ["treo tuong"] = "wall",
        ["de ban"] = "desk"
    };

    private readonly IRepository<Product> _productRepository;
    private readonly IRepository<Coupon> _couponRepository;
    private readonly IDiscountService _discountService;
    private readonly ILocalLlmService _localLlmService;

    public ChatAssistantService(
        IRepository<Product> productRepository,
        IRepository<Coupon> couponRepository,
        IDiscountService discountService,
        ILocalLlmService localLlmService)
    {
        _productRepository = productRepository;
        _couponRepository = couponRepository;
        _discountService = discountService;
        _localLlmService = localLlmService;
    }

    public async Task<ChatAnswerDto> AskAsync(ChatAskRequest request, CancellationToken cancellationToken = default)
    {
        var message = request.Message?.Trim();
        if (string.IsNullOrWhiteSpace(message))
        {
            throw new BadHttpRequestException("Nội dung câu hỏi không được để trống.");
        }

        var normalizedQuery = NormalizeText(message);
        if (IsRestrictedOrderQuestion(normalizedQuery))
        {
            return new ChatAnswerDto(
                "Tôi không thể cung cấp thông tin đơn hàng trong khung chat công khai. Bạn có thể xem đơn hàng của mình trong mục Đơn hàng, hoặc xem báo cáo trong trang quản trị nếu là admin.");
        }

        var products = await LoadProductContextAsync(normalizedQuery, cancellationToken);
        var coupons = await LoadCouponContextAsync(normalizedQuery, cancellationToken);
        var prompt = BuildPrompt(message, products, coupons);
        var llmAnswer = await _localLlmService.GenerateAnswerAsync(prompt, cancellationToken);

        if (string.IsNullOrWhiteSpace(llmAnswer))
        {
            throw new InvalidOperationException("Không nhận được phản hồi từ mô hình AI.");
        }

        return new ChatAnswerDto(llmAnswer);
    }

    private async Task<List<object>> LoadProductContextAsync(string normalizedQuery, CancellationToken cancellationToken)
    {
        var queryTokens = ExtractTokens(normalizedQuery);
        var products = await _productRepository.Entities
            .Include(x => x.Category)
            .Include(x => x.Discount)
            .Where(x => !x.IsDeleted && x.Category != null && x.Category.Status == "Active")
            .OrderBy(x => x.ProductId)
            .ToListAsync(cancellationToken);

        return products
            .Select(product => BuildProductContext(product, ScoreProduct(product, normalizedQuery, queryTokens)))
            .ToList<object>();
    }

    private async Task<List<object>> LoadCouponContextAsync(string normalizedQuery, CancellationToken cancellationToken)
    {
        var queryTokens = ExtractTokens(normalizedQuery);
        var coupons = await _couponRepository.Entities
            .OrderBy(x => x.CouponId)
            .ToListAsync(cancellationToken);

        return coupons
            .Select(coupon => BuildCouponContext(coupon, ScoreCoupon(coupon, normalizedQuery, queryTokens)))
            .ToList<object>();
    }

    private object BuildProductContext(Product product, int relevanceScore)
    {
        var currentPrice = _discountService.GetDiscountedPrice(product);
        var discount = product.Discount;
        var isOnSale = IsProductOnSale(product);

        return new
        {
            relevanceScore,
            product.ProductId,
            product.ProductName,
            ExactProductName = product.ProductName,
            CategoryName = product.Category?.CategoryName,
            product.CalendarType,
            CurrentPrice = currentPrice,
            OriginalPrice = product.Price,
            IsOnSale = isOnSale,
            DiscountName = isOnSale ? discount?.Name : null,
            DiscountType = isOnSale ? discount?.DiscountType : null,
            DiscountValue = isOnSale ? discount?.DiscountValue : null,
            product.StockQuantity,
            product.Status,
            product.Description
        };
    }

    private static object BuildCouponContext(Coupon coupon, int relevanceScore)
    {
        var now = DateTime.UtcNow;

        return new
        {
            relevanceScore,
            coupon.CouponId,
            coupon.Code,
            coupon.Description,
            coupon.DiscountType,
            coupon.DiscountValue,
            coupon.MinOrderValue,
            coupon.StartDate,
            coupon.EndDate,
            coupon.UsageLimit,
            coupon.UsedCount,
            coupon.Status,
            IsCurrentlyUsable = coupon.Status == "Active" && coupon.StartDate <= now && coupon.EndDate >= now
        };
    }

    private bool IsProductOnSale(Product product)
    {
        var discount = product.Discount;
        return discount != null &&
               discount.Status == "Active" &&
               discount.StartDate <= DateTime.UtcNow &&
               discount.EndDate >= DateTime.UtcNow &&
               _discountService.GetDiscountedPrice(product) < product.Price;
    }

    private static int ScoreProduct(Product product, string normalizedQuery, IReadOnlyCollection<string> queryTokens)
    {
        var score = 0;
        var name = NormalizeText(product.ProductName);
        var description = NormalizeText(product.Description);
        var category = NormalizeText(product.Category?.CategoryName);
        var calendarType = NormalizeText(product.CalendarType);

        if (!string.IsNullOrWhiteSpace(normalizedQuery) && name.Contains(normalizedQuery, StringComparison.Ordinal)) score += 14;
        if (!string.IsNullOrWhiteSpace(normalizedQuery) && description.Contains(normalizedQuery, StringComparison.Ordinal)) score += 7;
        if (!string.IsNullOrWhiteSpace(normalizedQuery) && category.Contains(normalizedQuery, StringComparison.Ordinal)) score += 8;

        foreach (var token in queryTokens)
        {
            if (name.Contains(token, StringComparison.Ordinal)) score += 5;
            if (description.Contains(token, StringComparison.Ordinal)) score += 3;
            if (category.Contains(token, StringComparison.Ordinal)) score += 4;
            if (calendarType.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        return score;
    }

    private static int ScoreCoupon(Coupon coupon, string normalizedQuery, IReadOnlyCollection<string> queryTokens)
    {
        var score = 0;
        var code = NormalizeText(coupon.Code);
        var description = NormalizeText(coupon.Description);

        if (!string.IsNullOrWhiteSpace(normalizedQuery) && code.Contains(normalizedQuery, StringComparison.Ordinal)) score += 12;
        if (!string.IsNullOrWhiteSpace(normalizedQuery) && description.Contains(normalizedQuery, StringComparison.Ordinal)) score += 7;

        foreach (var token in queryTokens)
        {
            if (code.Contains(token, StringComparison.Ordinal)) score += 5;
            if (description.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        if (normalizedQuery.Contains("coupon", StringComparison.Ordinal)) score += 2;
        return score;
    }

    private static string BuildPrompt(
        string userQuestion,
        IReadOnlyList<object> products,
        IReadOnlyList<object> coupons)
    {
        var runtimeContext = new
        {
            products,
            coupons
        };
        var runtimeContextJson = JsonSerializer.Serialize(runtimeContext, new JsonSerializerOptions { WriteIndented = true });

        return $"""
Bạn là trợ lý sản phẩm của Calendar Shop.

Quy tắc:
1. Chỉ trả lời dựa trên RUNTIME_DATA bên dưới.
2. RUNTIME_DATA là dữ liệu hiện tại lấy từ database đang chạy thông qua repository.
3. Dùng RUNTIME_DATA trước khi trả lời về sản phẩm, tồn kho, giá, sale hoặc coupon.
4. Không tự bịa giá, tồn kho, coupon, loại lịch hoặc mô tả sản phẩm.
5. Khi nhắc tên sản phẩm, phải copy chính xác ExactProductName/ProductName từ RUNTIME_DATA.
6. Không dịch, sửa chính tả, tự đoán, hoặc thay đổi tên sản phẩm.
7. relevanceScore chỉ là gợi ý độ liên quan với câu hỏi; điểm cao hơn thì nên ưu tiên đọc trước, nhưng vẫn được dùng dữ liệu có điểm thấp nếu câu hỏi cần.
8. Nếu IsOnSale = true hoặc CurrentPrice < OriginalPrice, sản phẩm đang sale.
9. Nếu StockQuantity > 0 và Status = Active, có thể nói sản phẩm còn hàng.
10. Nếu StockQuantity <= 0 hoặc Status khác Active, nói sản phẩm hiện không sẵn sàng để bán.
11. Trả lời tự nhiên, ngắn gọn, bằng tiếng Việt có dấu.

RUNTIME_DATA:
```json
{runtimeContextJson}
```

CÂU HỎI:
{userQuestion}
""";
    }

    private static string NormalizeText(string? text)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return string.Empty;
        }

        var normalized = text.Trim().ToLowerInvariant().Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder(normalized.Length);

        foreach (var ch in normalized)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(ch) != UnicodeCategory.NonSpacingMark)
            {
                builder.Append(ch);
            }
        }

        normalized = builder
            .ToString()
            .Normalize(NormalizationForm.FormC)
            .Replace('đ', 'd');

        foreach (var pair in PhraseSynonyms)
        {
            normalized = normalized.Replace(pair.Key, pair.Value, StringComparison.Ordinal);
        }

        normalized = Regex.Replace(normalized, @"[^a-z0-9_\s]", " ");
        normalized = Regex.Replace(normalized, @"\s+", " ").Trim();
        return normalized;
    }

    private static IReadOnlyList<string> ExtractTokens(string normalizedQuery)
    {
        return normalizedQuery
            .Split(' ', StringSplitOptions.RemoveEmptyEntries)
            .Where(token => token.Length > 1 && !StopWords.Contains(token))
            .Distinct()
            .ToList();
    }

    private static bool IsRestrictedOrderQuestion(string normalizedQuery)
    {
        return (normalizedQuery.Contains("don", StringComparison.Ordinal) ||
                normalizedQuery.Contains("order", StringComparison.Ordinal) ||
                normalizedQuery.Contains("ban gan day", StringComparison.Ordinal)) &&
               (normalizedQuery.Contains("gan day", StringComparison.Ordinal) ||
                normalizedQuery.Contains("moi nhat", StringComparison.Ordinal) ||
                normalizedQuery.Contains("latest", StringComparison.Ordinal) ||
                normalizedQuery.Contains("thoi gian", StringComparison.Ordinal));
    }
}
