Quick Start 
wget http://download.nextag.com/apache/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz
tar -xzf kafka_2.11-0.10.0.0.tgz
cd kafka_2.11-0.10.0.0

#Single Node Zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties

#This works on EMR master node - but not on EC2 VPC.  See error below.

bin/kafka-server-start.sh config/server.properties

```
[2016-08-02 15:29:41,155] FATAL Fatal error during KafkaServerStartable startup. Prepare                                                           to shutdown (kafka.server.KafkaServerStartable)
java.net.UnknownHostException: ip-10-32-12-145: ip-10-32-12-145: Name or service not kno                                                          wn
        at java.net.InetAddress.getLocalHost(InetAddress.java:1496)
        at kafka.server.KafkaHealthcheck$$anonfun$1.apply(KafkaHealthcheck.scala:61)
        at kafka.server.KafkaHealthcheck$$anonfun$1.apply(KafkaHealthcheck.scala:59)
        at scala.collection.MapLike$MappedValues.get(MapLike.scala:249)
        at scala.collection.MapLike$class.getOrElse(MapLike.scala:126)
        at scala.collection.AbstractMap.getOrElse(Map.scala:59)
        at kafka.server.KafkaHealthcheck.register(KafkaHealthcheck.scala:69)
        at kafka.server.KafkaHealthcheck.startup(KafkaHealthcheck.scala:51)
        at kafka.server.KafkaServer.startup(KafkaServer.scala:244)
        at kafka.server.KafkaServerStartable.startup(KafkaServerStartable.scala:37)
        at kafka.Kafka$.main(Kafka.scala:67)
        at kafka.Kafka.main(Kafka.scala)
Caused by: java.net.UnknownHostException: ip-10-32-12-145: Name or service not known
        at java.net.Inet6AddressImpl.lookupAllHostAddr(Native Method)
        at java.net.InetAddress$1.lookupAllHostAddr(InetAddress.java:922)
        at java.net.InetAddress.getAddressesFromNameService(InetAddress.java:1316)
        at java.net.InetAddress.getLocalHost(InetAddress.java:1492)
        ... 11 more
[2016-08-02 15:29:41,157] INFO [Kafka Server 0], shutting down (kafka.server.KafkaServer 
```
#Make a topic
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

#Test that it is there
bin/kafka-topics.sh --list --zookeeper localhost:2181

#Run producer
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
> Type messages here 

#Run the consumer 
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning

###Producer Maven Dependency 
<dependency>
	    <groupId>org.apache.kafka</groupId>
	    <artifactId>kafka-clients</artifactId>
	    <version>0.10.0.0</version>
	</dependency>


###Consumer Maven Dependency
<dependency>
	    <groupId>org.apache.kafka</groupId>
	    <artifactId>kafka-clients</artifactId>
	    <version>0.10.0.0</version>
	</dependency>

##Receiverless Approach to Kafka Spark Streaming integration
This approach periodically queries Kafka for the latest offsets in each topic+partition, and accordingly defines the offset ranges to process in each batch. When the jobs to process the data are launched, Kafka’s simple consumer API is used to read the defined ranges of offsets from Kafka.

This approach has the following advantages over the receiver-based approach

_Simplified Parallelism:_ No need to create multiple input Kafka streams and union them. With directStream, Spark Streaming will create as many RDD partitions as there are Kafka partitions to consume, which will all read data from Kafka in parallel. So there is a one-to-one mapping between Kafka and RDD partitions, which is easier to understand and tune.

_Efficiency_: Achieving zero-data loss in the Receiver approach required the data to be stored in a Write Ahead Log, which further replicated the data. This is actually inefficient as the data effectively gets replicated twice - once by Kafka, and a second time by the Write Ahead Log. This second approach eliminates the problem as there is no receiver, and hence no need for Write Ahead Logs. As long as you have sufficient Kafka retention, messages can be recovered from Kafka.

_Exactly-once semantics:_ The Reciever approach uses Kafka’s high level API to store consumed offsets in Zookeeper. This is traditionally the way to consume data from Kafka. While this approach (in combination with write ahead logs) can ensure zero data loss (i.e. at-least once semantics), there is a small chance some records may get consumed twice under some failure

Recieverless approach dependency (SBT/ Maven)
groupId = org.apache.spark
 artifactId = spark-streaming-kafka-0-8_2.11
 version = 2.0.0

//Create Dstream 
 import org.apache.spark.streaming.kafka._
 val directKafkaStream = KafkaUtils.createDirectStream[
     [key class], [value class], [key decoder class], [value decoder class] ](
     streamingContext, [map of Kafka parameters], [set of topics to consume])


//Consume from arbitrary offset 
// Hold a reference to the current offset ranges, so it can be used downstream
 var offsetRanges = Array[OffsetRange]()
	
 directKafkaStream.transform { rdd =>
   offsetRanges = rdd.asInstanceOf[HasOffsetRanges].offsetRanges
   rdd
 }.map {
           ...
 }.foreachRDD { rdd =>
   for (o <- offsetRanges) {
     println(s"${o.topic} ${o.partition} ${o.fromOffset} ${o.untilOffset}")
   }
   ...
 }
 
#Notes 

Interesting to note that the 2nd gen Kafka clients are written in Java.  The 1st versions were scala basesd. 
