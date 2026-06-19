using System.Diagnostics;
using System.Text;
using System.Text.RegularExpressions;

namespace CalendarShop.Api.Middlewares
{
    public class RequestLoggingMiddleware
    {
        private const int MaxLoggedBodyLength = 400;

        private readonly RequestDelegate _next;
        private readonly ILogger<RequestLoggingMiddleware> _logger;

        public RequestLoggingMiddleware(
            RequestDelegate next,
            ILogger<RequestLoggingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var stopwatch = Stopwatch.StartNew();
            var request = context.Request;
            var requestId = context.TraceIdentifier;
            var pathWithQuery = $"{request.Path}{request.QueryString}";

            string requestBodyText = string.Empty;
            if (request.ContentLength > 0 &&
                request.ContentType != null &&
                request.ContentType.Contains("application/json", StringComparison.OrdinalIgnoreCase))
            {
                request.EnableBuffering();

                using var reader = new StreamReader(request.Body, Encoding.UTF8, leaveOpen: true);
                requestBodyText = await reader.ReadToEndAsync();
                request.Body.Position = 0;
            }

            var maskedBody = TrimBody(MaskSensitiveJson(requestBodyText));
            _logger.LogInformation(
                "[{RequestId}] --> {Method} {Path}{Body}",
                requestId,
                request.Method,
                pathWithQuery,
                string.IsNullOrEmpty(maskedBody) ? string.Empty : $" | Body: {maskedBody}");

            try
            {
                await _next(context);
                stopwatch.Stop();

                var response = context.Response;
                if (response.StatusCode >= 400)
                {
                    _logger.LogWarning(
                        "[{RequestId}] <-- {StatusCode} {Method} {Path} ({ElapsedMilliseconds}ms)",
                        requestId,
                        response.StatusCode,
                        request.Method,
                        pathWithQuery,
                        stopwatch.ElapsedMilliseconds);
                }
                else
                {
                    _logger.LogInformation(
                        "[{RequestId}] <-- {StatusCode} {Method} {Path} ({ElapsedMilliseconds}ms)",
                        requestId,
                        response.StatusCode,
                        request.Method,
                        pathWithQuery,
                        stopwatch.ElapsedMilliseconds);
                }
            }
            catch (Exception ex)
            {
                stopwatch.Stop();
                _logger.LogError(
                    ex,
                    "[{RequestId}] !! {Method} {Path} failed after {ElapsedMilliseconds}ms",
                    requestId,
                    request.Method,
                    pathWithQuery,
                    stopwatch.ElapsedMilliseconds);
                throw;
            }
        }

        private string MaskSensitiveJson(string json)
        {
            if (string.IsNullOrEmpty(json))
            {
                return json;
            }

            var pattern = @"(""(?:password|oldpassword|newpassword)"".*?:\s*"")(.*?)("")";
            return Regex.Replace(json, pattern, "$1***$3", RegexOptions.IgnoreCase);
        }

        private static string TrimBody(string body)
        {
            if (string.IsNullOrEmpty(body) || body.Length <= MaxLoggedBodyLength)
            {
                return body;
            }

            return $"{body[..MaxLoggedBodyLength]}...";
        }
    }
}
