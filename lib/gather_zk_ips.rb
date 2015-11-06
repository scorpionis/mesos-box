# -*- mode: ruby -*-
# vi: set ft=ruby :

def gather_zk_ips(cluster)
  zk_ips = ''
  cluster['masters'].each_with_index do |master, i|
    if master['run'].include? 'zookeeper'
      if zk_ips != ''
         zk_ips = zk_ips + ","
      end
      zk_ips = zk_ips + cluster['master_ipbase']+"#{10+i}"
    end
  end
  return zk_ips
end