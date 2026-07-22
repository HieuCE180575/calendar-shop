using CalendarShop.Api.Dtos;
using CalendarShop.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

public class ChatController : AppControllerBase
{
    private readonly IChatAssistantService _chatAssistantService;
    private readonly ILogger<ChatController> _logger;

    public ChatController(IChatAssistantService chatAssistantService, ILogger<ChatController> logger)
    {
        _chatAssistantService = chatAssistantService;
        _logger = logger;
    }

    [HttpPost("ask")]
    public async Task<ActionResult<ChatAnswerDto>> Ask(ChatAskRequest request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("ChatController.Ask started. MessageLength={MessageLength}",
            request.Message?.Length ?? 0);

        var response = await _chatAssistantService.AskAsync(request, cancellationToken);

        _logger.LogInformation("ChatController.Ask completed. AnswerLength={AnswerLength}",
            response.Answer?.Length ?? 0);

        return Ok(response);
    }
}
