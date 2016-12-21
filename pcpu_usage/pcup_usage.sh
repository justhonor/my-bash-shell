#!/bin/bash 

#############################################
##
#文件名: pcup_usage.sh
#作者名: zane
#时间  : 2016-12-21
#简介  : 计算1小时内进程的CPU占用情况
##
#############################################

SECS=3600
UNIT_TIME=60

let steps=$SECS/$UNIT_TIME

for ((i=0;i<steps;i++))
do
#	ps -eo comm,pcpu | tail -n +2 > cpu_usage
	ps -eo comm,pcpu | tail -n +2 >> cpu_usage.$$
	sleep $UNIT_TIME
done	

cat cpu_usage.$$ | \
awk '
       {process[$1]+=$2;}
       END{ 
	    for (i in process)
	    {
		printf("%-20s %s\n",i,process[i]);
	    }
	  }' | sort -nrk 2 | head -n 5 
	   

rm cpu_usage.$$
