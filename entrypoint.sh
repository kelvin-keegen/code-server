#!/usr/bin/env sh
set -e

# exec code-server --bind-addr 0.0.0.0:8080 . \
#   ${PROXY_DOMAIN:+--proxy-domain "${PROXY_DOMAIN}"}

exec code-server --bind-addr 0.0.0.0:9000 --auth none .
