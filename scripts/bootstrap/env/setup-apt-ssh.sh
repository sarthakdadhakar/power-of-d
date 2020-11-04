#!/bin/bash

# example call: ./setup-apt-ssh.sh 2 sayee ~/CLionProjects/novalsm
END=$1
user=$2
local_project_dir=$3
no_copy=$4
REMOTE_HOME="/users/$user"
setup_script="$REMOTE_HOME/scripts/env"
limit_dir="$REMOTE_HOME/scripts"
LOCAL_HOME="$local_project_dir/scripts/bootstrap"

# dev - experiment name
host="dev.novalsm-PG0.apt.emulab.net"

for((i=0;i<END;i++)); do
    echo "copying files on node $i"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/env -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/exp -m 777"

    scp -r $LOCAL_HOME/env/*sh $user@node-$i.${host}:/users/sayee/scripts/env
    scp -r $LOCAL_HOME/../exp/*sh $user@node-$i.${host}:/users/sayee/scripts/exp
    scp -r $LOCAL_HOME/*conf $user@node-$i.${host}:/users/sayee/scripts
done

for ((i=0;i<END;i++)); do
    echo "building server on node $i"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "bash $setup_script/setup-ssh.sh"
done

echo "cloning YCSB client in node 0"
ssh -oStrictHostKeyChecking=no $user@node-0.${host} "rm -rf NovaLSM-YCSB-Client"
ssh -oStrictHostKeyChecking=no $user@node-0.${host} "git clone https://github.com/HaoyuHuang/NovaLSM-YCSB-Client.git"

if [[ $no_copy != "no_copy" ]]
then
  for ((i=0;i<END;i++)); do
      echo "copying configs on node $i"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/ulimit.conf /etc/systemd/user.conf"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/sys_ulimit.conf /etc/systemd/system.conf"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/limit.conf /etc/security/limits.conf"
      echo "rebooting $i... connection will be closed"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo reboot"
  done
else
  echo " --------- WARNING: not copying systemd config files on nodes --------"
  echo " --------- WARNING: not copying systemd config files on nodes --------"
fi