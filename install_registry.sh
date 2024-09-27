#!/bin/bash

# install registry

IP=$(hostname -I | awk '{print $2}')

echo "START - install registry - "$IP

echo "[1]: install docker"
apt-get update -qq >/dev/null
apt-get install -qq -y vim git wget curl >/dev/null


apt  install docker.io  # curl -fsSL https://get.docker.com | sh >/dev/null


curl -sL "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "[2]: install registry"
mkdir -p certs/ passwd/ data/
openssl req -x509 -newkey rsa:4096 -nodes -keyout certs/myregistry.key -out certs/myregistry.crt -days 365 -subj "/CN=myregistry.my"
docker run --entrypoint htpasswd httpd:2 -Bbn monja password > passwd/htpasswd

echo "
version: '3.5'
services:
    registry:
        restart: always
        image: registry:2
        container_name: registry
        ports:
            - 5000:5000
        environment:
            REGISTRY_HTTP_TLS_CERTIFICATE: /certs/myregistry.crt
            REGISTRY_HTTP_TLS_KEY: /certs/myregistry.key
            REGISTRY_AUTH: htpasswd
            REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
            REGISTRY_AUTH_HTPASSWD_REALM: Registry realm
        volumes:
            - ./data:/var/lib/registry
            - ./certs:/certs
            - ./passwd:/auth
" > docker-compose-registry.yml

docker-compose -f docker-compose-registry.yml up -d

echo "END - install registry"


#TEST
#docker login https://192.168.56.5:5000
