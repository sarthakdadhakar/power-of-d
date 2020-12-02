#!/bin/bash

# for colored output
#usage: echo "${red}red text ${green}green text${reset}"
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`


if [ $1 == "-h" ] || [ $# -ne 7 ]
then
  echo "${red}This file is for setup that copies and sets up the projects on remote nodes"
  echo "Additionally, install-deps is called for the remote nodes here."
  echo "1 -> num of servers"
  echo "2 -> username"
  echo "3 -> project dir in local machine"
  echo "4 -> parent folder of nova_server_main binary"
  echo "5 -> experiment name"
  echo "6 -> project name"
  echo "7 -> copy or not. If \"no_copy\" then system files are not copied and reboot is not done."
#bash scripts/bootstrap/env/setup-apt-ssh.sh 5 dhrumil /mnt/c/Users/dhrum/CLionProjects/dynamic_range_partitioning cmake-build-debug/
#dev rangepartition copy
  echo "example call: ./setup-apt-ssh.sh 2 kanakia ~/CLionProjects/novalsm cmake-build-debug/ dev nova-lsm no_copy"
  echo "example call: bash scripts/bootstrap/env/setup-apt-ssh.sh 5 dhrumil /mnt/c/Users/dhrum/CLionProjects/dynamic_range_partitioning cmake-build-debug/ dev rangepartition copy"
  echo "[HITARTH:CHANGE THIS]example call: ./setup-apt-ssh.sh 2 kanakia ~/CLionProjects/novalsm cmake-build-debug/ dev nova-lsm no_copy"
  echo "-h to get see this help${reset}"
  exit 1
fi


END=$1
user=$2
local_project_dir=$3
server_binary=$4
experiment_name=$5
project_name=$6
no_copy=$7


REMOTE_HOME="/users/$user"
setup_script="$REMOTE_HOME/scripts/env"
limit_dir="$REMOTE_HOME/scripts"
LOCAL_HOME="$local_project_dir/scripts/bootstrap"

# dev - experiment name
host="${experiment_name}.${project_name}-PG0.apt.emulab.net"
#host="${experiment_name}.${project_name}-PG0.utah.cloudlab.us"


for((i=0;i<END;i++)); do
    echo -e "${blue}\nbuilding server on node $i\n${reset}"
#    echo "scp $LOCAL_HOME/env/setup-ssh.sh $user@node-$i.${host}:/users/$user/setup-ssh.sh"
    scp $LOCAL_HOME/env/setup-ssh.sh $user@node-$i.${host}:/users/$user/setup-ssh.sh
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "bash $REMOTE_HOME/setup-ssh.sh $user"
done
# copying scripts on server
for((i=0;i<END;i++)); do
    echo ""
    echo "${blue}copying scripts files on node $i${reset}"
    echo ""

#    echo "sudo ssh -oStrictHostKeyChecking=no $user@node-$i.${host} sudo mkdir $REMOTE_HOME/scripts -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/env -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/scripts/exp -m 777"

    scp -r $LOCAL_HOME/env/*sh $user@node-$i.${host}:/users/$user/scripts/env
    scp -r $LOCAL_HOME/../exp/*sh $user@node-$i.${host}:/users/$user/scripts/exp
    scp -r $LOCAL_HOME/*conf $user@node-$i.${host}:/users/$user/scripts
    scp -r $LOCAL_HOME/../exp/parse_ycsb_nova_leveldb.py $user@node-$i.${host}:/users/$user/scripts
    scp -r $LOCAL_HOME/../tutorial/* $user@node-$i.${host}:/users/$user/scripts
done

# copying system files and then rebooting
if [[ $no_copy != "no_copy" ]]
then
  for ((i=0;i<END;i++)); do
      echo "${blue}copying system configs on node $i${reset}"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/ulimit.conf /etc/systemd/user.conf"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/sys_ulimit.conf /etc/systemd/system.conf"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo cp $limit_dir/limit.conf /etc/security/limits.conf"
      echo "${blue}rebooting $i... connection will be closed${reset}"
      ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo reboot"
  done
else
  echo "${red} --------- WARNING: not copying systemd config files on nodes -------- ${reset}"
  echo "${red} --------- WARNING: not copying systemd config files on nodes -------- ${reset}"
fi

# copy scripts and install dependency after reboot

# first check if rebooted
for((i=0;i<END;i++)); do
    until ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo touch /tmp/temp"; do
      echo "${red}node $i asleep${reset}"
      sleep 5
    done
    echo "${green}node $i awake${reset}"
done

for ((i=0;i<END;i++)); do

    echo -e "${blue}\ncloning YCSB client in node $i\n${reset}"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "rm -rf NovaLSM-YCSB-Client"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "git clone https://github.com/HaoyuHuang/NovaLSM-YCSB-Client.git"

    echo -e "${blue}\ncreating config and nova directories on node $i\n${reset}"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/config -m 777"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo mkdir $REMOTE_HOME/nova -m 777"

    echo -e "${blue}\ncopying server binary file to node $i\n${reset}"
    scp -r $server_binary/nova_server_main $user@node-$i.${host}:/users/$user/nova

    echo -e "${blue}\ncopying config files to node $i\n${reset}"
    scp -r $local_project_dir/config/* $user@node-$i.${host}:/users/$user/config

    echo -e "${blue}\nbuilding server on node $i\n${reset}"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "bash $setup_script/setup-ssh.sh $user"
done

for((i=0;i<END;i++)); do
    echo -e "${blue}\nrunning install-deps.sh script on node $i\n${reset}"
    ssh -oStrictHostKeyChecking=no $user@node-$i.${host} "sudo bash $REMOTE_HOME/scripts/env/install-deps.sh $REMOTE_HOME"
done

#echo -e "${blue}\nrunning init.sh on node 0\n${reset}"
#ssh -oStrictHostKeyChecking=no $user@node-0.${host} "sudo bash $REMOTE_HOME/scripts/env/init.sh $END $user"
