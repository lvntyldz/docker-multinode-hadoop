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

## Using Swarm for Multiple Hosts

Start Swarm on master node. Use the token generated to join slaves to the swarm

```sh
docker swarm init
```

Create an overlay network that will be used by the hadoop containers

```sh
docker network create -d overlay --subnet=10.0.9.0/24 --attachable hadoop-overlay
```

_Run a sample docker service just to make sure overlay newtork is discoverable across hosts_

## Build Docker Image

```sh
docker build -t hadoop-base .
```

- Start the master container

```sh
docker run --rm --name master --net hadoop-overlay --ip 10.0.9.22 --hostname master -it --add-host worker1:10.0.9.23 --add-host worker:10.0.9.24 -p 8080:8080 -p 8088:8088 -p 9870:9870 hadoop-base
```

- Start the worker container

```sh
docker run --rm --name worker1 --net hadoop-overlay --ip 10.0.9.23 --hostname worker1 -it --add-host hadoop-master:10.0.9.22 hadoop-base
```

## Format HDFS and Start Services

- On Master

```sh
docker exec -ti master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"
```

docker exec -ti master bash

- On Worker

```sh
docker exec -ti worker1 bash -c "/usr/local/hadoop/sbin/hadoop-daemon.sh start datanode && /usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager"
```
