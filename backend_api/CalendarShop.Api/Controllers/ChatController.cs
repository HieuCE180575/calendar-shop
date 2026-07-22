using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

public class ChatController : AppControllerBase
{
    private readonly IChatAssistantService _chatAssistantService;

    public ChatController(IChatAssistantService chatAssistantService)
    {
        _chatAssistantService = chatAssistantService;
    }

    [HttpPost("ask")]
    public async Task<ActionResult<ChatAnswerDto>> Ask(ChatAskRequest request, CancellationToken cancellationToken)
    {
        var response = await _chatAssistantService.AskAsync(request, cancellationToken);
        return Ok(response);
    }
}
