<%@ Page Language="C#" %>

<%
    //////////////////////////////////////////////////////////
    // TODO: update URL and Key to your own
    var ssoUrl = "http://site.example.com/account/sso";
    var ssoKey = "0123456789abcdef0123456789abcdef";

    var userData = new Dictionary<string, string>
    { 
        // TODO: add your own user info here
        { "email", "jane.doe@example.com" },
        { "name", "Jane Doe"},
        { "expires", DateTime.UtcNow.AddMinutes(5).ToString("o") },
    };
    //////////////////////////////////////////////////////////

    string token;
    using (var aes = System.Security.Cryptography.Rijndael.Create())
    {
        aes.Key = hexToBin(ssoKey);

        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        var json = serializer.Serialize(userData);

        var bytes = Encoding.UTF8.GetBytes(json);
        byte[] encryptedBytes;
        using (var encryptor = aes.CreateEncryptor())
            encryptedBytes = encryptor.TransformFinalBlock(bytes, 0, bytes.Length);

        var tokenBytes = aes.IV.Concat(encryptedBytes).ToArray();

        token = Convert.ToBase64String(tokenBytes);
    }    
%>
<script runat="server">
    static byte[] hexToBin(string hex)
    {
        byte[] bytes = new byte[hex.Length / 2];
        for (int i = 0; i < hex.Length; i += 2)
            bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
        return bytes;
    }
</script>
<html>
<body>
    <form id="ssoform" method="post" action="<%: ssoUrl %>">
        <input type="hidden" name="token" value="<%: token %>">
        <!-- In case script fails/not enabled, give them something to click -->
        <input type="submit" value="Continue">
    </form>
    <script>
        // Auto-submit form
        (function () {
            var form = document.getElementById('ssoform');
            form.style.display = 'none';
            form.submit();
        })();
    </script>
</body>
</html>