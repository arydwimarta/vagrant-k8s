#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "[TASK 1] Join node to Kubernetes Cluster"
sudo apt-get install -y sshpass >/dev/null 2>&1
sshpass -p "vagrant" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@ku20-master:/home/vagrant/joincluster.sh /home/vagrant/joincluster.sh 2>/dev/null

# kubedm must root user
echo "[TASK 2] join cluster using joincluster.sh"
bash /home/vagrant/joincluster.sh >/dev/null 2>&1
