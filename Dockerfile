FROM ghcr.io/driftive/driftive:0.23.0 AS build
FROM ghcr.io/tofuutils/tenv:4.9.1
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh

RUN apk add cosign git

ENTRYPOINT ["/entrypoint.sh"]
