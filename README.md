# My-bash-shell
bash shell 脚本使用记录

简介
每个脚本都放在单独目录中，清晰可见
以实际应用场景为基础的脚本代码

包含背景需求，功能介绍，使用介绍 ---> xxx.readme
代码实现                         ---> xxx.sh    

##This is analysis_dir.readme

####背景需求<br>

目录下面有N个文件和目录，且都是存放的是脚本文件；<br>
那么分析这些脚本的类型种类，总代码长度，平均代码长度等<br>
并想找出那些代码行数大于150行的脚本，命名后放到一个新目录中<br>

####功能介绍

1.找出代码行数大于n行的脚本文件，并复制到指定目录<br>
  默认n=100;      指定目录：~/morelines;<br>


2.给出一些统计信息：<br>
	总共多少个脚本<br>
	共多少行代码<br>
	平均代码长度<br>
	最长有多长<br>
	最短有多长<br>
	注释平均占比<br>


####使用介绍<br>

1.analysis_dir.sh {source_dir_name} [dir] [n]<br>

####测试<br>

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
-rwxrwxr-x 1 aiapple aiapple 6792 10-28 13:40 check_cpu.sh     <br>
-rwxrwxr-x 1 aiapple aiapple 6792 10-28 13:40 check_cpu.sh.bak <br>
-rwxrwxr-x 1 aiapple aiapple 6643 10-28 13:40 check_mem.pl     <br>
-rwxrwxr-x 1 aiapple aiapple 4435 10-28 13:40 check_mem.sh     <br>
-rwxrwxr-x 1 aiapple aiapple 5840 10-28 13:40 check_mem.sh.bak <br>
-rwxrwxr-x 1 aiapple aiapple 3511 10-28 13:40 rc.functions     <br>




======================================================================================


##This is cp_info_into_file.readme <br>

####背景需求 <br>

将指定类型文本的信息提取并加到指定文本中<br>

例如：<br>
有n个脚本readme文件，且在不同目录下.如/analysis_dir.readme且这些文件中都有背景信息,功能信息；<br>
此时要将这些背景信息和各自脚本名如analysis_dir.sh，都自动加到如README.md当中；<br>

####功能介绍 <br>

1.遍历my-bash-shell目录找到xxx.readme文件<br>

2.将xxx.readme内容添加到README.md中去<br>

3.自动比较各文件是否更新如已经更新，则替换为最新的内容;<br>

#####可扩展功能:<br>
1.判断原文件是否在,如果原文件不在,则认为整个工程已删除,则也删除README.md中对应内容;<br>


####使用介绍 <br>

./cp_info_into_file.sh <br>


####测试 <br>

aiapple@ubuntu:~/git/my-bash-shell/cp_info_into_file$ ./cp_info_into_file.sh <br>
目录已存在删除重建:d,更新:p<br>

my_vim.readme 已经更新内容<br>


======================================================================================


##This is login_manege.readme  <br>

####背景需求  <br>

管理服务器的时候，难免要登陆到各机器去察看系统情况. <br>
每次都需要IP 密码的输入 太重复.尤其是在短时间内， <br>
退出登陆后，又要再此登陆，不断在输入 同样的IP，密码. <br>

因此一个自动化登陆管理脚本是很有效果 <br>

####功能介绍  <br>


1.使用别名直接登陆: <br>
	基于SSH <br>
	判断网路是否通 <br>

2.管理登陆帐号 <br>
	添加:判断是否存在,判断网络是否通 <br>
	删除 <br>
	察看 <br>
	更改别名:先删再加，只是IP不删 <br>

3.察看使用帮助 <br>

#####问题： <br>
1.密码此时是明文存在server.cnf文件中,显然不合适 <br>

2.ssh登陆尚不稳定 <br>

3.若某别名的前缀，与另一个别名一样，则无法正常登陆 <br>
如： <br>
aliyun root shhsdhf 12.1.1.7 <br>
ali    root dawang  139.196.58.188 <br>
此时登陆aliyun,是可以的。但ali则会出错 <br>

4.登陆超时没有自动退出。 <br>

####使用介绍  <br>

登陆  <br>
login_manage.sh -i  alias_name <br>

添加 <br>
login_manage.sh -a alias_name user passwd ip  <br>

删除 <br>
login_manage.sh -d [ip|alias_name] <br>

更改别名 <br>
login_manage.sh -c source_alias_name destiant_alias_name <br>

察看 <br>
login_manage.sh -l <br>

使用帮助 <br>
login_manage.sh -h <br>

####测试  <br>
aiapple@ubuntu:~/git/my-bash-shell/login_manage$ ./login_manege.sh -i ali <br>
准备登陆ali,IP:139.196.58.188 <br>
网络畅通。。。。。 <br>
执行登陆程序 <br>
spawn ssh root@139.196.58.188 <br>
root@139.196.58.188's password:  <br>
Welcome to Ubuntu 12.04.5 LTS (GNU/Linux 3.2.0-67-generic-pae i686) <br>

