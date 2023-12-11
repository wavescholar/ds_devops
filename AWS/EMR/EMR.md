
eval `ssh-agent -s`
chmod 600 user_name-kp2.pem
ssh-add user_name-kp2.pem

#First attach the volume to the EMR instance as xvdf
#First time only
	# lsblk
	# sudo file -s /dev/xvdf
	# sudo mkfs -t ext4 /dev/xvdf
#Add this to fstab
#/dev/xvdf  /mnt/data ext4 defaults,noatime 0 0
sudo mkdir /mnt/data
sudo mount /dev/xvdf /mnt/data

#Describe image
aws ec2 describe-images --image-ids=ami-4d314928

#Here is how to set the replication
s3://elasticmapreduce/bootstrap-actions/configure-hadoop    -h, dfs.replication=2

#DFS reporting
hadoop dfsadmin -report | grep ^Name | cut -f2 -d: | cut -f2 -d' '

#Execute script on DataNodes
for i in `yarn node --list | cut -f 1 -d ':' | grep "ip"`; do ssh -i user_name-kp2.pem hadoop@$i 'hadoop fs -copyToLocal s3://sa-user_name/bootstrap-actions/data_node_setup.sh | chmod +x /home/hadoop/data_node_setup.sh | /home/hadoop/data_node_setup.sh > setup.log' ; done


#Make ec2 instance
aws ec2 run-instances --count 1 --instance-type t1.micro --key-name user_name-kp2.pem


#AWS EMR cli
	# add-instance-groups
	# add-steps
	# add-tags
	# create-cluster
	# create-default-roles
	# create-hbase-backup
	# describe-cluster
	# describe-step
	# disable-hbase-backups
	# get
	# install-applications
	# list-clusters
	# list-instances
	# list-steps
	# modify-cluster-attributes
	# modify-instance-groups
	# put
	# remove-tags
	# restore-from-hbase-backup
	# schedule-hbase-backup
	# socks
	# ssh
	# terminate-clusters
	# wait

aws emr create-cluster --name "Test cluster" --ami-version 4.1 \
--applications Name=Hue Name=Hive Name=Pig Name=Spark Name=Zeppelin-Sandbox Name=Hue\
--use-default-roles --ec2-attributes KeyName=user_name-kp2 \
--instance-type m1.xlarge --instance-count 3 --termination-protected

#Works
aws emr create-cluster --name "cluster" --release-label emr-4.1.0 \
--applications Name=Hue Name=Hive Name=Pig Name=Spark Name=Zeppelin-Sandbox \
--log-uri s3://sa-user_name/clusterLogs
--use-default-roles --ec2-attributes KeyName=user_name-kp2 \
--bootstrap-actions Path=s3://sa-user_name/bootstrap-actions/emR_bootstrap.sh \
--ec2-attributes AvailabilityZone=us-east-1d \
  --instance-groups \
  InstanceGroupType=MASTER,InstanceType=m3.xlarge,InstanceCount=1,BidPrice=0.09 \
  InstanceGroupType=CORE,BidPrice=0.09,InstanceType=m3.xlarge,InstanceCount=2 \
  InstanceGroupType=TASK,BidPrice=0.10,InstanceType=m3.xlarge,InstanceCount=3

  aws emr modify-instance-groups --instance-groups  \
  InstanceGroupType=TASK,BidPrice=0.08,InstanceType=m3.xlarge,InstanceCount=3

worker_tig

#Works
aws emr add-instance-groups --cluster-id j-3S712CETLZIA4 --instance-groups InstanceGroupType=TASK,BidPrice=0.06,InstanceType=m3.xlarge,InstanceCount=3

#The above command gives json with the InstanceGroupId - we use that to set the count  after running the job
aws emr modify-instance-groups  --instance-groups InstanceGroupId=ig-326X5UWOYYOAV,InstanceCount=0


aws emr modify-instance-groups --cluster-id j-3S712CETLZIA4  --instance-groups InstanceGroupId=worker_tig,InstanceCount=0

aws emr create-cluster --name "cluster" --release-label emr-4.1.0 --applications Name=Hue Name=Hive Name=Pig Name=Spark Name=Zeppelin-Sandbox --use-default-roles --ec2-attributes KeyName=user_name-kp2 --bootstrap-actions Path=s3://sa-user_name/bootstrap-actions/emR_bootstrap.sh --ec2-attributes AvailabilityZone=us-east-1d   --instance-groups InstanceGroupType=MASTER,InstanceType=m3.xlarge,InstanceCount=1,BidPrice=0.09 InstanceGroupType=CORE,BidPrice=0.09,InstanceType=m3.xlarge,InstanceCount=2

# Add task instance group Here

# Set up the master dev env
aws emr add-steps --cluster-id j-2OUOGRA7FLA7O \
--steps Type=CUSTOM_JAR,Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://elasticmapreduce/libs/script-runner/script-runner.jar,Args=["s3://sa-user_name/bootstrap-actions/dev_server_setup_driver.sh"]

#Add jars

aws emr add-steps --cluster-id j-XXXXXXXX --steps Type=CUSTOM_JAR,Name=CustomJAR, \
ActionOnFailure=CONTINUE,Jar=s3://mybucket/mytest.jar,Args=arg1,arg2,arg3 Type=CUSTOM_JAR, \
Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://mybucket/mytest.jar,MainClass=mymainclass,Args=arg1,arg2,arg3


# Streaming example
aws emr add-steps --cluster-id j-XXXXXXXX --steps Type=STREAMING,Name='Streaming Program', \
ActionOnFailure=CONTINUE,Args=[-files,s3://elasticmapreduce/samples/wordcount/wordSplitter.py,\
-mapper,wordSplitter.py,-reducer,aggregate,-input,s3://elasticmapreduce/samples/wordcount/input,\
-output,s3://mybucket/wordcount/output]

#This runs but does not work
aws emr add-steps --cluster-id j-2OUOGRA7FLA7O --steps Type=CUSTOM_JAR, \
Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://elasticmapreduce/libs/script-runner/script-runner.jar, \
Args=["s3://sa-user_name/bootstrap-actions/dev_server_setup_driver.sh"]

# Hive steps
aws emr add-steps --cluster-id j-XXXXXXXX --steps Type=HIVE,Name='Hive program',\
ActionOnFailure=CONTINUE,Args=[-f,s3://mybuckey/myhivescript.q,-d,INPUT=s3://mybucket/myhiveinput,\
-d,OUTPUT=s3://mybucket/myhiveoutput,arg1,arg2] Type=HIVE,Name='Hive steps',ActionOnFailure=TERMINATE_CLUSTER,\
Args=[-f,s3://elasticmapreduce/samples/hive-ads/libs/model-build.q,-d,INPUT=s3://elasticmapreduce/samples/hive-ads/tables\
,-d,OUTPUT=s3://mybucket/hive-ads/output/2014-04-18/11-07-32,-d,LIBS=s3://elasticmapreduce/samples/hive-ads/libs]



create table parquet_table_name (x INT, y STRING)
  ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe'
  STORED AS
    INPUTFORMAT "parquet.hive.DeprecatedParquetInputFormat"
    OUTPUTFORMAT "parquet.hive.DeprecatedParquetOutputFormat";


    create external table parquet_table_name (x INT, y STRING)
  ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe'
  STORED AS
    INPUTFORMAT "parquet.hive.DeprecatedParquetInputFormat"
    OUTPUTFORMAT "parquet.hive.DeprecatedParquetOutputFormat"
    LOCATION '/test-warehouse/tinytable';
