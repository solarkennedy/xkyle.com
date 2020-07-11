---
title: "Securing Your Own Privately-Hosted Internal Web Services"
date: 2020-07-11T00:00:00-00:00
---

Like any self-respecting nerd, I have a colletion of internal web services running in my home network.

Even though these are not exposed to the internet, I think they still deserve encryption and authentication. Inspired by [this blog post](https://kamal.io/blog/securing-internal-services-behind-oauth2-with-caddy), I decided to do this for myself.

Here are were my requirements:

* Google auth
* Not on the internet
* Easy to remember domain names
* Encryption

## Installing Caddy

Note: At the time of this writing I used Caddy version 1, which is now replaced with v2.

Caddy v1 provides a convenient build server which will produce binaries on demand based on your desired plugins. This is a pretty cool idea. Here was my download:

    wget "https://caddyserver.com/download/linux/amd64?plugins=dyndns,http.jwt,http.login,tls.dns.cloudflare&license=personal&telemetry=off"

I knew I needed:

* http.jwt (for google auth)
* dyndns (for creating DNS records for me! in the future)
* tls.dns.cloudflare (to be able to respond to the ACME challenge on a non-internet facing web service)

## Caddy Config

First I had to setup an oauth key for my Caddy application. Here are the [official docs](https://support.google.com/cloud/answer/6158849?hl=en). The important setting is the "Authorized redirect URIs", which needs to be `https://auth.internal.xkyle.com/login/google`, as set in the next config:

Here is the configuration for enabling internal google auth:

```
(int-auth) {

    # Use cloudflare for ACME challenges. Note: Requires setting env variables!
    tls {
        dns cloudflare
    }

    # Sets the jwt token. 
    jwt {
        path /
        redirect https://auth.internal.xkyle.com/login?backTo=https%3A%2F%2F{host}{rewrite_uri_escaped}
        # List of allowed users
        allow sub kyle@xkyle.com
    }
}
```

Now I can include this in a domain definition and it will automatically be behind auth and encryption. Here is an examples for [syncthing](https://syncthing.net/)

```
syncthing.internal.xkyle.com {
    import int-auth
    proxy / localhost:8384
}
```

But what "is" `auth.internal.xkyle.com`? It is defined like this:
```
auth.internal.xkyle.com {
        tls {
          dns cloudflare
        } 
        root /var/www/html/
        redir 302 {
                if {path} is /
                / /login 
        }
        login {
                google client_id=GOOGLE_OAUTH_CLIENT_ID
                client_secret=GOOGLE_OAUTH_SECRET
                redirect_check_referer false
                redirect_host_file /etc/caddy/redirect_hosts.txt
                cookie_domain internal.xkyle.com
        }
}
```

`/etc/caddy/redirect_hosts.txt` is a file on disks which lets Caddy know which domains it is allowed to redirect to after logging in via google.

## Dealing with Cloudflare Domains

With the requirement of internal (non-internet-reachable) web services, the default ACME (lets-encrypt) challenges will fail. Instead, you can use an alternate method of proving that you control a domain: DNS.

To do this, Caddy must be allowed to create DNS records. This is not the most secure way to do this, as giving an application premission to edit DNS records is giving something complete control over your domain.

Caddy uses the go-acme library, which understands these [environment variables](https://go-acme.github.io/lego/dns/cloudflare/) for talking to Cloudflare. Here are the [docs](https://developers.cloudflare.com/api/tokens/create) on creating a token.

## Dealing with Websockets (gotify)

[gotify](https://gotify.net/) is a self-hosted push notifications service. It uses websockets to function properly. To use gotify behind Caddy you can do this:

```
gotify.internal.xkyle.com {
    proxy / localhost:81 {
        websocket
        transparent
    }
}
```

## Conclusion

Now I can add memorable, encrypted, authorized endpoints to any new internal webservice I want, with just 4 lines in my Caddyfile.
