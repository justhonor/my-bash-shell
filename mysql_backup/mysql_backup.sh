#!/bin/bash 

#############################################
##
#文件名: mysql_backup.sh
#作者名: zane
#时间  : 2016-12-19
#简介  : 
##
#############################################

USER='root'
PWD='000000'
DF_FILE='/home/aiapple/mysqldata/my.cnf'
BCK_DIR='dbbackup'

PROGNAME=`basename $0`

OPTIONS="--user=$USER --password=$PWD --defaults-file=$DF_FILE "

debug=1
#all:全量 
#inc_dir 指定增量备份的参照，即某个全量              
#inc    --incremental 增量
#comps  --compress    压缩 
#paral  --parallel=4  并行线程 4
#throt  --throttle=10 限流 10M
#注意：并行和限流都有两个参数
use_all=1
use_inc=0
inc_dir=0
use_comps=0
comps_num=0
use_paral=0
paral_num=0
use_throt=0
throt_num=0

#create backup directory
#
if ! test -d $BCK_DIR;then
     echo this create directory
     mkdir $BCK_DIR
fi

print_usage() {
  echo "Usage: $PROGNAME [options]"
  echo "  e.g. $PROGNAME -a -c 2 -p 4 -t 10 "
  echo "  e.g. $PROGNAME -i dbbackup/2016-08-20_06-16-26 -c 2 -p 4 -t 10 "
  echo
  echo "Options:"
  echo -e "\t --help                   | -h       print help"
  echo -e "\t --verbose                | -v       be verbose (debug mode)"
  echo -e "\t --all                    | -a       using full backup"
  echo -e "\t --incremental  [dir]     | -i [dir] using incremental backup"
  echo -e "\t --compress     [int]     | -c [int] using compress function"
  echo -e "\t --parallel     [int]     | -p [int] using parallel function"
  echo -e "\t --throttle     [int]     | -t [int] using throttle function"
  echo
  echo
}

print_help() {
  echo "This is mysql backup using innobackupex"
  echo
  print_usage
  echo
}

#判断参数是否为数字
#不是则退出
is_digit() {
	if grep '^[[:digit:]]' <<<"$1" &>/dev/null;then
		echo -e "Input a digit!" &>/dev/null 
	else
		echo -e  "Input digit error!\n"
		print_help
		exit 4	
	fi	
}

is_dir() {
	if test -d $1;then
		echo -e "Input a dir!" &>/dev/null
	else
		echo -e  "Input dir error!\n"
		print_help
		exit 5	
		
	fi
}

parse_options() {
# parse cmdline arguments
  (( DEBUG )) && echo "Parsing options $1 $2 $3 $4 $5 $6 $7 $8"
  if [ "$#" -gt 0 ]; then
    while [ "$#" -gt 0 ]; do
      case "$1" in
        '--help'|'-h')
          print_help
          exit 3
          ;;
        '--verbose'|'-v')
          DEBUG=1
          shift 1
          ;;
        '--all'|'-a')
          use_all=1
          shift 1 
          ;;
	'--increment'|'-i')
	  is_dir $2
	  use_inc=1
	  inc_dir="$2"
	  shift 2
	  ;;
	'--compress'|'-c')
	  is_digit $2
	  use_comps=1
	  comps_num="$2"
	  shift 2
	  ;;
        '--parallel'|'-p')
	  is_digit $2
	  use_paral=1
	  paral_num="$2"
          shift 2
          ;;
	'--throttle'|'-t')
	  is_digit $2
	  use_throt=1
	  throt_num="$2"
	  shift 2
	  ;;
        *)
          echo "Unknown option!"
          print_usage
          exit 3
          ;;
      esac
    done
  else
	echo "Incorrect option numbers!"
	print_usage
  fi
}


assemble_options() {
	#using incremental
	if [ $use_inc -eq 1 ];then
		OPTIONS=$OPTIONS"--incremental --incremental-dir $inc_dir "	
	fi	

	#using parallel
	if [ $use_paral -eq 1 ];then
		OPTIONS=$OPTIONS"--parallel=$paral_num "	
	fi	

	#using throttle
	if [ $use_throt -eq 1 ];then
		OPTIONS=$OPTIONS"--throttle=$throt_num "	
	fi	
	
	#using compress
	if [ $use_comps -eq 1 ];then
		OPTIONS=$OPTIONS"--compress --compress-thread $comps_num "	
	fi	
}


####################
#	MAIN
####################
parse_options $@ 
assemble_options
#echo -e "options:\n $OPTIONS"

#you should have mysql-server 
innobackupex-1.5.1 $OPTIONS $BCK_DIR
