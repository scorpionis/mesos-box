#!/usr/bin/env bash

#use apt-get to load mesos, marathon and chronos software onto the box
#follows https://open.mesosphere.com/getting-started/datacenter/install/

# Setup
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list
apt-get -y update

#install Java8
#TODO - check if Mesosphere ever gets the Java8 headless dependency loaded into their packages
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get -y install openjdk-8-jdk
update-alternatives --config java
update-alternatives --config javac

#install mesos marathon chronos
apt-get -y install mesos marathon chronos curl

#install golang
apt-get -y install golang

#install docker
wget -qO- https://get.docker.com/ | sh
