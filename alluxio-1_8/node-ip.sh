#!/bin/bash

# PUB_IPS=(master_pub_ip, worker1_pub_ip, worker2_pub_ip, ...)
declare -a PUB_IPS=(34.207.67.194 44.201.189.83 3.83.243.171)

# PRV_IPS=(master_prv_ip, worker1_prv_ip, worker2_prv_ip, ...)
declare -a PRV_IPS=(172.31.89.6 172.31.80.182 172.31.92.238)

declare -a HOSTNAMES=()

for PRV_IP in "${PRV_IPS[@]}"; do
    HOSTNAMES+=(ip-${PRV_IP//\./-}.ec2.internal)
done

function generate_hosts() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        echo "${PRV_IPS[$i]} ${HOSTNAMES[$i]}"
    done
}
