#!/bin/bash 

#############################################
##
#文件名: login_notify.sh
#作者名: aiapple
#时间  : 2016-11-07
#简介  : 
##
#############################################


user_logined=1
user_logouted=1
#如果有用户登陆则发邮件
if [ $user_logined==1 ];then
	 mail -s "someone login the server" root < $REPORT_FILE
fi

if [ $user_logouted==1 ];then
	 mail -s "someone logout the server" root < $REPORT_FILE
fi

