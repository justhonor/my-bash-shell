#!/bin/bash 

#############################################
##
#文件名: remove_duplicats.sh
#作者名: zane
#时间  : 2016-12-26
#简介  : 
##
#############################################

#ls -lS | awk 'BEGIN {
#	getline;getline;
#	name1=$9;size=$5
#}
#{
#	name2=$9;
#	if ( size==$5 )
#	{
#		"md5sum "name1 | getline; csum1=$1;
#		"md5sum "name2 | getline; csum2=$1;
#	
#		if ( csum1==csum2 )
#		{
#			print name1;print name2;
#		}
#	};
#
#	size=$5;name1=name2;
#}'

ls -lS | awk 'BEGIN {
	getline;getline;
	name1=$9;size=$5
}
{
	name2=$9;
	if ( size==$5 )
	{
		"md5sum "name1 | getline; csum1=$1;
		"md5sum "name2 | getline; csum2=$1;
	
		if ( csum1==csum2 )
		{
			print "this is name1:"name1;
			print "this is name2:"name2;
		}
	};

	size=$5;name1=name2;
}'


#ls -lS | awk 'BEGIN{getline;} {system("md5sum "$9)}' >duplicate_files

