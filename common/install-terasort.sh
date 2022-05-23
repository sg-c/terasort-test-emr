#!/bin/bash

cd ~

# following files will be copied to the same dir on remote node
[ ! -f ./utils.sh ] && echo "Cannot find ./utils.sh" && exit 1

# following commands are executed on remote nodes
source ./utils.sh

install_maven

git clone -b spark-version-readme https://github.com/ehiggs/spark-terasort.git
cd spark-terasort
mvn install