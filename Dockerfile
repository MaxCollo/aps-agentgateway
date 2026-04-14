FROM cr.agentgateway.dev/agentgateway:v1.1.0 AS upstream

FROM frolvlad/alpine-glibc:alpine-3.21
RUN apk add --no-cache ca-certificates wget libgcc
COPY --from=upstream /app/agentgateway /app/agentgateway
COPY --chmod=755 entrypoint.sh /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:15000/healthz || exit 1

USER 1000
ENTRYPOINT ["/entrypoint.sh"]
