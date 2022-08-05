FROM caddy:2.5.2-builder-alpine AS builder


ARG date="1970-01-01T00:00:00Z"
ARG license="Apache-2"
ARG rev="4b825dc642cb6eb9a060e54bf8d69288fbee4904"
ARG src="localhost"
ARG title="Caddy: caddy with the azure dns plugin."
ARG url="https://caddyserver.com/"

# TODO: should probably pin the caddy plugins.
RUN xcaddy build \
    --with github.com/caddy-dns/azure

FROM caddy:2.5.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
