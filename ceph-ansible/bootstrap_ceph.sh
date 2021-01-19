#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.16.3.21 ceph-node-1
172.16.3.22 ceph-node-2
172.16.3.23 ceph-node-3
EOF

echo "[TASK 2]  Synchronize by chrony"

yum install chrony

cat >>/etc/chrony.conf<<EOF
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
EOF

systemctl start chronyd

systemctl enable chronyd

echo "[TASK 3]  Check"

timedatectl set-local-rtc 0

