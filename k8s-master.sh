#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.42.42.100

# Copy Kube Admin config
echo "[TASK 2] Copy cube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy detwork
echo "[TASK 3] deploy calico netorks"
su - vagrant -c "kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to joincluster.sh"
kubeadm token create --print-join-command >> joincluster.sh
