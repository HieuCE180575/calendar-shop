namespace CalendarShop.Api.Options;

public class LocalLlmSettings
{
    public bool Enabled { get; set; } = false;
    public string BaseUrl { get; set; } = "http://localhost:11434/v1";
    public string ChatCompletionsPath { get; set; } = "/chat/completions";
    public string? ApiKey { get; set; } = "ollama";
    public string Model { get; set; } = "qwen2.5:3b-instruct";
    public int TimeoutSeconds { get; set; } = 30;
    public int MaxProductCandidates { get; set; } = 3;
    public int MaxCouponCandidates { get; set; } = 2;
}
