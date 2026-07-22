namespace CalendarShop.Api.Services;

public interface ILocalLlmService
{
    Task<string?> GenerateAnswerAsync(string prompt, CancellationToken cancellationToken = default);
}
