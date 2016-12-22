#!/bin/bash 
#############################################
##
#文件名: connect_mysql.sh
#作者名: aiapple
#时间  : 2016-12-22
#简介  :  
##
#############################################

#config
#
USER='root'
PWD='000000'
PORT='3306'
SCKT='/home/aiapple/mysqldata/node1/mysql.sock'

connect_and_create_database() 
{
#	mysql -u$USER -p -P $PORT --socket=$SCKT << EOF 
	mysql -u$USER -p$PWD -P $PORT --socket=$SCKT << EOF 2> /dev/null 
        DROP DATABASE IF EXISTS zane;
	create database zane;
EOF
	[ $? -eq 0 ] && echo Created DB || echo DB already exist 
}

create_table() {

	mysql -u$USER -p$PWD -P $PORT --socket=$SCKT << EOF 2> /dev/null 
	use zane;
        DROP TABLE IF EXISTS stu;
	create table stu(
	id int(10) ,
	name varchar(5),
	number int(10)
	);
EOF
	[ $? -eq 0 ] && echo Create table stu suceesed || echo Created table failed 

}

connect_and_create_database

create_table

#果然每次都需要重新登陆
#确实是脚本无法保持连接
#还是用用python之类的
#当然特定场景还是很好用的

