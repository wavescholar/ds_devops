
#!/bin/bash
dateString=`date`
echo "Running at $dateString"

dateString=${dateString// /}
echo $dateString

dateString=${dateString//:/}
echo $dateString

#Make sure to run aws configure prior to running this script

#With TIG and AZ
# aws emr create-cluster --name "cluster $dateString" --release-label emr-4.1.0 \
# --applications Name=Hue Name=Hive Name=Pig Name=Spark Name=Zeppelin-Sandbox \
# --log-uri s3://sa-user_name/clusterLogs \
# --use-default-roles --ec2-attributes KeyName=user_name-kp2 \
# --bootstrap-actions Path=s3://sa-user_name/bootstrap-actions/emR_bootstrap.sh \
# --ec2-attributes AvailabilityZone=us-east-1d \
#   --instance-groups \
#   InstanceGroupType=MASTER,InstanceType=m3.xlarge,InstanceCount=1,BidPrice=0.09 \
#   InstanceGroupType=CORE,BidPrice=0.09,InstanceType=m3.xlarge,InstanceCount=2 \
#   InstanceGroupType=TASK,BidPrice=0.10,InstanceType=m3.xlarge,InstanceCount=1 > create_culter_reply.json

#Let's see if we can
# 1)  Wait until cluster is up
# 2)  ssh into it
# 3)  clone the TSE repo
# 3)  run the dev setup
# 3)  run the workflow

#No TIG AZ
aws emr create-cluster --name " cluster $dateString" --release-label emr-4.1.0 \
--applications Name=Hue Name=Hive Name=Pig Name=Spark Name=Zeppelin-Sandbox \
--log-uri s3://sa-user_name/clusterLogs \
--use-default-roles --ec2-attributes KeyName=user_name-kp2 \
--bootstrap-actions Path=s3://sa-user_name/bootstrap-actions/emR_bootstrap.sh \
  --instance-groups \
  InstanceGroupType=MASTER,InstanceType=m3.xlarge,InstanceCount=1,BidPrice=0.09 \
  InstanceGroupType=CORE,BidPrice=0.09,InstanceType=m3.xlarge,InstanceCount=2 > create_culster_reply.json

clusterID=`jq '.ClusterId' create_culster_reply.json | tr -d '"'`

# Or on the master node
export clusterID=j-BQOP4980FQA5

aws emr describe-cluster --cluster-id $clusterID > cluster_description.json

clusterState="NOTREADY"

while [ $clusterState == "NOTREADY" ]
do

aws emr describe-cluster --cluster-id $clusterID > cluster_description.json

clusterState=`jq '.Cluster.Status.State' cluster_description.json | tr -d '"'`

done

echo $clusterState

#Make sure to do this first so we can ssh into the cluster
#eval `ssh-agent -s`
#chmod 600 user_name-kp.pem #This solve two issues - one when you add the key and one when you connedt!
#ssh-add user_name-kp.pem

masterDNSName=`jq '.Cluster.MasterPublicDnsName' cluster_description.json | tr -d '"'`

#ssh -i my.pem ec2-xx-xx-xx-xx.compute-1.amazonaws.com

#We must set up the aws cli on the
#run aws configure first and enter credentials.

#On the master node -------------------------
# sudo mkdir /mnt/data
# sudo chown hadoop:hadoop /mnt/data
# ln -s /mnt/data /home/hadoop/data
# sudo chown hadoop:hadoop /mnt/data

cd data

git clone my_repo


#Add task instance group
aws emr add-instance-groups --cluster-id $clusterID --instance-groups \
InstanceGroupType=TASK,BidPrice=0.06,InstanceType=m3.xlarge,InstanceCount=3 > taks_group_reply.json
=======
#Add task instance group - note that the bootstrap script is run for us - we don't need to specify that
aws emr add-instance-groups --cluster-id $clusterID --instance-groups \
InstanceGroupType=TASK,BidPrice=0.06,InstanceType=m3.xlarge,InstanceCount=5 > taks_group_reply.json

taskGroupID=`jq '.InstanceGroupIds[]' taks_group_reply.json`
taskGroupID=${taskGroupID//'"'/}

./RUN_AnalyticsWorkflow.sh > RUN_AnalyticsWorkflow_$dateString.out 2>&1&

#The above command gives json with the InstanceGroupId - we use that to set the count to 0
# after running the job
aws emr modify-instance-groups --instance-groups InstanceGroupId=$taskGroupID,InstanceCount=0

# TODO Optionally tear cluster down

Many scripts or programs are placed on the shell login path environment so you do not need to specify the full path when executing them when using command-runner.jar. You also do not have to know the full path to command-runner.jar. command-runner.jar is located on the AMI so there is no need to know a full URI as was the case with script-runner.jar.

aws emr add-steps --cluster-id j-3BXO3QOQAIIHE --steps Name="Command Runner",Jar="command-runner.jar",Args=["s3-dist-cp","--s3Endpoint=s3.amazonaws.com","--src=s3://my_bucket/my_file.parquet/"]
