#Zookeeper


##Backgroud

*Apache Zookeeper is a distributed service providing application infrastructure for common distributed coordination tasks such as configuration management, distributed synchronization objects such as locks and barriers, leader election. Zookeeper can be used for cluster membership ops such as leader election and adding & removing of nodes. Zookeeper is used in the Hadoop ecosystem for high availability provisioning of YARN Resource Manager, HDFS NameNode fail over, HBase Master, and Spark Master.

The ZooKeeper service provides the abstraction of a set of data nodes -called znodes – organized into a hierarchical name space. The hierarchy of znodes in the namespace provide the objects used to keep state information. Access to nodes are provided my paths in the hierarchy.

Zookeeper uses the Zab distributed consensus algorithms this is similar to the classical Paxos algorithms. Zab and Paxos both follow a protocol where leader proposes values to the followers and then the leaders wait for acknowledgements from a quorum of followers before considering a proposal committed. Proposals include epoch numbers (ballot numbers in Paxos) that are unique version numbers.

In addition to configuration management, distributed locks and group membership algorithms; Zookeeper primitives can be used to implement;

Double barriers enable clients to synchronize the beginning and the end of a computation.
When enough processes, defined by the barrier threshold, have joined the barrier, processes start their computation and leave the barrier once they have finished.

Sometimes in distributed systems, it is not always clear a priori what the final system configuration will look like. For example, a client may want to start a master process and several worker processes, but the starting processes is done by a scheduler, so the client does not know ahead of time information such as addresses and ports that it can give the worker processes to connect to the master. We handle this scenario with ZooKeeper using a rendezvous znode.

Zookeeper Zab protocol messages are encapsulated in a QuorumPacket;
class QuorumPacket {
int type; // Request, Ack, Commit, Ping, etc
long zxid;
buffer data;
vector authinfo; // only used for requests
}

The basic API for manipulating nodes.

create(path, data, flags): Creates a znode with path name path, stores data[] in it, and returns the name of the new znode. flags enables a client to select the type of znode: regular, ephemeral, and set the sequential flag

delete(path, version): Deletes the znode path if that znode is at the expected version

getData(path, watch): Returns the data and meta-data, such as version information, associated with the znode

setData(path, data, version): Writes data[] to znode path if the version number is the current version of the znode

getChildren(path, watch): Returns the set of names of the children of a znode

sync(path): Waits for all updates pending at the start of the operation to propagate to the server that the client is connected to

Watches are used to monitor state changes. ZooKeeper watches are one-time triggers and due to the latency involved between getting a watch event and resetting of the watch, it’s possible that a client might lose changes done to a znode during this interval. In a distributed application in which a znode changes multiple times between the dispatch of an event and resetting the watch for events, developers must be careful to handle such situations in the application logic.
*

*ZooKeeper runs on a cluster of servers called an ensemble that share the state of your data. (These may be the same machines that are running other Hadoop services or a separate cluster.) Whenever a change is made, it is not considered successful until it has been written to a quorum (at least half) of the servers in the ensemble. A leader is elected within the ensemble, and if two conflicting changes are made at the same time, the one that is processed by the leader first will succeed and the other will fail. ZooKeeper guarantees that writes from the same client will be processed in the order they were sent by that client. This guarantee, along with other features discussed below, allow the system to be used to implement locks, queues, and other important primitives for distributed queueing. The outcome of a write operation allows a node to be certain that an identical write has not succeeded for any other node.

A consequence of the way ZooKeeper works is that a server will disconnect all client sessions any time it has not been able to connect to the quorum for longer than a configurable timeout. The server has no way to tell if the other servers are actually down or if it has just been separated from them due to a network partition, and can therefore no longer guarantee consistency with the rest of the ensemble. As long as more than half of the ensemble is up, the cluster can continue service despite individual server failures. When a failed server is brought back online it is synchronized with the rest of the ensemble and can resume service.

It is best to run your ZooKeeper ensemble with an odd number of server; typical ensemble sizes are three, five, or seven. For instance, if you run five servers and three are down, the cluster will be unavailable (so you can have one server down for maintenance and still survive an unexpected failure). If you run six servers, however, the cluster is still unavailable after three failures but the chance of three simultaneous failures is now slightly higher.* - Cloudera

##Recipes - Locks, Queues, Barriers, .etc

https://zookeeper.apache.org/doc/r3.3.6/recipes.html

##Basics of zookeeper on EMR.

If you choose zookeeper as an ERM app - then a cluster will be created on startup.

There is a Hue client UI for Zookeeper on EMR versions above 5.0.

```
zookeeper-server status
```

You'll see the config file - cat this and you will get the config

```maxClientCnxns=50
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
dataDir=/var/lib/zookeeper
# the port at which the clients will connect
clientPort=2181

server.0=ip-10-32-70-42.blah:2888:3888
```


We should replicate the config file on all the nodes in the quorum

Now restart

```
sudo zookeeper-server restart
```



To access zookeeper from the command line:

```
zookeeper-client
```

It may seem like this is hot to get coneected in local mode, but executing zookeeer commands tells us otherwise.  For instance

Zookeeper stored data in a directory of znodes. We get set and create data in the znode hierarchy with the get set and create commands.  Zookeeper keeps a version id for the data.

```
zookeeper-client create /zk_test_data  state_data_to_persist
```

Too verify the data is stored on the zookeeper cluster

```zookeeper-client get  /zk_test_data```
