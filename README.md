# my-bash-shell
bahs shell 脚本使用记录

简介
每个脚本都放在单独目录中，清晰可见；
以实际应用场景为基础的脚本代码；

包含背景需求，功能介绍，使用介绍 ---> xxx.readme

代码实现                         ----> xxx.sh


背景需求

##this is analysis_dir.readme
目录下面有N个文件和目录，且都是存放的是脚本文件；<br>
那么分析这些脚本的类型种类，总代码长度，平均代码长度等<br>
并想找出那些代码行数大于150行的脚本，命名后放到一个新目录中<br>

<br>
<br>
功能介绍

1.找出代码行数大于n行的脚本文件，并复制到指定目录<br>
  默认n=100;      指定目录：~/morelines;<br>


2.给出一些统计信息：<br>
	总共多少个脚本<br>
	共多少行代码<br>
	平均代码长度<br>
	最长有多长<br>
	最短有多长<br>
	注释平均占比<br>


使用介绍<br>

1.analysis_dir.sh {source_dir_name} [dir] [n]<br>


测试<br>

使用script目录作为例子<br>

aiapple@ubuntu:~/git/my-bash-shell/analysis_dir$ ./analysis_dir.sh script/ copy 150 <br>
 there is 217 lines in script/check_cpu.sh      <br>
 there is 217 lines in script/check_cpu.sh.bak  <br>
 there is 197 lines in script/check_mem.pl      <br>
 there is 167 lines in script/check_mem.sh      <br>
 there is 200 lines in script/check_mem.sh.bak  <br>
 there is 164 lines in script/rc.functions      <br>
共有38个脚本           <br>
共有1643行代码         <br>
平均有43.23行          <br>
最大的有217行          <br>
最小的有3行            <br>
注释有230行            <br>
注释占比13.00%         <br>

aiapple@ubuntu:~/git/my-bash-shell/analysis_dir$ ls -l copy/   <br>
ls: 初始化月份字符串出错<br>
总用量 44 <br>
-rwxrwxr-x 1 aiapple aiapple 6792 10�� 28 13:40 check_cpu.sh     <br>
-rwxrwxr-x 1 aiapple aiapple 6792 10�� 28 13:40 check_cpu.sh.bak <br>
-rwxrwxr-x 1 aiapple aiapple 6643 10�� 28 13:40 check_mem.pl     <br>
-rwxrwxr-x 1 aiapple aiapple 4435 10�� 28 13:40 check_mem.sh     <br>
-rwxrwxr-x 1 aiapple aiapple 5840 10�� 28 13:40 check_mem.sh.bak <br>
-rwxrwxr-x 1 aiapple aiapple 3511 10�� 28 13:40 rc.functions     <br>

======================================================================================


#this is cp_info_into_file.readme 

背景需求 

将指定类型文本的信息提取并加到指定文本中

例如：
有n个脚本readme文件，且在不同目录下.如/analysis_dir.readme且这些文件中都有背景信息,功能信息；此时要将这些背景信息和各自脚本名如analysis_dir.sh，都自动加到如README.md当中；


功能介绍 

1.遍历my-bash-shell目录找到xxx.readme文件

2.将xxx.readme内容添加到README.md中去

3.自动比较各文件是否更新如已经更新，则替换为最新的内容;

可扩展功能:
1.判断原文件是否在,如果原文件不在,则认为整个工程已删除,则也删除README.md中对应内容;


使用介绍 

./cp_info_into_file.sh 


测试 

aiapple@ubuntu:~/git/my-bash-shell/cp_info_into_file$ ./cp_info_into_file.sh 
目录已存在删除重建:d,更新:p

my_vim.readme 已经更新内容

======================================================================================


#this is login_manege.readme 

背景需求 

管理服务器的时候，难免要登陆到各机器去察看系统情况.
每次都需要IP 密码的输入 太重复.尤其是在短时间内，
退出登陆后，又要再此登陆，不断在输入 同样的IP，密码.

因此一个自动化登陆管理脚本是很有效果

功能介绍 


1.使用别名直接登陆:
	基于SSH
	判断网路是否通

2.管理登陆帐号
	添加:判断是否存在,判断网络是否通
	删除
	察看
	更改别名:先删再加，只是IP不删

3.察看使用帮助

问题：
1.密码此时是明文存在server.cnf文件中,显然不合适

2.ssh登陆尚不稳定

3.若某别名的前缀，与另一个别名一样，则无法正常登陆
如：
aliyun root shhsdhf 12.1.1.7
ali    root dawang  139.196.58.188
此时登陆aliyun,是可以的。但ali则会出错

