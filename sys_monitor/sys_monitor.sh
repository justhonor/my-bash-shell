#!/bin/bash 

#############################################
##
#文件名: sys_monitor.sh
#作者名: aiapple
#时间  : 2016-11-07
#简介  : 
##
#############################################


DATE=`date +%F`
TIME=`date +%T`
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
echo "$DATE,$TIME,$USERS,$LOAD,$FREE MB,$SWAP MB,$CPU %,$ROOT,$VAR,$USR" >> $REPORT_FILE
# EOF

