#!/bin/bash

if [ $1 == "-h" ] || [ $# -ne 6 ]
then
  echo "This file is for copying files to all remote nodes from local node"
  echo "1 -> num of servers"
  echo "2 -> username"
  echo "3 -> file location in local machine"
  echo "4 -> destination location in remote machine"
  echo "5 -> experiment name"
  echo "6 -> project name"
  echo "example call: ./copy_files 5 smit14 cmake-build-debug/nova_server_main /users/smit14/nova"
  echo "-h to get see this help"
  exit 1
fi

END=$1
user=$2
local_location=$3
server_location=$4
exp=$5
project=$6

# dev- experiment name
host="$exp.$project-PG0.apt.emulab.net"
#host="$exp.$project-PG0.utah.cloudlab.us"

for((i=0;i<END;i++)); do
    echo "copying file on node $i"

    scp -r $local_location $user@node-$i.${host}:$server_location
done