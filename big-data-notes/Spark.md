There are a number of ways to get pair RDDs in Spark. Many formats for loading from in will directly return pair RDDs for their key/value data. In other cases we have a regular RDD that we want to turn into a pair RDD. We can do this by running a map() function that returns key/value pairs.

To adjust logging level use sc.setLogLevel("WARN")

:load /path/to/file in the repl to run scala code 

rdd1 = {(1, 2), (3, 4), (3, 6)} rdd2 = {(3, 9)}

val pairRDD1 = sc.parallelize(List( ("cat",2), ("cat", 5), ("book", 4),("cat", 12)))

val rdd1 = sc.parallelize(List( (1, 2), (3, 4), (3, 6) ))
val rdd2 = sc.parallelize(List( (3, 9) ))


Collections with Description
1	Scala Lists
Scala's List[T] is a linked list of type T.

2	Scala Sets
A set is a collection of pairwise different elements of the same type.

3	Scala Maps
A Map is a collection of key/value pairs. Any value can be retrieved based on its key.

4	Scala Tuples
Unlike an array or list, a tuple can hold objects with different types.

5	Scala Options
Option[T] provides a container for zero or one element of a given type.

6	Scala Iterators
An iterator is not a collection, but rather a way to access the elements of a collection one by one.

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

//Scala REPL - list bound variable 
$intp.definedTerms.foreach(println)

