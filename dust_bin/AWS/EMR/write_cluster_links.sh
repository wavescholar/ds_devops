#!/bin/bash

HadoopNameNode=$(curl -s http://instance-data.ec2.internal/latest/meta-data/public-hostname)

yarnURI=http://$HadoopNameNode:8088/cluster
hdfsURI=http://$HadoopNameNode:50070/dfshealth.html#tab-overview
sparkURI=http://$HadoopNameNode:20888/proxy/APIDHERE
sparkNotebookURI=http://$HadoopNameNode:8989
HadoopResourceManager=http://$HadoopNameNode:9026/
HadoopHDFSNameNode=http://$HadoopNameNode:9101/
HUEUri=http://$HadoopNameNode:8888
echo $yarnURI
echo $hdfsURI
echo $sparkURI
echo $sparkNotebookURI
echo $HUEUri
