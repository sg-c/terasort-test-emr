#!/bin/bash

source ./core.sh

function deploy() {
    echo "====== ====== prepare nodes ====== ======"
    prepare_nodes
    echo "====== ====== set up master ====== ======"
    setup_master
    echo "====== ====== install alluxio ====== ======"
    install_alluxio
    echo "====== ====== configure and restart alluxio ====== ======"
    configure_and_restart_alluxio
}

DEPLOY_ACTION=$2

[ -z $DEPLOY_ACTION ] && echo "Usage: deploy PROFILE_DIR ACTION" && exit 1

echo "** Time: $(date) **"

case "$DEPLOY_ACTION" in
"deploy")
    deploy
    ;;
"reboot_alluxio")
    configure_and_restart_alluxio
    ;;
*)
    echo "Unknown action: $DEPLOY_ACTION"
    exit 1
    ;;
esac

echo "** Time: $(date) **"