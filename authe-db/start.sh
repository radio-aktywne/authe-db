#!/bin/sh

envsub() {
  eval "cat <<EOF
$(cat "$1")
EOF
" 2>/dev/null
}

find ./init -type f | while IFS= read -r file; do
  # shellcheck disable=SC2005
  echo "$(envsub "$file")" >"$file"
done

until [ -f /etc/certs/ca.crt ] &&
  [ -f /etc/certs/node.crt ] &&
  [ -f /etc/certs/node.key ] &&
  [ -f /etc/certs/ui.crt ] &&
  [ -f /etc/certs/ui.key ] &&
  [ -f /etc/certs/client.root.crt ] &&
  [ -f /etc/certs/client.root.key ]; do
  echo "Waiting for certificates..."
  sleep 1
done

cat /etc/certs/ca.crt >>/etc/ssl/certs/ca-certificates.crt

cockroach start-single-node \
  --listen-addr="0.0.0.0:${AUTHE_DB_PORT:-22000}" \
  --advertise-addr=authe-db \
  --http-addr="0.0.0.0:${AUTHE_DB_ADMIN_PORT:-22001}" \
  --certs-dir=/etc/certs &

pid=$!

until cockroach sql --certs-dir=/etc/certs --port="${AUTHE_DB_PORT:-22000}" --execute ''; do
  echo "Waiting for cockroach to be ready..."
  sleep 1
done

for sql in ./init/*.sql; do
  cockroach sql --certs-dir=/etc/certs --port="${AUTHE_DB_PORT:-22000}" --file="$sql"
done

wait $pid
