#!/bin/bash 

#############################################
##
#文件名: intruder_detect.sh
#作者名: zane
#时间  : 2016-12-21
#简介  : 
##
#############################################

AUTHLOG=auth.log 
TOPN=2

#AddHostName=0
#except invalid user and find the intruders
#
#users=`grep -v "invalid" auth.log | grep "Failed password" | awk '{print $(NF-5)} ' | sort | uniq`

#整理日志文件
#月 日 时间 账户 地址 主机名
grep -v "invalid" auth.log | grep "Failed password" | awk '{print $1 " " $2 " " $3 " " $9 "  " $11} ' > log
#grep -v "invalid" auth.log | grep "Failed password" | awk '{print $1 " " $2 " " $3 " " $9 " " $11} '| head > log

lines=`cat log | wc -l`
echo -e "lines:$lines"

#给每行尾增加主机名
#无需在整理日志的时候增加
#在最终报告的时候给出即可
#if $AddHostName;then
#	for ((i=1;i<=$lines;i++))
#	do
#		#get  hostname
#		ip=`cat log | awk 'NR=='$i'{print $NF}'`
#		#echo -e "ip:$ip"
#		hosts[$i]=`host $ip | awk '{print $NF}'`
#		#echo -e "hosts$i:${hosts[$i]}"
#	
#		#insert hostname
#		sed -i "$i s/$/ ${hosts[$i]}/g" log
#	done
#fi

#统计登陆次数TOPN多的ip 
#
cat log | \
awk '
{IPS[$5]++;}
END{
	for (i in IPS)
	{
		print i,IPS[i];
	}

}' | sort -nrk 2 | head -n $TOPN > IpAndNums.t

#在log中找到TOPN ip对应的所有的 users
#
printf "%-5s|%-10s|%-10s|%-16s|%-13s|%s\n" "Sr#" "USERS" "TIMES" "IP address" "Host name" "Time range"
for ((i=1;i<=$TOPN;i++))
do
	IPS[$i]=`cat IpAndNums.t | awk ''NR==$i'{print $1}'`
	TIMES[$i]=`cat IpAndNums.t | awk ''NR==$i'{print $2}'`
	HOST[$i]=`host ${IPS[$i]}|awk '{print $NF}'`
        #echo -e "IPPPP:${IPS[$i]}"	

	users=`cat log | grep "${IPS[$i]}" | awk '{print $4}'| uniq`
	#echo -e "users:"
	echo -e "$users" > users
	usernums=`cat users| wc -l`
	#echo -e "usernums:$usernums"

	#根据IP和username,找到登陆时间段
	for ((ii=1;ii<=$usernums;ii++))
	do
		#echo -e "this is for"
		USER=`cat users | sed -n ''$ii'p'`
		#echo -e uses$1:$USER
		stat=`cat log | grep "$USERT.*$IPS"| head -1 | awk '{print $1 " " $2 " " $3 }'`	
		end=`cat log | grep "$USERT.*$IPS"| tail -1 | awk '{print $1 " " $2 " " $3 }'`	
		TimeRange="$stat -->$end"
		printf "%-5s|%-10s|%-10s|%-16s|%-13s|%s\n" "$i" "$USER" "${TIMES[$i]}" "${IPS[$i]}" "${HOST[$i]}" "$TimeRange"
		
	done
	#echo -e "执行下次循环"
done

rm IpAndNums.t
rm log
#rm users
