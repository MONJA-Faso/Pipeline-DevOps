#!/bin/bash

# install server postgres

IP=$(hostname -I | awk '{print $2}')

echo "START - install postgres - "$IP

echo "[1]: install postgres"
apt-get update -qq >/dev/null
apt-get install -qq -y vim git wget curl >/dev/null
apt-get install -qq -y postgresql >/dev/null

# Créer l'utilisateur et les bases de données avec l'utilisateur postgres
sudo -u postgres bash -c "psql -c \"CREATE USER vagrant WITH PASSWORD 'vagrant';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE dev OWNER vagrant;\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE stage OWNER vagrant;\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE prod OWNER vagrant;\""

# Modifier les configurations pour autoriser les connexions externes
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf
sed -i "s/127.0.0.1\/32/0.0.0.0\/0/" /etc/postgresql/*/main/pg_hba.conf

# Redémarrer le service PostgreSQL
service postgresql restart

echo "END - install postgres"
