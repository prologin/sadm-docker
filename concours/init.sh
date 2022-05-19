#! /bin/sh

set -e

PATHS_TO_CHOWN="/concours/shared /concours/concours_static /concours/config"

CONCOURS_CONFIG_PATH="/concours/config/concours.yml"

# Fix gunicorn logging
export PYTHONUNBUFFERED=TRUE

# fix django statics
export CONCOURS_STATIC_ROOT=/concours/concours_static

export DB_HOST=${DB_HOST?Please set DB_HOST}
export DB_PORT=${DB_PORT:-5432}
export DB_USER=${DB_USER?Please set DB_USER}
export DB_NAME=${DB_NAME?Please set DB_NAME}
export DB_PASSWORD=${DB_PASSWORD?Please set DB_PASSWORD}

export MASTER_URL=${MASTER_URL?Please set MASTER_URL}
export MASTER_SHARED_SECRET=${MASTER_SHARED_SECRET?Please set MASTER_SHARED_SECRET}
export CONCOURS_GAME=${CONCOURS_GAME?Please set CONCOURS_GAME}
export CONCOURS_NB_PLAYERS=${CONCOURS_NB_PLAYERS:-2}
export CONCOURS_USE_MAPS=${CONCOURS_USE_MAPS:-true}
export CONCOURS_MAP_VALIDATOR_SCRIPT=${CONCOURS_MAP_VALIDATOR_SCRIPT?Please set CONCOURS_MAP_VALIDATOR_SCRIPT}
export CONCOURS_FIGHT_ONLY_OWN_CHAMPIONS=${CONCOURS_FIGHT_ONLY_OWN_CHAMPIONS?Please set CONCOURS_FIGHT_ONLY_OWN_CHAMPIONS}

export CONCOURS_DEBUG=${CONCOURS_DEBUG?Please set CONCOURS_DEBUG}
export CONCOURS_SECRET_KEY=${CONCOURS_SECRET_KEY?Please set CONCOURS_SECRET_KEY}

export CONCOURS_STATIC_PATH=${CONCOURS_STATIC_PATH?Please set CONCOURS_STATIC_PATH}
export CONCOURS_ENABLE_REPLAY=${CONCOURS_ENABLE_REPLAY?Please set CONCOURS_ENABLE_REPLAY}

export CONCOURS_ENABLE_OIDC=${CONCOURS_ENABLE_OIDC?Please set CONCOURS_ENABLE_OIDC}
export CONCOURS_OIDC_CLIENT_ID=${CONCOURS_OIDC_CLIENT_ID?Please set CONCOURS_OIDC_CLIENT_ID}
export CONCOURS_OIDC_CLIENT_SECRET=${CONCOURS_OIDC_CLIENT_SECRET?Please set CONCOURS_OIDC_CLIENT_SECRET}

export REDMINE_ISSUE_LIST_URL=${REDMINE_ISSUE_LIST_URL?Please set REDMINE_ISSUE_LIST_URL}
export REDMINE_ISSUE_NEW_URL=${REDMINE_ISSUE_NEW_URL?Please set REDMINE_ISSUE_NEW_URL}

export GUNICORN_NB_WORKERS=${GUNICORN_NB_WORKERS:-4}

tmp_config=$(mktemp concoursXXXX)

envsubst < "$CONCOURS_CONFIG_PATH" > "$tmp_config"
mv "$tmp_config" "$CONCOURS_CONFIG_PATH"

./venv/bin/python /concours/concours/manage.py migrate --noinput
./venv/bin/python /concours/concours/manage.py collectstatic --noinput

./venv/bin/gunicorn \
    -w "${GUNICORN_NB_WORKERS}" \
    -b "0.0.0.0:8000" \
    --error-logfile "-" \
    --access-logfile "-" \
    prologin.concours.wsgi
