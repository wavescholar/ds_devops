# Setting up a spark development on Windows 
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
Open your settings.xml file ```(~/.m2/settings.xml)```. Add a section with the properties added. Then make sure the activeProfiles contains this

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

Run Example

```
call set_env.cmd

cd c:\Bruceuser_name\SparkDevelopment\MLLib\

%SPARK_HOME%\bin\spark-submit --master local[2] --class com.kl.mllib.MLLibExample c:\Bruceuser_name\SparkDevelopment\MLLib\target\MLLibExample-0.0.1.jar .\data

```