# Spark 2.0 R Spike

##SparkR Documentation Here;
http://spark.apache.org/docs/latest/sparkr.html

#Sparklyr

##splarklyr codumentation here;
##http://spark.rstudio.com/index.html

```
install.packages("devtools")
devtools::install_github("rstudio/sparklyr")

library(sparklyr)
library(dplyr)

Sys.setenv(SPARK_HOME = "/usr/lib/spark")
sc <- spark_connect(master = "yarn-client")

library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

#Not sure if the sparklyr package does this for us
sparkR.session(master = "yarn-client", sparkConfig = list(spark.driver.memory = "2g"))

df <- read.df("s3://bucket_names/location/testRDD.parquet")

#We can also read Parquet with the sparklyr
#spark_read_parquet(sc, name, path, options = list(), repartition = 0,memory = TRUE, overwrite = TRUE)
	#sc The Spark connection
	#name Name of table
	#path The path to the file. Needs to be accessible from the cluster. Supports: "hdfs://" or "s3n://"
	#options A list of strings with additional options. See http://spark.apache.org/docs/latest/sql-programming-guide.html#configuration.
	#repartition Total of partitions used to distribute table or 0 (default) to avoid partitioning
	#memory Load data eagerly into memory
	#overwrite Overwrite the table with the given name if it already exists

df2 <- spark_read_parquet(sc,"s3:/bucket_names/testRDD.parquet", name = "consumption")

#This should list the tables. It's a sparklyr function extension
src_tbls(sc)
```



Did you see this error installing devtools?
```* DONE (withr)
ERROR: dependencies ‘curl’, ‘openssl’ are not available for package ‘httr’
* removing ‘/home/rstudio/R/x86_64-redhat-linux-gnu-library/3.2/httr’
```

curl and curl-devel are installed according to yum

We've seen this before - it comes from trying to install via rstudio.

Install these in the R console if you come accross this.

Note - updating the version of RStudio to the very latest preview eliminates the problem above.
