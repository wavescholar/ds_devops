# Spark Lab Book
      Bruce Campbell
      March 2016

Notes on the Journey to Integrate Spark with R for Time Series Analysis.

>In the days when Sussman was a novice, Minsky once came to him as he sat hacking at the PDP-6."What are you doing?", asked Minsky. "I am training a randomly wired neural net to play Tic-tac-toe", Sussman replied. "Why is the net wired randomly?", asked Minsky. "I do not want it to have any preconceptions of how to play", Sussman said. Minsky then shut his eyes. "Why do you close your eyes?" Sussman asked his teacher. "So that the room will be empty." At that moment, Sussman was enlightened.

Table of Contents

- Overview
  - Demo Setup
  - Custom Aggregation
    - SparkR
    - JRI
    - Spark Pipes
    - GroupBy with Pipes
    - Forking R as a Process
    - User defined aggregation in Spark
  - Spark Container Architecture and Tuning Considerations
    - Executor Tuning Example
  - SCM Considerations
    - Spark On Windows
    - Setting up Spark development on CentOS

## Overview
Our time series data is stored in Amazon S3 in csv files.  They are moved to S3 from the data lake via a distributed upload process that converts ORC to partitioned csv data.  We only partition by size currently. For the next upload we'll be partitioning by endpoint so the data is localized by device.

Our goal is to scale the types of manufacturing data analysis we've been doing on water and electric data to very large sets and calculate more sophisticated features.  Currently we we use R on a single compute node to calculate features for small sets of time series (20,000-50,000) or we generate summary statsitics using Apache Hive.  Hive limits the quality of features that can be calculated.

First, some google search numbers.  These give an idea how obscure our objective is.   
```
Query                                                   |     Hits
------------------------------------------------------------------------
hadoop                                                  |     23,000,000
apache spark                                            |     7,800,000
apache hive                                             |     420,000
apache hive user defined functions                      |     200,000
apache hive user defined aggregate functions            |     43,000
apache spark user defined Functions                     |     117,000
apache spark user defined aggregate functions           |     28,000
apache spark user defined aggregate functions R Script  | 271
```

##{Demo Setup}
We've got some data setup on S3/EMR that we've attached to using SparkHive context.  Here's the setup code

```
val hiveContext = new org.apache.spark.sql.hive.HiveContext(sc)
hiveContext.sql("use 022816")
sc.setLogLevel("WARN")

val queryRDD=hiveContext.sql("select endpoint_id, sample_point,read_value from er_no_hot_socket_sample where endpoint_id in(37350262, 49823079, 72398601, 72179515, 49831365, 49880869, 49392877, 47748229, 49362485, 48498880) ")

//Set the number of partitions to the number of data nodes.  
//Set the second parameter to true to force a shuffle. This is not working in Spark 1.6.0
val resultsDF = queryRDD.toDF().coalesce(4)          
```

## Custom Aggregation
The API in SparkR and Spark DataFrames in Scala have mechanisms to aggregate using built in functions - the usual ones you'd find in Hive live sum, count, avg, etc.  In order to calculate features on time series using R we first need to gather the tics by aggregating on device id.

There are a number of ways to approach the generalization of aggregation.  Hive supports User Defined Aggregation Functions (UDAF). Spark has an experimental API for UDAF.  It's a bit odd that SparkR does not have this.  There is a package dplyr.spark that does aggregation, but I could not find a way to do a custom aggregation like ddply.

After the time series data has been aggregated it needs to be passed into R for feature calculations. There are several way of achieving this. rengine, pipes, and Rjava. Hadoop has an interface that uses stdio to stream data to external processes (Hadoop Streaming).  Hive also has thiscapability. The Spark notion of streaming- using stdio and the pipe the data to a R process.
Using RJava/jri

###{SparkR}
SparkR is an R package that provides a light-weight frontend to use Apache Spark from R. In Spark 1.6.0, SparkR provides a distributed data frame implementation that supports operations like selection, filtering, aggregation etc. (similar to R data frames, dplyr) but on large datasets. SparkR also supports distributed machine learning using MLlib

