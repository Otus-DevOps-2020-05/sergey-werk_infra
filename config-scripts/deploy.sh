#!/usr/bin/env bash

cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
