#!/bin/bash 

#############################################
##
#文件名: active_users.sh
#作者名: aiapple
#时间  : 2016-12-21
#简介  : 
##
#############################################

WTMP=/var/log/wtmp

#去除still,crash,down等状态信息
#去除系统用户root,reboot等
#去除tty虚拟登陆

last -f $WTMP | head -n -2 | grep -v "still" | grep -v "down" \
| grep -v "crash" | grep -v "reboot" | grep -v "tty"> nlog

cat nlog | awk '{print $1}' | sort | uniq > users

cat nlog | sort | \
awk '
{users[$1]++;}
END{
	for(user in users)
	{
		print user " "users[user];
	}
   }' > UsersAndTimes 

#echo -e "users:"
#cat users
#查找首次登陆和上次登陆的时间
#
printf "%-4s %-8s %-15s %-15s %-5s\n" "Rand" "User" "StartTime" "LastTime" "Mins"
(
while read user;
do
	#echo this user is: $user
	firstlog=`grep "$user" nlog | tail -n 1 |awk '{print $5 " "$6 " " $7}'`
	lastlog=`grep "$user" nlog | head -n 1 |awk '{print $5 " "$6 " " $7}'`

	minutes=1
	grep "$user" nlog | awk '{print $NF}' | tr -d ')(' > TIME 
	while read time;
	do
		s=`echo $time | awk -F: '{print $1*60+$2}'`
		let minutes=$minutes+s
	done < TIME	

	Times=`grep "$user" UsersAndTimes | awk '{print $2}'`

	printf "%-8s %-15s %-15s %-5s\n" "$user" "$firstlog" "$lastlog" "$minutes"

done < users
) | sort -nk 4 | awk '{ printf("%-4s %s\n",NR,$0) }'

rm nlog TIME  users  UsersAndTimes
#新的结构,新的思想,值得理解
#只是在代码上不易理解，但确实方便快速许多

#while read user
#do
#done < users
#从文件中按行读取

#awk '{ printf("%-4s %s\n",NR,$0) }'
#在输出的整体前增加序列,
#简直神器