```
Sys.setenv(SPARK_HOME = "/usr/lib/spark")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

sc <- sparkR.init(master = "local[*]", sparkEnvir = list(spark.driver.memory="2g"))

#----------This does not work until we set up the RStudio user to have premissions to run YARN jobs.
#sc <- sparkR.init(master="yarn-client",
                  sparkEnvir=list(spark.executor.memory="5g"),'logistic')

hiveContext <- sparkRHive.init(sc)

sql(hiveContext,"use _emf_022816")

queryRDD <-sql(hiveContext,"select endpoint_id, sample_point,read_value from er_no_hot_socket_sample where endpoint_id in(37350262, 49823079, 72398601, 72179515, 49831365, 49880869, 49392877, 47748229, 49362485, 48498880) ")
#queryRDD <-sql(hiveContext,"select endpoint_id, sample_point,read_value from er_no_hot_socket_sample ")

collectedReads <- collect(queryRDD)

endpointGroupedDatas <- groupBy(queryRDD,"endpoint_id" )

summaryDF <-agg(endpointGroupedDatas, read_value="avg")

collected <- collect(summaryDF)

collected$endpoint_id[1:10]

cache(queryRDD)

#---------------------Install dplr.spark
#install.packages(c("RJDBC", "dplyr", "DBI", "devtools"))
#devtools::install_github("hadley/purrr")

library(rJava)
.jinit()

Sys.setenv(HADOOP_JAR = "/usr/lib/spark/lib/spark-assembly-1.6.0-hadoop2.7.1-amzn-0.jar")

#devtools::install_url("https://github.com/RevolutionAnalytics/dplyr-spark/releases/download/0.3.0/dplyr.spark_0.3.0.tar.gz")

library(dplyr)
library(dplyr.spark)

library("pracma")
calculatEntropyConsumption <- function(df) {
  result<-tryCatch(
{
  Data <- df$read_value
  tsRep <- ts(data=tail(Data, 500))
  result <- approx_entropy(tsRep, edim=2, r=0.2*sd(tsRep), elag=1)
}, error=function(e){
  class(e)<-class(simpleWarning(''))
  warning(e)
  NULL
})
return(result)
}

#------------------ddply is part of plyr - the original ply - but we're using ddpl for spark so THIS DOES NOT WORK.
#dfEntropyFeaturesConsumption <- ddply(queryRDD, "endpoint_id", calculatEntropyConsumption)

#------------------This is the dplyr.spark call it works on the built in aggregation functions but for our user defined function
dfEntropyFeaturesConsumption <- queryRDD %>%
  groupBy("endpoint_id") %>%
  summarise(
    ae = mean(queryRDD$read_value)
  )
```

### {JRI}
Using JRI one communicates with R from Spark, with some utils to convert from Scala data types into R datatypes/dataframes etc.
Using mapPartitions we can push R closures thru JRI and collecting back the results in Spark.

First get rJava

```
git clone --recursive https://github.com/s-u/rJava.git rJava
```

We're getting a configure error trying to build ourselvs

checking JNI data types... configure: error: One or more JNI types differ from the corresponding native type.

To get around this - we install rJava through R and then locate the jri libraries

```
system.file("jri",package="rJava")
```

in R. which returns  "/home/hadoop/R/x86_64-redhat-linux-gnu-library/3.2/rJava/jri" on EMR.

This uses a static class Rengine which is not thread safe.  It passes the variable input as string to the R process and reads
the variable output from the R process.  It smells like streaming if a data frame can not be passed back and fourth. I think there is a path that will allow that since that's what SparkR is using.  We'll have to get down into the Spark source code to figure this out.

Spark runs the aggregation in a Tasks which are run together in a Executor JVM.  Since the engine is not thread safe we'll need to tune the Spark job so we can get maximal cluster utilization.  There is a section below detailing some of those considerations.

###{Spark Pipes}
Pipe is the Spark equivalent to Hadoop Streaming.  Data is passed back and fourth to an external process via stdin and stdout.  Hive has streaming capabilities as well.  

Here's an example

