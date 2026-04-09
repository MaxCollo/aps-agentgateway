FROM cr.agentgateway.dev/agentgateway:v1.0.1

COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh
USER 1000

ENTRYPOINT ["/entrypoint.sh"]
