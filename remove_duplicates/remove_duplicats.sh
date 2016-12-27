#!/bin/bash 

#############################################
##
#文件名: remove_duplicats.sh
#作者名: zane
#时间  : 2016-12-26
#简介  : 
##
#############################################


#有些版本的awk "md5sum "name1 | getline; 出错
ls -lS | awk 'BEGIN {
	getline;getline; #BEGIN得到第一行
	name1=$9;size=$5
}
{
	name2=$9;        #awk从第二行开始读去数据
	if ( size==$5 )  #如果大小一样,md5校验码一样就打印出来
	{
		"md5sum "name1 | getline; csum1=$1;
		"md5sum "name2 | getline; csum2=$1;
	
		if ( csum1==csum2 )
		{
			printf "相同文件:%s %s\n",name1,name2;
		}
	};

	size=$5;name1=name2; #递推比较,即第二行和awk即将读取的第三行比较
}' | sort > duplicate_files
 
#删除后一个文件
duplicates=`cat duplicate_files | awk '{print $NF}'`
rm $duplicates duplicate_files

####################方法二###############################
#ls -lS | awk '{print $NF}' | tail -n +2 > file_name.t 
#
##生成对应md5校验码
#while read filename;
#do
#	sum=`md5sum $filename`
#	echo -e "$sum" >> md5sum.t
#done < file_name.t
#
##寻找重复文件
#while read mdsum_file;
#do
#	mdsum=`echo $mdsum_file | cut -d " " -f1`
#	file=`echo $mdsum_file | cut -d " " -f2`
#	num=`grep "$mdsum" md5sum.t | wc -l`
#	
#	#如有重复的md5码则,删除正在做查询的文件
#	#并删除比较文件md5sum.t中对应的行
#	if [ $num -gt 1 ];then
#		#echo -e "delete:" $file
#		rm $file
#		sed -i "/ $file/"d md5sum.t
#	fi	
#done< <(cat md5sum.t)
#
#rm md5sum.t
#rm file_name.t
