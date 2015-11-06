#!/bin/bash
#set -x #echo on

echo configure-worker...
#$1 expected to be an array of resources
#$2 expected to be an array of attributes for the worker node
#$3 expected to be a comma separated list of ip addresses (in zookeeper id order)
#$4 node ip

#follows https://open.mesosphere.com/getting-started/datacenter/install/
#apt-get update
#apt-get -y install mesos curl

# Disable zookeeper service
# sudo sh -c "echo manual > /etc/init/zookeeper.override"
sudo service zookeeper stop
echo manual | tee /etc/init/zookeeper.override

# Disable mesos-master service
# sudo sh -c "echo manual > /etc/init/mesos-master.override"
sudo sudo service mesos-master stop
echo manual | tee /etc/init/mesos-master.override

#Disable marahon service
sudo service marathon stop
echo manual > /etc/init/marathon.override

#Disable chronos service
sudo service chronos stop
echo manual > /etc/init/chronos.override

echo $1 | tee /etc/mesos-slave/resources

echo $2 | tee /etc/mesos-slave/attributes

#Set /etc/mesos/zk to:
#     zk://1.1.1.1:2181,2.2.2.2:2181,3.3.3.3:2181/mesos
zk_str="zk://"

IFS=","
zk_ips=($3)

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
#echo $zk_str | tee /etc/mesos-slave/master

#set node ip in /etc/mesos-slave/hostname
echo $4 | tee /etc/mesos-slave/ip
echo $5 | tee /etc/mesos-slave/hostname

#excutor_registration_timeout
echo "50mins" | tee /etc/mesos-slave/executor_registration_timeout

#restart the mesos-slave service
mkdir /var/lib/hdfs
useradd hadoop
#useradd hadoop sudo
chown -R hadoop /var/lib/hdfs
rm -rf /tmp/mesos/*
sudo service mesos-slave restart

