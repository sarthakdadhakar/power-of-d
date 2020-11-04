#!/bin/bash
recordcount="10000000"
dryrun="false"
user=$1

# bash /proj/bg-PG0/kanakia/scripts/nova_lsm_subrange_leveldb_backup.sh $recordcount $dryrun > backup_out
bash /users/$user/scripts/exp/nova_lsm_subrange_leveldb_ranges.sh $recordcount $dryrun $user > lsm_ranges
# bash /proj/bg-PG0/kanakia/scripts/nova_leveldb_bench.sh $recordcount $dryrun > leveldb_ranges