Documentation:  https://help.ubuntu.com/ <br>
New release '14.04.1 LTS' available. <br>
Run 'do-release-upgrade' to upgrade to it. <br>

Welcome to aliyun Elastic Compute Service! <br>

Last login: Sun Nov  6 19:10:56 2016 from 114.219.76.109 <br>
root@iZ11xkhdslnZ:~#  <br>


======================================================================================


##This is login_notify.readme <br>

####背景需求 <br>

有人到你家里来你还不知道。<br>
家里东西被搬光,你却不知道。<br>
还是装个云摄像头吧。<br>

####功能介绍 <br>

1.有人登陆系统则发邮件<br>
	邮件内容：用户名,终端,时间,主机名<br>
		  现在操作命令的历史文件<br>
		  <br>
2.有人退出系统则发邮件<br>
	邮件内容：用户名,终端,时间,主机名<br>
		  现在操作命令的历史文件<br>
		  录制其操作的脚本文件<br>


内容包括:<br>
	录制其操作的脚本文件<br>
	操作命令的历史文件<br>
	登陆log文件:<br>
		登陆时登陆中登陆后<br>

分析:<br>

通过/var/log/auth.log监控用户登陆行为<br>
如果有用户登陆/退出则给root发邮件<br>
以登陆时间和用户来控制不重复发送<br>

每20秒统计一下信息<br>
可以使用cron任务调度<br>

上一次用户登陆状态<br>
与这此用户登陆状态<br>

root在/etc/profile 中添加script，并保存在/root目录中<br>
等到用户退出时将，录制文件，发送邮件。<br>

####使用介绍 <br>

####测试 <br>

======================================================================================


##This is my_vim.readme<br>

####背景需求<br>

脚本编写时总有固定的头格式：脚本解析器位置，脚本名，作者，时间，功能；等<br>
每次都重复输入很多东西，是时候写个脚本改变这一切了；<br>


####功能介绍<br>

1.根据脚本名称如my.sh,my.py<br>
  自动生成脚本解析器位置，脚本名，作者，时间，<br>

2.使用参数，输入功能简述;<br>

3.如果是my.readme文件则<br>
  自动生成:##This is file_name  背景需求  功能介绍  使用介绍 测试 <br>

4.除基本功能外，还增加了输入参数检测，文件是否存在的交互等功能<br>

5.在完成上述功能之后创建脚本之后，直接调用vim接口使之直接进入vim进程<br>

####使用介绍<br>

1.my_vim.sh  my.py<br>

2.my_vim.sh  my.py  [-d] "your describe"<br>



####测试<br>

测试一：<br>
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my.sh<br>
\#!/bin/bash <br>

\#############################################<br>
\##<br>
\#文件名: my.sh<br>
\#作者名: zane<br>
\#时间  : 2016-10-27<br>
\#简介  : <br>
\##<br>
\#############################################<br>

测试二：<br>
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my.py<br>
\#!/usr/bin/python <br>

\#############################################<br>
\##<br>
\#文件名: my.py<br>
\#作者名: zane<br>
\#时间  : 2016-10-27<br>
\#简介  : <br>
\##<br>
\#############################################<br>

测试三：<br>
zane@zane:~/github/my-bash-shell/my_vim$ ./my_vim.sh my_python.py -d "this is a test"<br>
\#!/usr/bin/python <br>

\#############################################<br>
\##<br>
\#文件名: my_python.py<br>
\#作者名: zane<br>
\#时间  : 2016-10-27<br>
\#简介  : this is a test<br>
\##<br>
\#############################################<br>

======================================================================================


##This is service_monitor.readme <br>

####背景需求 <br>

    运维核心就是保证线上业务稳定运而线上业务是否在运行呢？<br>
所以监控线上业务进程是否在很重要.<br>

####功能介绍 <br>

	开机自启动<br>
	监控httpd服务默认端口80<br>
	服务不在则重启服务并发送告警<br>




####使用介绍 <br>

####测试 <br>

======================================================================================


##This is sys_monitor.readme <br>

####背景需求 <br>

监控服务器状态及时预警是运维职责所在。<br>

####功能介绍 <br>

监控服务器关键状态指标,发送邮件<br>
指标:<br>
	CPU<br>
	MEMORY<br>
	SWAP<br>
	ROOT/USR/VAR DISK SPACE <br>

邮件:<br>
	发送给本机邮件<br>
	<br>
周期报警:<br>
	如若报警为解除,则建立周期任务,给刚上线的用户直接弹消息<br>

####使用介绍 <br>

aiapple@ubuntu:~/git/my-bash-shell/sys_monitor$ ./sys_monitor.sh <br>
The file is exsit~<br>
Delete:d  Flush:f	<br>
Adding a new report in this file........<br>

####测试 <br>

======================================================================================


