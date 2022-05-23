#!/bin/bash

# PUB_IPS=(master_pub_ip, worker1_pub_ip, worker2_pub_ip, ...)
declare -a PUB_IPS=(44.204.152.128 18.234.205.63 34.227.20.184 44.203.36.173 54.89.217.190 18.208.135.207)

# PRV_IPS=(master_prv_ip, worker1_prv_ip, worker2_prv_ip, ...)
declare -a PRV_IPS=(172.31.86.59 172.31.95.204 172.31.90.136 172.31.80.77 172.31.91.131 172.31.84.211)

declare -a HOSTNAMES=()

for PRV_IP in "${PRV_IPS[@]}"; do
    HOSTNAMES+=(ip-${PRV_IP//\./-}.ec2.internal)
done

function generate_hosts() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        echo "${PRV_IPS[$i]} ${HOSTNAMES[$i]}"
    done
}
