#!/usr/bin/env bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /workdir/tmp/pids/server.pid

exec "$@"
