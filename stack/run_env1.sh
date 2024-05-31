#!/bin/bash -eu
export MYSQL_SERVICE_NAME=ali
export MYSQL_PORT=3306
export MYSQL_USER=root
export MYSQL_USER_PASS=abcd6789
export MYSQL_DB=testdb

envsubst < docker-compose.template | docker compose  -f - $@