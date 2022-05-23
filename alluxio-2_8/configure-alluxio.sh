#!/bin/bash

ALLX_HOME="~/alluxio"

function generate_and_upload_conf_masters() {
    local master_ip=$1
    local master_hostname=$2

    echo "$master_hostname" >$PROFILE_DIR/tmp/masters
    upload_file $master_ip "$ALLX_HOME/conf/masters" $PROFILE_DIR/tmp/masters
}

function generate_and_upload_conf_workers() {
    local master_ip=$1

    printf "%s\n" "${@:2}" >$PROFILE_DIR/tmp/workers
    upload_file $master_ip "$ALLX_HOME/conf/workers" $PROFILE_DIR/tmp/workers
}

function generate_and_upload_conf_site() {
    local master_ip=$1
    local master_hostname=$2

    sed "s/MASTER_HOSTNAME/$master_hostname/g" $PROFILE_DIR/alluxio-site.template.properties \
        >$PROFILE_DIR/tmp/alluxio-site.properties

    upload_file $master_ip "$ALLX_HOME/conf/" $PROFILE_DIR/tmp/alluxio-site.properties
}

function generate_and_upload_conf_env() {
    local master_ip=$1
    local master_hostname=$2

    cp $PROFILE_DIR/alluxio-env.template.sh $PROFILE_DIR/tmp/alluxio-env.sh
    upload_file $master_ip "$ALLX_HOME/conf/" $PROFILE_DIR/tmp/alluxio-env.sh
}

function client_symlink() {
    echo "sudo ln -s 
    $ALLX_HOME/client/alluxio-enterprise-2.8.0-1.0-client.jar 
    /usr/lib/spark/jars/alluxio-enterprise-2.8.0-1.0-client.jar"
}
