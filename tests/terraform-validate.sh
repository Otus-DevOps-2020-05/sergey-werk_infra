#!/usr/bin/env bash

TFENVS="stage prod"
TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR:-`pwd`}

echo "Validate terraform environments:" $TFENVS
for tfenv in $TFENVS; do
    cd "${TRAVIS_BUILD_DIR}/terraform/$tfenv"
    terraform init && terraform validate && echo $tfenv - ok
    tflint
done