```
val tsDF = resultsDF.select($"endpoint_id", concat($"read_value", lit(","),$"sample_point"))

//Pipe Example
/*
    #!/bin/sh
    echo "Running shell script"
    while read LINE; do
       echo ${LINE}
    done
*/

//There is no pipe api for DataFrame so we go back to RDD
val mRDD = tsDF.rdd

//sc.addFile can use hdfs or local files. It makes the files available on all nodes for tasks in a temp directory. /tmp/spark-###...

val scriptPath = "/home/hadoop/data/spark_pipe_echo.sh"

sc.AddFile(scriptPath)

import org.apache.spark.SparkFiles

//This is the temp dir on the local filesystem where the script is located.
SparkFiles.get(scriptPath)

//This works only because of ./ - the file is actually in the location specified from the last command.
mRDD.pipe("./spark_pipe_echo.sh").collect()
```


###{GroupBy with Pipes}
groupBy on a Spark DataFrame returns a GroupedData class, there is not much that can be done with this other than call the standard aggregation functions or a user defined aggregation fuction.  To pipe grouped data we need to go to the RDD interface.  

This is an example of that.  This should work but it does not.  The pipe process gets the data formatted as expected - with it all goes into one process.  The groupByKey should send each aggregation to it's own pip process.  It may be a Spark bug that is does not. See SO entry ()

```
//Here is how we call the spark-shell when running this code as a script
//spark-shell --packages com.databricks:spark-csv_2.10:1.3.0 --jars /home/hadoop/data/timeSeriesEngine/Packages/SparkUDAFLibrary/target/sparkudaflibrary-0.0.1.jar
//This installs the spark-csv databricks library and puts the UDAF jar in the Ivy cache

import sys.process._
import org.apache.spark.SparkFiles
import org.apache.spark.storage.StorageLevel
import org.apache.spark.sql._

val hiveContext = new org.apache.spark.sql.hive.HiveContext(sc)
hiveContext.sql("use 022816")
sc.setLogLevel("WARN")

val queryRDD=hiveContext.sql("select endpoint_id, sample_point,read_value from icon_hot_sockets_sorted where endpoint_id in(35526096,35527968,35528121,35528562,35531001,35531598,35532027,35534169,35536785) ")

val resultsDF = queryRDD.toDF().coalesce(10)   

sc.setCheckpointDir("/user/hadoop")

resultsDF.persist(StorageLevel.DISK_ONLY)

// Run this if you want to see how many samples per endpoint are returned.
// resultsDF.groupBy($"endpoint_id").count().show()

// Display the schema of the data frame
// resultsDF.schema

val scriptPathRWrapper = "/home/hadoop/data/timeSeriesEngine/TSE/scripts/SparkPipeDriver_CheckInputData.R"
sc.addFile(scriptPathRWrapper)
SparkFiles.get(scriptPathRWrapper)

val mRDD = resultsDF.rdd
val rowsAsSeqRDD = mRDD.map{x:Row => x.toSeq}
val pairs = rowsAsSeqRDD.map(x => ( x(0), (x(1),x(2) )))

val gbkRDD = pairs.groupByKey()

//Best practice is to use reduceByKey instead of groupByKey
//val gbkRDD = pairs.reduceByKey((x,y) => x ).distinct() //---------------<   This needs to be fixed up
val gbkFeatures = gbkRDD.pipe("./SparkPipeDriver_CheckInputData.R")

sc.setCheckpointDir("/user/hadoop")
import org.apache.spark.storage.StorageLevel
gbkFeatures.persist(StorageLevel.DISK_ONLY)

"hadoop fs -rm -R hdfs:///ec2-52-91-138-84.compute-1.amazonaws.com/user/hadoop/features"!
gbkFeatures.saveAsTextFile("hdfs:///ec2-52-91-138-84.compute-1.amazonaws.com/user/hadoop/features")

resultsDF.persist(StorageLevel.DISK_ONLY)
"hadoop fs -rm -R hdfs:///ec2-52-91-138-84.compute-1.amazonaws.com/user/hadoop/resultsDF"!
resultsDF.save("hdfs:///ec2-52-91-138-84.compute-1.amazonaws.com/user/hadoop/resultsDF", "com.databricks.spark.csv")
```

###{Forking R as a Process}
Interop with R can be achieved by forking R as a process, attaching to the process's stdin, stdout, and stderr streams, and sending R commands via the input stream. the file system can be used to communicate between R and a Java process. This way, we can have multiple R processes running from different threads in Java and their environments do not conflict with each other.

