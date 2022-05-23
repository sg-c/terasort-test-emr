#!/bin/bash

source ./core.sh

function upload_terasort_script() {
    TERASORT_SCRIPT=$(mktemp -q /tmp/run-test-terasort.sh.XXXXX)
    sed "s/MASTER_HOSTNAME/${HOSTNAMES[0]}/g" ./common/run-test-terasort.sh >$TERASORT_SCRIPT
    chmod +xr $TERASORT_SCRIPT

    upload_file $MASTER_PUB_IP "~/run-test-terasort.sh" $TERASORT_SCRIPT
    rm $TERASORT_SCRIPT
}

function install_terasort() {
    upload_file $MASTER_PUB_IP "~" ./common/install-terasort.sh
    remote_run_bash $MASTER_PUB_IP "~/install-terasort.sh"

    upload_terasort_script
}

TERASORT_ACTION=$2

[ -z $TERASORT_ACTION ] && echo "Usage ./terasort.sh PROFILE_DIR ACTION" && exit 1

[[ $TERASORT_ACTION == "upload" ]] && upload_terasort_script
[[ $TERASORT_ACTION == "install" ]] && install_terasort
