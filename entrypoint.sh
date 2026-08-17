#!/bin/sh
set -e

# Replace literal ${BRAVE_API_KEY} in the copied settings file with the runtime env value.
if [ -n "${BRAVE_API_KEY:-}" ]; then
  escaped=$(printf '%s' "$BRAVE_API_KEY" | sed 's/[\/&]/\\&/g')
  sed -i "s|\${BRAVE_API_KEY}|$escaped|g" /etc/searxng/settings.yml
fi

exec /usr/local/searxng/entrypoint.sh "$@"
