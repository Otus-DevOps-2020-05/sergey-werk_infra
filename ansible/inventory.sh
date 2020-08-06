#!/usr/bin/env bash

DIR=$(dirname $(readlink -f $0))

# I'm too lazy to implement REST requests =)

# Toggle comment
#yc compute instance list --format json | $DIR/yc_hosts.py
$DIR/yc_hosts.py < yc.json