This is the pipe method above applied to an R process.  R can be set up to recieve input from stdio.

```
#!/user/bin/env Rscript

#This script takes args :  scriptFileName function
#All of the data is extracted and sent to the function in the script
#It's ment to be used by a group by function.
#The input is recieved through stdin and the output is written to stdout

#The script is called from Spark pipe like so :
#   df.groupBy().pipe(SparkPipeDriver libFile functionName)

args <-commandArgs(trailingOnly = TRUE )
libFile <- args[1]
functionName <- args[2]

if(exists(functionName, mode="function"))
  source(libFile)

stdin <- file("stdin")

open(stdin)

Data <- data.frame(read_value=double(),sample_point=integer())

while(TRUE) {
input <- readLines(stdin,n=1,ok=TRUE,encoding = "UTF-8")

fileds<-strsplit(input, ",")
Data <- rbind(Data,c(as.numeric(fileds[[1]][1]),as.numeric(fileds[[1]][2])) )

}

eval(parse(text=paste( "write(",functionName,"(data)[[1]]$content,stdout())"  )))


```

We test this usig the same mechanism we would test a Hadoop streaming application i.e.    ```cat data | map | sort```


```
cat data | ./SparkPipeDriver.R calculate_features.R calculate_features
```

#####{Considerations regarding pipes with R script}
Any R packages required by the script must be installedd on all nodes.  To avoid the interactive prompt use this in an EMR cluster bootsrap action.

```
sudo R --no-save << EOF
install.packages(c('pracma', 'moments'),repos="http://cran.rstudio.com", INSTALL_opts=c('--byte-compile') )
EOF
```

Put the script in S3 and distribute to all YARN nodes

```
for i in `yarn node --list | cut -f 1 -d ':' | grep "ip"`; do ssh -i your-key.pem hadoop@$i 'hadoop fs -copyToLocal s3://your-bucet/R_install.sh | chmod +x /home/hadoop/R_install.sh | /home/hadoop/R_install.sh > setup_f12.log' ; done
```

Warnings from the Rscript will cause Spark task failure.  Wrap code that might throw warnings in R exception handling.  Here's an example from reading stdio

```
read_input <- function()
{
  input<-tryCatch(
    {
       suppressWarnings(input <- readLines(stdin,n=1,ok=TRUE,encoding = "UTF-8"))

    }, error=function(e){
      class(e)<-class(simpleWarning(''))
      warning(e)
      NULL
    })
  return(input)
}
...

input <-  read_input()  #Warnings here will now be handled gracefully.


```

###{User defined aggregation in Spark}
This is a experimental API.  Here's an example we have implemented on the same time series RDD in the other examples.
It multiplies all the readings by pi and sums them up.

```
import org.apache.spark.sql.expressions.MutableAggregationBuffer
import org.apache.spark.sql.expressions.UserDefinedAggregateFunction
import org.apache.spark.sql.Row
import org.apache.spark.sql.types._
class TestFeature() extends UserDefinedAggregateFunction {

  // Input Data Type Schema
  def inputSchema: StructType = StructType(Array(StructField("item", DoubleType)))

  // Intermediate Schema
  def bufferSchema = StructType(Array(
    StructField("sum", DoubleType),
    StructField("cnt", LongType)
  ))

  // Returned Data Type .
  def dataType: DataType = DoubleType

  // Self-explaining
  def deterministic = true

  // This function is called whenever key changes
  def initialize(buffer: MutableAggregationBuffer) = {
    buffer(0) = 0.toDouble // set sum to zero
    buffer(1) = 0L // set number of items to 0
  }

  // Iterate over each entry of a group
  def update(buffer: MutableAggregationBuffer, input: Row) = {
    buffer(0) = buffer.getDouble(0) + input.getDouble(0)
    buffer(1) = buffer.getLong(1) + 1
  }

  // Merge two partial aggregates
  def merge(buffer1: MutableAggregationBuffer, buffer2: Row) = {
    buffer1(0) = buffer1.getDouble(0) + buffer2.getDouble(0)
    buffer1(1) = buffer1.getLong(1) + buffer2.getLong(1)
  }

  // Called after all the entries are exhausted.
  def evaluate(buffer: Row) = {
    buffer.getDouble(0)
    val count =buffer.getLong(1)
    count* 3.14159
  }

}
```


