#docker build -t ansible_vmware .
#docker run -ti -v `pwd`/app:/app  ansible_vmware
FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y curl python python-pip zip sshpass openssh-client openssh-server rsync locales vim software-properties-common git iputils-ping
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt-get install -y ansible

COPY image/ansible-hosts /etc/ansible/hosts
RUN locale-gen en_US.UTF-8
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
for key in /etc/ssh/ssh_host_*_key.pub; do echo "localhost $(cat ${key})" >> /root/.ssh/known_hosts; done

RUN pip install Pyvmomi
WORKDIR /pyvmomi
RUN git clone https://github.com/vmware/pyvmomi-community-samples.git .
RUN pip install -r requirements.txt
