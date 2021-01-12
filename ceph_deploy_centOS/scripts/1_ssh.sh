#!/bin/bash

echo "[TASK 1]  ssh-keygen"

ssh-keygen

echo "[TASK 2]  ssh-config"

cat >>~/.ssh/config<<EOF
Host ceph-node-1
        Hostname ceph-node-1
        User root

Host ceph-node-2
        Hostname ceph-node-2
        User root

Host ceph-node-3
        Hostname ceph-node-3
        User root
EOF

chmod 600 ~/.ssh/config


echo "[TASK 3]  ssh-copy-id"
ssh-copy-id vagrant@ceph-node-1 
ssh-copy-id vagrant@ceph-node-2
ssh-copy-id vagrant@ceph-node-3
