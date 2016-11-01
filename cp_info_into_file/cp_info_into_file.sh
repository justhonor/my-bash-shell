#!/bin/bash 

#############################################
##
#文件名: cp_info_into_file.sh
#作者名: aiapple
#时间  : 2016-11-01
#简介  : 自动拷贝指定类型文件内容到同一文件 
##
#############################################

#默认目录和文件
my_base_path=/home/aiapple/git/my-bash-shell

my_readmd=/home/aiapple/git/my-bash-shell/README

files=`tree -if $my_base_path`


#如果存在则询问是否删除
#
if ! test -d info_bk;then
	info_bk=`mkdir info_bk`
else
	read -s -p "目录已存在删除重建:d,继续:p" -t 5 -n 1 input
	echo -e "\n"
	if [ $input == 'd' ];then
		echo "this is d"
		rm -rf info_bk
		info_bk=`mkdir info_bk`
	fi
		
fi

#diff()
#{

#没有更新，则退出
#有更新，则继续

#}

for file in $files
do
	#提取文件类型名
	lastname=${file##*.}	

	if [ $lastname == 'readme' ];then
		#比较新旧文件
		#diff
		
		#排除info_bk目录本身
		#echo $file &> /dev/null | grep 'info_bk'
		echo $file | grep 'info_bk'
		if [ $? == 1 ];then
			#拷贝最新文件,作为比较文件
			cp -ar $file info_bk
			echo -e "has cp \n"
			#追加内容至指定文件
			cat $file >> $my_readmd
		fi
	fi
done
