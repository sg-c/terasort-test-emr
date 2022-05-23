#!/bin/bash

# following files will be copied to the same dir on remote node
[ ! -f ./utils.sh ] && echo "Cannot find ./utils.sh" && exit 1
[ ! -f ./hosts.sh ] && echo "Cannot find ./hosts.sh" && exit 1

# following commands are executed on remote nodes
source ./utils.sh

# add ec2-user to hadoop group
# sudo usermod -a -G hadoop ec2-user
sudo usermod -a -G hdfsadmingroup ec2-user

# ssh to localhost
append_if_not_exists ~/.ssh/authorized_keys "$(cat ~/.ssh/id_rsa.pub)"

# use java 1.8.0
#append_if_not_exists ~/.bashrc "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64"

# update /etc/hosts
while read line; do
    append_if_not_exists /etc/hosts "$line"
done < ./hosts.sh