FROM ghcr.io/driftive/driftive:0.8.3 as build
FROM public.ecr.aws/docker/library/alpine:3.20
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh

RUN apk add cosign git
RUN apk add tenv --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

ENTRYPOINT ["/entrypoint.sh"]
