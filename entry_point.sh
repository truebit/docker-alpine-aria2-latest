#! /bin/sh -eu

if [ "$UID" != "1000" ]; then
    echo "**** update uid to ${UID} ****"
    usermod -o -u "$UID" aria2
fi

if [ "$GID" != "1000" ]; then
    echo "**** update gid to ${GID} ****"
    groupmod -o -g "$GID" aria2
fi

chown -R ${UID}:${GID} \
        /app \
        /var/log

if [ "$1" = 'aria2c' -a "$(id -u)" = '0' ]; then
    shift
    if [ "$RPC_SECURE" = 'true' ]; then
        echo "enabling ssl on rpc connection"
        exec su-exec $UID:$GID aria2c --conf-path="/app/conf/aria2.conf" \
            --enable-rpc --rpc-listen-all \
            --rpc-certificate=/app/conf/key/aria2.cer \
            --rpc-private-key=/app/conf/key/aria2.key \
            --rpc-secret="$RPC_SECRET" --rpc-secure \
            "$@"
    else 
        echo "common rpc connection"
        exec su-exec $UID:$GID aria2c --conf-path="/app/conf/aria2.conf" \
            --enable-rpc --rpc-listen-all "$@"
    fi

fi

exec "$@"
