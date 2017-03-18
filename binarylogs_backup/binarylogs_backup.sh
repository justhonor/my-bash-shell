#!/bin/bash

############################################
##
# Filename: binarylogs_backup.sh
# Author  : zane
# Date    : 2017-03-08
# Describe:
##
#############################################

HOST='datasyncca.cx8segvsabtq.us-west-1.rds.amazonaws.com'
PORT='3306'
USER='devdb'
PWD='000000'

targetdb=data

if [ -d binlogs.$(date +%F) ];then
	echo "binlogs.$(date +%F) exist"
	echo "binlog backup failed!!"
	exit 1
	
else
	mkdir binlogs.$(date +%F)
	touch binlogs.$(date +%F)/binlogs.$(date +%F)
fi

binlogs=binlogs.$(date +%F)/binlogs.$(date +%F)
D_binlogs=binlogs.$(date +%F)

# get  names of all bin logs.
mysql --login-path=$targetdb -e "show binary logs;" > $binlogs

# get the last bin log name
LastBinLog=`cat $binlogs | awk 'BEGIN{getline}{print $1}' | sort | tail -n 1`
echo "lastbinlog name:$LastBinLog"
# using mysqlbinlog backup all bin logs with LastBinLog
mysqlbinlog --login-path=$targetdb  --read-from-remote-server --raw --to-last-log $LastBinLog 

