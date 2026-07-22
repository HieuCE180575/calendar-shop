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
    private readonly ILogger<LocalLlmService> _logger;

    public LocalLlmService(HttpClient httpClient, IOptions<LocalLlmSettings> settings, ILogger<LocalLlmService> logger)
    {
        _httpClient = httpClient;
        _settings = settings.Value;
        _logger = logger;
    }

    public async Task<string?> GenerateAnswerAsync(string prompt, CancellationToken cancellationToken = default)
    {
        if (!_settings.Enabled || string.IsNullOrWhiteSpace(_settings.BaseUrl) || string.IsNullOrWhiteSpace(_settings.Model))
        {
            _logger.LogError(
                "LocalLlmService.GenerateAnswerAsync invalid configuration. Enabled={Enabled}, BaseUrlSet={BaseUrlSet}, ModelSet={ModelSet}",
                _settings.Enabled,
                !string.IsNullOrWhiteSpace(_settings.BaseUrl),
                !string.IsNullOrWhiteSpace(_settings.Model));

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

        _logger.LogInformation(
            "LocalLlmService.GenerateAnswerAsync preparing request. BaseUrl={BaseUrl}, Path={Path}, Model={Model}, TimeoutSeconds={TimeoutSeconds}, PromptLength={PromptLength}, ApiKeySet={ApiKeySet}",
            _settings.BaseUrl,
            _settings.ChatCompletionsPath,
            _settings.Model,
            Math.Max(5, _settings.TimeoutSeconds),
            prompt.Length,
            !string.IsNullOrWhiteSpace(_settings.ApiKey));

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

        _logger.LogInformation(
            "LocalLlmService.GenerateAnswerAsync received response. StatusCode={StatusCode}, Reason={ReasonPhrase}",
            (int)response.StatusCode,
            response.ReasonPhrase);

        if (!response.IsSuccessStatusCode)
        {
            var errorBody = await response.Content.ReadAsStringAsync(cancellationToken);
            _logger.LogError(
                "LocalLlmService.GenerateAnswerAsync failed response body. StatusCode={StatusCode}, ErrorPreview={ErrorPreview}",
                (int)response.StatusCode,
                Preview(errorBody));

            throw new InvalidOperationException(
                $"Local LLM trả về lỗi {(int)response.StatusCode} {response.ReasonPhrase}: {errorBody}");
        }

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        var completion = await JsonSerializer.DeserializeAsync<ChatCompletionResponse>(stream, JsonOptions, cancellationToken);
        var choice = completion?.Choices?.FirstOrDefault();
        var answer = choice?.Message?.Content?.Trim();

        _logger.LogInformation(
            "LocalLlmService.GenerateAnswerAsync parsed response. ChoiceCount={ChoiceCount}, FinishReason={FinishReason}, ContentLength={ContentLength}, ReasoningLength={ReasoningLength}",
            completion?.Choices?.Count ?? 0,
            choice?.FinishReason ?? "(null)",
            answer?.Length ?? 0,
            choice?.Message?.ReasoningContent?.Length ?? 0);

        if (string.IsNullOrWhiteSpace(answer))
        {
            _logger.LogError(
                "LocalLlmService.GenerateAnswerAsync empty content. FinishReason={FinishReason}, ReasoningPreview={ReasoningPreview}",
                choice?.FinishReason ?? "(null)",
                Preview(choice?.Message?.ReasoningContent ?? string.Empty));

            throw new InvalidOperationException("Local LLM trả về phản hồi rỗng hoặc thiếu choices[0].message.content.");
        }

        _logger.LogInformation(
            "LocalLlmService.GenerateAnswerAsync completed. AnswerPreview={AnswerPreview}",
            Preview(answer));

        return answer;
    }

    private static string Preview(string value, int maxLength = 240)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        var singleLine = string.Join(' ', value.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries));
        return singleLine.Length <= maxLength ? singleLine : singleLine[..maxLength] + "...";
    }

    private sealed class ChatCompletionResponse
    {
        public List<ChatCompletionChoice>? Choices { get; set; }
    }

    private sealed class ChatCompletionChoice
    {
        public ChatCompletionMessage? Message { get; set; }

        public string? FinishReason { get; set; }
    }

    private sealed class ChatCompletionMessage
    {
        public string? Content { get; set; }

        public string? ReasoningContent { get; set; }
    }
}