4.登陆超时没有自动退出。

使用介绍 

登陆 
login_manage.sh -i  alias_name

添加
login_manage.sh -a alias_name user passwd ip 

删除
login_manage.sh -d [ip|alias_name]

更改别名
login_manage.sh -c source_alias_name destiant_alias_name

察看
login_manage.sh -l

使用帮助
login_manage.sh -h

测试 
aiapple@ubuntu:~/git/my-bash-shell/login_manage$ ./login_manege.sh -i ali
准备登陆ali,IP:139.196.58.188
网络畅通。。。。。
执行登陆程序
spawn ssh root@139.196.58.188
root@139.196.58.188's password: 
Welcome to Ubuntu 12.04.5 LTS (GNU/Linux 3.2.0-67-generic-pae i686)

 * Documentation:  https://help.ubuntu.com/
New release '14.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Welcome to aliyun Elastic Compute Service!

Last login: Sun Nov  6 19:10:56 2016 from 114.219.76.109
root@iZ11xkhdslnZ:~# 

======================================================================================


#this is login_notify.readme 

背景需求 

有人到你家里来你还不知道。
家里东西被搬光,你却不知道。
还是装个云摄像头吧。

功能介绍 

1.有人登陆系统则发邮件
	邮件内容：用户名,终端,时间,主机名
		  现在操作命令的历史文件
		  
2.有人退出系统则发邮件
	邮件内容：用户名,终端,时间,主机名
		  现在操作命令的历史文件
		  录制其操作的脚本文件


内容包括:
	录制其操作的脚本文件
	操作命令的历史文件
	登陆log文件:
		登陆时登陆中登陆后

分析:
#通过/var/log/auth.log监控用户登陆行为
#如果有用户登陆/退出则给root发邮件
#以登陆时间和用户来控制不重复发送

#每20秒统计一下信息
#可以使用cron任务调度

#上一次用户登陆状态
#与这此用户登陆状态

#root在/etc/profile 中添加script，并保存在/root目录中
#等到用户退出时将，录制文件，发送邮件。


使用介绍 

测试 

======================================================================================


#this is my_vim.readme

背景需求

脚本编写时总有固定的头格式：脚本解析器位置，脚本名，作者，时间，功能；等
每次都重复输入很多东西，是时候写个脚本改变这一切了；


功能介绍

1.根据脚本名称如my.sh,my.py
  自动生成脚本解析器位置，脚本名，作者，时间，

2.使用参数，输入功能简述;

3.如果是my.readme文件则
  自动生成:#this is file_name  背景需求  功能介绍  使用介绍 测试 

4.除基本功能外，还增加了输入参数检测，文件是否存在的交互等功能

5.在完成上述功能之后创建脚本之后，直接调用vim接口使之直接进入vim进程

使用介绍

1.my_vim.sh  my.py

2.my_vim.sh  my.py  [-d] "your describe"



测试

测试一：
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my.sh
#!/bin/bash 

#############################################
##
#文件名: my.sh
#作者名: zane
#时间  : 2016-10-27
#简介  : 
##
#############################################

测试二：
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my.py
#!/usr/bin/python 

#############################################
##
#文件名: my.py
#作者名: zane
#时间  : 2016-10-27
#简介  : 
##
#############################################

测试三：
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my_python.py -d "this is a test"
#!/usr/bin/python 

#############################################
##
#文件名: my_python.py
#作者名: zane
#时间  : 2016-10-27
#简介  : this is a test
##
#############################################

======================================================================================


#this is service_monitor.readme 

背景需求 

    运维核心就是保证线上业务稳定运而线上业务是否在运行呢？
所以监控线上业务进程是否在很重要.

功能介绍 

	开机自启动
	监控httpd服务默认端口80
	服务不在则重启服务并发送告警




使用介绍 

测试 

======================================================================================


#this is sys_monitor.readme 

背景需求 

监控服务器状态及时预警是运维职责所在。


功能介绍 

监控服务器关键状态指标,发送邮件
指标:
	CPU
	MEMORY
	SWAP
	ROOT/USR/VAR DISK SPACE 

邮件:
	发送给本机邮件
	
周期报警:
	如若报警为解除,则建立周期任务,给刚上线的用户直接弹消息

使用介绍 

aiapple@ubuntu:~/git/my-bash-shell/sys_monitor$ ./sys_monitor.sh 
The file is exsit~
Delete:d  Flush:f	
Adding a new report in this file........

测试 

======================================================================================


