namespace CalendarShop.Api.Options;

public class LocalLlmSettings
{
    public bool Enabled { get; set; } = true;
    public string BaseUrl { get; set; } = "http://localhost:1234/v1";
    public string ChatCompletionsPath { get; set; } = "/chat/completions";
    public string? ApiKey { get; set; } = "ollama";
    public string Model { get; set; } = "qwen/qwen3-4b";
    public int TimeoutSeconds { get; set; } = 30;
    public int MaxProductCandidates { get; set; } = 5;
    public int MaxCouponCandidates { get; set; } = 5;
    public int MaxOverviewProducts { get; set; } = 50;
    public int MaxOverviewCoupons { get; set; } = 20;
}
