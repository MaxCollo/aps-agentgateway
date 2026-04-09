# AgentGateway Wrapper

Wraps the upstream [agentgateway](https://agentgateway.dev) Docker image for deployment through Central Station.

## How it works

Central Station builds this Dockerfile and deploys it as a standard web app. The entrypoint script generates the gateway config from environment variables.

## Configuration

**Option A** — Full config via `GATEWAY_CONFIG` env var (takes precedence):

Set `GATEWAY_CONFIG` to the complete YAML configuration. The entrypoint writes it to `/tmp/config.yaml` and starts the gateway.

**Option B** — Individual env vars (used when `GATEWAY_CONFIG` is empty):

| Variable | Description |
|---|---|
| `PORT` | Listen port (default: 8080, set by CS) |
| `GATEWAY_TRACING_ENDPOINT` | OpenTelemetry tracing endpoint |
| `GATEWAY_JWT_ISSUER` | JWT issuer for authentication |
| `GATEWAY_JWT_AUDIENCE` | JWT audience for authentication |
| `GATEWAY_JWT_JWKS_URL` | JWKS URL for JWT validation |

The default config starts with no MCP routes. The APS API updates routes dynamically.
