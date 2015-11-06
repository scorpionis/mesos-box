#!/bin/bash
#set -x #echo on

#stop all the services on the node, configuration of the required services will cause them to restart
service mesos-slave stop
service mesos-master stop
service marathon stop
service chronos stop
service zookeeper stop