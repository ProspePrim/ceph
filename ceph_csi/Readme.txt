1. Install helm (k8s cluster)
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh

2. Create pool in ceph cluster (ceph cluster)
    ceph osd pool create kube 128
    ceph osd pool application enable kube rbd

3. Add repo to helm and inspect cephrbd.yml (k8s cluster)
    helm repo add ceph-csi https://ceph.github.io/csi-charts
    helm inspect values ceph-csi/ceph-csi-rbd > cephrbd.yml

4. info (ceph cluster)
    ceph fsid
    ceph mon dump

5. Correct cephrbd.yml. Only these lines (k8s cluster)
    csiConfig:
  - clusterID: "bcd0d202-fba8-4352-b25d-75c89258d5ab"
    monitors:
      - "v2:xxx.xx.x.x:3300/0,v1:xxx.xx.x.x:6789/0"
      - "v2:xxx.xx.x.x:3300/0,v1:xxx.xx.x.x:6789/0"
      - "v2:xxx.xx.x.x:3300/0,v1:xxx.xx.x.x:6789/0"

    nodeplugin:
      podSecurityPolicy:
        enabled: true

    provisioner:
      podSecurityPolicy:
        enabled: true

6. Install the chart in the Kubernetes cluster (k8s cluster)
    helm upgrade -i ceph-csi-rbd ceph-csi/ceph-csi-rbd -f cephrbd.yml -n ceph-csi-rbd --create-namespace

7. Create a new user in Ceph and grant him write rights to the kube pool (ceph cluster)
    ceph auth get-or-create client.rbdkube mon 'profile rbd' osd 'profile rbd pool=kube'
    ceph auth get-key client.rbdkube

8. Correct secret.yaml, storageclass.yaml and install (k8s cluster)
    vi secret.yaml
    vi storageclass.yaml
    kubectl apply -f secret.yaml
    kubectl apply -f storageclass.yaml
