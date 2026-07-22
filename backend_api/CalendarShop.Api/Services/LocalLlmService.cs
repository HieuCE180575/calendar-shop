using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using CalendarShop.Api.Options;
using Microsoft.Extensions.Options;

namespace CalendarShop.Api.Services;

public class LocalLlmService : ILocalLlmService
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly HttpClient _httpClient;
    private readonly LocalLlmSettings _settings;

    public LocalLlmService(HttpClient httpClient, IOptions<LocalLlmSettings> settings)
    {
        _httpClient = httpClient;
        _settings = settings.Value;
    }

    public async Task<string?> GenerateAnswerAsync(string prompt, CancellationToken cancellationToken = default)
    {
        if (!_settings.Enabled || string.IsNullOrWhiteSpace(_settings.BaseUrl) || string.IsNullOrWhiteSpace(_settings.Model))
        {
            throw new InvalidOperationException("Local LLM chưa được cấu hình hoặc đang bị tắt.");
        }

        _httpClient.BaseAddress = new Uri(_settings.BaseUrl.TrimEnd('/') + "/");
        _httpClient.Timeout = TimeSpan.FromSeconds(Math.Max(5, _settings.TimeoutSeconds));
        _httpClient.DefaultRequestHeaders.Accept.Clear();
        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        _httpClient.DefaultRequestHeaders.Authorization = null;

        if (!string.IsNullOrWhiteSpace(_settings.ApiKey))
        {
            _httpClient.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", _settings.ApiKey);
        }

        var payload = new
        {
            model = _settings.Model,
            temperature = 0.2,
            messages = new object[]
            {
                new
                {
                    role = "system",
                    content = "Bạn là trợ lý sản phẩm của Calendar Shop. Luôn trả lời bằng tiếng Việt có dấu và copy chính xác tên sản phẩm từ dữ liệu được cung cấp, không tự dịch hoặc đổi tên sản phẩm."
                },
                new { role = "user", content = prompt }
            }
        };

        var requestContent = new StringContent(
            JsonSerializer.Serialize(payload, JsonOptions),
            Encoding.UTF8,
            "application/json");

        using var response = await _httpClient.PostAsync(
            _settings.ChatCompletionsPath.TrimStart('/'),
            requestContent,
            cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            var errorBody = await response.Content.ReadAsStringAsync(cancellationToken);
            throw new InvalidOperationException(
                $"Local LLM trả về lỗi {(int)response.StatusCode} {response.ReasonPhrase}: {errorBody}");
        }

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        var completion = await JsonSerializer.DeserializeAsync<ChatCompletionResponse>(stream, JsonOptions, cancellationToken);
        var answer = completion?.Choices?.FirstOrDefault()?.Message?.Content?.Trim();

        if (string.IsNullOrWhiteSpace(answer))
        {
            throw new InvalidOperationException("Local LLM trả về phản hồi rỗng hoặc thiếu choices[0].message.content.");
        }

        return answer;
    }

    private sealed class ChatCompletionResponse
    {
        public List<ChatCompletionChoice>? Choices { get; set; }
    }

    private sealed class ChatCompletionChoice
    {
        public ChatCompletionMessage? Message { get; set; }
    }

    private sealed class ChatCompletionMessage
    {
        public string? Content { get; set; }
    }
}
