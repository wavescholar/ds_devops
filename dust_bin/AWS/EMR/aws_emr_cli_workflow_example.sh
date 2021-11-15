#!/bin/bash

#This should be run on an AWS edge node with the AWS cli set up.  Example on how to do this is below
# > aws configure
# 	AWS Access Key ID [None]: YOUR KEYID
# 	AWS Secret Access Key [None]: YOUR KEY
# 	Default region name [None]: us-east-1
# 	Default output format [None]: json
aws emr create-cluster --applications Name=Hadoop Name=Hive Name=Hue Name=Ganglia Name=Spark Name=Zeppelin Name=JupyterHub Name=TensorFlow --ec2-attributes '{"KeyName":"INTERNAL-DATA-SCIENCE-KP","InstanceProfile":"EMR_EC2_DefaultRole","ServiceAccessSecurityGroup":"sg-af9e2add","SubnetId":"subnet-0a063a26","EmrManagedSlaveSecurityGroup":"sg-f5992d87","EmrManagedMasterSecurityGroup":"sg-a89327da","AdditionalMasterSecurityGroups":["sg-8fff63fc"]}' --release-label emr-5.23.0 --log-uri 's3n://aws-logs-795755361461-us-east-1/elasticmapreduce/' --instance-groups '[{"InstanceCount":1,"BidPrice":"OnDemandPrice","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":1024,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"MASTER","InstanceType":"r4.4xlarge","Name":"Master - 1"},{"InstanceCount":6,"BidPrice":"OnDemandPrice","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":1024,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"CORE","InstanceType":"r4.4xlarge","Name":"Core - 2"}]' --configurations '[{"Classification":"spark-env","Properties":{},"Configurations":[{"Classification":"export","Properties":{"PYSPARK_PYTHON":"python3"}}]}]' --auto-scaling-role EMR_AutoScaling_DefaultRole --bootstrap-actions '[{"Path":"s3://xds-devops/r-emr-bootstrap/rstudio_sparklyr_emr5.sh","Name":"Custom action"},{"Path":"s3://xds-devops/r-emr-bootstrap/install_jags.sh","Name":"Custom action"}]' --ebs-root-volume-size 100 --service-role EMR_DefaultRole --enable-debugging --name 'sv-cluster-preprod-autoscaling-spot' --scale-down-behavior TERMINATE_AT_TASK_COMPLETION --region us-east-1

#Autoscaling
#aws emr create-cluster --auto-scaling-role EMR_AutoScaling_DefaultRole --applications Name=Hadoop Name=Hive Name=Hue Name=Spark Name=Tez Name=ZooKeeper Name=Zeppelin Name=Ganglia Name=HCatalog --bootstrap-actions '[{"Path":"s3://aws-bigdata-blog/artifacts/aws-blog-emr-rstudio-sparklyr/rstudio_sparklyr_emr5.sh","Args":["--sparklyr,","--rstudio,","--shiny,","--sparkr"],"Name":"Custom action"}]' --ebs-root-volume-size 75 --ec2-attributes '{"KeyName":"daz1e1-datascience","AdditionalSlaveSecurityGroups":["sg-97e0d2ec"],"InstanceProfile":"EMR_EC2_DefaultRole","ServiceAccessSecurityGroup":"sg-3659f24d","SubnetId":"subnet-e9d9f9c3","EmrManagedSlaveSecurityGroup":"sg-3059f24b","EmrManagedMasterSecurityGroup":"sg-3159f24a","AdditionalMasterSecurityGroups":["sg-97e0d2ec"]}' --service-role EMR_DefaultRole --enable-debugging --release-label emr-5.7.0 --log-uri 's3n://aws-logs-371066304662-us-east-1/elasticmapreduce/' --name 'General-Custer' --instance-groups '[{"InstanceCount":1,"BidPrice":"1","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":150,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"MASTER","InstanceType":"r4.4xlarge","Name":"Master instance group - 1"},{"InstanceCount":2,"BidPrice":"1","AutoScalingPolicy":{"Constraints":{"MinCapacity":2,"MaxCapacity":6},"Rules":[{"Action":{"SimpleScalingPolicyConfiguration":{"ScalingAdjustment":4,"CoolDown":180,"AdjustmentType":"CHANGE_IN_CAPACITY"}},"Description":"","Trigger":{"CloudWatchAlarmDefinition":{"MetricName":"YARNMemoryAvailablePercentage","ComparisonOperator":"LESS_THAN_OR_EQUAL","Statistic":"AVERAGE","Period":300,"Dimensions":[{"Value":"${emr.clusterId}","Key":"JobFlowId"}],"EvaluationPeriods":2,"Unit":"PERCENT","Namespace":"AWS/ElasticMapReduce","Threshold":25}},"Name":"out"},{"Action":{"SimpleScalingPolicyConfiguration":{"ScalingAdjustment":-4,"CoolDown":180,"AdjustmentType":"CHANGE_IN_CAPACITY"}},"Description":"","Trigger":{"CloudWatchAlarmDefinition":{"MetricName":"YARNMemoryAvailablePercentage","ComparisonOperator":"GREATER_THAN_OR_EQUAL","Statistic":"AVERAGE","Period":300,"Dimensions":[{"Value":"${emr.clusterId}","Key":"JobFlowId"}],"EvaluationPeriods":2,"Unit":"PERCENT","Namespace":"AWS/ElasticMapReduce","Threshold":75}},"Name":"in"}]},"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":100,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"CORE","InstanceType":"r4.4xlarge","Name":"Core instance group - 2"}]' --scale-down-behavior TERMINATE_AT_INSTANCE_HOUR --region us-east-1

