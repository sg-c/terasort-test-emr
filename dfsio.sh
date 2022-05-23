#!/bin/bash

source ./core.sh

function upload_dfsio_script() {
    DFSIO_SCRIPT=$(mktemp -q /tmp/run-test-dfsio.sh.XXXXX)
    sed "s/MASTER_HOSTNAME/${HOSTNAMES[0]}/g" ./common/run-test-dfsio.sh >$DFSIO_SCRIPT
    chmod +xr $DFSIO_SCRIPT

    upload_file $MASTER_PUB_IP "~/run-test-dfsio.sh" $DFSIO_SCRIPT
    rm $DFSIO_SCRIPT
}

function install_dfsio() {
    upload_file $MASTER_PUB_IP "~" ./common/install-dfsio.sh
    remote_run_bash $MASTER_PUB_IP "~/install-dfsio.sh"

    upload_dfsio_script
}

DFSIO_ACTION=$2

[ -z $DFSIO_ACTION ] && echo "Usage ./dfsio.sh PROFILE_DIR ACTION" && exit 1

[[ $DFSIO_ACTION == "upload" ]] && upload_dfsio_script
[[ $DFSIO_ACTION == "install" ]] && install_dfsio
