#!/usr/bin/env bash
set -ev

echo "Ansible Linter"
cd ansible/playbooks
for file in *.yml; do
	ansible-lint $file --exclude=roles/jdauphant.nginx && echo $file - ok
done
