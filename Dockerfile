FROM ghcr.io/driftive/driftive:0.26.0 AS build
FROM alpine:3.23
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash cosign curl git \
    && curl https://mise.run | sh

ENV MISE_YES=1
ENV PATH="/root/.local/bin:${PATH}"

ENTRYPOINT ["/entrypoint.sh"]
