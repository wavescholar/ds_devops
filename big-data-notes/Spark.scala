// There are a number of ways to get pair RDDs in Spark. Many formats for
// loading from in will directly return pair RDDs for their key/value data.
// In other cases we have a regular RDD that we want to turn into a pair RDD.
// We can do this by running a map() function that returns key/value pairs.

// A feature of Scala REPL is if you drop any jar in your %SCALA_HOME%\lib directory,
// it is available for import from the REPL

//To add jars to spark-shell we use $SPARK_HOME/spark-shell --jars ../path to jars
//
// spark-shell --jars ~/data/timeSeriesEngine/Packages/lib/spark-csv_2.10-1.4.0-SNAPSHOT.jar, ~/data/timeSeriesEngine/Packages/lib/sparkudaflibrary-0.0.1.jar


// To adjust logging level use sc.setLogLevel("WARN")

// :load /path/to/file in the repl to run scala code

//---------execute shell command
import sys.process._
"ls /home/hadoop"!

//------ Spark REPL MultiLine Paste
:paste

things here

ctl-D to finsih



//----------------RDD

rdd1 = {(1, 2), (3, 4), (3, 6)} rdd2 = {(3, 9)}

val pairRDD1 = sc.parallelize(List( ("cat",2), ("cat", 5), ("book", 4),("cat", 12)))

val rdd1 = sc.parallelize(List( (1, 2), (3, 4), (3, 6) ))
val rdd2 = sc.parallelize(List( (3, 9) ))

// Collections with Description
// 1	Scala Lists
// Scala's List[T] is a linked list of type T.

// 2	Scala Sets
// A set is a collection of pairwise different elements of the same type.

// 3	Scala Maps
// A Map is a collection of key/value pairs. Any value can be retrieved based on its key.

// 4	Scala Tuples
// Unlike an array or list, a tuple can hold objects with different types.

// 5	Scala Options
// Option[T] provides a container for zero or one element of a given type.

// 6	Scala Iterators
// An iterator is not a collection, but rather a way to access the elements of a collection one by one.

// Define List of integers.
val x = List(1,2,3,4)

// Define a set.
var x = Set(1,3,5,7)

// Define a map.
val x = Map("one" -> 1, "two" -> 2, "three" -> 3)

// Create a tuple of two elements.
val x = (10, "Scala")

// Define an option
val x:Option[Int] = Some(5)


//--------------Joining data by registering RDD as table
//  echo "a, 1
// b, 2
// c, 3
// d, 4" > ages.txt
//  echo "a, 10
// b, 20
// c, 30
// d, 40" > scores.txt
// hadoop fs -put ages.txt /user/hadoop/temp/ages.txt
// hadoop fs -put scores.txt /user/hadoop/temp/scores.txt
val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext._
case class Score(name: String, score: Int) //The class represents the schema here
case class Age(name: String, age: Int)
val scores = sc.textFile("/user/hadoop/temp/scores.txt").map(_.split(",")).map(s => Score(s(0),s(1).trim.toInt))
val ages = sc.textFile("/user/hadoop/temp/ages.txt").map(_.split(",")).map(s => Age(s(0),s(1).trim.toInt))

//This give us an RDD or Score objects now we need to convert that to a DataFrame
val scoresDF = scores.toDF()
val agesDF = ages.toDF()

scoresDF.map( x=> (x(1) )).collect() // Gets the second thing

scoresDF.select("name", "score").write.format("parquet").save("/user/hadoop/temp/namesAndScores.parquet")

scoresDF.select("name", "score").write.format("parquet").save("s3://bucket_name/namesAndScores.parquet")




//This is not working yet :( - it's working in other examples -
scoresDF.registerTempTable("scores")
agesDF.registerTempTable("ages")
val joined = sqlContext.sql("""
    SELECT a.name, a.age, s.score
    FROM ages a JOIN scores s
    ON a.name = s.name""")
joined.collect().foreach(println)


//----------------DataFrames
//With a SQLContext, applications can create DataFrames from an existing RDD, from a Hive table, or from data sources.

//SQLContext - don't use load methods as they are depricated use read.json

//----------------Here we explicitly create a schema and wrap the data in a DataFrame
// Create an RDD
// echo "a, 1
// b, 2
// c, 3
// d, 4" > people.txt
"hadoop fs -mkdir  /user/hadoop/temp"!
"hadoop fs -put people.txt /user/hadoop/temp"!
val people = sc.textFile("/user/hadoop/temp/people.txt")