sudo mkdir /dev/data
sudo chown ec2-user:ec2-user /dev/data
ln -s /dev/data /home/ec2-user/data
cd /dev/data
sudo yum -y update
sudo yum -y install git
git config --global user.email $GIT_USER_EMAIL
git config --global user.name $GIT_USER_NAME


#Clone the java spark-time-series repository
git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/spark-time-series.git

pushd /mnt/data/spark-time-series/TSFeatures/
mvn package
aws s3 rm  s3://aloidia-solutions/EMRJars/TSFeatures-0.0.1.jar
aws s3 cp /mnt/data/spark-time-series/TSFeatures/target/TSFeatures-0.0.1.jar  s3://aloidia-solutions/EMRJars/
aws s3 ls  --recursive  s3://aloidia-solutions/EMRJars/
popd

pushd /mnt/data/spark-time-series/AGSparkWorkflow/
mvn package
aws s3 rm s3://aloidia-solutions/EMRJars/AGSparkWorkflow-0.0.1-SNAPSHOT.jar
aws s3 cp /mnt/data/spark-time-series/AGSparkWorkflow/target/AGSparkWorkflow-0.0.1-SNAPSHOT.jar s3://aloidia-solutions/EMRJars/
aws s3 ls  --recursive  s3://aloidia-solutions/EMRJars/
popd


