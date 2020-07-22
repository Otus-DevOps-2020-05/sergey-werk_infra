#!/usr/bin/env bash

AS_USER=appuser
# Deploy the Reddit app
useradd -m ${AS_USER} || true  # if not exist for some reason
sudo -u ${AS_USER} --login git clone -b monolith https://github.com/express42/reddit.git
cd /home/${AS_USER}/reddit/ && bundle install  # as a root even though it argues
