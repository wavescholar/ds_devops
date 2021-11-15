
#Parquet File Format Notes 


hadoop fsck /output/xxx.snappy.parquet -files -blocks -locations

print the partitions like this

spark.read.parquet("/output/xxx.snappy.parquet").rdd.partitions.foreach(print)

Spark splits a large parquet with snappy file into multiple partition with the size of spark.sql.files.maxPartitionBytes

The Parquet row group size as defining how much data or how many rows to group together to be processed by a single task (the row groups exist for splittability but each can only be processed by one task)

Most people recommend setting the parquet.block.size = dfs.block.size or setting the parquet.block.size so that dfs.block.size is some integer multiple of the parquet.block.size (more parallelism). This ensures that there's some harmony between the number of partitions/parallelism and the number of row groups.


## Random scratch notes - some are quite dated.


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
    


    ##########Read Write In Java Map Reduce
    Using Parquet Files in MapReduce
MapReduce needs thrift in its CLASSPATH and in libjars to access Parquet files. It also needs parquet-format in libjars. Perform the following setup before running MapReduce jobs that access Parquet data files:

if [ -e /opt/cloudera/parcels/CDH ] ; then
    CDH_BASE=/opt/cloudera/parcels/CDH
else
    CDH_BASE=/usr
fi
THRIFTJAR=`ls -l $CDH_BASE/lib/hive/lib/libthrift*jar | awk '{print $9}' | head -1`
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$THRIFTJAR
export LIBJARS=`echo "$CLASSPATH" | awk 'BEGIN { RS = ":" } { print }' | grep parquet-format | tail -1`
export LIBJARS=$LIBJARS,$THRIFTJAR

hadoop jar my-parquet-mr.jar -libjars $LIBJARS
Reading Parquet Files in MapReduce
Taking advantage of the Example helper classes in the Parquet JAR files, a simple map-only MapReduce job that reads Parquet files can use the ExampleInputFormat class and the Group value class. There is nothing special about the reduce phase when using Parquet files. The following example demonstrates how to read a Parquet file in a MapReduce job; portions of code specific to the Parquet aspect are shown in bold.

import static java.lang.Thread.sleep;
import java.io.IOException;
  
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper.Context;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import parquet.Log;
import parquet.example.data.Group;
import parquet.hadoop.example.ExampleInputFormat;

public class TestReadParquet extends Configured
  implements Tool {
  private static final Log LOG =
  Log.getLog(TestReadParquet.class);

    /*
     * Read a Parquet record
     */
    public static class MyMap extends
      Mapper<LongWritable, Group, NullWritable, Text> {

      @Override
      public void map(LongWritable key, Group value, Context context) throws IOException, InterruptedException {
          NullWritable outKey = NullWritable.get();
          String outputRecord = "";
          // Get the schema and field values of the record
          String inputRecord = value.toString();
          // Process the value, create an output record
          // ...
          context.write(outKey, new Text(outputRecord));
      }
  }

  public int run(String[] args) throws Exception {

    Job job = new Job(getConf());

    job.setJarByClass(getClass());
    job.setJobName(getClass().getName());
    job.setMapOutputKeyClass(LongWritable.class);
    job.setMapOutputValueClass(Text.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    job.setMapperClass(MyMap.class);
    job.setNumReduceTasks(0);

    job.setInputFormatClass(ExampleInputFormat.class);
    job.setOutputFormatClass(TextOutputFormat.class);
       
    FileInputFormat.setInputPaths(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
       
    job.waitForCompletion(true);
    return 0;
  }

  public static void main(String[] args) throws Exception {
    try {
      int res = ToolRunner.run(new Configuration(), new TestReadParquet(), args); 
      System.exit(res);
    } catch (Exception e) {
      e.printStackTrace();
      System.exit(255);
    }
  }
}
Writing Parquet Files in MapReduce
When writing Parquet files you will need to provide a schema. The schema can be specified in the run method of the job before submitting it, for example:

...
import parquet.Log;
import parquet.example.data.Group;
import parquet.hadoop.example.GroupWriteSupport;
import parquet.hadoop.example.ExampleInputFormat;
import parquet.hadoop.example.ExampleOutputFormat;
import parquet.hadoop.metadata.CompressionCodecName;
import parquet.hadoop.ParquetFileReader;
import parquet.hadoop.metadata.ParquetMetadata;
import parquet.schema.MessageType;
import parquet.schema.MessageTypeParser;
import parquet.schema.Type;
...
public int run(String[] args) throws Exception {
...

  String writeSchema = "message example {\n" +
  "required int32 x;\n" +
  "required int32 y;\n" +
  "}";
  ExampleOutputFormat.setSchema(
    job,
    MessageTypeParser.parseMessageType(writeSchema));
  
  job.submit();
or it can be extracted from the input file(s) if they are in Parquet format:

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.LocatedFileStatus;
import org.apache.hadoop.fs.RemoteIterator;
...

public int run(String[]
  args) throws Exception {
...

String inputFile = args[0];
  Path parquetFilePath = null;
  // Find a file in case a directory was passed
 
  RemoteIterator<LocatedFileStatus> it = FileSystem.get(getConf()).listFiles(new Path(inputFile), true);
  while(it.hasNext()) {
      FileStatus fs = it.next();
     
    if(fs.isFile()) {
      parquetFilePath = fs.getPath();
      break;
    }
  }
  if(parquetFilePath == null) {
    LOG.error("No file found for " + inputFile);
    return 1;
  }
  ParquetMetadata readFooter =
    ParquetFileReader.readFooter(getConf(), parquetFilePath);
  MessageType schema =
    readFooter.getFileMetaData().getSchema();
  GroupWriteSupport.setSchema(schema, getConf());

  job.submit();
Records can then be written in the mapper by composing a Group as value using the Example classes and no key:

protected void map(LongWritable key, Text value,
  Mapper<LongWritable, Text, Void, Group>.Context context)
  throws java.io.IOException, InterruptedException {
    int x;
    int y;
    // Extract the desired output values from the input text
    //
    Group group = factory.newGroup()
      .append("x", x)
      .append("y", y);
    context.write(null, group);
  }
}
Compression can be set before submitting the job with:

ExampleOutputFormat.setCompression(job, codec);