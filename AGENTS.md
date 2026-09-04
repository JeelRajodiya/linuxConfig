# Repository Purpose

This repository is the source of truth for a reproducible development environment.

# Configuration Changes

When asked to add or change configuration, treat this repository as the source of truth: add or update the configuration here first, then run `bash bin/sync.sh` to sync it with the global settings. Do not edit global configuration directly when it can be managed here.

Keep configuration in this repository unless it contains secrets. Never commit secrets. When possible, separate secrets from the non-sensitive configuration, track the non-sensitive files here, and store the secret files outside the repository or exclude them with `.gitignore`.
