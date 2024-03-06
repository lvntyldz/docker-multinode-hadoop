# Hadoop Multinode Cluster Docker Image

## Description

This repository prepared for create hadoop multinode cluster within docker container as automatically.

- firstly you will create a docker image that contains installed hadoop and other environments.
- after that you will create a master container that has master configurations.
- lastly you will create slave containers as the number given.

## Run

The easiest way to get this docker image installed is to clone the latest version from the git repository and run bellow commands:

```sh
$ git clone <>
$ cd docker-multinode-hadoop
$ ./run.sh <SLAVE_CONTAINER_COUNT>
```

### Sample(Create Container)

To create a master container and 2 slave containers which will be related master containers run below commands.

```sh
$ git clone <>
$ cd docker-multinode-hadoop
$ ./run.sh 2
```

## Sample Word Count

Follow below steps to run the word count example that is "hello world" of hadoop community.

```sh
$ cd codeSamples/
```

This script counts of word in a text file that contains A.SANCAR's summary of life.

```sh
$ ./src/run/wc/run.sh
```

## [Docker Swarm for Multiple Hosts Hadoop Setup]((https://www.youtube.com/watch?v=nGSNULpHHZc))

`Step: 1`: Start Swarm on master node. Use the token generated to join slaves to the swarm

```sh
docker swarm init
```

**NOTE**: Upon initializing the swarm manager, you will receive a token in a command formatted as follows, which you'll need to execute on the slave nodes:

`docker swarm join --token <TOKEN> <IP:PORT>`

`Step: 2`: Create an overlay network that will be used by the hadoop containers

```sh
docker network create -d overlay --subnet=10.0.9.0/24 --attachable hadoop-overlay
```

_Run a sample docker service just to make sure overlay newtork is discoverable across hosts_

`Step: 3`: Build Docker Image on all the hosts

```sh
docker build -t base-hadoop .
```

`Step: 4`: Start the master container on the **master host/node**

```sh
docker run -itd --name master --net hadoop-overlay --ip 10.0.9.22 --hostname master --add-host worker1:10.0.9.23 --add-host worker2:10.0.9.24 -p 8081:8080 -p 8089:8088 -p 9871:9870 base-hadoop
```

`Step: 5`: Start the worker container 1 on **slave host/node**

```sh
docker run -itd --name worker1 --net hadoop-overlay --ip 10.0.9.23 --hostname worker1 --add-host master:10.0.9.22 base-hadoop
```

`Step: 6`*(Optional): Start the worker container 2 in the same way on **slave host/node**:*
```sh
docker run -itd --name worker2 --net hadoop-overlay --ip 10.0.9.24 --hostname worker2 --add-host master:10.0.9.22 base-hadoop
```

`Step: 7`: Format HDFS and start services on Master

```sh
docker exec -ti master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"
```

`Step: 8`: Start datanode and nodemanager on Worker containers

```sh
docker exec -ti worker1 bash -c "/usr/local/hadoop/sbin/hadoop-daemon.sh start datanode && /usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager"
```
