#!/usr/bin/env bash

function graceful {
  kill -USR1 `pidof gearmand`
}

function finish {
  kill -KILL `pidof gearmand`
}

trap graceful SIGTERM
trap finish SIGKILL

declare PARAMS

for variable in "${!GEARMAN_@}"; do
  option="${variable#GEARMAN_}"
  option="${option/_/-}"
  if [ "${!variable}" == "true" ]; then
    PARAMS="$PARAMS --${option,,}"
  elif [ "${!variable}" != "false" ]; then
    PARAMS="$PARAMS --${option,,}=${!variable}"
  fi
done

echo "Starting gearman job server with params: $PARAMS"

exec gearmand $PARAMS
