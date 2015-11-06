#!/bin/bash
#set -x #echo on

echo configure-zookeeper...
#$1 expected to be a unique int starting at 1 (unique for all the zookeeper nodes in the cluster
#$2 expected to be a comma separated list of ip addresses (in zookeeper id order)

#follows https://open.mesosphere.com/getting-started/datacenter/install/
#Assumes mesos already installed!!!
#TDOD - independent install of zookeeper
#sudo apt-get update
#Set /etc/zookeeper/conf/myid
echo $1 | tee /etc/zookeeper/conf/myid

#Set /etc/zookeeper/conf/zoo.cfg to the list of ip addresses
#    server.1=1.1.1.1:2888:3888
#    server.2=2.2.2.2:2888:3888
#    server.3=3.3.3.3:2888:3888

IFS=","
zk_ips=($2)

for i in "${!zk_ips[@]}"
do
  j=$((i + 1))
  echo "server."$j"=""${zk_ips[$i]}"":2888:3888" | tee -a /etc/zookeeper/conf/zoo.cfg
done

#Restart Zookeeper
rm -rf /var/lib/zookeeper/*
rm -rf /tmp/zookeeper/*
service zookeeper restart
