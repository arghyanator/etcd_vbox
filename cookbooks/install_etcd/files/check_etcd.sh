#!/bin/bash
while [ "$(etcdctl cluster-health |tail -1)" != "cluster is healthy" ]
do
echo "cluster not healthy yet...sleeping 5 seconds and trying again"
sleep 5
done
echo "cluster setup done...change cluster to existing"
sed -i 's/^ETCD_INITIAL_CLUSTER_STATE="new"/ETCD_INITIAL_CLUSTER_STATE="existing"/g' /etc/default/etcd
/bin/systemctl restart etcd.service