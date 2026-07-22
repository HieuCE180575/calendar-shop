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
        "voi", "ve", "duoc", "khach", "hang", "shop", "calendar"
    ];

    private static readonly Dictionary<string, string> PhraseSynonyms = new()
    {
        ["cuon"] = "lich",
        ["quyen"] = "lich",
        ["ma giam"] = "coupon",
        ["giam gia"] = "coupon",
        ["khuyen mai"] = "coupon",
        ["treo tuong"] = "wall",
        ["de ban"] = "desk",
        ["con hang"] = "stock",
        ["het hang"] = "outofstock"
    };

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
            throw new BadHttpRequestException("Noi dung cau hoi khong duoc de trong.");
        }

        var normalizedQuery = NormalizeText(message);
        var queryTokens = ExtractTokens(normalizedQuery);
        if (queryTokens.Count == 0)
        {
            throw new BadHttpRequestException("Cau hoi chua du thong tin de tim san pham hoac coupon.");
        }

        var productCandidates = await GetProductCandidatesAsync(normalizedQuery, queryTokens, cancellationToken);
        var couponCandidates = await GetCouponCandidatesAsync(normalizedQuery, queryTokens, cancellationToken);

        if (productCandidates.Count == 0 && couponCandidates.Count == 0)
        {
            return new ChatAnswerDto(
                normalizedQuery,
                "Toi chua tim thay du lieu phu hop trong cua hang. Ban co the nhap ro ten san pham, danh muc hoac ma coupon duoc khong?",
                [],
                false,
                true);
        }

        var requiresClarification = NeedsClarification(productCandidates, couponCandidates);
        if (requiresClarification)
        {
            return new ChatAnswerDto(
                normalizedQuery,
                BuildClarificationAnswer(productCandidates, couponCandidates),
                BuildSources(productCandidates, couponCandidates),
                false,
                true);
        }

        var fallbackAnswer = BuildFallbackAnswer(productCandidates.FirstOrDefault(), couponCandidates.FirstOrDefault(), normalizedQuery);
        var prompt = BuildPrompt(normalizedQuery, productCandidates, couponCandidates);
        var llmAnswer = await _localLlmService.GenerateAnswerAsync(prompt, cancellationToken);
        var finalAnswer = string.IsNullOrWhiteSpace(llmAnswer) ? fallbackAnswer : llmAnswer!;

        return new ChatAnswerDto(
            normalizedQuery,
            finalAnswer,
            BuildSources(productCandidates, couponCandidates),
            !string.IsNullOrWhiteSpace(llmAnswer),
            false);
    }

    private async Task<List<ProductCandidate>> GetProductCandidatesAsync(
        string normalizedQuery,
        IReadOnlyCollection<string> queryTokens,
        CancellationToken cancellationToken)
    {
        var products = await _productRepository.Entities
            .Include(x => x.Category)
            .Include(x => x.Discount)
            .Where(x => !x.IsDeleted && x.Status != "Hidden")
            .ToListAsync(cancellationToken);

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

        foreach (var token in queryTokens)
        {
            if (name.Contains(token, StringComparison.Ordinal)) score += 5;
            if (!string.IsNullOrWhiteSpace(description) && description.Contains(token, StringComparison.Ordinal)) score += 3;
            if (!string.IsNullOrWhiteSpace(category) && category.Contains(token, StringComparison.Ordinal)) score += 4;
            if (!string.IsNullOrWhiteSpace(calendarType) && calendarType.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        if (product.Status == "Active") score += 1;
        if (product.StockQuantity > 0) score += 1;

        return score;
    }

    private static int ScoreCoupon(Coupon coupon, string normalizedQuery, IReadOnlyCollection<string> queryTokens)
    {
        var score = 0;
        var code = NormalizeText(coupon.Code);
        var description = NormalizeText(coupon.Description);

        if (code.Contains(normalizedQuery, StringComparison.Ordinal)) score += 12;
        if (!string.IsNullOrWhiteSpace(description) && description.Contains(normalizedQuery, StringComparison.Ordinal)) score += 7;

        foreach (var token in queryTokens)
        {
            if (code.Contains(token, StringComparison.Ordinal)) score += 5;
            if (!string.IsNullOrWhiteSpace(description) && description.Contains(token, StringComparison.Ordinal)) score += 3;
        }

        if (normalizedQuery.Contains("coupon", StringComparison.Ordinal)) score += 2;
        return score;
    }

    private static bool NeedsClarification(IReadOnlyList<ProductCandidate> products, IReadOnlyList<CouponCandidate> coupons)
    {
        if (products.Count >= 2 && Math.Abs(products[0].Score - products[1].Score) <= 2)
        {
            return true;
        }

        if (products.Count == 0 && coupons.Count >= 2 && Math.Abs(coupons[0].Score - coupons[1].Score) <= 2)
        {
            return true;
        }

        return false;
    }

    private static string BuildClarificationAnswer(IReadOnlyList<ProductCandidate> products, IReadOnlyList<CouponCandidate> coupons)
    {
        if (products.Count > 0)
        {
            var suggestions = string.Join(", ", products.Take(3).Select(x => $"\"{x.Product.ProductName}\""));
            return $"Toi dang thay mot vai san pham gan dung: {suggestions}. Ban dang hoi san pham nao trong so nay?";
        }

        var couponSuggestions = string.Join(", ", coupons.Take(3).Select(x => $"\"{x.Coupon.Code}\""));
        return $"Toi dang thay mot vai coupon gan dung: {couponSuggestions}. Ban muon hoi coupon nao?";
    }

    private string BuildFallbackAnswer(ProductCandidate? productCandidate, CouponCandidate? couponCandidate, string normalizedQuery)
    {
        if (productCandidate != null)
        {
            var product = productCandidate.Product;
            var discountedPrice = _discountService.GetDiscountedPrice(product);
            var stockText = product.Status == "Active" && product.StockQuantity > 0
                ? $"San pham hien con hang voi so luong {product.StockQuantity}."
                : "San pham hien khong san sang de ban.";

            var priceText = discountedPrice < product.Price
                ? $"Gia hien tai la {discountedPrice:N0} VND, gia goc {product.Price:N0} VND."
                : $"Gia hien tai la {product.Price:N0} VND.";

            return $"{product.ProductName} thuoc danh muc {product.Category?.CategoryName ?? "chua ro"}, loai {product.CalendarType}. {priceText} {stockText}";
        }

        if (couponCandidate != null)
        {
            var coupon = couponCandidate.Coupon;
            var discountText = coupon.DiscountType == "Percent"
                ? $"giam {coupon.DiscountValue:N0}%"
                : $"giam {coupon.DiscountValue:N0} VND";

            return $"Coupon {coupon.Code} hien dang hoat dong, {discountText}, ap dung cho don tu {coupon.MinOrderValue:N0} VND.";
        }

        return "Toi chua tim thay du lieu phu hop de tra loi cau hoi nay.";
    }

    private static IReadOnlyList<ChatSourceDto> BuildSources(
        IReadOnlyList<ProductCandidate> products,
        IReadOnlyList<CouponCandidate> coupons)
    {
        var sources = new List<ChatSourceDto>();

        sources.AddRange(products.Select(x => new ChatSourceDto("product", x.Product.ProductId, x.Product.ProductName, x.Score)));
        sources.AddRange(coupons.Select(x => new ChatSourceDto("coupon", x.Coupon.CouponId, x.Coupon.Code, x.Score)));

        return sources;
    }

    private string BuildPrompt(
        string normalizedQuery,
        IReadOnlyList<ProductCandidate> products,
        IReadOnlyList<CouponCandidate> coupons)
    {
        var context = new
        {
            query = normalizedQuery,
            products = products.Select(x => new
            {
                x.Product.ProductId,
                x.Product.ProductName,
                CategoryName = x.Product.Category?.CategoryName,
                x.Product.CalendarType,
                CurrentPrice = _discountService.GetDiscountedPrice(x.Product),
                OriginalPrice = x.Product.Price,
                x.Product.StockQuantity,
                x.Product.Status,
                x.Product.Description
            }),
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
Ban la tro ly san pham cua Calendar Shop.

Quy tac:
1. Chi duoc tra loi dua tren du lieu trong CONTEXT.
2. Khong duoc tu bia gia, ton kho, coupon, loai lich hoac mo ta san pham.
3. Neu CONTEXT khong du de tra loi, phai noi ro la khong tim thay du thong tin.
4. Neu co nhieu ket qua gan giong nhau, phai yeu cau nguoi dung lam ro.
5. Tra loi ngan gon, tu nhien, bang tieng Viet khong dau.
6. Neu stockQuantity > 0 va status = Active, co the noi la con hang.
7. Neu stockQuantity <= 0 hoac status khac Active, noi la hien khong san sang de ban.

CONTEXT:
{contextJson}

CAU HOI:
{normalizedQuery}
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

        normalized = Regex.Replace(normalized, @"[^a-z0-9\s]", " ");
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

    private sealed record ProductCandidate(Product Product, int Score);
    private sealed record CouponCandidate(Coupon Coupon, int Score);
}
