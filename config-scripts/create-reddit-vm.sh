#!/usr/bin/env bash

# Using the last image in reddit-full family
LATEST_IMAGE_INFO=`yc compute images get-latest-from-family reddit-full`

IMAGE_ID=$(grep ^id: <<< "$LATEST_IMAGE_INFO" | cut -d: -f2- | xargs)
IMAGE_FOLDER_ID=$(grep ^folder_id: <<< "$LATEST_IMAGE_INFO" | cut -d: -f2- | xargs)

ret=$(yc compute instance create \
    --name reddit-full-`date +%s` \
    --zone ru-central1-a \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --preemptible \
    --create-boot-disk type=network-ssd,size=4,image-id=${IMAGE_ID},image-folder-id=${IMAGE_FOLDER_ID},auto-delete=true \
    --memory 4 \
    --cores 2 \
    --core-fraction 5 \
    --async \
    --ssh-key ~/.ssh/otus.pub
) && echo OK || echo Failed

test $? -eq 0 && yc operation wait $(grep ^id: <<< "$ret" | cut -d: -f2 | xargs) # =)

#TODO: interrupt creation on Ctrl+C
