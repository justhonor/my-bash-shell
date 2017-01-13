#!/bin/bash 

#############################################
##
#文件名: login_manege.sh
#作者名: aiapple
#时间  : 2016-11-01
#简介  : 别名登陆以及管理功能 
##
#############################################

#配置文件不存在则创建
if ! test -f server.cnf;then
	echo "Alias_name User Passwd Ip" > server.cnf
fi

help_()
{
	echo -e "使用介绍:\n"
	echo -e "登陆\nlogin_manage.sh -i  alias_name\n"
	echo -e "添加\nlogin_manage.sh -a alias_name user passwd ip\n"
	echo -e "删除\nlogin_manage.sh -d [ip|alias_name]\n"
	echo -e "更改别名\nlogin_manage.sh -c source_alias_name destiant_alias_name\n"
	echo -e "帮助\nlogin_manage.sh -h\n"
	echo -e "查看\nlogin_manage.sh -l\n"
}

if [ $# == 5 ];then
	#添加
	if [ $1 == '-a' ];then
		server="$2 $3 $4 $5"

		#判断是否存在，不存在则写入配置文件
		have_alias=0
		have_ip=0
		
		alias_name=`cat server.cnf | cut -d ' ' -f1`
		for name in $alias_name;do
			if [ $name == $2  ];then
				#别名已存在
				have_alias=1
			fi
		done

		ip_name=`cat server.cnf | cut -d ' ' -f4`
		for name in $ip_name;do
			if [ $name == $5  ];then
				#地址已存在
				have_ip=1
			fi
		done
		echo "this is alias:$have_alias"
		echo "this is ip:$have_ip"

		if [ $have_ip == '1' ];then
			echo "地址已存在,请察看！"	
			exit 1 
		elif [ $have_alias == '1' ];then
			echo "别名已存在,请更换别名！"
			exit 1 
		else
			#地址和别名都不存在则写入配置文件
			echo $server >> server.cnf
		fi
	else
		echo "请正确使用！"
		help_
	fi
elif [ $# == 2 ];then
	#删除
	if [ $1 == '-d' ];then
		server="$2"
		#如果alias_name输入不完全则会删除匹配的所有机器
		#删除alias_name匹配的行
		sed -i "/^$server/d" server.cnf

		#删除ip结尾的行
		sed -i "/$server$/d" server.cnf
	#登陆
	elif [ $1 == '-i' ];then
		#如果别名存在则执行登陆

		#别名集合
		alias_name=`cat server.cnf | cut -d ' ' -f1`
		
		for name in $alias_name;do
			if [ $name == $2  ];then
				#别名存在,取出登陆参数
				login_parameter=`cat server.cnf | grep "^$2" | sed  "s/^$2//g "`
				#echo "this is login_parameter:$login_parameter"
				
				#判断网络是否同,不同则退出
				ip=`echo $login_parameter | cut -d ' ' -f3`
				#echo "this is ip:$ip"
				echo "准备登陆$name,IP:$ip"
				ping $ip -c 3 &>/dev/null
				if [ $? != 0 ];then
					echo "网络不通，请检查网络！"
					exit 0
				else
					echo "网络畅通。。。。。"
					echo "执行登陆程序"
					./auto_expect.sh $login_parameter 
					#登陆脚本是否成功登陆无法得知
					#只能知道登陆脚本是否执行成功
					#echo "result:$?" > result.t
					exit 0
				fi
			fi
		done

		echo "机器尚未添加，请添加机器！"
		exit 0
	else
		echo "请正确使用！！"
		help_
	fi
elif [ $# == 3 ];then
	#更改别名
	if [ $1 == '-c' ];then
		#如果别名存在则改名
		alias_name=`cat server.cnf | cut -d ' ' -f1`
		for name in $alias_name;do
			if [ $name == $2  ];then
				echo "更改别名"
				sed -i "s/^$2/$3/g" server.cnf
				exit 0
			fi
		done
		
		echo "尚未有该别名，请添加！"
		exit 0
	else
		echo "请正确使用！！！"
		help_
	fi
elif [ $# == 1 ];then
	#察看
	if [ $1 == '-l' ];then
		cat server.cnf 
	#帮助
	elif [ $1 == '-h' ];then
		help_
	else
		echo "请正确使用！！"
		help_
	fi
else
	echo "请正确使用！！！！"
	help_

fi

