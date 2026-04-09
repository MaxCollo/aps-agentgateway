#!/bin/sh
set -e

CONFIG_PATH="/tmp/config.yaml"

if [ -n "$GATEWAY_CONFIG" ]; then
  echo "$GATEWAY_CONFIG" > "$CONFIG_PATH"
else
  LISTEN_PORT="${PORT:-8080}"

  cat > "$CONFIG_PATH" <<EOF
listeners:
  - name: main
    protocol: MCP
    sse:
      address: "0.0.0.0:${LISTEN_PORT}"
    routes: []

admin:
  address: "0.0.0.0:15000"
  healthRoute: true

EOF

  if [ -n "$GATEWAY_TRACING_ENDPOINT" ]; then
    cat >> "$CONFIG_PATH" <<EOF
tracing:
  endpoint: "${GATEWAY_TRACING_ENDPOINT}"

EOF
  fi

  if [ -n "$GATEWAY_JWT_ISSUER" ] && [ -n "$GATEWAY_JWT_AUDIENCE" ] && [ -n "$GATEWAY_JWT_JWKS_URL" ]; then
    cat >> "$CONFIG_PATH" <<EOF
authentication:
  jwtAuth:
    issuer: "${GATEWAY_JWT_ISSUER}"
    audience: "${GATEWAY_JWT_AUDIENCE}"
    jwksUrl: "${GATEWAY_JWT_JWKS_URL}"

EOF
  fi
fi

exec /agentgateway --file "$CONFIG_PATH"
