#!/bin/bash

aws s3 cp s3://alluxio-binaries/ee_trial/2.8.0-1.0/alluxio-enterprise-2.8.0-1.0.tar.gz - > \
~/alluxio-enterprise-2.8.0-1.0.tar.gz

tar xf ~/alluxio-enterprise-2.8.0-1.0.tar.gz

mv alluxio-enterprise-2.8.0-1.0 alluxio

source ./utils.sh

append_if_not_exists ~/.bashrc "PATH=$PATH:~/alluxio/bin"
append_if_not_exists ~/.bashrc "ALLX_HOME=~/alluxio"

source ~/.bashrc