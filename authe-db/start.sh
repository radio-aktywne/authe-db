#!/bin/sh

cockroach start-single-node \
  --listen-addr "0.0.0.0:${AUTHE_DB_PORT:-22000}" \
  --http-addr "0.0.0.0:${AUTHE_DB_ADMIN_PORT:-22001}" \
  --insecure
