#! /bin/sh

set -e

CONFIG_PATH="/concours/config/masternode.yml"

export MASTERNODE_PORT=${MASTERNODE_PORT:-8067}
export MASTERNODE_SHARED_SECRET=${MASTERNODE_SHARED_SECRET?Please set shared secret}

export WORKER_TIMEOUT_SECS=${WORKER_TIMEOUT_SECS:-12}
export WORKER_COMPILATION_TIMEOUT_SECS=${WORKER_COMPILATION_TIMEOUT_SECS:-20}
export WORKER_MATCH_TIMEOUT_SECS=${WORKER_MATCH_TIMEOUT_SECS:-450}
export WORKER_MAX_TASK_TRIES=${WORKER_MAX_TASK_TRIES:-10}

export DB_HOST=${DB_HOST?Please set DB_HOST}
export DB_PORT=${DB_PORT:-5432}
export DB_USER=${DB_USER?Please set DB_USER}
export DB_PASSWORD=${DB_PASSWORD?Please set DB_PASSWORD}
export DB_NAME=${DB_NAME?Please set DB_NAME}

export CONTEST_GAME=${CONTEST_GAME?Please set CONTEST_GAME}
export CONTEST_DIRECTORY=${CONTEST_DIRECTORY:-/concours/shared}

tmp_file=$(mktemp /tmp/masternodeXXXX)

envsubst < "$CONFIG_PATH" > "$tmp_file"
mv "$tmp_file" "$CONFIG_PATH"

if [ "$MASTERNODE_DEBUG" -eq 1 ]; then
  exec python -m prologin.masternode -v
else
  exec python -m prologin.masternode 
fi
