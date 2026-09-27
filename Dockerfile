FROM python:3.11-slim

ARG CACHEBUST=20260927-v3

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    tini \
  && rm -rf \var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth 1 https://github.com/NousResearch/hermes-agent.git

RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir \
    hermes-agent \
    python-dotenv \
    ruamel.yaml \
    "python-telegram-bot[webhooks]>=20.0" \
    aiohttp \
    requests

ENV PYTHONUNBUFFERED=1 \
  HERMES_HOME=/data/.hermes \
  HOME=/data

WORKDIR /app
COPY scripts/entrypoint.sh /app/scripts/entrypoint.sh
RUN chmod +x /app/scripts/entrypoint.sh

ENTRYPOINT ["tini", "--"]
CMD ["/app/scripts/entrypoint.sh"]
