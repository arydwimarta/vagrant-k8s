# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
 
  config.vm.provision "shell", path: "k8s-default.sh"

  # Kubernetes Master Server
  config.vm.define "ku20-master" do |kmaster|
    kmaster.vm.box = "ubuntu/focal64"
    kmaster.vm.hostname = "ku20-master.mine.labs"
    kmaster.vm.network "private_network", ip: "172.42.42.100"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "ku20-master"
      v.memory = 4024
      v.cpus = 2
    end
    kmaster.vm.provision "shell", path: "k8s-master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "ku20-worker#{i}" do |workernode|
      workernode.vm.box = "ubuntu/bionic64"
      workernode.vm.hostname = "ku20-worker#{i}.mine.labs"
      workernode.vm.network "private_network", ip: "172.42.42.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "ku20-worker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "k8s-worker.sh"
    end
  end

end
