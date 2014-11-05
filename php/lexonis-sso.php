<?php
    //////////////////////////////////////////////////////////
    // TODO: update URL and Key to your own
    $sso_url = 'http://site.example.com/account/sso';
    $sso_key = '0123456789abcdef0123456789abcdef';

    $user_data = array(
        // TODO: add your own user info here
        'email' => 'jane.doe@example.com',
        'name' => 'Jane Doe',
        'expires' => date("c", strtotime("+5 minutes"))
    );
    //////////////////////////////////////////////////////////
    
    if (!function_exists('hex2bin')) {
        function hex2bin($str) {
            $sbin = "";
            for ($i = 0; $i < strlen($str); $i += 2) {
                $sbin .= pack("H*", substr($str, $i, 2));
            }
            return $sbin;
        }
    }

    function pkcs5_pad ($text, $blocksize) { 
        $pad = $blocksize - (strlen($text) % $blocksize); 
        return $text . str_repeat(chr($pad), $pad); 
    }

    $json = json_encode($user_data);
    
    $iv = mcrypt_create_iv(16);
    $sso_key = hex2bin($sso_key);
    $cipher = mcrypt_module_open(MCRYPT_RIJNDAEL_128,'','cbc','');
    mcrypt_generic_init($cipher, $sso_key, $iv);
    $token = $iv . mcrypt_generic($cipher, pkcs5_pad($json, 16));
    mcrypt_generic_deinit($cipher);
    
    $token = base64_encode( $token );
?>
<html>
    <body>
        <form id="ssoform" method="post" action="<?php echo htmlspecialchars($sso_url) ?>">
            <input type="hidden" name="token" value="<?php echo htmlspecialchars($token) ?>">
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
