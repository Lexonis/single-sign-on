# Lexonis Single Sign-On Sample code #

Sample code to implement Single Sign-On (SSO) to a Lexonis QuickAssess (QA) site. 

## Overview ##

SSO is carried out by encrypting JSON-encoded user data using strong AES encryption and passing to a URL on the QA site. 

The JSON data looks like so:

    { 
        "uniqueid": "1234567",       
        "email": "jane.doe@example.com",
        "name": "Jane Doe",
        "expires": "2012-06-30T13:34:29.2228586Z"
    }

* `uniqueid` is used as the unique user identifier in QA; the user will be logged on as this user if it exists in QA, otherwise a new user account will be created.
* `email` will be used for a newly-created account, or to update an existing account if the user's email address changes.  
* `name` will be used for a newly-created account, or to update an existing account if the user's name changes.
* `expires` should be a UTC ISO-8601 formatted date that is a few minutes into the future. Expired dates will be rejected. It is therefore essential that your server clocks are kept in sync using something like [NTP](http://en.wikipedia.org/wiki/Network_Time_Protocol).

Other values (or "claims") may be passed in the JSON if they have been agreed upon with your Lexonis representative.

The JSON is then encoded to a UTF-8 byte-array and encrypted using [AES](http://en.wikipedia.org/wiki/Advanced_Encryption_Standard) using a pre-shared key (which your Lexonis representative will supply). This token is then [Base64](http://en.wikipedia.org/wiki/Base64) encoded and passed to the Lexonis site. The data can be passed directly in the URL as a GET request using HTTP 302 redirect (`Response.Redirect` in ASP.NET), or hyperlink for the user to click. For example:

    http://lexonis-site.example.com/account/sso?token=0vVpI3g%2fH...

When the JSON data is larger (you are passing more custom data) then it's recommended you POST the token data in an HTML `<form>`. For example:

    <form method="post" action="http://lexonis-site.example.com/account/sso">
        <input type="hidden" name="token" value="0vVpI3g/H...">
        <input type="submit" value="Continue">
    </form>

See the examples (ASP.NET and PHP currently) for more information.

## Other implementations ##

The process described above is similar to that used by a number of other SSO implementations known as **Multipass**, for example:

* https://github.com/entp/multipass
* https://github.com/ideascale/multipass
* https://github.com/assistly/multipass-examples

The main difference is that the AES Initialization Vector (IV) is intialized to a cryptographically-secure value and transmitted as part of the authentication token.
