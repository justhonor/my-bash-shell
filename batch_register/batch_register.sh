#!/bin/bash 

#############################################
##
#文件名: batch_register.sh
#作者名: zane
#时间  : 2016-12-27
#简介  : 
##
#############################################

PROGNAME=`basename $0`

print_help() {
	echo -e
	echo -e "使用说明: "
	echo -e "            $PROGNAME 起始学号 学生数"
	echo -e "例子:  "
	echo -e "            $PROGNAME 222150000 4952"
	echo -e
}

#判断参数是否为数字
#不是则退出
is_digit() {
        if grep '^[[:digit:]]' <<<"$1" &>/dev/null;then
                echo -e "Input a digit!" &>/dev/null
        else
                echo -e "请输入数字！"
                print_help
                exit 4
        fi
}


addusers() {
	startnum=$1
	nums=$2
	for i in `seq 1 $nums`;
	do
		let num=$startnum+$i-1
		#echo -e "user:$num"
		
		if id $num &> /dev/null;then
			echo "$num 用户已存在！"
		else
			#创建用户密码
			useradd $num
			echo $num | passwd --stdin $num &>/dev/null
		
			#强制登陆修改密码
			chage -d 0 $num
		fi
	
	done
}

if [ $# -eq 2 ];then
	is_digit $1
	is_digit $2
else
	print_help
fi

addusers $1 $2
