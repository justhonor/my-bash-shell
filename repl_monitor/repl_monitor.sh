#!/bin/bash 

#############################################
##
#文件名: repl_monitor.sh
#作者名: zane
#时间  : 2016-12-23
#简介  : 
##
#############################################

 # get some slave stats

 Slave_IO_Running=`mysql -u test -h testmaster.co16f7xzvs0r.us-east-1.rds.amazonaws.com -P 3306 --password="00000000" -e "show slave status\G" | grep Slave_IO_Running | awk '{ print $2 }'`

 Slave_SQL_Running=`mysql -u test -h testmaster.co16f7xzvs0r.us-east-1.rds.amazonaws.com -P 3306 --password="00000000" -e "show slave status\G" | grep Slave_SQL_Running | awk '{ print $2 }'`

 Last_error=`mysql -u test -h testmaster.co16f7xzvs0r.us-east-1.rds.amazonaws.com -P 3306 --password="00000000" -e "show slave status\G" | grep Last_error | awk '{ print $2 }'`

 echo -e "Slave_IO_Running:$Slave_IO_Running"
echo -e "Slave_SQL_Running:$Slave_SQL_Running"

if [ $Slave_SQL_Running == 'No' ] || [ $Slave_IO_Running == 'No' ];

 then

     echo "Last Error:" $Last_error | mail -s "Replication error on slavedb!!!" zane.zhang@zoom.us 

  else
	echo "Replication correct!!!"
 fi  

exit 0
