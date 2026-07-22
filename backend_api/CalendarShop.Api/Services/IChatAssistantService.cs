using CalendarShop.Api.Dtos;

namespace CalendarShop.Api.Services;

public interface IChatAssistantService
{
    Task<ChatAnswerDto> AskAsync(ChatAskRequest request, CancellationToken cancellationToken = default);
}
