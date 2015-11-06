#!/bin/bash
#set -x #echo on

echo configure-master...
#$1 expected to be the quorum size for the master cluster
#$2 expected to be a comma separated list of ip addresses (in zookeeper id order)
#$3 is the ip address to set for /etc/mesos-master/ip and /etc/mesos-master/hostname
#$4 is the cluster name

#follows https://open.mesosphere.com/getting-started/datacenter/install/
#apt-get update
#apt-get -y install mesos

#Set /etc/mesos/zk to:
#     zk://1.1.1.1:2181,2.2.2.2:2181,3.3.3.3:2181/mesos
zk_str="zk://"

IFS=","
zk_ips=($2)

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

echo $zk_str | tee /etc/mesos/zk

# Set /etc/mesos-master/quorum on each master node to a number greater than the number of masters divided by 2.
echo $1 | tee /etc/mesos-master/quorum

# Set /etc/mesos-master/ip and /etc/mesos-master/hostname
echo $3 | tee /etc/mesos-master/ip
echo $3 | tee /etc/mesos-master/hostname
echo $3 | tee /etc/mesos-master/advertise_ip

echo "5050" | tee /etc/mesos-master/advertise_port

echo "/tmp/mesosphere" | tee /etc/mesos-master/work_dir

echo $4 | tee /etc/mesos-master/cluster

# Disable mesos-slave service
# sudo sh -c "echo manual > /etc/init/mesos-slave.override"
sudo service mesos-slave stop
echo manual | tee /etc/init/mesos-slave.override

#restart the mesos-master service
sudo service mesos-master restart
