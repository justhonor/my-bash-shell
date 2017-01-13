#!/bin/bash 

#############################################
##
#文件名: find_max10file.sh
#作者名: zane
#时间  : 2016-12-20
#简介  : 
##
#############################################

BASEDIR=~/git/my-bash-shell/find_max10file/cc

filenums=3

echo -e "The top $filenums files are coming!"
find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk '{print}'
allfiles=`find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk '{print $2}' &>/dev/null`

#echo $allfiles
delete_allfile() {
    for i in `seq 1 $filenums`;do
    	fullname[$i]=`find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk 'NR=='$i'{print $2}'`
    	#echo -e "this is fullname: ${fullname[$i]}"

    	basename[$i]=`basename ${fullname[$i]}`
    	#echo -e "this is basename: ${basename[$i]}"
	
	echo -e "正在删除:${basename[$i]}"	
	
	rm -rf ${fullname[$i]}
	if [ $? -eq 0 ];then
		echo "........."
		echo "....."
		echo "删除成功"
		echo 
	else
		echo "删除失败"
		exit 1
	fi
    done
    
}

delete_file() {
    for i in `seq 1 $filenums`;do
    	fullname[$i]=`find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk 'NR=='$i'{print $2}'`
    	#echo -e "this is fullname: ${fullname[$i]}"

    	basename[$i]=`basename ${fullname[$i]}`
    	#echo -e "this is basename: ${basename[$i]}"

	if [ $1 == ${fullname[$i]} ] || [ $1 == ${basename[$i]} ];then
		rm -rf ${fullname[$i]}
		if [ $? -eq 0 ];then
			echo "........."
			echo "....."
			echo "删除成功"
			exit 0
		else
			echo "删除失败"
			exit 1
		fi
	fi
    done
    
    echo -e "Error delete file not exsit!!!"
    exit 1
}

backup_file() {

    file_exsit=0
    for i in `seq 1 $filenums`;do
    	fullname[$i]=`find $BASEDIR -type f -exec du -k {} \; | sort -nr  | head -$filenums | awk 'NR=='$i'{print $2}'`
    	#echo -e "this is fullname: ${fullname[$i]}"

    	basename[$i]=`basename ${fullname[$i]}`
    	#echo -e "this is basename: ${basename[$i]}"

	if [ $1 == ${fullname[$i]} ] || [ $1 == ${basename[$i]} ];then
    		#判断指定备份目录是否存在
   		#不存在则创建目录
    		if ! test -d $2;then
			mkdir $2
			echo -e "directory not exsit,created"
    		fi
		cp -ar ${fullname[$i]} $2/${basename[$i]}
		if [ $? -eq 0 ];then
			echo "........."
			echo "....."
			echo -e "backup done!!"
			exit 0
		else
			echo "backup failed!!"
			exit 1
		fi
	fi
    done

    echo -e "Error backup file not exsit!!!"
    exit 1
    
}

print_help() {
	echo 
	echo   "这是操作选项:"
	echo   "               a          删除查询文件"
	echo   "               d filename 删除指定文件"
	echo   "               b filename directory 备份指定文件到指定目录"
	echo   "直接回车，结束脚本....."
	echo 
}

print_help
read -t 50 op filename directory

#echo input op:$op  input filename:$filename 

#read 判断输入回车方式
if   [ -z $op ];then
	echo -e "查询完毕...."
elif [ $op == 'a' ];then
	#echo "正在删除....."
	delete_allfile
elif [ $op == 'd' ];then
	echo -e "正在删除 $filename"
        delete_file $filename
elif [ $op == 'b' ];then
	echo -e "正在备份 $filename"
	backup_file $filename $directory
else 
	echo -e "请正确使用"
	#print_help
fi
