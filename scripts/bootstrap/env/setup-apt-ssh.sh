#!/bin/bash

# example call: ./setup-apt-ssh.sh 5 sayee /home/vedant/Desktop/new_repo/power-of-d
END=$1
user=$2
local_project_dir=$3
no_copy=$4
REMOTE_HOME="/proj/bg-PG0/$user"
HOME="/users/$user"
setup_script="$REMOTE_HOME/scripts/env"
limit_dir="$REMOTE_HOME/scripts"
LOCAL_HOME="$local_project_dir/scripts/bootstrap"

# dev - experiment name
host="sayee-qv85012.nova-pg0.apt.emulab.net"

for((i=0;i<END;i++)); do
    echo "copying files on node $i"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME -m 777"

    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/env -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/exp -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/tutorial -m 777"

#    ssh -oStrictHostKeyChecking=no ${host[i]} "sudo mkdir $REMOTE_HOME/scripts -m 777"
#    ssh -oStrictHostKeyChecking=no ${host[i]} "sudo mkdir $REMOTE_HOME/scripts/env -m 777"
#    ssh -oStrictHostKeyChecking=no ${host[i]} "sudo mkdir $REMOTE_HOME/scripts/exp -m 777"

    scp -r $LOCAL_HOME/env/*sh $user@node-$i.${host}:$REMOTE_HOME/scripts/env
    scp -r $LOCAL_HOME/../exp/*sh $user@node-$i.${host}:$REMOTE_HOME/scripts/exp
    scp -r $LOCAL_HOME/../tutorial/*sh $user@node-$i.${host}:$REMOTE_HOME/scripts/tutorial
    scp -r $LOCAL_HOME/*conf $user@node-$i.${host}:$REMOTE_HOME/scripts

#    scp -r $LOCAL_HOME/env/*sh ${host[i]}:/users/sayee/scripts/env
#    scp -r $LOCAL_HOME/../exp/*sh ${host[i]}:/users/sayee/scripts/exp
#    scp -r $LOCAL_HOME/*conf ${host[i]}:/users/sayee/scripts
done
#
#for ((i=0;i<END;i++)); do
#    echo "building server on node $i"
#    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "bash $setup_script/setup-ssh.sh"
#
##    ssh -oStrictHostKeyChecking=no ${host[i]} "bash $setup_script/setup-ssh.sh"
#done
#
#echo "cloning YCSB client in node 0"
#ssh -oStrictHostKeyChecking=no $user@node-0.${host} "rm -rf NovaLSM-YCSB-Client"
#ssh -oStrictHostKeyChecking=no $user@node-0.${host} "git clone https://github.com/HaoyuHuang/NovaLSM-YCSB-Client.git"
#
##ssh -oStrictHostKeyChecking=no ${host[0]} "rm -rf NovaLSM-YCSB-Client"
##ssh -oStrictHostKeyChecking=no ${host[0]} "git clone https://github.com/HaoyuHuang/NovaLSM-YCSB-Client.git"
#
#if [[ $no_copy != "no_copy" ]]
#then
#  for ((i=0;i<END;i++)); do
#      echo "copying configs on node $i"
#      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/ulimit.conf /etc/systemd/user.conf"
#      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/sys_ulimit.conf /etc/systemd/system.conf"
#      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/limit.conf /etc/security/limits.conf"
#      echo "rebooting $i... connection will be closed"
#      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo reboot"
#
##      ssh -oStrictHostKeyChecking=no ${host[i]} "sudo cp $limit_dir/ulimit.conf /etc/systemd/user.conf"
##      ssh -oStrictHostKeyChecking=no ${host[i]} "sudo cp $limit_dir/sys_ulimit.conf /etc/systemd/system.conf"
##      ssh -oStrictHostKeyChecking=no ${host[i]} "sudo cp $limit_dir/limit.conf /etc/security/limits.conf"
##      echo "rebooting $i... connection will be closed"
##      ssh -oStrictHostKeyChecking=no ${host[i]} "sudo reboot"
#  done
#else
#  echo " --------- WARNING: not copying systemd config files on nodes --------"
#  echo " --------- WARNING: not copying systemd config files on nodes --------"
#fi