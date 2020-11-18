#!/bin/bash

END=2
REMOTE_HOME="/users/sayee"
local_project_dir="/home/vedant/Desktop/new_repo/power-of-d/cmake-build-default/nova_server_main"

host[0]="sayee@apt002.apt.emulab.net"
host[1]="sayee@apt018.apt.emulab.net"
#host[2]="sayee@apt049.apt.emulab.net"
#host[3]="sayee@apt037.apt.emulab.net"
#host[4]="sayee@apt038.apt.emulab.net"

for((i=0;i<END;i++)); do
    echo "Installing dependencies binary on node $i"
#    echo $local_project_dir
#    scp -r ${local_project_dir} ${host[i]}:/users/sayee/
    ssh -oStrictHostKeyChecking=no ${host[i]} "bash $REMOTE_HOME/scripts/env/install-deps.sh"
done
