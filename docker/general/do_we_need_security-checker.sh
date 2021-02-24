#!/bin/bash -x

if [ "$ENV" == "dev" ] || [ "$ENV" == "test" ]; then
    curl -s https://api.github.com/repos/fabpot/local-php-security-checker/releases/latest | \
    grep -E "browser_download_url(.+)linux_amd64" | \
    cut -d : -f 2,3 | \
    tr -d \" | \
    xargs -I{} wget -O local-php-security-checker {} \
    && mv local-php-security-checker /usr/bin/local-php-security-checker \
    && chmod +x /usr/bin/local-php-security-checker
fi
