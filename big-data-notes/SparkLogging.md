#Spark Logging

###Background
Spark uses log4j as the standard library for its own logging. Everything that happens inside Spark gets logged to the shell console and to the configured underlying storage. Spark also provides a template for app writers so we could use the samelog4j libraries to add whatever messages we want to the existing and in place implementation of logging in Spark.

###CONFIGURING LOG4J

Under the SPARK_HOME/conf folder, there is log4j.properties.template file which serves as an starting point for our own logging system. To set up custom logging we modify this file and call it log4j.properties and put it under the same directory.

On EMR there is no Spark Home, as of EMR 4.0 all applications live in /usr/lib/ so the log configuration file can be found in /usr/lib/spark/conf

```
log4j.appender.myConsoleAppender=org.apache.log4j.ConsoleAppender
log4j.appender.myConsoleAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.myConsoleAppender.layout.ConversionPattern=%d [%t] %-5p %c - %m%n

# By default, everything goes to console and file
log4j.rootLogger=INFO, RollingAppender, myConsoleAppender

# My custom logging goes to another file
log4j.logger.myLogger=INFO, RollingAppenderU

```

The log4j configuration file can also be loaded when we submit a job or start the REPL
```
/spark/bin/spark-shell --driver-java-options "-Dlog4j.configuration=file:///home/hadoop/spark/conf/log4j.‌​properties"
```

##Set global loglevel

The SparkConf object can be used to set the global log level. It can be helpful to set the global level to WARN when running interactive jobs that print results to the console. 

```
sc.setLogLevel("WARN")
```

##Adding logging to Spark Jobs

Add dependencies and get root logger
```
import org.apache.log4j._
val log = LogManager.getRootLogger
```

log to root logger
```
log.info("Starting Workflow")

```

With a custom logger set up in the log4j properties file *log4j.logger.myLogger=INFO, RollingAppender* we can

```
val log = org.apache.log4j.LogManager.getLogger("myLogger")
log.info("My Message")
```
####ALERT#### This will work in the driver code, but not in Spark job.  Since the log is not serializable you will get a serialization error when executing actions with the log inside.

Use this inside mappers,reducers, and other functions used in actions on RDD's. 

```
@transient lazy val log = org.apache.log4j.LogManager.getLogger("myLogger")
 ```

 An alternative approach is to wrap in a holder class
 ```
 object LogHolder extends Serializable {      
   @transient lazy val log = LogManager.getRootLogger// Logger.getLogger(getClass.getName)    
}


myRDD.action x =>{
	...
	LogHolder.log.error("DOOM")
	...
}
```

##EMR Log Aggregation
Changed YARN log aggregation to retain logs at the aggregation destination for two days. The default destination is your cluster's HDFS storage. If you wish to change this duration, change the value of yarn.log-aggregation.retain-seconds using the yarn-site configuration classification when you create your cluster. As always, you can save your application logs to Amazon S3 using the log-uri parameter when you create your cluster.

