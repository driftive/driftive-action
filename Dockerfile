FROM ghcr.io/driftive/driftive:0.16.0 AS build
FROM public.ecr.aws/docker/library/alpine:3.21
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh

RUN apk add cosign git
RUN apk add tenv --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

ENTRYPOINT ["/entrypoint.sh"]
