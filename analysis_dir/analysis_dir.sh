#!/bin/bash 

#############################################
##
#文件名: analysis_dir.sh
#作者名: aiapple
#时间  : 2016-10-28
#简介  : 
##
#############################################

#文件计数器
filenum=0

#默认n=100 
#指定目录为当前目录下的copy
lines=100
dir=~/morelines

#创建目录
if ! test -d $dir;then
	mkdir $dir
fi

#判断参数是否正确，并使用
if [ $# == 2 ] && [ -r $1 ];then
	if [ $2 == '-l' ];then
		echo   'analysis'
	else
		dir=`pwd`/$2
	fi
elif [ $# == 3 ] && [ -r $1 ];then
	expr $3 + 3 &>/dev/null 
	if [ $? -eq 0 ];then
		lines=$3
		dir=`pwd`/$2
	else 
		echo "请正确使用！"
		echo "analysis_dir.sh {source_dir_name} [-l] [dir] [n]"
	fi
elif [ $# == 1 ] ;then
	if [ -r $1 ];then
		echo   'analysis'
	else
		echo "请正确使用！！"
		echo "analysis_dir.sh {source_dir_name} [-l] [dir] [n]"
		exit 2 
	fi
else
	echo "请正确使用！！！"
	echo "analysis_dir.sh {source_dir_name} [-l] [dir] [n]"
	exit 1

fi

#analysis()
#{
#
#
#}

echo "this is lines $lines"
echo "this is dir $dir"
#遍历文件目录，找出文本行超过n行的重命名
#复制到制定目录
filetree=`tree -if $1` 

FindFile()
{
	for file in $filetree
	do
		if [ -f $file ] ;then
	#		echo "this is file:" $file
	 		let filenum++	
			filelines=`wc -l $file | cut -d ' ' -f1`
			if [ $filelines -gt $lines ];then
				echo " there is $filelines lines in $file " 
				#提取文件名
				realname=${file##*/} 
				cp $file $dir/$realname
			fi
		#	echo "this is filenum" $filenum
		fi
	done
}

#FindFile
