# searxng

This compose setup builds a custom `searxng` image because the upstream SearxNG image does not support reading the Brave API key from an environment variable in `settings.yml`.

## Why this custom image exists

SearxNG config files can include `${BRAVE_API_KEY}` as a placeholder, but the container does not automatically substitute that placeholder from the runtime environment.

To solve this, the custom image:

- copies `./core-config/settings.yml` into `/etc/searxng/`
- adds a wrapper entrypoint script
- replaces `${BRAVE_API_KEY}` inside `/etc/searxng/settings.yml` with the actual `BRAVE_API_KEY` value from the container environment
- then starts the original SearxNG entrypoint

This enables using an environment variable for the Brave API key while still keeping the config file in version control.
