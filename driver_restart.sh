export APACHE_DIR="/dan/apache-tomcat-8.0.11/bin"
export COSBENCH_DIR="/cos"
 
echo "--------------------"
echo "Restarting on $1"
echo "--------------------"
ssh root@$1 -x "/etc/init.d/ntp restart"
ssh root@$1 -x "cd $COSBEN_DIR; for NUM in `cat drivers.txt`; do echo "Deleting libs.log.$NUM"; rm libs.log.$NUM; done"
ssh root@$1 -x "cd $COSBEN_DIR; for NUM in `cat drivers.txt`; do echo "Deleting system.log.$NUM"; rm system.log.$NUM; done"
ssh root@$1 -x "cd $COSBENCH_DIR; sh stop-all.sh"
ssh root@$1 -x "cd $APACHE_DIR; sh shutdown.sh"
sleep 5
ssh root@$1 -x "cd $APACHE_DIR; sh startup.sh"
ssh root@$1 -x "cd $COSBENCH_DIR; sh start-all.sh"
