#These are notes from Mongo --> Python/Spark --> Mongo workflow development.

To get our version of python set up in Spark we edit the spark-env.sh file at /etc/spark/conf/ and
export PYSPARK_PYTHON=/mnt/data/anaconda2/bin/python #- our installation directory.

To get this working in Apache Zeppelin we
export PYSPARK_PYTHON=/mnt/data/anaconda2/bin/python
in zeppelin/conf/zeppelin-env.sh   #Not Working

Restart Zeppelin

sudo /usr/lib/zeppelin/bin/zeppelin-daemon.sh stop
sudo /usr/lib/zeppelin/bin/zeppelin-daemon.sh start

##Install MongoDB On EMR

https://docs.mongodb.org/manual/tutorial/install-mongodb-on-amazon/

/etc/yum.repos.d/mongodb-org-3.2.repo

sudo echo  '
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc'  >> mongodb-org-3.2.repo
sudo cp mongodb-org-3.2.repo /etc/yum.repos.d/
sudo yum install -y mongodb-org

Mongo is set up to run mongod in /etc/init.d via sudo service
The config file is picked up from /etc/mongod.conf
This is where we edit the ip.  Change the section below to the internal ip of the master node.  
```
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1  # Listen to local interface only, comment to listen on all interfaces.
```

###Restore a database - Copy bson and json schema info

mkdir /mnt/data/mongo-data
cd /mnt/data/mongo-data
aws s3 cp --recursive s3://my_bucket_with_bson/ .
sudo chown mongod:mongod /mnt/data/mongo-data/
sudo service mongod restart
mongorestore -d verdeeco_core_redwoodcw /mnt/data/mongo-data/

If it does not go well - we can drop with this command

mongo <dbname> --eval "db.dropDatabase()"

###Now we can access Mongo from python.  Our cluster bootstrap does that for us.

from pymongo import MongoClient
client = MongoClient("172.31.57.185",27017)
db = client['']
db.intervals.count()
db.intervals.find()

##PySpark MongoRDD

git clone https://github.com/mongodb/mongo-hadoop.git
cd mongo-hadoop
./gradlew jar

cd spark/src/main/python
python setup.py install

pyspark  --jars /home/hadoop/data/mongo-hadoop/spark/build/libs/mongo-hadoop-spark-1.5.2.jar  --py-files pymongo_spark.py

import pymongo_spark
pymongo_spark.activate()
mongo_rdd = sc.mongoRDD('mongodb://xx.xx.xx.xx:27017/data_loc')
print(mongo_rdd.first())

#Write
some_rdd.saveToMongoDB('mongodb://localhost:27017/db.output_collection')


This file has MongoBD connection and path info

###Example Contents
```
[Inputs]
DSWebService_path = /mnt/data/DSWebService/
[MongoSource]
Default_authenticationDatabase = authenticationDatabase
Default_authenticationUser = authenticationUserName
Default_authenticationPassword = authenticationPassword
```

```/mnt/data/DSWebService/```

```
def Spark_decorator(func):
    def func_wrapper(*args):
        import os
        os.environ['DSPackage_Config_File_Path']=pyspark.SparkFiles.get('.DSPackagerc')
        return func(*args)
    return func_wrapper
```

use @Spark_decorator before any of your spark map functions that use DSPackage

also add the config file to the cluster

sc.addFile('/mnt/data/DSWebService/.DSPackagerc')


##Python Spark Workflow

```
%pyspark #If we're rnning in Zeppelin

from datetime import datetime
from DSPackage.DataLibrary import Data
from DSPackage.AlgorithmLibrary import SummaryFeatureTransform
RawData = sc.textFile('s3n://my_bucket/000000_0')


def mapper1(record):
    Fields = record.split(',')
    eT = datetime.utcfromtimestamp(float(Fields[7]))
    return (Fields[0],{'eT':eT,'v':float(Fields[10])})

MappedData = RawData.map(mapper1)
GroupedData = MappedData.groupByKey()

@Spark_decorator
def mapper2(record):
    from DSPackage.DataLibrary.BaseData import Data
    Readings = list(record[1])
    return Data([{'d':record[0],'Readings':Readings}])

DataClass_RDD = GroupedData.map(mapper2)


@Spark_decorator
def mapper3(Data):
    from DSPackage.AlgorithmLibrary import SummaryFeatureTransform
    #model = SummaryFeatureTransform()
    model = Imputation(method = 'interpolation',frequency = 24,interval = 3600)
    return model.fit_transform(Data)

Feature_RDD = DataClass_RDD.map(mapper3).collect()


@Spark_decorator
def mapper4(Data):
    from DSPackage.AlgorithmLibrary import Imputation
    model = Imputation(method = 'interpolation',frequency = 24,interval = 3600)
    return model.fit_transform(Data)

Impute_RDD = DataClass_RDD.map(mapper4)

# Try impute locally
D = Impute_RDD.take(1)[0]  
model = Imputation(method = 'interpolation',frequency = 24,interval = 3600)
return model.fit_transform(D)

#Try 1
Impute_RDD.take(1)

#Try all
Impute_RDD.collect()
```


##MongoDB Notes

###Install MongoDB __On EMR__

<https://docs.mongodb.org/manual/tutorial/install-mongodb-on-amazon/>

```

/etc/yum.repos.d/mongodb-org-3.2.repo

sudo echo  '
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc'  >> mongodb-org-3.2.repo
sudo cp mongodb-org-3.2.repo /etc/yum.repos.d/
sudo yum install -y mongodb-org

mkdir /mnt/data/mongo-data
cd /mnt/data/mongo-data
aws s3 cp --recursive s3://bucket/location/bsonfile.bson .
sudo chown mongod:mongod /mnt/data/mongo-data/
mongo restart
mongorestore -d bsonfile.bson /mnt/data/mongo-data/

```

