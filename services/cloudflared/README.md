# cloudflared

[dns-over-https](https://developers.cloudflare.com/1.1.1.1/dns-over-https/cloudflared-proxy)

    sudo docker-compose up --detached

Afterwards use the IP address of your NAS as your primary DNS and add
`1.1.1.1` and `1.0.0.1` as fallbacks in case your NAS is unreachable.
