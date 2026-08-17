# 2026.7.9-8456831a0
FROM searxng/searxng@sha256:a7b2b16eb4d79c2f0f6cff84fab9c41137e4e6dd29a1f64e2d785d27acb5a2e0

# Copy the custom settings file into the container
COPY ./core-config/settings.yml /etc/searxng/settings.yml

# Wrap the original entrypoint to run our custom entrypoint first
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
