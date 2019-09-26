# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
 
  config.vm.provision "shell", path: "k8s-default.sh"

  # Kubernetes Master Server
  config.vm.define "ku-master" do |kmaster|
    kmaster.vm.box = "ubuntu/bionic64"
    kmaster.vm.hostname = "ku-master.mine.labs"
    kmaster.vm.network "private_network", ip: "172.42.42.100"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "ku-master"
      v.memory = 2024
      v.cpus = 2
    end
    kmaster.vm.provision "shell", path: "k8s-master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "ku-worker#{i}" do |workernode|
      workernode.vm.box = "ubuntu/bionic64"
      workernode.vm.hostname = "ku-worker#{i}.mine.labs"
      workernode.vm.network "private_network", ip: "172.42.42.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "ku-worker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "k8s-worker.sh"
    end
  end

end
