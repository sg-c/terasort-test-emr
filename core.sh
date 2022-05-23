#!/bin/bash

source ./utils.sh

function generate_hosts_file() {
    local fileLocation=$PROFILE_DIR/tmp/hosts.sh
    echo "$(generate_hosts)" >$fileLocation
    echo $fileLocation
}

function upload_ssh_keys() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        upload_file "${PUB_IPS[$i]}" "~/.ssh" "$GLOBAL_SSH_TMP_KEYS"
    done
}

function upload_and_run_setup_script() {
    local hostsFile="$(generate_hosts_file)"
    local filesToUpload="$hostsFile ./utils.sh ./common/setup-node.sh"

    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        upload_file "${PUB_IPS[$i]}" "~" "$filesToUpload"
        remote_run_bash "${PUB_IPS[$i]}" "~/setup-node.sh"
    done
}

function prepare_nodes() {
    upload_ssh_keys
    upload_and_run_setup_script
}

function setup_master() {
    # install necessary tools
    remote_exec "$MASTER_PUB_IP" "sudo yum install -y tmux git"

    # set up AWS credentials
    read -p "enter aws_access_key_id: " aws_access_key_id
    remote_exec "$MASTER_PUB_IP" "aws configure set aws_access_key_id $aws_access_key_id"

    read -p "enter aws_secret_access_key: " aws_secret_access_key
    remote_exec "$MASTER_PUB_IP" "aws configure set aws_secret_access_key $aws_secret_access_key"

    # upload Spark log4j.properties
    upload_file "$MASTER_PUB_IP" "~" ./common/spark-log4j.properties
}

function install_alluxio() {
    upload_file "$MASTER_PUB_IP" "~" $PROFILE_DIR/install-alluxio.sh
    remote_run_bash "$MASTER_PUB_IP" "~/install-alluxio.sh"

    remote_exec "$MASTER_PUB_IP" "alluxio copyDir $ALLX_HOME"

    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        remote_exec "${PUB_IPS[$i]}" "$(client_symlink)"
    done
}

function configure_and_restart_alluxio() {
    remote_exec "$MASTER_PUB_IP" "alluxio-stop.sh all"

    generate_and_upload_conf_masters "$MASTER_PUB_IP" "${HOSTNAMES[0]}"
    generate_and_upload_conf_workers "$MASTER_PUB_IP" "${HOSTNAMES[@]:1}"
    generate_and_upload_conf_site "$MASTER_PUB_IP" "${HOSTNAMES[0]}"
    generate_and_upload_conf_env "$MASTER_PUB_IP" "${HOSTNAMES[0]}"

    remote_exec "$MASTER_PUB_IP" "alluxio copyDir $ALLX_HOME; alluxio-start.sh all SudoMount"
}

GLOBAL_SSH_PATH="/Users/saiguang/.ssh/saiguang-virginia.pem"
GLOBAL_SSH_USER=ec2-user
GLOBAL_SSH_TMP_KEYS=~/.ssh/tmp-keys/*

PROFILE_DIR=$1

IP_CONF=$PROFILE_DIR/node-ip.sh
CONFIGURE_ALLUXIO=$PROFILE_DIR/configure-alluxio.sh

[ -z $PROFILE_DIR ] && echo "Missing PROFILE_DIR" && exit 1
[ ! -f $IP_CONF ] && echo "Cannot find $IP_CONF" && exit 1
[ ! -f $CONFIGURE_ALLUXIO ] && echo "Cannot find $CONFIGURE_ALLUXIO" && exit 1

mkdir -p $PROFILE_DIR/tmp # create folder for generated files

source $IP_CONF
source $CONFIGURE_ALLUXIO

MASTER_PUB_IP="${PUB_IPS[0]}"
