#!/bin/bash 

#############################################
##
#文件名: login_notify.sh
#作者名: aiapple
#时间  : 2016-11-07
#简介  : 
##
#############################################


user_logined=0
reported=1

#NR 控制处理的行数
###################################虚拟机模拟##########
#########################除去tty登陆更接近真实环境#####
a=`who`
NF=`echo $a | awk '{print NF}'`
let NF=$NF-4
#echo -e "NF:$NF"
let NR=NF/5
#echo -e "NR:$NR"
user_number=1

#取出当前用户信息
for ((i=0;i<$NF;i=$i+1));do
	let j=$i+5
	user[$i]=`echo $a | awk '{print $'$j'}'`
	#echo ${user[$i]}
done
#echo "length:${#user[@]}"
#echo 24:${user[24]}
#echo "元素:${user[*]}"
#####################################################
<<COMMENTBLOCK
NR 控制处理的行数
################################服务器环境######
a=`who`
NF=`echo $a | awk '{print NF}'`
let NR=NF/5
echo -e "NR:$NR"
user_number=1
取出当前用户信息
for ((i=0;i<$NF;i=$i+1));do
	let j=$i+1
	user[$i]=`echo $a | awk '{print $'$j'}'`
	#echo ${user[$i]}
done
################################################
COMMENTBLOCK
USERS=$NR

#记录现在的登陆信息
for ((i=0;i<$USERS;i++));do

	#记录已登陆信息
	echo -n " ${user[`expr $i*5+0`]} ${user[`expr $i*5+2`]}" >> new_info
	echo -e " ${user[`expr $i*5+3`]} ${user[`expr $i*5+4`]}">>new_info
done	

#与对比文件中登陆信息对比判断是否要发送邮件
#如需发送邮件，则将邮件内容写到reprot_file中
if ! test -e old_info;then
	cp -ar new_info old_info
	#发送邮件
	user_logined=1
	echo -e "Warning someone have login your server!!!" >> Report.t
	
	#将所有登陆信息记录到Report.t
       	for ((i=0;i<$USERS;i++));do

		#user(user pts date time ip user pts date time ip .....)
		#间隔为5,假想成二维数组:行为i 列为j user[i][j]=i*len+j
		let j=$i+1
		echo -n " $j  User:${user[`expr $i*5+0`]} Date:${user[`expr $i*5+2`]}" >>Report.t
		echo -e " Time:${user[`expr $i*5+3`]} IP:${user[`expr $i*5+4`]}">>Report.t

		
	done	
else
	#对比信息确定是否需要发送邮件

	#计算old_info记录数
	aa=`cat old_info`
	nf=`echo $aa | awk '{print NF}'`
        let nr=nf/4

       	for ((i=0;i<$USERS;i++));do
		#一条条记录比较
		#有一条新记录和所有旧记录都不同则发送邮件
		for ((j=1;j<=$nr;j++)) ;do
			User=`cat old_info | awk 'NR=='$j' {print $1}'`
			Date=`cat old_info | awk 'NR=='$j' {print $2}'`
			Time=`cat old_info | awk 'NR=='$j' {print $3}'`
			Ip=`cat old_info | awk 'NR=='$j' {print $4}'`
			if [ $User == ${user[`expr $i*5+0`]} ] && [ $Date == ${user[`expr $i*5+2`]} ] && [ $Time == ${user[`expr $i*5+3`]} ] && [ $Ip == ${user[`expr $i*5+4`]} ];then

				#新记录与老记录相同则跳出本次循环
				reported=0
				#echo -e "新老相同跳出"
				break
			else
				reported=1
				#echo -e "Maybe there coming a new user"
				
			fi
		done

		if [ $reported -eq 1 ];then
			reported=0
			user_logined=1
			echo -e "有新登陆用户"
			echo -e "Warning someone have login your server!!!" >> Report.t
			echo -n " $j  User:${user[`expr $i*5+0`]} Date:${user[`expr $i*5+2`]}" >>Report.t
			echo -e " Time:${user[`expr $i*5+3`]} IP:${user[`expr $i*5+4`]}">>Report.t
		fi
	done	
	
fi 

#如果有用户登陆则发邮件
if [ $user_logined -eq 1 ];then
	 echo -e "发送邮件"
	 mail -s "someone login the server" root < Report.t
fi
#用现在的登陆信息替换原来的
rm -rf old_info
mv new_info old_info
rm -rf Report.t
