#!/bin/bash 

#############################################
##
#文件名: sys_monitor.sh
#作者名: aiapple
#时间  : 2016-11-07
#简介  : 监控系统信息并报警 
##
#############################################

REPORT_FILE=`pwd`/report_file

DATE=`date +%F`
TIME=`date +%T`

if ! test -f report_file;then
	touch report_file
	echo "        TIME           MEMORY       SWAP      CPU     DISK">>$REPORT_FILE
else
	
	echo "The file is exsit~"
	read  -s -p"Delete:d  Flush:f" -n 1  -t 5 input 
	echo -e "\t"
	#echo "this is input:$input"
	if [ $input == 'd' ];then
		echo -e "Deleting and recreate........"
		rm -rf report_file
		touch report_file
		echo "        TIME           MEMORY       SWAP      CPU     DISK">>$REPORT_FILE
	elif [ $input == 'f' ];then
		echo -e "Adding a new report in this file........"
	else
		echo "Please use correctly!"
		exit 
	fi
fi

#
##################################################################
# Memory Free
#
FREE=`free -m | head -n 2 | tail -n 1 | awk {'print $4'}`
USE_PER=`ps aux | awk '{sum+=$4} END {print sum}'` 
##################################################################
# Swap Free
#
SWAP=`free -m | tail -n 1 | awk {'print $3'}`
##################################################################
# CPU Idle
#
CPU=`ps aux | awk '{sum+=$3} END {print sum}'`
##################################################################
# Disk Space Available
# 
ROOT=`df -h /   | awk '{ a = $5} END { print a }'`
###########################################################
# Send email 
#
#echo "        TIME           MEMORY       SWAP      CPU     DISK">>$REPORT_FILE
echo "$DATE $TIME    $FREE MB       $SWAP MB    $CPU %    $ROOT">>$REPORT_FILE 
if [ `expr $CPU \> $num` -ge 0 ] || [ $ROOT -ge 70 ];then
	echo "this is diff `expr $CPU \> $num` "
	echo "this is CPU $CPU "
	echo "this is root $ROOT"
	mail -s "This is monitor" root < $REPORT_FILE
fi
# EOF