chmod +x /dev/data/action-guide-data-science/*.sh

dateString=`date`
echo "Running at $dateString"

dateString=${dateString// /}
echo $dateString

dateString=${dateString//:/}
echo $dateString


aws emr create-cluster --applications Name=Hadoop Name=Hive Name=Hue Name=Ganglia Name=Spark Name=Zeppelin Name=JupyterHub Name=TensorFlow --ec2-attributes '{"KeyName":"INTERNAL-DATA-SCIENCE-KP","InstanceProfile":"EMR_EC2_DefaultRole","ServiceAccessSecurityGroup":"sg-af9e2add","SubnetId":"subnet-0a063a26","EmrManagedSlaveSecurityGroup":"sg-f5992d87","EmrManagedMasterSecurityGroup":"sg-a89327da","AdditionalMasterSecurityGroups":["sg-8fff63fc"]}' --release-label emr-5.23.0 --log-uri 's3n://aws-logs-795755361461-us-east-1/elasticmapreduce/' --instance-groups '[{"InstanceCount":1,"BidPrice":"OnDemandPrice","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":1024,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"MASTER","InstanceType":"r4.4xlarge","Name":"Master - 1"},{"InstanceCount":6,"BidPrice":"OnDemandPrice","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":1024,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"CORE","InstanceType":"r4.4xlarge","Name":"Core - 2"}]' --configurations '[{"Classification":"spark-env","Properties":{},"Configurations":[{"Classification":"export","Properties":{"PYSPARK_PYTHON":"python3"}}]}]' --auto-scaling-role EMR_AutoScaling_DefaultRole --bootstrap-actions '[{"Path":"s3://xds-devops/r-emr-bootstrap/rstudio_sparklyr_emr5.sh","Name":"Custom action"},{"Path":"s3://xds-devops/r-emr-bootstrap/install_jags.sh","Name":"Custom action"}]' --ebs-root-volume-size 100 --service-role EMR_DefaultRole --enable-debugging --name 'sv-cluster-preprod-autoscaling-spot' --scale-down-behavior TERMINATE_AT_TASK_COMPLETION --region us-east-1
#Get the Cluster ID so we can submit steps
clusterID=`jq '.ClusterId' create_culster_reply.json | tr -d '"'`

aws emr describe-cluster --cluster-id $clusterID > cluster_description.json

clusterState="NOTREADY"

while [ $clusterState == "NOTREADY" ]
do

aws emr describe-cluster --cluster-id $clusterID > cluster_description.json

clusterState=`jq '.Cluster.Status.State' cluster_description.json | tr -d '"'`

done

echo $clusterState

# # Set up the master dev env
# aws emr add-steps --cluster-id $clusterID \
# --steps Type=CUSTOM_JAR,Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://elasticmapreduce/libs/script-runner/script-runner.jar,Args=["s3://xds-data/AG/EMRSteps/emr_dev_setup.sh"]

#Copy S3 data to HDFS
aws emr add-steps --cluster-id $clusterID --steps Name="Command Runner",Jar="command-runner.jar",Args=["s3-dist-cp","--s3Endpoint=s3.amazonaws.com","--src=s3://bucket_name/data.parquet","--dest=hdfs:///user/hadoop/loc/data.parquet/"]

#Run a bash scrip on the edge node.
aws emr add-steps --cluster-id $clusterID \
--steps Type=CUSTOM_JAR,Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://elasticmapreduce/libs/script-runner/script-runner.jar,Args=["s3://xds-data/AG/EMRSteps/main_workflow.sh"]


#Wait until the steps have run to spin up task instance group
clusterState="NOTREADY"
while [ $clusterState != "WAITING" ]
do

aws emr describe-cluster --cluster-id $clusterID > cluster_description.json

clusterState=`jq '.Cluster.Status.State' cluster_description.json | tr -d '"'`

done

echo $clusterState

#Add task instance group
aws emr add-instance-groups --cluster-id $clusterID --instance-groups \
InstanceGroupType=TASK,InstanceType=r3.4xlarge,InstanceCount=6 > taks_group_$dateString.json

taskGroupID=`jq '.InstanceGroupIds[]' taks_group_$dateString.json`
taskGroupID=${taskGroupID//'"'/}


#Run the main workflow
aws emr add-steps --cluster-id $clusterID \
--steps Type=CUSTOM_JAR,Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://elasticmapreduce/libs/script-runner/script-runner.jar,Args=["s3://xds-data/AG/EMRSteps/main_workflow.sh"]

#The above command gives json with the InstanceGroupId - we use that to set the count to 0
# after running the job
aws emr modify-instance-groups --instance-groups InstanceGroupId=$taskGroupID,InstanceCount=0

aws emr modify-instance-groups --instance-groups InstanceGroupId=ig-HTB9C68OKFQ6,InstanceCount=0

aws emr terminate-clusters --cluster-ids $clusterID

###############################################################################################
#                                  !!!!STOP READING!!!!!
#                     WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP WIP

aws emr add-steps --cluster-id $clusterID --steps Name=TSFeaturesFeatureCalculation,Jar=s3://us-east-1.elasticmapreduce/libs/script-runner/script-runner.jar,Args=[/home/hadoop/spark/bin/spark-submit,--class,FeatureCalculation,--deploy-mode,cluster,--master,yarn,--jars,s3://aloidia-solutions/EMRJars/TSFeatures-0.0.1.jar,s3://xds-data/AG/SparkScalaScripts/FeatureCalculationScript.scala],ActionOnFailure=CONTINUE

aws emr add-steps --cluster-id $clusterID --steps Name=TSFeaturesFeatureCalculation,Jar=s3://us-east-1.elasticmapreduce/libs/script-runner/script-runner.jar,Args=[/home/hadoop/spark/bin/spark-submit,--class,FeatureCalculationWF,--deploy-mode,cluster,--master,yarn,--jars,s3://aloidia-solutions/EMRJars/AGSparkWorkflow-0.0.1-SNAPSHOT.jar],ActionOnFailure=CONTINUE


terminate-clusters --cluster-id $clusterID
