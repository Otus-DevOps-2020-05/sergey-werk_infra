#!/usr/bin/env bash

su appuser
cd ~

# Install MondoDB
wget -qO - "https://www.mongodb.org/static/pgp/server-4.2.asc" | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee "/etc/apt/sources.list.d/mongodb-org-4.2.list"
sudo apt-get update && sudo apt-get install -y mongodb-org
sudo systemctl start mongod && sudo systemctl enable mongod

# Install ruby
sudo apt-get update && sudo apt-get install -y ruby-full ruby-bundler build-essential

# Deploy
sudo apt-get install -y git
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

# Install and run the Dev. version
sudo tee <<EOT >>/etc/systemd/system/reddit.service
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

sudo systemctl daemon-reload
sudo systemctl start reddit.service && sudo systemctl enable reddit.service
