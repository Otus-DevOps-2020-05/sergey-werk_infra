#!/usr/bin/env bash
echo "Ansible Linter"
cd ansible/playbooks && ansible-lint
