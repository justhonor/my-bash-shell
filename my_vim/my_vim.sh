#!/bin/bash

#########################################
##
#文件名: my_vim.sh
#作者名: zane
#时间  : 2016-10-27
#简介  : 创建脚本时自动添加固定格式
##         
#########################################


#判断参数输入是否正确
if [ $# -gt 3 ] ;then
	echo "请正确使用"
	echo "请输入正确文件名:xxx.sh xxx.py xxx.readme"
	exit 1
elif [ $# -eq 3 ] && [ $2 == '-d' ];then
	filename=$1
	describe=$3
elif [ $# -eq 1 ]  ;then
	filename=$1
else 
	echo "请正确使用"
	echo "请输入正确文件名:xxx.sh xxx.py xxx.readme"
	exit 
fi

#截取脚本名后缀
lastname=$(echo $1 | cut -d '.' -f2)
#echo $lastname

IsShell()
{

echo "#############################################" >> $filename
echo "##" >> $filename
echo "#文件名: $filename" >> $filename
echo "#作者名: $(whoami)" >> $filename
echo "#时间  : $(date +%F)" >> $filename
echo "#简介  : $describe" >> $filename
echo "##" >> $filename
echo "#############################################" >> $filename
chmod a+x $filename
	vim $filename
}

IsReadMe()
{

echo -e "背景需求 \n" >> $filename
echo -e "功能介绍 \n" >> $filename
echo -e "使用介绍 \n" >> $filename
echo -e "测试 \n"     >> $filename
	vim $filename

}

#判断文件是否存在
#存在则询问是删除继续还是退出
if [ -e $1 ] ;then 
        read -s -p "该文件已存在,删除继续:m 退出:q" -t 10  -n 1 input
	if [ $input == 'm' ] ;then
		echo -e "\nthis is m"
		rm -rf $1
	elif [ $input == 'q' ];then
		echo -e "\nthis is q"
		exit 0
	else
		echo -e " \n 输入错误"
		exit 3 
		
	fi
fi

#判断是bash/python/readme文件
if [ $lastname == 'py' ] ;then
	####可增加逻辑型增加
	####如果文件存在则询问是否要删除
	echo -e "#!/usr/bin/python \n" >> $1
	IsShell
elif [ $lastname == 'sh' ] ;then
	echo -e "#!/bin/bash \n" >> $1
	IsShell
elif [ $lastname == 'readme' ] ;then
	echo -e "#This is $filename \n" >> $1
	IsReadMe
else
	echo "请输入正确文件名:xxx.sh xxx.py xxx.readme"
	exit 2
fi
