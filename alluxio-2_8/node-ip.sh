#!/bin/bash

# PUB_IPS=(master_pub_ip, worker1_pub_ip, worker2_pub_ip, ...)
declare -a PUB_IPS=(3.83.88.198 3.88.165.134 18.212.18.69 3.88.9.70 54.147.245.190 174.129.134.127)

# PRV_IPS=(master_prv_ip, worker1_prv_ip, worker2_prv_ip, ...)
declare -a PRV_IPS=(172.31.83.157 172.31.95.170 172.31.89.250 172.31.80.163 172.31.80.152 172.31.88.157)

declare -a HOSTNAMES=()

for PRV_IP in "${PRV_IPS[@]}"; do
    HOSTNAMES+=(ip-${PRV_IP//\./-}.ec2.internal)
done

function generate_hosts() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        echo "${PRV_IPS[$i]} ${HOSTNAMES[$i]}"
    done
}