## Spark Container Architecture and Tuning Considerations

Spark Architecture

```
App Master
    AppCode
        ------------->
        Physical Node
        Worker (!)
          Executor(s)
            Tasks -------These must be reentrant!
```

How this fits into YARN - remember SPark can be run stand alone or as a YARN job.  For YARN there are two modes Client and Server.  There is no spark-shell CLI mode for YARN server mode.

YARN

```
client (spark shell) ---sends jar and cache data ---->

            YARN Application Master
              (Spark Driver)----------------asks for task resource from YARN Resource Manager

         Physical Node
          YARN Node Manager
            YARN Container
            Spark Executor 1:1 YARN Container to Executor
                Tasks --------
```

Every Spark executor in an application has the same fixed number of cores and same fixed heap size. The number of cores can be specified with the --executor-cores flag when invoking spark-submit, spark-shell, and pyspark from the command line, or by setting the spark.executor.cores property in the spark-defaults.conf file or on a SparkConf object. Similarly, the heap size can be controlled with the --executor-memory flag or the spark.executor.memory property. The cores property controls the number of concurrent tasks an executor can run. --executor-cores 5 means that each executor can run a maximum of five tasks at the same time. The memory property impacts the amount of data Spark can cache, as well as the maximum sizes of the shuffle data structures used for grouping, aggregations, and joins.

In Spark 1.4 1 data node node will have 1 Worker, which is responsible for launching and managing multiple Executors.  This may have changed in 1.5 or 1.6. When spark runs it behaves like any other YARN application so it asks Yarn for resources so for starters you need to set up Yarn so that it would be able to accommodate your executors You can set desired number of executors and their memory, and the number of cores each executor gets when you submit a job.


Here is the SparkPi example  

```
 ./bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn-cluster \
    --num-executors 3 \
    --driver-memory 4g \
    --executor-memory 2g \
    --executor-cores 1 \
    lib/spark-examples*.jar \
```

This setup would request 1 driver with 4gb of ram and a total of 3 executors with 2g an 1 core each. The actual number of executors would depend on YARN's ability to fulfil these request.

Doing this in scala :

```
val conf = new SparkConf()
             .setMaster(...)
             .setAppName(...)
             .set("spark.executor.memory", "2g")
             .set("spark.cores.max", "10")
```

The --num-executors command-line flag or spark.executor.instances configuration property control the number of executors requested.

It’s also important to think about how the resources requested by Spark will fit into what YARN has available. The relevant YARN properties are:

yarn.nodemanager.resource.memory-mb controls the maximum sum of memory used by the containers on each node

yarn.nodemanager.resource.cpu-vcores controls the maximum sum of cores used by the containers on each node

Asking for five executor cores will result in a request to YARN for five virtual cores. The memory requested from YARN is a little more complex for a couple reasons:

--executor-memory/spark.executor.memory controls the executor heap size, but JVMs can also use some memory off heap.  The value of the spark.yarn.executor.memoryOverhead property is added to the executor memory to determine the full memory request to YARN for each executor. It defaults to max(384, .07 * spark.executor.memory). YARN may round the requested memory up a little. YARN’s yarn.scheduler.minimum-allocation-mb and yarn.scheduler.increment-allocation-mb properties control the minimum and increment request values respectively.

Other concerns when sizing Spark executors:

1) The application master, which is a non-executor container with the special capability of requesting containers from YARN, takes up resources of its own that must be budgeted in. In yarn-client mode, it defaults to a 1024MB and one vcore. In yarn-cluster mode, the application master runs the driver, so it’s often useful to bolster its resources with the --driver-memory and --driver-cores properties.
2) Running executors with too much memory often results in excessive garbage collection delays. 64GB is a rough guess at a good upper limit for a single executor.
I’ve noticed that the HDFS client has trouble with tons of concurrent threads. A rough guess is that at most five tasks per executor can achieve full write throughput, so it’s good to keep the number of cores per executor below that number.
3) Running tiny executors (with a single core and just enough memory needed to run a single task, for example) throws away the benefits that come from running multiple tasks in a single JVM. For example, broadcast variables need to be replicated once on each executor, so many small executors will result in many more copies of the data.

