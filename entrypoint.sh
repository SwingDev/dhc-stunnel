#!/bin/bash
set -e

# Sanity checks
if [ -z "$STUNNEL_DEBUG" ]; then
  echo "STUNNEL_DEBUG env. variable needs to be set."
  exit 1
fi
if [ -z "$STUNNEL_SERVICE_NAME" ]; then
  echo "STUNNEL_SERVICE_NAME env. variable needs to be set."
  exit 1
fi

if [ -z "$STUNNEL_SERVICE_ACCEPT_PORT" ]; then
  echo "STUNNEL_SERVICE_ACCEPT_PORT env. variable needs to be set."
  exit 1
fi
if [ -z "$STUNNEL_SERVICE_CONNECT_HOST" ]; then
  echo "STUNNEL_SERVICE_CONNECT_HOST env. variable needs to be set."
  exit 1
fi
if [ -z "$STUNNEL_SERVICE_CONNECT_PORT" ]; then
  echo "STUNNEL_SERVICE_CONNECT_PORT env. variable needs to be set."
  exit 1
fi
if [ -z "$STUNNEL_SERVICE_VERIFY_LEVEL" ]; then
  echo "STUNNEL_SERVICE_VERIFY_LEVEL env. variable needs to be set."
  exit 1
fi

# Service configuration
STUNNEL_SERVICE_CONF=""
STUNNEL_SERVICE_CONF+="accept = ${STUNNEL_SERVICE_ACCEPT_PORT}"$'\n'
STUNNEL_SERVICE_CONF+="connect= ${STUNNEL_SERVICE_CONNECT_HOST}:${STUNNEL_SERVICE_CONNECT_PORT}"$'\n'
STUNNEL_SERVICE_CONF+="verify = ${STUNNEL_SERVICE_VERIFY_LEVEL}"$'\n'

if [ -z "$STUNNEL_SERVICE_CA_FILE" ];
then
  echo "[INFO] No CA file set."
else
  echo "[INFO] CA file set, including in the config."
  echo -e "${STUNNEL_SERVICE_CA_FILE}" > /etc/stunnel/server.pem
  export STUNNEL_SERVICE_CA_PATH=/etc/stunnel/server.pem
fi

if [ -z "$STUNNEL_SERVICE_CA_PATH" ];
then
  echo "[INFO] No CA path set, not including in the config."
else
  STUNNEL_SERVICE_CONF+="CAfile = ${STUNNEL_SERVICE_CA_PATH}"$'\n'
fi
export STUNNEL_SERVICE_CONF

cat /etc/stunnel/stunnel.conf.template | envsubst > /etc/stunnel/stunnel.conf

exec "$@"
