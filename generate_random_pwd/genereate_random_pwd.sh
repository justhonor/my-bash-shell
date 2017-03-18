#!/bin/bash 
#############################################
##
#文件名: genereate_random_pwd.sh
#作者名: zane
#时间  : 2017-03-18
#简介  : 
##
#############################################

BITS=32
genpasswd(){
	local l=$1
	[ "$1" == "" ] && l=$BITS
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c $l | xargs
}


if [ $# -eq 0 ];then
	genpasswd 
elif [ $# -eq 1 ];then
	if grep '^[[:digit:]]' <<< "$1" >/dev/null ;then
		genpasswd $1
	else
		echo "输入需生成密码的位数"
		echo "例子："
		echo "      $0 10"
	fi
	
else
	echo "输入需生成密码的位数"
	echo "例子："
	echo "      $0 10"
fi