### Executor Tuning Example
Here is a worked example of configuring a Spark app to use as much of the cluster as possible: Imagine a cluster with six nodes running NodeManagers, each equipped with 16 cores and 64GB of memory. The NodeManager capacities, yarn.nodemanager.resource.memory-mb and yarn.nodemanager.resource.cpu-vcores, should probably be set to 63 * 1024 = 64512 (megabytes) and 15 respectively. We avoid allocating 100% of the resources to YARN containers because the node needs some resources to run the OS and Hadoop daemons. In this case, we leave a gigabyte and a core for these system processes. Cloudera Manager helps by accounting for these and configuring these YARN properties automatically.

The likely first impulse would be to use --num-executors 6 --executor-cores 15 --executor-memory 63G. However, this is the wrong approach because:

63GB + the executor memory overhead won’t fit within the 63GB capacity of the NodeManagers.
The application master will take up a core on one of the nodes, meaning that there won’t be room for a 15-core executor on that node.
15 cores per executor can lead to bad HDFS I/O throughput.
A better option would be to use --num-executors 17 --executor-cores 5 --executor-memory 19G. Why?

This config results in three executors on all nodes except for the one with the AM, which will have two executors.
--executor-memory was derived as (63/3 executors per node) = 21.  21 * 0.07 = 1.47.  21 – 1.47 ~ 19.

##{SCM Considerations}

###{Spark On Windows}
It can be done.

First install (unzip) java, maven, scala, sbt, and a spark distro somewhere - ie C:\JavaDev

Put together a DOS env script (ends with .cmd) that looks like this;

```
SET PATH=%PATH%;C:\JavaDev\maven-3.2.5\bin;C:\JavaDev\scala-2.10.5\bin;C:\JavaDev\sbt\
SET JAVA_HOME=C:\JavaDev\jdk1.7.79
SET SCALA_HOME=C:\JavaDev\scala-2.10.5
SET MAVEN_HOME=C:\JavaDev\maven-3.2.5\bin
SET SPARK_HOME=C:\JavaDev\spark-1.4.0
REM SET MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
```
Run the spark build

mvn -DskipTests clean package

If Maven runs out of memory (it will) un-comment the MAVEN_OPTS line in the environment script, or set the java settings on the build command line

mvn -DskipTests clean package -DargLine="-Xmx1524m"

I like to have all the sources available for debugging – here is a recipe for getting that set up. It works on Windows and Linux.

There are 2 ways to get the sources for all dependencies in Maven project.

1)
Specifying -DdownloadSources=true -DdownloadJavadocs=true at the command line when building.

2)
Open your settings.xml file (~/.m2/settings.xml). Add a section with the properties added. Then make sure the activeProfiles contains this

```
<profiles>
<profile>
<id>downloadSources</id>
<properties>
<downloadSources>true</downloadSources>
<downloadJavadocs>true</downloadJavadocs>
</properties>
</profile>
</profiles>

<activeProfiles>
<activeProfile>downloadSources</activeProfile>
</activeProfiles>
```

###{Setting up Spark development on CentOS}

On the Windows platforms we run Spark in local mode and off the local filesystem for development.  On Linux we can run using a variety of settings.  
For a full development environment set up a single node Hadoop cluster (pseudo-distributed).  Jobs can be run in a variety of configs.  The vesions in the settings below match those of EMR 4.2.  Ultimately, we will script the build and install of Hadoop, Hive, and Spark.


These are the enviromnent variables that should be set after installing Hadoop,
Hive, and Spark.

```
export JAVA_HOME=/usr/java/jdk1.7.0_79
export SCALA_HOME=/home/vagrant/opt/scala-2.10.5/
export SPARK_HOME=/home/vagrant/opt/spark-1.6.0/
export HADOOP_HOME=/usr/local/hadoop/
export HIVE_HOME=/home/vagrant/opt/hive-0.12.0-bin
export PATH=$HIVE_HOME/bin:$PATH
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
export PATH=$JAVA_HOME/bin:$PATH
export PATH=/home/vagrant/opt/apache-maven-3.3.9/bin:$PATH
export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
```

