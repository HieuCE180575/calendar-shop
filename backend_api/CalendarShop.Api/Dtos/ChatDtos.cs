namespace CalendarShop.Api.Dtos;

public record ChatAskRequest(string Message);

public record ChatSourceDto(
    string Type,
    int? Id,
    string Name,
    double Score
);

public record ChatAnswerDto(
    string NormalizedQuery,
    string Answer,
    IReadOnlyList<ChatSourceDto> Sources,
    bool UsedInference,
    bool RequiresClarification
);
