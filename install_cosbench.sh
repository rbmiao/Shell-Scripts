export APACHE_DIR="/dan/apache-tomcat-8.0.11/bin"
export APACHE_CONF_DIR="/dan/apache-tomcat-8.0.11/conf"
export COSBENCH_DIR="/cos"
export COSBENCH_CONTROLLER=10.114.192.221

echo "--------------------"
echo "Installing Tomcat Apache on $1"
echo "--------------------"

hostname cosbench-driver$1

ssh root@$1 -x "sudo apt-get update"
ssh root@$1 -x "sudo apt-get install openjdk-7-jre"
ssh root@$1 -x "sudo mkdir /dan"
ssh root@$1 -x "cd /dan"
ssh root@$1 -x "sudo scp -r root@$COSBENCH_CONTROLLER:/dan/apache-tomcat-8.0.11 apache-tomcat-8.0.11"

## edit .bashrc, add $CATALINA_HOME and $JAVA_HOME --
## source .bashrc --
ssh root@$1 -x "rm /etc/hosts"
ssh root@$1 -x "scp root@COSBENCH_CONTROLLER:/dan/etc-host$1 /etc/hosts"

ssh root@$1 -x "cd $HOME"
ssh root@$1 -x "sudo cp .bashrc .bashrc-backup"
## following .bashrc is already done with adding $CATALINA_HOME and $JAVA_HOME on controller"
ssh root@$1 -x "rm /etc/hosts"
ssh root@$1 -x "scp root@COSBENCH_CONTROLLER:/dan/etc-host$1 /etc/hosts"
ssh root@$1 -x "sudo scp root@$COSBENCH_CONTROLLER:/.bashrc .bashrc"
ssh root@$1 -x "sudo source ./.bashrc"
## remove default admin/password from tomcat-users.xml
ssh root@$1 -x "cd $APACHE_CONF_DIR;sudo cp tomcat-users.xml tomcat-users-backup.xml"
ssh root@$1 -x "sudo scp root@$COSBENCH_CONTROLLER:$APACHE_CONF_DIR/tomcat-users.xml tomcat-users.xml"
ssh root@$1 -x "cd $APACHE_DIR;sudo chmod +x *.sh"
ssh root@$1 -x "cd $APACHE_DIR;sh catalina.sh; sh startup.sh"



echo "--------------------"
echo "Installing COSbench on $1"
echo "--------------------"

ssh root@$1 -x "sudo apt-get update"
ssh root@$1 -x "sudo apt-get install unzip"
ssh root@$1 -x "cd /dan"
ssh root@$1 -x "sudo scp root@$COSBENCH_CONTROLLER:/dan/0.4.0.e1.zip 0.4.0.e1.zip"
ssh root@$1 -x "sudo mkdir /home/COSBench"
ssh root@$1 -x "cd /home/COSBench"
ssh root@$1 -x "sudo scp /dan/0.4.0.e1.zip /home/COSBench/0.4.0.e1.zip"
ssh root@$1 -x "sudo unzip 0.4.0.e1.zip"
ssh root@$1 -x "sudo ln -s /home/COSBench/0.4.0.e1/ cos"
ssh root@$1 -x "cd $COSBENCH_DIR"
ssh root@$1 -x "sudo chmod +x *.sh"
ssh root@$1 -x "sudo unset http_proxy"
ssh root@$1 -x "sudo sh start-all.sh"


echo "--------------------"
echo "Checking connectivity from COSbench Controller node to $1"
echo "--------------------"

ssh root@$1 -x "sudo apt-get install curl"
ssh root@$1 -x "cd $COSBENCH_DIR; scp root@$COSBENCH_CONTROLLER:/driver.txt driver.txt"

ssh root@$1 -x "for NUM in `cat driver.txt`; do echo "Checking connectivity to controller: $NUM; curl http://$COSBENCH_CONTROLLER:19088/controller/index.html; done"
ssh root@$1 -x "for NUM in `cat driver.txt`; do echo "Checking connectivity to driver nodes: $NUM; curl http://$driver$NUM:18088/driver/index.html; done"
