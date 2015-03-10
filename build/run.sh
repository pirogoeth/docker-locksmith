#!/bin/bash

# This is a simple script that ensures the presence of environment variables
# and starts the django server.  Later on, this will become something more,
# that will probably start locksmith behind uwsgi for serving with nginx.
# But again, that's later.

export APP_DIR="/app"

export ADMIN_FULLNAME=${ADMIN_FULLNAME:-"Some Admin"}
export ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@example.org"}
export ADMIN_USERNAME=${ADMIN_USERNAME:-"admin"}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-`pwgen -s 16`}

export BIND_HOST=${BIND_HOST:-"0.0.0.0"}
export BIND_PORT=${BIND_PORT:-3000}

export DB_PATH=${DB_PATH:-"/app/locksmith.db"}

export LANG=${LANG:-"en_US.UTF-8"}
export LC_ALL=${LC_ALL:-"en_US.UTF-8"}

export PRIVATE=${PRIVATE:-"YES"}

export REDIS_ENABLE=${REDIS_ENABLE:-"NO"}
export REDIS_HOST=${REDIS_PORT_6379_TCP_ADDR:-""}
export REDIS_PORT=${REDIS_PORT_6379_TCP_PORT:-""}
export REDIS_DB=${REDIS_DB:-0}
export REDIS_PASSWORD=${REDIS_PASSWORD:-""}

export SENTRY_DSN=${SENTRY_DSN:-""}

export TIMEZONE=${TIMEZONE:-"America/Chicago"}

export __APP_SECRET=`pwgen -s 92`

cd ${APP_DIR} && source bin/activate

if [[ ! -e ${DB_PATH} ]] ; then
    echo " [+] Creating new database at ${DB_PATH}..."
    python ./manage.py syncdb --noinput
    python ./manage.py migrate
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('${ADMIN_USERNAME}', '${ADMIN_EMAIL}', '${ADMIN_PASSWORD}')" | python ./manage.py shell
else
    echo " [+] Using existing database at ${DB_PATH}."
fi

if [[ "${REDIS_ENABLE}" == "YES" ]] ; then
    echo " [+] Locksmith has been linked to a Redis backend at ${REDIS_HOST}:${REDIS_PORT}."
fi

echo " [+] Launching Locksmith, should be available momentarily.."
echo " [+]   Admin Username: ${ADMIN_USERNAME}"
echo " [+]   Admin Password: ${ADMIN_PASSWORD}"
echo " [+] Listening on ${BIND_HOST}:${BIND_PORT}."

python ./manage.py runserver ${BIND_HOST}:${BIND_PORT}
