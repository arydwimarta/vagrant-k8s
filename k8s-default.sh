#!/bin/sh

sudo su

apt-get -y update

echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 ku20-master.mine.labs ku20-master
172.42.42.101 ku20-worker1.mine.labs ku20-worker1
172.42.42.102 ku20-worker2.mine.labs ku20-worker2
EOF


echo "[TASK 2] Add Key and Repo"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat >>/etc/apt/source.list<<EOF
"deb http://apt.kubernetes.io/ kubernetes-xenial main"
EOF


sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7EA0A9C3F273FCD8
apt-get update -y

 
echo "[TASK 3] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 4]Install packages to allow apt to use a repository over HTTPS"
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

echo "[TASK 5] install and setup docker"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce

touch /etc/docker/daemon.json
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload
sudo systemctl restart docker

apt-get update

apt-get update
apt-get install -y apt-transport-https curl

echo "[TASK 6] install and setup kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
touch /etc/apt/sources.list.d/kubernetes.list
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7EA0A9C3F273FCD8

sudo apt-get -y update
sudo apt-get install -y kubelet kubeadm kubectl

cat >>/etc/systemd/system/kubelet.service.d/10-kubeadm.conf<<EOF
Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"
EOF

# Start and Enable kubelet service
echo "[TASK 7] Enable and start kubelet service"
systemctl enable kubelet
systemctl start kubelet

# Enable ssh password authentication
echo "[TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

su - vagrant

# Set Root password
#echo "[TASK 9] Set root password"
#echo -e "kubeadmin\nkubeadmin" | sudo passwd

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

# Install sshpass
echo "[TASK 10] install ssh pass"
sudo apt-get install -y sshpass
