#!/usr/bin/env bash

# Install MondoDB
wget -qO -- "https://www.mongodb.org/static/pgp/server-4.2.asc" | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee "/etc/apt/sources.list.d/mongodb-org-4.2.list"
sudo apt update && apt install -y mongodb-org
sudo systemctl start mongod && sudo systemctl enable mongod

# Install ruby
sudo apt update && apt install -y ruby-full ruby-bundler build-essential

# Deploy
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

# Run Dev Version
sudo cat <<EOT >>/etc/systemd/system/reddit.service
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

sudo systemctl start reddit.service && sudo systemctl enable reddit.service
