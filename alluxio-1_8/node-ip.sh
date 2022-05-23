#!/bin/bash

# PUB_IPS=(master_pub_ip, worker1_pub_ip, worker2_pub_ip, ...)
declare -a PUB_IPS=(34.201.129.133 54.174.29.199 54.161.185.177 3.82.223.153 44.202.144.168 54.159.149.170)

# PRV_IPS=(master_prv_ip, worker1_prv_ip, worker2_prv_ip, ...)
declare -a PRV_IPS=(172.31.83.240 172.31.80.124 172.31.86.1 172.31.84.126 172.31.85.130 172.31.81.235)

declare -a HOSTNAMES=()

for PRV_IP in "${PRV_IPS[@]}"; do
    HOSTNAMES+=(ip-${PRV_IP//\./-}.ec2.internal)
done

function generate_hosts() {
    for ((i = 0; i < ${#HOSTNAMES[@]}; i++)); do
        echo "${PRV_IPS[$i]} ${HOSTNAMES[$i]}"
    done
}
