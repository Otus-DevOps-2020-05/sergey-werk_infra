#!/usr/bin/env bash
set -e

wget -qO - "https://www.mongodb.org/static/pgp/server-4.2.asc" | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" >  "/etc/apt/sources.list.d/mongodb-org-4.2.list"
apt-get update
apt-get install -y apt-transport-https ca-certificates || true  # Fix for apt via https
apt-get install -y mongodb-org
systemctl start mongod && systemctl enable mongod || true # Ignore if failed to start
