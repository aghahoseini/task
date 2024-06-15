#!/bin/bash

CMD="/usr/local/bin/docker-entrypoint.sh mysqld"

if test -n "$GALERA_NEW_CLUSTER" -a -f /tmp/.wsrep-new-cluster; then
  CMD="$CMD --wsrep-new-cluster"
fi




rm -f /tmp/.wsrep-new-cluster



if [ -z "${GALERA_NEW_CLUSTER}" ]
then
	sleep 15
fi


exec $CMD

