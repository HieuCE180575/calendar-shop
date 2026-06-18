using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace CalendarShop.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public abstract class AppControllerBase : ControllerBase
{
    protected int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
