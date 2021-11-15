#Java Machine Learning Libraries

Here's a comparison of java machine learning libraries

https://java.libhunt.com/categories/430-machine-learning

##Smile - from Chief Data Scientist at ADP

https://github.com/haifengl/smile

	<dependency>
	      <groupId>com.github.haifengl</groupId>
	      <artifactId>smile-core</artifactId>
	      <version>1.1.0</version>
	</dependency>

Scala

   <dependency>
      <groupId>com.github.haifengl</groupId>
      <artifactId>smile-scala_2.11</artifactId>
      <version>1.1.0</version>
    </dependency>


```
rm -rf smile
git clone https://github.com/haifengl/smile
cd smile
git checkout tags/
git checkout tags/v1.2.0 -b v1.2.0
sbt clean compile test package
cd ../
```

##Time Series Libraries to Investigate

https://github.com/jrachiele/java-timeseries


https://github.com/jrachiele/makina


Some of the use gradle

###Gradle install
```
#This is for the devlopment environment
export gradle_version=2.14
wget -N https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip
mkdir /home/vagrant/opt/gradle
unzip gradle-$gradle_version-all.zip -d /home/vagrant/opt/gradle
export GRADLE_HOME=/home/vagrant/opt/gradle/gradle-2.14
export PATH=$PATH:$GRADLE_HOME/bin
```

##Building notes

```
#export JAVA_HOME=/home/vagrant/opt/jdk1.8.0_101/

rm -rf makina
git clone https://github.com/jrachiele/makina
cd makina
gradle build
cd ../


rm -rf java-timeseries
git clone https://github.com/jrachiele/java-timeseries
cd java-timeseries
gradle build
cd ../
```

Ran into this building smile with sbt - same error whether we use java 8 or 7
```
[error] (math/compile:compileIncremental) java.lang.IllegalArgumentException: invalid source release: 1.8
```

Ran into this building makina

```
A problem occurred evaluating root project 'makina'.
> Cannot add task ':experiment:sourcesJar' as a task with that name already exists
```

##Smile Notes


Smile uses sbt which can be imported to intellij.  When running the unit tests make sure to set the working directory to the sbt app_home location.  I beleive this is where the build.sbt file is locatet - the root of the git repo.
