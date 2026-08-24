#!/bin/sh
set -e

log() {
  echo "[entrypoint] $*"
}

# Set default paths for configuration and data if not provided
# These variables override the default ones set in base searxng image
__SEARXNG_DATA_PATH="${SEARXNG_DATA_PATH:-/var/cache/searxng}"
__SEARXNG_CONFIG_PATH="${SEARXNG_CONFIG_PATH:-/etc/searxng}"
__SEARXNG_SETTINGS_PATH="$__SEARXNG_CONFIG_PATH/settings.yml"

# Ensure settings file exists and is writable
log "__SEARXNG_CONFIG_PATH: ${__SEARXNG_CONFIG_PATH}"
log "__SEARXNG_SETTINGS_PATH: ${__SEARXNG_SETTINGS_PATH}"
DEFAULT_SETTINGS_PATH='/etc/searxng/settings.yml'
log "Default settings file: ${DEFAULT_SETTINGS_PATH}"
if [ "$__SEARXNG_SETTINGS_PATH" != "$DEFAULT_SETTINGS_PATH" ]; then
  log "Target settings file differs from default. Copying ${DEFAULT_SETTINGS_PATH} to ${__SEARXNG_SETTINGS_PATH}..."
  mkdir -p "$(dirname "$__SEARXNG_SETTINGS_PATH")"
  cp "$DEFAULT_SETTINGS_PATH" "$__SEARXNG_SETTINGS_PATH"
  log 'Settings file copied successfully.'
else
  log "Using default settings file: ${DEFAULT_SETTINGS_PATH}"
fi

# Replace the placeholder in the settings file with the actual BRAVE_API_KEY value
if [ -n "${BRAVE_API_KEY:-}" ]; then
  log 'BRAVE_API_KEY is set; replacing placeholder in settings file...'
  escaped=$(printf '%s' "$BRAVE_API_KEY" | sed 's/[\/&]/\\&/g')
  sed -i "s|\${BRAVE_API_KEY}|$escaped|g" "$__SEARXNG_SETTINGS_PATH"
  log 'Placeholder replacement complete.'
else
  log 'BRAVE_API_KEY is not set; skipping placeholder replacement.'
fi

# Ensure the data path exists and has the correct permissions
log "__SEARXNG_DATA_PATH: ${__SEARXNG_DATA_PATH}"
if [ -e "$__SEARXNG_DATA_PATH" ]; then
  log 'Data path already exists; leaving it untouched.'
else
  log 'Data path does not exist; creating...'
  mkdir -p "$__SEARXNG_DATA_PATH"
  log 'Data path created.'
fi

log 'Handing off to original SearXNG entrypoint...'
exec /usr/local/searxng/entrypoint.sh "$@"
