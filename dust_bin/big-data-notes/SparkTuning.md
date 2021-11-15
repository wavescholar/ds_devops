#Tuning Notes

One important parameter for parallel collections is the number of partitions to cut the dataset into. Spark will run one task for each partition of the cluster. Typically you want 2-4 partitions for each CPU in your cluster. Normally, Spark tries to set the number of partitions automatically based on your cluster. However, you can also set it manually by passing it as a second parameter to parallelize or in groupby /reduce calls.

In general, smaller/more numerous partitions allow work to be distributed among more workers, but larger/fewer partitions allow work to be done in larger chunks, which may result in the work getting done more quickly as long as all workers are kept busy, due to reduced overhead.

Preferred way to set up the number of partitions for an RDD is to directly pass it as the second input parameter in the call like rdd = sc.textFile("hdfs://…​/file.txt", 400)

INSTANCE   		core	ram
r3.xlarge		4		30.5	1 x 80
r3.2xlarge		8		61		1 x 160
r3.4xlarge		16		122		1 x 320
r3.8xlarge  	32  	244 	2 x 320

INSTANCE   		core	ram
m4.2xlarge		8		32
m4.4xlarge		16		64

###Example  r3.4xlarge

n= num nodes 
ram=122 
cores=16

```num-executors = n * cores / cores*executor^-1```

i.e for six nodes
```
6 nodes * 16 core*node^-1 / 4 cores*executor^-1 = 24 executors

6 nodes *122 GB*node^-1 /24 executors = (30 GB - overhead) GB*executor^-1 
```s

###An example - note that executors and cores are not conf args.
```
spark-shell --conf spark.yarn.executor.memoryOverhead=4g \
--num-executors=24 \
--executor-cores=4 \
--conf spark.executor.memory=26g \
--jars /mnt/data/timeSeriesEngine/Packages/ClientSideAnalytics/target/ClientSideAnalytics-0.0.1.jar 
```

##Example m4.4xlarge
n= 7
ram=64

cores=16

we set cores per executor = 5 since the application is memory intensive

i.e for six nodes
7 nodes * 16 core*node^-1 / 5 cores*executor^-1 = 22 executors

7 nodes *64 GB*node^-1 /22 executors = (20 GB - overhead) GB*executor^-1 

spark-shell --conf spark.yarn.executor.memoryOverhead=4g \
--num-executors=22 \
--executor-cores=5 \
--conf spark.executor.memory=17g \
--jars /mnt/data/timeSeriesEngine/Packages/ClientSideAnalytics/target/ClientSideAnalytics-0.0.1.jar 