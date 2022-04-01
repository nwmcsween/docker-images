FROM debian:stable-20220125-slim

ARG service_uid
ARG service_uid=${service_uid:-39311}
ARG service_gid
ARG service_gid=${service_gid:-$service_uid}
ARG data_uid=${data_uid:-19011}
ARG data_gid=${data_gid:-19311}
ARG rport_version
ARG rport_version=${rport_version:-0.6.0}
ARG rport_frontend_version
ARG rport_frontend_version=${rport_frontend_version:-0.6.0-build-966}
ARG novnc_version
ARG novnc_version=${no_nvnc_version:-1.3.0}

ARG TARGETARCH
ARG TARGETVARIANT

ENV RPORT_CFG_API_ACCESS_LOG_FILE=/proc/self/fd/1
ENV RPORT_CFG_API_ADDR=0.0.0.0:3000
ENV RPORT_CFG_API_AUTH_GROUP_TABLE=groups
ENV RPORT_CFG_API_AUTH_USER_TABLE=users
ENV RPORT_CFG_API_DOC_ROOT=/var/www
ENV RPORT_CFG_AUTH_TABLE=clients_auth
ENV RPORT_CFG_AUTH_TABLE=clients_auth
ENV RPORT_CFG_DB_NAME=/var/lib/rport/database.db
ENV RPORT_CFG_DB_TYPE=sqlite
ENV RPORT_CFG_LOG_FILE=/proc/self/fd/1
# htpasswd -nbB password "rport123" | cut -d: -f2
ENV RPORT_ADMIN_PASSWORDHASH='$2y$05$EJqUCUy3C7pF5azwbUBxrelRD30DSWgM3zW3nXRY2lr9D2W8SjNyq'

COPY etc /etc
COPY bin /bin
COPY --chown=$service_uid:$service_gid var/lib/rport /var/lib/rport

VOLUME ["/var/lib/rport"]

# Dependencies  according to: https://get.rport.io/.
RUN set -eu; \
    apt update && \
    apt install -y --auto-remove sqlite3 netcat-openbsd wget unzip && \
    rm -rf /var/lib/apt/lists/*

RUN set -e; \
    VARIANT=$TARGETVARIANT && \
    case "$TARGETARCH${VARIANT:+/$VARIANT}" in \
    "amd64")  ARCH=x86_64 ;; \
    "arm64")  ARCH=aarch64 ;; \
    "arm/v7") ARCH=armv7l ;; \
    "arm/v6") ARCH=armv6l ;; \
    esac && \
    echo "Building for OS: $(uname -s), with ARCH: ${ARCH}, VARIANT: ${VARIANT}" && \
    wget -qO- "https://github.com/cloudradar-monitoring/rport/releases/download/${rport_version}/rportd_${rport_version}_$(uname -s)_${ARCH}.tar.gz" | tar xvz -C /bin && \
    rm /bin/rportd.example.conf

RUN set -e; \
    groupadd -g $service_gid service && \
    useradd -m -l -d /var/lib/rport -s /sbin/nologin -u $service_uid -g $service_gid service && \
    groupadd -g $data_gid data && \
    useradd -m -l -d /var/www -s /sbin/nologin -u $data_uid -g $data_gid data

USER data:data

RUN set -e; \
    cd ~ && \
    wget -qO frontend.zip https://downloads.rport.io/frontend/stable/rport-frontend-stable-${rport_frontend_version}.zip && \
    unzip frontend.zip && rm -rf frontend.zip

USER service:service

RUN set -e; \
    cd ~ && \
    sqlite3 database.db < database.sql

RUN set -e; \
    cd ~ && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v${novnc_version}.tar.gz | tar zxf - && \
    mv noVNC-${novnc_version} noVNC

ENTRYPOINT ["/bin/init"]

EXPOSE 8080
EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=5s \
    CMD wget --spider -S http://localhost:3000 2>&1 > /dev/null | grep -q "200"
