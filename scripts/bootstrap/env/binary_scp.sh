#!/bin/bash

END=5
REMOTE_HOME="/proj/bg-PG0/sayee"
local_project_dir="/home/vedant/Desktop/new_repo/power-of-d/cmake-build-default/nova_server_main"
#local_scripts_dir="/home/vedant/Desktop/new_repo/power-of-d/"
user="sayee"
host="sayee-QV85012.nova-pg0.apt.emulab.net"

#host[0]="sayee@apt002.apt.emulab.net"
#host[1]="sayee@apt018.apt.emulab.net"
#host[2]="sayee@apt049.apt.emulab.net"
#host[3]="sayee@apt037.apt.emulab.net"
#host[4]="sayee@apt038.apt.emulab.net"

for((i=0;i<END;i++)); do
    echo "copying files on node $i"
    echo ${user}@node-$i.${host}
    ssh -oStrictHostKeyChecking=no ${user}@node-$i.${host} "rm nova"
    ssh -oStrictHostKeyChecking=no ${user}@node-$i.${host} "sudo mkdir $REMOTE_HOME/nova -m 777"
#    scp -r ${local_project_dir} $user@node-$i.${host}:/users/sayee/scripts/env
##    echo $local_project_dir
#    scp -r ${local_project_dir} ${host[i]}:/users/sayee/
    scp -r ${local_project_dir} ${user}@node-$i.${host}:/${REMOTE_HOME}/nova/nova_server_main
done