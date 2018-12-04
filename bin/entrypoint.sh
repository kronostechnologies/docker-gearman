#!/usr/bin/env bash

function graceful {
  kill -USR1 `pidof gearmand`
}

function finish {
  kill -KILL `pidof gearmand`
}

trap graceful SIGTERM
trap finish SIGKILL

PARAMS="--job-retries=1 --log-file=none --round-robin"

if [ ! -z $GEARMAN_PORT ]; then
  PARAMS="$PARAMS --port=$GEARMAN_PORT"
fi

if [ ! -z $MEMCACHE_HOST ]; then
  PARAMS="$PARAMS --queue-type=libmemcached --libmemcached-servers=$MEMCACHE_HOST"
fi

if [ ! -z $MYSQL_HOST ]; then
  PARAMS="$PARAMS --queue-type=mysql --mysql-host=$MYSQL_HOST --mysql-user=$MYSQL_USER --mysql-password=$MYSQL_PASSWORD --mysql-db=$MYSQL_DB"
fi

echo "Starting gearman job server with params: $PARAMS"

exec gearmand $PARAMS
