#!/bin/bash

source ./core.sh

function upload_load_script() {
    LOAD_SCRIPT=$(mktemp -q /tmp/run-test-load.sh.XXXXX)
    sed "s/MASTER_HOSTNAME/${HOSTNAMES[0]}/g" ./common/run-test-load.sh >$LOAD_SCRIPT
    chmod +xr $LOAD_SCRIPT

    upload_file $MASTER_PUB_IP "~/run-test-load.sh" $LOAD_SCRIPT
    rm $LOAD_SCRIPT
}

upload_load_script