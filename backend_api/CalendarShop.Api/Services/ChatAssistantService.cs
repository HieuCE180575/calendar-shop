using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using CalendarShop.Api.Dtos;
using CalendarShop.Api.Models;
using CalendarShop.Api.Options;
using CalendarShop.Api.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

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
        ["sale"] = "sale",
        ["dang sale"] = "sale",
        ["uu dai"] = "sale",
        ["treo tuong"] = "wall",
        ["de ban"] = "desk",
        ["con hang"] = "stock_available",
        ["het hang"] = "stock_unavailable",
        ["ton kho"] = "inventory",
        ["gia thap nhat"] = "min_price",
        ["gia cao nhat"] = "max_price",
        ["thap nhat"] = "min_price",
        ["cao nhat"] = "max_price",
        ["re nhat"] = "min_price",
        ["dat nhat"] = "max_price",
        ["mac nhat"] = "max_price",
        ["gia mac"] = "max_price",
        ["tam trung"] = "mid_range",
        ["trung binh"] = "mid_range"
    };

    private static readonly HashSet<string> ControlTokens =
    [
        "lich", "product", "list", "price", "range", "min_price", "max_price", "mid_range",
        "min", "max", "mid", "gia", "thap", "cao", "nhat", "re", "dat", "mac",
        "tam", "trung", "binh", "stock_available", "stock_unavailable", "inventory",
        "stock", "available", "unavailable", "con", "het", "ton", "kho", "sale"
    ];

    private readonly IRepository<Product> _productRepository;
    private readonly IRepository<Coupon> _couponRepository;
    private readonly IDiscountService _discountService;
    private readonly ILocalLlmService _localLlmService;
    private readonly LocalLlmSettings _llmSettings;

    public ChatAssistantService(
        IRepository<Product> productRepository,
        IRepository<Coupon> couponRepository,
        IDiscountService discountService,
        ILocalLlmService localLlmService,
        IOptions<LocalLlmSettings> llmSettings)
    {
        _productRepository = productRepository;
        _couponRepository = couponRepository;
        _discountService = discountService;
        _localLlmService = localLlmService;
        _llmSettings = llmSettings.Value;
    }

    public async Task<ChatAnswerDto> AskAsync(ChatAskRequest request, CancellationToken cancellationToken = default)
    {
        var message = request.Message?.Trim();
        if (string.IsNullOrWhiteSpace(message))
        {
            throw new BadHttpRequestException("Nội dung câu hỏi không được để trống.");
        }

        var normalizedQuery = NormalizeText(message);
        var queryTokens = ExtractTokens(normalizedQuery);
        if (queryTokens.Count == 0)
        {
            throw new BadHttpRequestException("Câu hỏi chưa đủ thông tin để tìm sản phẩm hoặc coupon.");
        }

        if (IsRestrictedOrderQuestion(normalizedQuery))
        {
            return new ChatAnswerDto(
                "Tôi không thể cung cấp thông tin đơn hàng trong khung chat công khai. Bạn có thể xem đơn hàng của mình trong mục Đơn hàng, hoặc xem báo cáo trong trang quản trị nếu là admin.");
        }

        var products = await _productRepository.Entities
            .Include(x => x.Category)
            .Include(x => x.Discount)
            .Where(x => !x.IsDeleted && x.Category != null && x.Category.Status == "Active")
            .ToListAsync(cancellationToken);

        var productCandidates = GetProductCandidates(normalizedQuery, queryTokens, products);
        productCandidates = EnsureGeneralProductContext(normalizedQuery, productCandidates, products);

        var couponCandidates = await GetCouponCandidatesAsync(normalizedQuery, queryTokens, cancellationToken);
        couponCandidates = EnsureGeneralCouponContext(normalizedQuery, couponCandidates);

        if (productCandidates.Count == 0 && couponCandidates.Count == 0)
        {
            return new ChatAnswerDto(
                "Tôi chưa tìm thấy dữ liệu phù hợp trong cửa hàng. Bạn có thể nhập rõ tên sản phẩm, danh mục hoặc mã coupon được không?");
        }

        var fallbackAnswer = BuildFallbackAnswer(productCandidates.FirstOrDefault(), couponCandidates.FirstOrDefault());
        var prompt = BuildPrompt(message, productCandidates, couponCandidates);
        var llmAnswer = await _localLlmService.GenerateAnswerAsync(prompt, cancellationToken);

        return new ChatAnswerDto(string.IsNullOrWhiteSpace(llmAnswer) ? fallbackAnswer : llmAnswer!);
    }

    private List<ProductCandidate> GetProductCandidates(
        string normalizedQuery,
        IReadOnlyCollection<string> queryTokens,
        IReadOnlyList<Product> products)
    {
        return products
            .Select(product => new ProductCandidate(product, ScoreProduct(product, normalizedQuery, queryTokens)))
            .Where(candidate => candidate.Score > 0)
            .OrderByDescending(candidate => candidate.Score)
            .Take(Math.Max(1, _llmSettings.MaxProductCandidates))
            .ToList();
    }

    private async Task<List<CouponCandidate>> GetCouponCandidatesAsync(
        string normalizedQuery,
        IReadOnlyCollection<string> queryTokens,
        CancellationToken cancellationToken)
    {
        var now = DateTime.UtcNow;
        var coupons = await _couponRepository.Entities
            .Where(x => x.Status == "Active" && x.StartDate <= now && x.EndDate >= now)
            .ToListAsync(cancellationToken);

        return coupons
            .Select(coupon => new CouponCandidate(coupon, ScoreCoupon(coupon, normalizedQuery, queryTokens)))
            .Where(candidate => candidate.Score > 0)
            .OrderByDescending(candidate => candidate.Score)
            .Take(Math.Max(1, _llmSettings.MaxCouponCandidates))
            .ToList();
    }

    private List<ProductCandidate> EnsureGeneralProductContext(
        string normalizedQuery,
        List<ProductCandidate> productCandidates,
        IReadOnlyList<Product> products)
    {
        if (productCandidates.Count > 0 || !ShouldUseOverviewProductContext(normalizedQuery))
        {
            return productCandidates;
        }

        return products
            .Where(x => x.Status == "Active" && x.StockQuantity > 0)
            .OrderByDescending(x => ShouldPrioritizeSaleProducts(normalizedQuery) && IsProductOnSale(x))
            .ThenByDescending(x => x.StockQuantity)
            .ThenBy(x => _discountService.GetDiscountedPrice(x))
            .Take(Math.Max(1, _llmSettings.MaxOverviewProducts))
            .Select(product => new ProductCandidate(product, 1))
            .ToList();
    }

    private List<CouponCandidate> EnsureGeneralCouponContext(
        string normalizedQuery,
        List<CouponCandidate> couponCandidates)
    {
        if (couponCandidates.Count > 0 || !ShouldUseOverviewCouponContext(normalizedQuery))
        {
            return couponCandidates;
        }

        return _couponRepository.Entities
            .Where(x => x.Status == "Active" && x.StartDate <= DateTime.UtcNow && x.EndDate >= DateTime.UtcNow)
            .OrderByDescending(x => x.DiscountValue)
            .Take(Math.Max(1, _llmSettings.MaxOverviewCoupons))
            .AsEnumerable()
            .Select(coupon => new CouponCandidate(coupon, 1))
            .ToList();
    }

    private static int ScoreProduct(Product product, string normalizedQuery, IReadOnlyCollection<string> queryTokens)
    {
        var score = 0;
        var name = NormalizeText(product.ProductName);
        var description = NormalizeText(product.Description);
        var category = NormalizeText(product.Category?.CategoryName);
        var calendarType = NormalizeText(product.CalendarType);

        if (name.Contains(normalizedQuery, StringComparison.Ordinal)) score += 14;
        if (!string.IsNullOrWhiteSpace(description) && description.Contains(normalizedQuery, StringComparison.Ordinal)) score += 7;
        if (!string.IsNullOrWhiteSpace(category) && category.Contains(normalizedQuery, StringComparison.Ordinal)) score += 8;

        foreach (var token in queryTokens.Where(token => !ControlTokens.Contains(token)))
        {
            if (name.Contains(token, StringComparison.Ordinal)) score += 5;
            if (!string.IsNullOrWhiteSpace(description) && description.Contains(token, StringComparison.Ordinal)) score += 3;
            if (!string.IsNullOrWhiteSpace(category) && category.Contains(token, StringComparison.Ordinal)) score += 4;
            if (!string.IsNullOrWhiteSpace(calendarType) && calendarType.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        return score;
    }

    private static int ScoreCoupon(Coupon coupon, string normalizedQuery, IReadOnlyCollection<string> queryTokens)
    {
        var score = 0;
        var code = NormalizeText(coupon.Code);
        var description = NormalizeText(coupon.Description);

        if (code.Contains(normalizedQuery, StringComparison.Ordinal)) score += 12;
        if (!string.IsNullOrWhiteSpace(description) && description.Contains(normalizedQuery, StringComparison.Ordinal)) score += 7;

        foreach (var token in queryTokens.Where(token => !ControlTokens.Contains(token)))
        {
            if (code.Contains(token, StringComparison.Ordinal)) score += 5;
            if (!string.IsNullOrWhiteSpace(description) && description.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        if (normalizedQuery.Contains("coupon", StringComparison.Ordinal)) score += 2;
        return score;
    }

    private string BuildFallbackAnswer(ProductCandidate? productCandidate, CouponCandidate? couponCandidate)
    {
        if (productCandidate != null)
        {
            var product = productCandidate.Product;
            var discountedPrice = _discountService.GetDiscountedPrice(product);
            var stockText = product.Status == "Active" && product.StockQuantity > 0
                ? $"Sản phẩm hiện còn hàng với số lượng {product.StockQuantity}."
                : "Sản phẩm hiện không sẵn sàng để bán.";

            var priceText = discountedPrice < product.Price
                ? $"Giá hiện tại là {discountedPrice:N0} VND, giá gốc {product.Price:N0} VND."
                : $"Giá hiện tại là {product.Price:N0} VND.";

            return $"{product.ProductName} thuộc danh mục {product.Category?.CategoryName ?? "chưa rõ"}, loại {product.CalendarType}. {priceText} {stockText}";
        }

        if (couponCandidate != null)
        {
            var coupon = couponCandidate.Coupon;
            var discountText = coupon.DiscountType == "Percent"
                ? $"giảm {coupon.DiscountValue:N0}%"
                : $"giảm {coupon.DiscountValue:N0} VND";

            return $"Coupon {coupon.Code} hiện đang hoạt động, {discountText}, áp dụng cho đơn từ {coupon.MinOrderValue:N0} VND.";
        }

        return "Tôi chưa tìm thấy dữ liệu phù hợp để trả lời câu hỏi này.";
    }

    private object BuildProductContext(Product product)
    {
        var currentPrice = _discountService.GetDiscountedPrice(product);
        var discount = product.Discount;
        var isOnSale = IsProductOnSale(product);

        return new
        {
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

    private bool IsProductOnSale(Product product)
    {
        var discount = product.Discount;
        return discount != null &&
               discount.Status == "Active" &&
               discount.StartDate <= DateTime.UtcNow &&
               discount.EndDate >= DateTime.UtcNow &&
               _discountService.GetDiscountedPrice(product) < product.Price;
    }

    private string BuildPrompt(
        string userQuestion,
        IReadOnlyList<ProductCandidate> products,
        IReadOnlyList<CouponCandidate> coupons)
    {
        var normalizedQuestion = NormalizeText(userQuestion);
        var productContexts = products.Select(x => BuildProductContext(x.Product)).ToList();
        var saleProductContexts = products
            .Where(x => IsProductOnSale(x.Product))
            .Select(x => BuildProductContext(x.Product))
            .ToList();

        var productLimitNote = products.Count >= Math.Max(1, _llmSettings.MaxOverviewProducts)
            ? $"Product context may be capped at {_llmSettings.MaxOverviewProducts} items."
            : "Product context is not capped.";
        var couponLimitNote = coupons.Count >= Math.Max(1, _llmSettings.MaxOverviewCoupons)
            ? $"Coupon context may be capped at {_llmSettings.MaxOverviewCoupons} items."
            : "Coupon context is not capped.";

        var context = new
        {
            notes = new[]
            {
                productLimitNote,
                couponLimitNote
            },
            questionHints = new
            {
                IsSaleQuestion = ShouldPrioritizeSaleProducts(normalizedQuestion)
            },
            activeSaleProductCount = saleProductContexts.Count,
            saleProducts = saleProductContexts,
            products = productContexts,
            coupons = coupons.Select(x => new
            {
                x.Coupon.CouponId,
                x.Coupon.Code,
                x.Coupon.Description,
                x.Coupon.DiscountType,
                x.Coupon.DiscountValue,
                x.Coupon.MinOrderValue,
                x.Coupon.StartDate,
                x.Coupon.EndDate,
                x.Coupon.Status
            })
        };

        var contextJson = JsonSerializer.Serialize(context, new JsonSerializerOptions { WriteIndented = true });

        return $"""
Bạn là trợ lý sản phẩm của Calendar Shop.

Quy tắc:
1. Chỉ trả lời dựa trên dữ liệu trong CONTEXT.
2. Không tự bịa giá, tồn kho, coupon, loại lịch hoặc mô tả sản phẩm.
3. Nếu CONTEXT không đủ để trả lời, nói rõ là chưa tìm thấy đủ thông tin.
4. Nếu có nhiều sản phẩm phù hợp, hãy gợi ý ngắn gọn 2-3 lựa chọn tốt nhất thay vì bắt người dùng hỏi lại.
5. Khi nhắc tên sản phẩm, phải copy chính xác ExactProductName/ProductName từ CONTEXT.
6. Không được dịch, sửa chính tả, tự đoán, hoặc thay đổi tên sản phẩm. Ví dụ ProductName là "Lịch để bàn mini 2026" thì phải giữ đúng như vậy.
7. Không dùng CalendarType để tạo tên sản phẩm mới.
8. Nếu questionHints.IsSaleQuestion = true, hãy ưu tiên đọc saleProducts trước.
9. Nếu activeSaleProductCount > 0, phải trả lời là có sản phẩm đang sale và liệt kê từ saleProducts.
10. Nếu activeSaleProductCount = 0, mới được nói là chưa có sản phẩm đang sale.
11. Nếu IsOnSale = true, sản phẩm đó đang áp dụng khuyến mãi/đang sale.
12. Nếu IsOnSale = false, không được nói sản phẩm đó đang sale.
13. Nếu CurrentPrice < OriginalPrice thì đây cũng là dấu hiệu sản phẩm đang được bán với giá ưu đãi.
14. Nếu stockQuantity > 0 và status = Active, có thể nói là còn hàng.
15. Nếu stockQuantity <= 0 hoặc status khác Active, nói là hiện không sẵn sàng để bán.
16. Trả lời tự nhiên, ngắn gọn, bằng tiếng Việt có dấu.

CONTEXT:
{contextJson}

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

        var normalized = text.Trim().ToLowerInvariant();
        normalized = normalized.Normalize(NormalizationForm.FormD);

        var builder = new StringBuilder(normalized.Length);
        foreach (var ch in normalized)
        {
            var category = CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category != UnicodeCategory.NonSpacingMark)
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

    private static bool ShouldUseOverviewProductContext(string normalizedQuery)
    {
        return normalizedQuery.Contains("lich", StringComparison.Ordinal) ||
               normalizedQuery.Contains("san pham", StringComparison.Ordinal) ||
               normalizedQuery.Contains("stock_available", StringComparison.Ordinal) ||
               normalizedQuery.Contains("stock_unavailable", StringComparison.Ordinal) ||
               normalizedQuery.Contains("inventory", StringComparison.Ordinal);
    }

    private static bool ShouldUseOverviewCouponContext(string normalizedQuery)
    {
        return normalizedQuery.Contains("coupon", StringComparison.Ordinal);
    }

    private static bool ShouldPrioritizeSaleProducts(string normalizedQuery)
    {
        return normalizedQuery.Contains("sale", StringComparison.Ordinal) ||
               normalizedQuery.Contains("coupon", StringComparison.Ordinal);
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

    private sealed record ProductCandidate(Product Product, int Score);
    private sealed record CouponCandidate(Coupon Coupon, int Score);
}
