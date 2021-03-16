#!/bin/sh

echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 ku-master.mine.labs ku-master
172.42.42.101 ku-worker1.mine.labs ku-worker1
172.42.42.102 ku-worker2.mine.labs ku-worker2
EOF


echo "[TASK 2] Add Key and Repo"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

cat >>/etc/apt/source.list<<EOF
"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
EOF

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -


echo "[TASK 3] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a
apt-get -y update

echo "[TASK 4]Install packages to allow apt to use a repository over HTTPS"
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "[TASK 5] install and setup docker"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install -y docker-ce=18.06.2~ce~3-0~ubuntu

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

systemctl daemon-reload
systemctl restart docker

apt-get update
apt-get install -y apt-transport-https curl

echo "[TASK 6] install and setup kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
touch /etc/apt/sources.list.d/kubernetes.list
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update
apt-get install -y kubelet kubeadm kubectl

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

# Set Root password
echo "[TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | sudo passwd

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

# Install sshpass
echo "[TASK 10] install ssh pass"
apt-get install -y sshpass
