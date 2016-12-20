#!/bin/bash 

#############################################
##
#文件名: find_max10file.sh
#作者名: zane
#时间  : 2016-12-20
#简介  : 
##
#############################################

BASEDIR=/home/zane/github

filenums=5

echo -e "The top $filenums files are coming!"
find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk 'NR=1'

read -s -p "Input a for delete all;\n b for backup all  " -t 5 
#echo " this is kb_files $kb_files"
#for i in `find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums`;do
#	echo -e "this is : $i \n"
#done
