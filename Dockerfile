FROM driftive/driftive:0.3.0 as build
FROM alpine:3.20
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh

RUN apk add cosign git
RUN apk add tenv --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

ENTRYPOINT ["/entrypoint.sh"]
