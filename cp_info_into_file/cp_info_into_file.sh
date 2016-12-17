#!/bin/bash 

#############################################
##
#文件名: cp_info_into_file.sh #作者名: aiapple
#时间  : 2016-11-01
#简介  : 自动拷贝指定类型文件内容到同一文件 
##
#############################################

#默认目录和文件
my_base_path=/home/aiapple/git/my-bash-shell

my_readmd=/home/aiapple/git/my-bash-shell/README.md

files=`tree -if $my_base_path`

#如果存在则询问是否删除
#
if ! test -d info_bk;then
	info_bk=`mkdir info_bk`
else
	echo -e "目录已存在"
	read -s -p "删除:d,更新:p" -t 5 -n 1 input
	echo -e "\t"
	if [ $input == 'd' ];then
		#echo "this is d"
		rm -rf info_bk
		rm -rf $my_readmd
		
		touch $my_readmd
		info_bk=`mkdir info_bk`
		
		echo -e "# My-bash-shell"        		          >> $my_readmd
		echo -e "bash shell 脚本使用记录"         	    	  >> $my_readmd
		echo -e ""			         		  >> $my_readmd
		echo -e "简介"                 				  >> $my_readmd
		echo -e "每个脚本都放在单独目录中，清晰可见" 		  >> $my_readmd
		echo -e "以实际应用场景为基础的脚本代码" 		  >> $my_readmd
		echo -e "" 		  				  >> $my_readmd
		echo -e "包含背景需求，功能介绍，使用介绍 ---> xxx.readme" 		   >> $my_readmd
		echo -e "代码实现                         ---> xxx.sh    "                 >> $my_readmd
		echo -e ""			         		                   >> $my_readmd
	fi
		
fi

for file in $files
do
	#提取文件类型名
	lastname=${file##*.}	
	#提取文件名不含目录
	realname=${file##*/}
	if [ $lastname == 'readme' ];then
		
		#排除info_bk目录本身
		#echo $file &> /dev/null | grep 'info_bk'
		echo $file | grep 'info_bk' &>/dev/null
		if [ $? == 1 ];then
			
			#判断info_bk中是否已有文件
			#没有则,拷贝文件,追加内容
			#新增文件,追加在后面
			if ! test -f info_bk/$realname;then
				#拷贝文件到目录,并追加内容
				cp -ar $file info_bk
				cat $file >> $my_readmd 
				#添加结束标制
				echo -e "======================================================================================\n\n" &>/dev/null >>$my_readmd
			else
				diff $file info_bk/$realname &>/dev/null
				#有旧文件$,但没有更新,则退出本次循环
				if [ $? == 0 ];then    	
					#echo -e "有旧文件$realname,但没有更新,退出\n"
					continue	
				else 
				   	#有旧文件,且已经更新,则删除旧内容,追加新内容
				        #如有多个内容 仅能删除一个,略显不足
					#echo -e "删除realname=$realname,my_reamd=$my_readmd"
					sed  -i "/^##This is $realname/,/============/d" $my_readmd 


					#删除旧文件,复制新文件,并追加内容
				        rm -rf info_bk/$realname
					cp -ar $file info_bk
					cat $file >> $my_readmd 
					#添加结束标制
				   	echo "$realname 已经更新内容"
					echo -e "======================================================================================\n\n" &>/dev/null >>$my_readmd
				fi
				
			fi
		fi
	fi
done
