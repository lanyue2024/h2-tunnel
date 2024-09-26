#!/bin/bash

host="$1"
key="$2"


if [[ "$host" = "" ]] || [[ "$key" = "" ]]; then
    echo "usage: $0 <host> <key>"
    exit 1
fi


if [[ ! -f "ca.crt" ]]; then
    openssl ecparam -out ca.key -name prime256v1 -genkey
    openssl req -new -sha256 -key ca.key -out ca.csr -subj "/CN=ca"
    openssl x509 -req -sha256 -days 3650 -in ca.csr -signkey ca.key -out ca.crt
fi

openssl ecparam -out server.crt.key -name prime256v1 -genkey
openssl req -new -sha256 -key server.crt.key -out server.csr -subj "/CN=${host}"
openssl x509 -req -in server.csr -CA  ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -sha256
cp server.crt* /etc/haproxy

cp h2-tunnel.cfg /etc/haproxy/haproxy.cfg
sed -i "s/HOST/${host}/" /etc/haproxy/haproxy.cfg
sed -i "s/KEY/${key}/" /etc/haproxy/haproxy.cfg