###MondoDB Basics - Notes

* Basic Commands
* show dbs
* use mydatabase - sets the current db to mydatabase access via db.
* show collections
* The primary method for the read operation is the db.collection.find() method. This method queries a collection and returns a cursor to the returning documents ie __var myCursor = db.inventory.find( { type: 'food' } );__


In MongoDB data is located and manipulated through cursors.  A database cursor is a control structure that enables traversal over the records in a database. Cursors facilitate subsequent processing in conjunction with the traversal, such as retrieval, addition and removal of database records. The main operations are search, read, write, and data aggregation. Collections are containers for documents.  db.createCollection() creates a new collection.

###Mongo Operaions from Python

from pymongo import MongoClient

client = MongoClient("127.0.0.1",27017)
db = client['verdeeco_core_redwoodcw']
db.intervals.count()
endpoints = db.intervals.aggregate([{'$group':{'_id':'$d'}}])

###Run Mongo Windows Bat - Use RoboMongo for UI with this

1) Install MongoDB
2) Set a directory for mongo files
3) use same restore command as Linux;
     [mongorestore -d verdeeco_core_redwoodcw path to bson files ]
4) Run the mongod daemon
```start C:\"Program Files"\MongoDB\Server\3.2\bin\mongod --port 27017 --dbpath E:\Data\mongo-data\mongo-data-dir-windevmahcine```
5) Use RoboMongo to attach to running Mongo store and view documents


###Access MongoDB from Python

```
from pymongo import MongoClient
client = MongoClient("172.31.63.59",27017)
db = client['verdeeco_core_redwoodcw']
db.intervals.count()
db.intervals.find()

##Get the endpoint id's as an aggregate from the read intervals
We don't have device data in the redwood db yet. (Reach out to Dan F for info on new data)

db.intervals.aggregate([{'$group':{'_id':'$d'}}])
```

##PySpark Notes

Pyspark internals < https://cwiki.apache.org/confluence/display/SPARK/PySpark+Internals >

PySpark is built on top of Spark's Java API. Data is processed in Python and cached / shuffled in the JVM:

In the Python driver program, SparkContext uses Py4J to launch a JVM and create a JavaSparkContext. Py4J is only used on the driver for local communication between the Python and Java SparkContext objects; large data transfers are performed through a different mechanism.
RDD transformations in Python are mapped to transformations on PythonRDD objects in Java. On remote worker machines, PythonRDD objects launch Python subprocesses and communicate with them using pipes, sending the user's code and the data to be processed.

###Serialization
Data is currently serialized using the Python cPickle serializer. PySpark uses cPickle for serializing data because it's reasonably fast and supports nearly any Python data structure.
TODO: discuss why you didn't use JSON, BSON, ProtoBuf, MsgPack, etc

###Forking Python Worker Processes
Daemon for launching worker processes
Many JVMs use fork/exec to launch child processes in ProcessBuilder or Runtime.exec. These child processes initially have the same memory footprint as their parent. When the Spark worker JVM has a large heap and spawns many child processes, this can cause memory exhaustion, leading to "Cannot allocate memory" errors. In Spark, this affects both pipe() and PySpark.
Other developers have run into the same problem and discovered a variety of workarounds, including adding extra swap space or telling the kernel to overcommit memory. We can't use the java_posix_spawn library to solve this problem because it's too difficult to package due to its use of platform-specific native binaries.
For PySpark, we resolved this problem by forking a daemon when the JVM heap is small and using that daemon to launch and manage a pool of Python worker processes. Since the daemon uses very little memory, it won't exhaust the memory during fork().

###Tuning Notes

val rdd2 = rdd1.reduceByKey(_ + _, numPartitions = X)
What should “X” be? The most straightforward way to tune the number of partitions is experimentation: Look at the number of partitions in the parent RDD and then keep multiplying that by 1.5 until performance stops improving.

There is also a more principled way of calculating X, but it’s difficult to apply a priori because some of the quantities are difficult to calculate. I’m including it here not because it’s recommended for daily use, but because it helps with understanding what’s going on. The main goal is to run enough tasks so that the data destined for each task fits in the memory available to that task.

The memory available to each task is (spark.executor.memory * spark.shuffle.memoryFraction * spark.shuffle.safetyFraction)/spark.executor.cores. Memory fraction and safety fraction default to 0.2 and 0.8 respectively.


```
from pyspark import SparkConf, SparkContext
conf = (SparkConf().setAppName("My app").set("spark.yarn.executor.memoryOverhead", "1024"))
sc = SparkContext(conf = conf)
```


#iPython Notes

##Bootstrap Script for iPython

https://github.com/awslabs/emr-bootstrap-actions/blob/master/ipython-notebook/install-ipython-notebook

##install Bokeh

conda install bokeh
or

pip install bokeh



#Pyspark Hive notes

Example of how to access hive data from pyspark

```import pyspark.sql
hiveContext = HiveContext(sc)
hiveContext.sql("use tablename")

queryRDD=hiveContext.sql("select * from consumption_summary_stats where window_key in ('COBB_1N6027669642_45869502April','COBB_1N6027669652_45877702October', 'COBB_1N6027669646_45879406April') ")

resultsDF = queryRDD.toDF('window_key', 'meter_key', 'month','read_count', 'min_consumption', 'max_consumption', 'average_read', 'stddev_consumption','p05_read_value', 'p95_read_value', 'zero_read_ratio')

resultsDF = queryRDD.toDF().coalesce(10)   

sc.setCheckpointDir("/user/hadoop")

resultsDF.persist(StorageLevel.DISK_ONLY)
```
