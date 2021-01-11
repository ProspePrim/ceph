#!/bin/bash

echo "[TASK 1]  Add update the package sources"
sudo rpm --import 'https://download.ceph.com/keys/release.asc'

###

echo "[TASK 2]  Add update the package sources"

cat >>/etc/yum.repos.d/ceph.repo<<EOF
[ceph]
name=Ceph packages for $basearch
baseurl=https://download.ceph.com/rpm-nautilus/el7/$basearch
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-nautilus/el7//noarch
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=https://download.ceph.com/rpm-nautilus/el7/SRPMS
enabled=0
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc
EOF
###

echo "[TASK 3]  Create dir ceph-deploy"

mkdir ~/ceph-deploy

cd ~/ceph-deploy

###

echo "[TASK 4]  Install Ceph-Deploy"

sudo yum install ceph-deploy

###

echo "[TASK 5] Start to create the cluster"

ceph-deploy new ceph-node-1 ceph-node-2 ceph-node-3 -y

###

echo "[TASK 6] Install Ceph packages"

ceph-deploy install --release nautilus ceph-node-1 ceph-node-2 ceph-node-3

###

echo "[TASK 7] Deploy the initial monitor(s) and gather the keys"

ceph-deploy mon create-initial

###

echo "[TASK 8] Copy the configuration file and admin key to your admin node and your Ceph Nodes"

ceph-deploy admin ceph-node-1 ceph-node-2 ceph-node-3

###

echo "[TASK 9] Deploy a manager daemon"

ceph-deploy mgr create ceph-node-1

###

echo "[TASK 10] create metadata servers"

ceph-deploy mds create ceph-node-1 ceph-node-2 ceph-node-3

###

echo "[TASK 11] Create Object Store Daemons (OSDs)"

ceph-deploy osd create --data /dev/sdb ceph-node-1
ceph-deploy osd create --data /dev/sdb ceph-node-2
ceph-deploy osd create --data /dev/sdb ceph-node-3

echo "[TASK 12] Check status"

ceph -s