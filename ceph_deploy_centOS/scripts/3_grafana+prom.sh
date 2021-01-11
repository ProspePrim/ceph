#!/bin/bash

mkdir ~/grafana_prom
cd ~/grafana_prom

echo "[TASK 1] Installing prometheus"

sudo wget https://github.com/prometheus/prometheus/releases/download/v2.8.1/prometheus-2.8.1.linux-amd64.tar.gz

###

echo "[TASK 2] Add a Prometheus user"

sudo useradd --no-create-home --shell /bin/false prometheus

###

echo "[TASK 3] Create /etc/prometheus and /var/lib/prometheus directories"

sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

echo "[TASK 14] Change the owner of the above directories"

sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

###

echo "[TASK 4] Now go to Prometheus downloaded location and extract it"

sudo tar -xvzf prometheus-2.8.1.linux-amd64.tar.gz

###

echo " [TASK 5] Rename it as per your preference"

sudo mv prometheus-2.8.1.linux-amd64 prometheuspackage

###

echo "[TASK 6] Copy “prometheus” and “promtool” binary from the “prometheuspackage” folder to “/usr/local/bin”"

sudo cp prometheuspackage/prometheus /usr/local/bin/
sudo cp prometheuspackage/promtool /usr/local/bin/

###

echo "[TASK 7] Change the ownership to Prometheus user"

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

###


echo "[TASK 8] Change the ownership to Prometheus user"

sudo cp -r prometheuspackage/consoles /etc/prometheus
sudo cp -r prometheuspackage/console_libraries /etc/prometheus

###

echo "[TASK 9] Create the prometheus.yml file"

touch /etc/prometheus/prometheus.yml

cat >>/etc/prometheus/prometheus.yml<<EOF
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'ceph'
    static_configs:
      - targets: ['localhost:9283']
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

###

echo "[TASK 10] Change the ownership of the file"

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

###

echo "[TASK 11] Configure the Prometheus Service File"

cat >>/etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

###

echo "[TASK 12] Reload the systemd service"

sudo systemctl daemon-reload

###

echo "[TASK 13] Start the Prometheus service"

sudo systemctl start prometheus

###

echo "[TASK 14]  Check service status"

systemctl status prometheus

###

echo "[TASK 15] Check service status"

systemctl status prometheus

###

echo "[TASK 16] Installing grafana"

cat >>/etc/yum.repos.d/grafana.repo<<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

sudo yum install grafana -y

sudo yum install fontconfig -y
sudo yum install freetype* -y
sudo yum install urw-fonts -y

echo "[TASK 17] Start service"

sudo systemctl start grafana-server

sudo systemctl enable grafana-server.service

###

echo "[TASK 18] Mgr enable dashboard"

sudo ceph mgr module enable dashboard --force

###

echo "[TASK 19] Mgr enable Prometheus"

sudo ceph mgr module enable prometheus --force

###

echo "[TASK 20] Edit the ceph.conf"

cat >>~/ceph-deploy/ceph.conf<<EOF

[mon]
        mgr initial modules = dashboard
EOF

###

echo "[TASK 35] Check Mgr Services"

sudo ceph mgr services



