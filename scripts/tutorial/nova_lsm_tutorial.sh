#!/bin/bash
dryrun="false"

recordcount="10000000"
dist="uniform"
nservers="5"
number_of_ltcs="2"
zipfianconstant="0.99"
nranges_per_server="1"
num_sstable_replicas="1"
num_memtable_partitions="64"

echo "starting nova_lsm_tutorial_backup script"
bash /proj/bg-PG0/sayee/scripts/tutorial/nova_lsm_tutorial_backup.sh $recordcount $dryrun $number_of_ltcs $nservers $num_memtable_partitions $dist $num_sstable_replicas $nranges_per_server $zipfianconstant > backup_out
echo "starting nova_lsm_tutorial_exp script"
bash /proj/bg-PG0/sayee/scripts/tutorial/nova_lsm_tutorial_exp.sh $recordcount $dryrun > exp_out
echo "All done!"

#echo "starting nova_lsm_tutorial_backup script"
#bash /users/sayee/scripts/tutorial/nova_lsm_tutorial_backup.sh $recordcount $dryrun $number_of_ltcs $nservers $num_memtable_partitions $dist $num_sstable_replicas $nranges_per_server $zipfianconstant > backup_out
#echo "starting nova_lsm_tutorial_exp script"
#bash /users/sayee/scripts/tutorial/nova_lsm_tutorial_exp.sh $recordcount $dryrun > exp_out
#echo "All done!"
