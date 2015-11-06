# mesos-box
Configure a mesos cluster using Vagrant and VirtualBox

RUN FIRST!!!
bash create-base-box/scripts/create-box.sh

This creates a base VirtualBox VM that contains Java8 installed on Ubuntu Trusty (14.04)
The base VirtualBox (mesos-box) needs to be created once, after that you don't really need to run this again.

To launch a Mesos cluster, 
cd {install dir}
Vagrant up

The cluster.json file describes the cluster configuration (number of masters and content, number of workers and content)

Once the cluster is started, you can browse to the following sites:

Mesos master: http://172.31.0.10:5050
Marathon http://172.31.0.10:8080/
Chronos http://172.31.0.10:4400/
