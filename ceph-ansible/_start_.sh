#!/bin/sh

d=$(date '+%Y.%m.%d_%H:%M')
ANSIBLE_LOG_PATH="./deploy-$d.log"
export ANSIBLE_LOG_PATH

ansible-playbook -u root -k -i inventory/hosts site.yml -b --diff