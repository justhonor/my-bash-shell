#!/bin/bash 
#############################################
##
#FileName: repl_monitor.sh
#Author  : zane
#Date    : 2016-12-23 
##
#############################################

 ## check IP address 
 Master_IP1='34.194.150.195'
 Master_IP2='34.194.150.194'
 Master_DNS='datasyncva.co16f7xzvs0r.us-east-1.rds.amazonaws.com'

 Got_ip=`nslookup $Master_DNS | grep Address | awk 'NR ==2 {print $2 }'`

 echo -e "==================="
 echo IP:$Master_IP1 , DNS:$Master_DNS
 echo  Got_ip:$Got_ip

 if [ $Got_ip != $Master_IP1 ] && [ $Got_ip != $Master_IP2 ];then
	echo "Mashter IP loss control!!"
	#python /opt/monitor/sendmail2.py  "Master IP loss control!!!" "Master IP loss control on $Master_DNS" None "zane.zhang@zoom.us"
 else
	echo "master ip normaly!!"
 fi

 # set login-path
 # mysql_config_editor set --login-path=data --host=datasyncva.co16f7xzvs0r.us-east-1.rds.amazonaws.com --user=devdb --password

 targetdb='ssbdb'
 # get some slave stats

 #mysql --login-path=$targetdb -e "show slave status\G"  > repl_monitor_$targetdb.t


 Slave_IO_Running=`cat repl_monitor_$targetdb.t | grep Slave_IO_Running | awk '{ print $2 }'`

 Slave_SQL_Running=`cat repl_monitor_$targetdb.t | grep Slave_SQL_Running: | awk '{ print $2 }'`

 Last_error=`cat repl_monitor_$targetdb.t | grep Last_error | awk '{ print $2 }'`

 Seconds_Behind_Master=`cat repl_monitor_$targetdb.t | grep Seconds_Behind_Master | awk '{ print $2 }'`

 #Seconds_Behind_Master=0

 echo -e "Slave_IO_Running:$Slave_IO_Running"
 echo -e "Slave_SQL_Running:$Slave_SQL_Running"
 echo -e "Seconds_Behind_Master:$Seconds_Behind_Master"


if [ $Slave_SQL_Running == 'No' ] || [ $Slave_IO_Running == 'No' ] || [ $Seconds_Behind_Master == 'NULL' ];

then

	echo "Replication error on $targetdb"
	#python /opt/monitor/sendmail2.py  "Replication error on $targetdb!!!" "Replication error on $targetdb!!!, Last Error:$Last_error" None "zane.zhang@zoom.us"
	exit 0
else
	echo "Replication correct!!!"
fi  


if [ $Seconds_Behind_Master -ge 50 ];

then


	 echo "Replication  delay on $targetdb!!!"
	 #python /opt/monitor/sendmail2.py  "Replication delay Warning on $targetdb!!!" "Replication delay Warning on $targetdb!!!, Seconds_Behind_Master:$Seconds_Behind_Master" None "zane.zhang@zoom.us"

else
	echo "Replication no delay!!!"
fi  

#rm repl_monitor_$targetdb.t
exit 0
