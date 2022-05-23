#!/bin/bash

aws s3 cp s3://alluxio-binaries/os/1.8.2/alluxio-1.8.2-hadoop-2.8-bin.tar.gz - > \
~/alluxio-1.8.2-hadoop-2.8-bin.tar.gz

tar xf ~/alluxio-1.8.2-hadoop-2.8-bin.tar.gz

mv alluxio-1.8.2-hadoop-2.8 alluxio

source ./utils.sh

append_if_not_exists ~/.bashrc "PATH=$PATH:~/alluxio/bin"
append_if_not_exists ~/.bashrc "ALLX_HOME=~/alluxio"

source ~/.bashrc