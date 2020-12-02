#!/bin/bash

END=$1
user=$2
exp=$3
project=$4

host="$exp.$project-PG0.apt.emulab.net"
#host="$exp.$project-PG0.utah.cloudlab.us"

for((i=0;i<END;i++)); do
    echo "killing processes on node $i"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo killall leveldb_main nova_shared_main nova_multi_thread_compaction nova_server_main java collectl sar"
done