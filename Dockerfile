FROM driftive/driftive:0.2 as build
FROM alpine:3.12
COPY --from=build /usr/local/bin/driftive /usr/local/bin/driftive
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]