#!/bin/bash 

#############################################
##
#文件名: service_monitor.sh
#作者名: aiapple
#时间  : 2016-11-07
#简介  : 
##
#############################################

#判断参数输入是否正确
if [ $# -ge 3 ] || [ $# -eq 1 ];then
	echo -e "请输入两个参数"
        echo -e "例如:mysqld 3306"
        exit 1
elif [ $# -eq 2 ]  ;then
	#使用grep判断输入参数是字母还是数字
	if grep '^[[:digit:]]' <<<"$2" &>/dev/null && grep '^[[:alpha:]]' <<<"$1" &>/dev/null;then
        	server=$1
		port=$2
	else
		echo -e "请正确输入两个参数"
        	echo -e "例如:mysqld 3306"
        	exit 1
		
	fi
else
		echo -e "请输入两个参数"
        	echo -e "例如:mysqld 3306"
        	exit 1
fi

#echo server:$server port:$port
reloaded=1

#如果服务不在重新拉起服务
#计算服务名出现次数,注意这里最少会出现3次
#grep一次，bash ./server.sh 一次,ser_gone赋值又一次。
ser_gone=`ps -ef | grep  -o -w "$server"  |awk '{count++} END{print count}'`
#echo ser_gone:$ser_gone
if [ $ser_gone -eq 3 ];then
	echo "server have gone!!! rebooting...."
	#此环境中起mysqld
	/usr/local/mysql56/bin/mysqld_safe --defaults-file=/home/aiapple/mysqldata/my.cnf
fi

#当然你也可以接受进程号，以进程号来判定服务是否在
#这里只是shell脚本编码的练习
