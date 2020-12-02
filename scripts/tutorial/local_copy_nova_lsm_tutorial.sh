#!/bin/bash

# for colored output
#usage: echo "${red}red text ${green}green text${reset}"
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

user=$1
run_backup=$2

dryrun="false"

recordcount="10000000"
dist="uniform"
nservers="4"
number_of_ltcs="1"
zipfianconstant="0.99"
nranges_per_server="8"
num_sstable_replicas="2"
num_memtable_partitions="4"

# note: If there is a change in parameters, then please ensure that the parameters are changed in both backup and exp.
# note: Also, after doing this, run_backup should be run_backup for the first run.

if [[ $run_backup == "run_backup" ]]
then
  bash /users/$user/scripts/tutorial/nova_lsm_tutorial_backup.sh $recordcount $dryrun $number_of_ltcs $nservers $num_memtable_partitions $dist $num_sstable_replicas $nranges_per_server $zipfianconstant $user > backup_out
else
  echo "${red} --------- WARNING: not running backup | Please run backup if parameters are changed  -------- ${reset}"
  echo "${red} --------- WARNING: not running backup | Please run backup if parameters are changed  -------- ${reset}"
fi


echo "running exp file now"
bash /users/$user/scripts/tutorial/nova_lsm_tutorial_exp.sh $recordcount $dryrun $user > exp_out
