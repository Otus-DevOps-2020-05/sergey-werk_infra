#!/usr/bin/env bash

# Install MondoDB
wget -qO - "https://www.mongodb.org/static/pgp/server-4.2.asc" | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee "/etc/apt/sources.list.d/mongodb-org-4.2.list"
apt-get update && apt-get install -y mongodb-org
systemctl start mongod && systemctl enable mongod

# Install ruby
apt-get update && apt-get install -y ruby-full ruby-bundler build-essential


# Deploy
apt-get install -y git

# Install as service
tee <<EOT >>/etc/systemd/system/reddit.service
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/home/appuser/reddit
# Environment=PUMA_DEBUG=1
ExecStart=/usr/local/bin/puma config.ru
Restart=always

[Install]
WantedBy=multi-user.target
EOT

useradd -m appuser  # if not exist for some reason
# su appuser # <-- not working in cloud-init!
wget -qO - -- https://raw.githubusercontent.com/Otus-DevOps-2020-05/sergey-werk_infra/cloud-testapp/deploy.sh \
	| sudo -u appuser --login  bash

# start
systemctl daemon-reload
sudo systemctl start reddit.service && sudo systemctl enable reddit.service
