#!/bin/bash

#example call: ./init.sh 2 sayee
numServers=$1
user=$2
basedir="/users/$user"
prefix="h"

for ((i=0;i<numServers;i++)); do
	echo "*******************************************"
	echo "*******************************************"
   	echo "******************* node-$i ********************"
   	echo "*******************************************"
   	echo "*******************************************"
 	ssh -oStrictHostKeyChecking=no node-$i "sudo apt-get update"
    ssh -oStrictHostKeyChecking=no node-$i "sudo apt-get --yes install screen"
    ssh -n -f -oStrictHostKeyChecking=no node-$i screen -L -S env1 -dm "$basedir/scripts/env/setup-all.sh $user"
done

sleep 10

sleepcount="0"

for ((i=0;i<numServers;i++)); 
do
	while ssh -oStrictHostKeyChecking=no  node-$i "screen -list | grep -q env1"
	do 
		((sleepcount++))
		sleep 10
		echo "waiting for node-$i "
	done
	echo "setup-all done for node-$i"

done

echo "init env took $((sleepcount/6)) minutes"
