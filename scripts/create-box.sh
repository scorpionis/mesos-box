#!/bin/bash
#set -x #echo on

#Create a mesos-box by vagrant up of an ubuntu trusty (14.04) base box (which installs jdk8 and mesos,marathon,chronos)
#Run this script in the same sub-directory as the Vagrantfile (create-base-box)

BOXNAME="mesos-box"
BOXPATH=$BOXNAME
BOXPATH+=".box"

#Make sure the base box is up to date
vagrant box update

#Vagrant up, invokes the Vagrantfile which causes software to be installed via a script
vagrant up

#cleanup if other runs have happened
rm $BOXPATH

#Package and add the box with the newly installed software.  This new box will be the base for the rest of the boxes in a mesos cluster
vagrant package --output $BOXPATH
vagrant box add --force $BOXNAME $BOXPATH

#Clean up so subsequent runs of Vagrant up will reinstall the software
vagrant destroy -f
