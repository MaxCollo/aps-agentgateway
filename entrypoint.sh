#!/bin/sh
set -e

# Agentgateway v1.1.0 config format
CONFIG_PATH="/tmp/config.yaml"

if [ -n "$GATEWAY_CONFIG" ]; then
  echo "$GATEWAY_CONFIG" > "$CONFIG_PATH"
else
  LISTEN_PORT="${PORT:-8080}"

  # Build config section
  CONFIG_BLOCK="config:
  adminAddr: 0.0.0.0:15000"

  if [ -n "$GATEWAY_TRACING_ENDPOINT" ]; then
    CONFIG_BLOCK="${CONFIG_BLOCK}
  tracing:
    otlpEndpoint: ${GATEWAY_TRACING_ENDPOINT}"
  fi

  # Build binds section (v1.1.0 format)
  cat > "$CONFIG_PATH" <<EOF
${CONFIG_BLOCK}
binds:
- port: ${LISTEN_PORT}
  listeners:
  - name: mcp-listener
    routes: []
EOF
fi

exec /app/agentgateway --file "$CONFIG_PATH"
