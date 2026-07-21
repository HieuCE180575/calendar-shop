using System.Globalization;
using System.Net;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Http;

namespace CalendarShop.Api.Infrastructure;

public class VNPayLibrary
{
    private readonly SortedList<string, string> _requestData = new(new VnPayCompare());
    private readonly SortedList<string, string> _responseData = new(new VnPayCompare());

    public void AddRequestData(string key, string value)
    {
        if (!string.IsNullOrEmpty(value))
        {
            _requestData.Add(key, value);
        }
    }

    public void AddResponseData(string key, string value)
    {
        if (!string.IsNullOrEmpty(value))
        {
            _responseData.Add(key, value);
        }
    }

    public string GetResponseData(string key)
    {
        return _responseData.TryGetValue(key, out var retValue) ? retValue : string.Empty;
    }

    public string RawQueryString { get; private set; } = string.Empty;
    public string SecureHash { get; private set; } = string.Empty;
    public SortedList<string, string> GetRequestDataMap() => _requestData;

    public string CreateRequestUrl(string baseUrl, string vnp_HashSecret)
    {
        var data = new StringBuilder();
        foreach (var (key, value) in _requestData)
        {
            if (!string.IsNullOrEmpty(value))
            {
                data.Append(WebUtility.UrlEncode(key) + "=" + WebUtility.UrlEncode(value) + "&");
            }
        }

        var querystring = data.ToString();
        baseUrl += "?" + querystring;
        var signData = querystring;
        if (signData.Length > 0)
        {
            signData = signData.Remove(data.Length - 1, 1);
        }

        RawQueryString = signData;
        var vnp_SecureHash = HmacSHA512(vnp_HashSecret, signData);
        SecureHash = vnp_SecureHash;
        baseUrl += "vnp_SecureHash=" + vnp_SecureHash;

        return baseUrl;
    }

    public bool ValidateSignature(string inputHash, string secretKey)
    {
        var rspRaw = GetResponseData();
        var myChecksum = HmacSHA512(secretKey, rspRaw);
        return myChecksum.Equals(inputHash, StringComparison.InvariantCultureIgnoreCase);
    }

    private string GetResponseData()
    {
        var data = new StringBuilder();
        if (_responseData.ContainsKey("vnp_SecureHashType"))
        {
            _responseData.Remove("vnp_SecureHashType");
        }

        if (_responseData.ContainsKey("vnp_SecureHash"))
        {
            _responseData.Remove("vnp_SecureHash");
        }

        foreach (var (key, value) in _responseData)
        {
            if (!string.IsNullOrEmpty(value))
            {
                data.Append(WebUtility.UrlEncode(key) + "=" + WebUtility.UrlEncode(value) + "&");
            }
        }

        if (data.Length > 0)
        {
            data.Remove(data.Length - 1, 1);
        }

        return data.ToString();
    }

    public static string GetIpAddress(HttpContext context)
    {
        var ipAddress = string.Empty;
        try
        {
            var remoteIpAddress = context.Connection.RemoteIpAddress;

            if (remoteIpAddress != null)
            {
                if (remoteIpAddress.AddressFamily == AddressFamily.InterNetworkV6)
                {
                    remoteIpAddress = Dns.GetHostEntry(remoteIpAddress).AddressList
                        .FirstOrDefault(x => x.AddressFamily == AddressFamily.InterNetwork);
                }

                if (remoteIpAddress != null) ipAddress = remoteIpAddress.ToString();

                return ipAddress;
            }
        }
        catch (Exception)
        {
            return "127.0.0.1";
        }

        return "127.0.0.1";
    }

    private static string HmacSHA512(string key, string inputData)
    {
        var hash = new StringBuilder();
        var keyBytes = Encoding.UTF8.GetBytes(key);
        var inputBytes = Encoding.UTF8.GetBytes(inputData);
        using (var hmac = new HMACSHA512(keyBytes))
        {
            var hashValue = hmac.ComputeHash(inputBytes);
            foreach (var theByte in hashValue)
            {
                hash.Append(theByte.ToString("x2"));
            }
        }

        return hash.ToString();
    }
}

public class VnPayCompare : IComparer<string>
{
    public int Compare(string? x, string? y)
    {
        if (x == y) return 0;
        if (x == null) return -1;
        if (y == null) return 1;
        var vnpCompare = CompareInfo.GetCompareInfo("en-US");
        return vnpCompare.Compare(x, y, CompareOptions.Ordinal);
    }
}