This is the build command for Spark on YARN with Hive support.

mvn -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.1 -Phive -Phive-thriftserver

###{Persistence Example}

```
sc.setCheckpointDir("/user/hadoop")
val r = sc.parallelize(List(1,2,3,4,5,6,7,8,9))
import org.apache.spark.storage.StorageLevel
r.persist(StorageLevel.DISK_ONLY)
r.count
r.saveAsTextFile("hdfs:///ec2-52-3-209-168.compute-1.amazonaws.com/user/hadoop/regressiondata/testfile.txt")
r.saveAsObjectFile("hdfs:///ec2-52-3-209-168.compute-1.amazonaws.com/user/hadoop/regressiondata/testfile.obj")
```


###{Stop Reading - this is  WIP Haddop Streaming with R}

One option is to implemnt the group by in classical Map Reduce and use Hadoop streaming in R.

TODO - this needs to converted to our EMF group by example.

This link describes the java map reduce setup for a groupBy operation
https://github.com/nitins30/hadoopessence/blob/master/GroupMR/src/org/techmytalk/groupby/GroupMR.java


The code below describes
The data used in this example;

Format of each line of the data set is: date, time, store name, item description, cost and method of payment. The six fields are separated by tab. Only two fields, store and cost, are used to aggregate the cost by each store.

```
#Make R scripts executable
chmod w+x mapper.R
chmod w+x reducer.R

#This is also the idea for how we will test R scripts used in Spark Pipes
cat test1.txt | ./mapper.R | sort | ./reducer.R

Running - our distro will have a different streaming jar

hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.1.jar
-mapper mapper.R –reducer reducer.R
–file mapper.R –file reducer.R
-input myinput
-output joboutput
```

Mapper.R

```
# Use batch mode under R (don't use the path like /usr/bin/R)
#! /usr/bin/env Rscript

options(warn=-1)

# We need to input tab-separated file and output tab-separated file

input = file("stdin", "r")
while(length(currentLine = readLines(input, n=1, warn=FALSE)) > 0) {
   fields = unlist(strsplit(currentLine, "\t"))
   # Make sure the line has six fields
   if (length(fields)==6) {
       cat(fields[3], fields[5], "\n", sep="\t")
   }
}
close(input)

#! /usr/bin/env Rscript

options(warn=-1)
salesTotal = 0
oldKey = ""

# Loop around the data by the formats such as key-val pair
input = file("stdin", "r")
while(length(currentLine = readLines(input, n=1, warn=FALSE)) > 0) {
  data_mapped = unlist(strsplit(currentLine, "\t"))
  if (length(data_mapped) != 2) {
    # Something has gone wrong. However, we can do nothing.
    continue
  }

  thisKey = data_mapped[1]
  thisSale = as.double(data_mapped[2])

  if (!identical(oldKey, "") && !identical(oldKey, thisKey)) {
    cat(oldKey, salesTotal, "\n", sep="\t")
    oldKey = thisKey
    salesTotal = 0
  }

  oldKey = thisKey
  salesTotal = salesTotal + thisSale
}

if (!identical(oldKey, "")) {
  cat(oldKey, salesTotal, "\n", sep="\t")
}

close(input)

```

Reducer.R

```

#! /usr/bin/env Rscript

options(warn=-1)
salesTotal = 0
oldKey = ""

# Loop around the data by the formats such as key-val pair
input = file("stdin", "r")
while(length(currentLine = readLines(input, n=1, warn=FALSE)) > 0) {
  data_mapped = unlist(strsplit(currentLine, "\t"))
  if (length(data_mapped) != 2) {
    # Something has gone wrong. However, we can do nothing.
    continue
  }

  thisKey = data_mapped[1]
  thisSale = as.double(data_mapped[2])

  if (!identical(oldKey, "") && !identical(oldKey, thisKey)) {
    cat(oldKey, salesTotal, "\n", sep="\t")
    oldKey = thisKey
    salesTotal = 0
  }

  oldKey = thisKey
  salesTotal = salesTotal + thisSale
}

if (!identical(oldKey, "")) {
  cat(oldKey, salesTotal, "\n", sep="\t")
}

close(input)

```
