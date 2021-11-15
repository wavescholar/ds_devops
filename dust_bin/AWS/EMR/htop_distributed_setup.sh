#Runs a script 
for i in `yarn node --list | cut -f 1 -d ':' | grep "ip"`; do ssh -i user_name-kp2.pem hadoop@$i 'hadoop fs -copyToLocal s3://aloidia-solutions/bootstrap-actions/htop_datanode_setup.sh | chmod +x /home/hadoop/htop_datanode_setup.sh | /home/hadoop/htop_datanode_setup.sh > setup_f12.log' ; done
