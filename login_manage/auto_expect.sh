#!/usr/bin/expect 

#############################################
##
#文件名: auto_expect.sh
#作者名: aiapple
#时间  : 2016-11-03
#简介  : 接收用户名,密码,地址实现ssh自动登陆
##
#############################################

set timeout 10 
set user  [lindex $argv 0 ]
set pwd   [lindex $argv 1 ]
set addr  [lindex $argv 2 ]
set count $argc

#spawn echo "the user is $user\n"
#interact
#spawn echo "the pwd is $pwd\n"
#interact
#spawn echo "the addr is $addr\n"
#interact
#spawn echo "the count is $count\n"

#很重要直接导致命令能否执行成功以及能否继续执行。
#一个spawn对应一个interact
#interact

if {$count!=3} {
	spawn	echo "请正确使用！"
	interact
	spawn   echo "bash auto_expect.sh user passwd ip" 
	interact
#	spawn   exit 0
}

spawn ssh $user@$addr
#expect("password")
expect "password"
send "$pwd\n"
interact
spawn exit 
interact
