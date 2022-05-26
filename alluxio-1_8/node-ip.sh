#!/bin/bash

# PUB_IPS=(master_pub_ip, worker1_pub_ip, worker2_pub_ip, ...)
declare -a PUB_IPS=(3.94.85.79 54.172.67.105 34.207.66.73 3.86.244.236 34.203.228.111 54.89.43.59)

# PRV_IPS=(master_prv_ip, worker1_prv_ip, worker2_prv_ip, ...)
declare -a PRV_IPS=(172.31.83.132 172.31.83.209 172.31.86.21 172.31.90.121 172.31.85.140 172.31.88.43)

declare -a HOSTNAMES=()

for PRV_IP in "${PRV_IPS[@]}"; do
    HOSTNAMES+=(ip-${PRV_IP//\./-}.ec2.internal)
done

function generate_hosts() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        echo "${PRV_IPS[$i]} ${HOSTNAMES[$i]}"
    done
}