// The schema is encoded in a string
val schemaString = "name age"

import org.apache.spark.sql.Row;
import org.apache.spark.sql.types.{StructType,StructField,StringType};
// Generate the schema based on the string of schema
val schema =
  StructType(
    schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))

// Convert records of the RDD (people) to Rows.
val rowRDD = people.map(_.split(",")).map(p => Row(p(0), p(1).trim))

// Apply the schema to the RDD.
val peopleDataFrame = sqlContext.createDataFrame(rowRDD, schema)

// Register the DataFrames as a table.
peopleDataFrame.registerTempTable("people")

// SQL statements can be run by using the sql methods provided by sqlContext.
val results = sqlContext.sql("SELECT name FROM people")

// The results of SQL queries are DataFrames and support all the normal RDD operations.
// The columns of a row in the result can be accessed by field index or by field name.
results.map(t => "Name: " + t(0)).collect().foreach(println)

val results = sqlContext.sql("SELECT * FROM people")
results.map(t => "Age: " + t(1)).collect().foreach(println)


// //--------------resgisterTempTable and saving
// registerTempTable() creates an in-memory table that is scoped to the cluster
// in which it was created. The data is stored using Hive's highly-optimized, in-memory columnar format.
// Re-registering a temp table of the same name (using overwrite=true) but with new data causes an
// atomic memory pointer switch so the new data is seemlessly updated and immediately accessble for querying.

//saveAsTable() creates a permanent, physical table stored in S3 using the Parquet format if everything is set up correctly

//-------------------Save a data frame in Hive
val hiveWarehouseHDFSLocation = "hdfs://ec2-54-236-190-205.compute-1.amazonaws.com/user/hive/warehouse"
val options = Map("path" -> hiveWarehouseHDFSLocation)
//This is how you write with a partition
//agesDF.write.format("orc").partitionBy("partitiondate").options(options).mode(SaveMode.Append).saveAsTable("agesDF")
agesDF.write.format("sequencefile").options(options).mode(SaveMode.Append).saveAsTable("agesDF")


//-------------------sql data in spark
// Spark SQL provides inbuilt support for only 3 types of data sources:
// Parquet (This is default)
// Json
// Jdbc
// For CSV, there is a separate library: spark-csv
// Scala 2.10

// groupId: com.databricks
// artifactId: spark-csv_2.10
// version: 1.3.0
// It's CsvContext class provides csvFile method which can be used to load csv.
//val cars = sqlContext.csvFile("cars.csv") // uses implicit class CsvContext

//Starting the repl with the spark-cvs reader
			//spark-shell --packages com.databricks:spark-csv_2.10:1.3.0

//Here is another example
import org.apache.spark.sql.{SQLContext, Row, DataFrame}

//First curl https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD | Crimes_-_2001_to_present.csv
//hadoop fs -put Crimes_-_2001_to_present.csv /user/hadoop/temp/Crimes_-_2001_to_present.csv
val sqlContext = new SQLContext(sc)
val crimeFile = "/user/hadoop/temp/Crimes_-_2001_to_present.csv"
sqlContext.load("com.databricks.spark.csv", Map("path" -> crimeFile, "header" -> "true")).registerTempTable("crimes")

//Try to write DF using spark-csv
scoresDF.save("/tmp/d.csv", "com.databricks.spark.csv")

//----------------- UDF Exampple
import org.apache.spark.sql.functions.udf

val toDate = (t: String) => t.split("T")(0)
val toDateUDF = udf(toDate)
val dfWithDate = df.withColumn("collector_date", toDateUDF(df.col("collector_tstamp")))

//------------------Drop Column from data frame
// Use select() to create a new DataFrame with only the columns you want.
// Sort of the opposite of what you want -- but you can select all but the columns you want minus the one you don.
// You could even use a filter to remove just the one column you want on the fly:
//
//                 myDF.select(myDF.columns.filter(_ != "column_you_do_not_want").map(colname => new Column(colname)).toList : _* )


//-----------------Local Data Location
//
//              spark.local.dir (by default /tmp)
//This is the directory used for local storage in Spark, including map output files and RDDs that get stored on disk.
//This should be on a fast, local disk in your system. It can also be a comma-separated list of multiple directories on different disks.
//Note this is also SPARK_LOCAL_DIRS (Standalone, Mesos) or LOCAL_DIRS (YARN) environment variables set by the cluster manager.



//Multiline string in scala - enclose these with

"""
Multiline
String
Scala
"""
