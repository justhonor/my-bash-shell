#!/bin/bash 

#############################################
##
#文件名: IFS.sh
#作者名: aiapple
#时间  : 2016-12-22
#简介  : 
##
#############################################

data="name,sex,location,numbers"

#oldIFS=$IFS
IFS=','
for item in $data;
do
	echo item:$item
done

#IFS=$oldIFS
data2="wo,men,shi,hao,ren "

for it in $data2;
do
	echo it:$it
done
