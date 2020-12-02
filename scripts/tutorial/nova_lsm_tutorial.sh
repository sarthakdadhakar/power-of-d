#!/bin/bash

user=$1

dryrun="false"

recordcount="10000000"
dist="uniform"
nservers="2"
number_of_ltcs="1"
zipfianconstant="0.99"
nranges_per_server="1"
num_sstable_replicas="1"
num_memtable_partitions="32"

bash /users/$user/scripts/nova_lsm_tutorial_backup.sh $recordcount $dryrun $number_of_ltcs $nservers $num_memtable_partitions $dist $num_sstable_replicas $nranges_per_server $zipfianconstant $user > backup_out
echo "running exp file now"
bash /users/$user/scripts/nova_lsm_tutorial_exp.sh $recordcount $dryrun $user > exp_out
