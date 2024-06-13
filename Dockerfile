FROM driftive/driftive:0.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]