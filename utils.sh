#!/bin/bash

function append_if_not_exists() {
    local targetFile=$1
    local toAppend=$2

    grep -qxF "$toAppend" $targetFile || echo "$toAppend" | sudo tee -a $targetFile >/dev/null
}

function upload_file() {
    [ -z $GLOBAL_SSH_PATH ] && echo "env GLOBAL_SSH_PATH is NOT set" && exit 1
    [ -z $GLOBAL_SSH_USER ] && echo "env GLOBAL_SSH_USER is NOT set" && exit 1

    local remoteHost=$1
    local remoteDir=$2
    local localFile=$3

    scp -i $GLOBAL_SSH_PATH $localFile $GLOBAL_SSH_USER@$remoteHost:$remoteDir
}

function remote_exec() {
    [ -z $GLOBAL_SSH_PATH ] && echo "env GLOBAL_SSH_PATH is NOT set" && exit 1
    [ -z $GLOBAL_SSH_USER ] && echo "env GLOBAL_SSH_USER is NOT set" && exit 1

    local remoteHost=$1
    local command=$2

    ssh -i $GLOBAL_SSH_PATH $GLOBAL_SSH_USER@$remoteHost $command
}

function remote_run_bash() {
    local remoteHost=$1
    local remoteScript=$2

    remote_exec $remoteHost "bash $remoteScript"
}

function install_maven() {
    sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    sudo yum install -y apache-maven
}
