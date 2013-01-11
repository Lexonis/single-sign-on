<%@ Page Language="C#" %>
<%@ Import Namespace="System.Security.Cryptography" %>

<script runat="server">
    // TODO: update URL and Key to your own
    const string SSO_URL = "http://site.example.com/account/sso?token={0}";
    const string SSO_KEY = "0123456789abcdef0123456789abcdef";

    protected void Page_Load(object sender, EventArgs e)
    {
        // TODO: add your own user info here
        ssoLogon("jane.doe@example.com", "Jane Doe");
    }

    void ssoLogon(string email, string name)
    {
        // Create a JSON token like so:
        // {
        //    "email": "jane.doe@example.com",
        //    "name": "Jane Doe",
        //    "expires": "2012-06-30T13:34:29.2228586Z"
        // }
        //
        // Tip: consider using something like Newtonsoft.Json

        string json = "{"
                        + "\"email\":\"" + email + "\""
                        + ",\"name\":\"" + name + "\""
                        + ",\"expires\":\"" + DateTime.UtcNow.AddMinutes(5).ToString("o") + "\""
                    + "}";

        string token = encrypt(SSO_KEY, json);

        Response.Redirect(string.Format(SSO_URL, HttpUtility.UrlEncode(token)));
    }
    
    static string encrypt(string keyHex, string data)
    {
        // Rijndael is AES
        using (SymmetricAlgorithm aes = Rijndael.Create())
        {
            aes.Key = hexToBytes(keyHex);
            using (ICryptoTransform encryptor = aes.CreateEncryptor())
            {
                // Encrypt
                byte[] bytes = Encoding.UTF8.GetBytes(data);
                byte[] encryptedBytes = encryptor.TransformFinalBlock(bytes, 0, bytes.Length);

                // Concatenate IV + encryptedBytes
                byte[] ivAndEncBytes = new byte[aes.IV.Length + encryptedBytes.Length];
                aes.IV.CopyTo(ivAndEncBytes, 0);
                encryptedBytes.CopyTo(ivAndEncBytes, aes.IV.Length);

                // Return as Base-64 string
                return Convert.ToBase64String(ivAndEncBytes);
            }
        }
    }

    static byte[] hexToBytes(String hex)
    {
        byte[] bytes = new byte[hex.Length / 2];
        for (int i = 0; i < hex.Length; i += 2)
            bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
        return bytes;
    }
</script>
