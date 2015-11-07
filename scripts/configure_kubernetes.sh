#Set /etc/mesos/zk to:
#     zk://1.1.1.1:2181,2.2.2.2:2181,3.3.3.3:2181/mesos
zk_str="zk://"

IFS=","
zk_ips=($1)

num_ips=${#zk_ips[@]}

unset IFS
for i in "${!zk_ips[@]}"
do
    zk_str=$zk_str"${zk_ips[$i]}"":2181"
    if (($i < $num_ips-1)); then
        zk_str+=,
    fi
done
zk_str=$zk_str"/mesos"

#download pre-builed binaries
[[ ! -d "/opt/kubernetes" ]] && sudo git clone https://github.com/scorpionis/ubuntu-kubernetes-mesos.git /opt/kubernetes

#env
a=$(hostname -i)
IFS=" "
array=($a)
delete=("127.0.1.1")
result=${array[@]/$delete}
echo $result
export KUBERNETES_MASTER_IP=$result
export KUBERNETES_MASTER=http://${KUBERNETES_MASTER_IP}:8888

#set up etcd service
sudo docker rm -f etcd
sudo docker run -d --hostname $(uname -n) --name etcd \
              -p 4001:4001 -p 7001:7001 quay.io/coreos/etcd:v2.0.12 \
              --listen-client-urls http://0.0.0.0:4001 \
              --advertise-client-urls http://${KUBERNETES_MASTER_IP}:4001
sleep 10s

export PATH="/opt/kubernetes/_output/local/go/bin:$PATH"
export MESOS_MASTER=$zk_str

# create mesos-cloud.conf
cat <<EOF >mesos-cloud.conf
[mesos-cloud]
        mesos-master        = ${MESOS_MASTER}
EOF

km apiserver \
  --address=${KUBERNETES_MASTER_IP} \
  --etcd-servers=http://${KUBERNETES_MASTER_IP}:4001 \
  --service-cluster-ip-range=10.10.10.0/24 \
  --port=8888 \
  --cloud-provider=mesos \
  --cloud-config=mesos-cloud.conf \
  --v=1 >apiserver.log 2>&1 &
sleep 10s
km controller-manager \
  --master=${KUBERNETES_MASTER_IP}:8888 \
  --cloud-provider=mesos \
  --cloud-config=./mesos-cloud.conf  \
  --v=1 >controller.log 2>&1 &
sleep 10s
km scheduler \
  --address=${KUBERNETES_MASTER_IP} \
  --mesos-master=${MESOS_MASTER} \
  --etcd-servers=http://${KUBERNETES_MASTER_IP}:4001 \
  --mesos-user=root \
  --api-servers=${KUBERNETES_MASTER_IP}:8888 \
  --cluster-dns=10.10.10.10 \
  --cluster-domain=cluster.local \
  --v=2 >scheduler.log 2>&1 &
disown -a
