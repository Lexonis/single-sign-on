# Lexonis Single Sign-On Sample code #

Sample code to implement Single Sign-On (SSO) to a Lexonis QuickAssess (QA) site. 

## Overview ##

SSO is carried out by encrypting JSON-encoded user data using strong AES encryption and passing to a URL on the QA site. 

The JSON data looks like so:

    { 
        "email": "jane.doe@example.com",
        "name": "Jane Doe",
        "expires": "2012-06-30T13:34:29.2228586Z"
    }

* `email` is used as the unique user identifier in QA; the user will be logged on as this user if it exists in QA, otherwise a new user account will be created. 
* `name` will be used for a newly-created account, or to update an existing account if the user's name changes.
* `expires` should be a UTC ISO-8601 formatted date that is a few minutes into the future. Expired dates will be rejected. It is therefore essential that your server clocks are kept in sync using something like [NTP](http://en.wikipedia.org/wiki/Network_Time_Protocol).

Other values (or "claims") may be passed in the JSON if they have been agreed upon with your Lexonis representative.

The JSON is then encoded to a UTF-8 byte-array and encrypted using [AES](http://en.wikipedia.org/wiki/Advanced_Encryption_Standard) using a pre-shared key (which your Lexonis representative will supply). This token is then [Base64](http://en.wikipedia.org/wiki/Base64) encoded and passed to the QA site URL-encoded, for example:

    http://lexonis-site.example.com/account/sso?token=0vVpI3g%2fH%2flT05buNegaj4BRTEUAYUifRvn3O2b15qKZSCWBjRWqsKSzc%2fd6o%2bVJ3qOssVyZxLGyZUVI20PZMrABFEmk7O8axnimCEZdH5Ti7dLRs%2bdxCY5U9YRRZtyn%2bwgGEXkXmofaJuNTGN7rIA%3d%3d

This URL is typically sent to the user's browser as an HTTP 302 redirect (`Response.Redirect` in ASP.NET), but could just as easily be embedded in a hyperlink for the user to click.

## Other implementations ##

The process described above is similar to that used by a number of other SSO implementations known as **Multipass**, for example:

* https://github.com/entp/multipass
* https://github.com/ideascale/multipass
* https://github.com/assistly/multipass-examples

The main difference is that the AES Initialization Vector (IV) is intialized to a cryptographically-secure value and transmitted as part of the authentication token.
