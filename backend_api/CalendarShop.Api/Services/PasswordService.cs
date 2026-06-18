using System.Security.Cryptography;
using System.Text;

namespace CalendarShop.Api.Services;

public class PasswordService
{
    // Demo only. In production, use BCrypt or ASP.NET Identity PasswordHasher.
    public string Hash(string password)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(password));
        return Convert.ToHexString(bytes);
    }

    public bool Verify(string password, string passwordHash)
    {
        return string.Equals(Hash(password), passwordHash, StringComparison.OrdinalIgnoreCase);
    }
}
