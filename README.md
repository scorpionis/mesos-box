# mesos-box
Configure a mesos cluster using Vagrant and VirtualBox

```
Vagrant up
```

The cluster.json file describes the cluster configuration (number of masters and content, number of workers and content)

Once the cluster is started, you can browse to the following sites:

Mesos master: http://172.31.0.10:5050
Marathon http://172.31.0.10:8080/
Chronos http://172.31.0.10:4400/
