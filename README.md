# Hadoop Multinode Cluster Docker Image
[![Go to Docker Hub](https://img.shields.io/badge/Docker%20Hub-%E2%86%92-blue.svg)](https://registry.hub.docker.com/u/leventyildiz/docker-multinode-hadoop/)

## Description
This repository prepared for create hadoop multinode cluster within docker container as automatically.
- firstly you will create a docker image that contains installed hadoop and other environments.
- after that you will create a master container that has master configurations.
- lastly you will create slave containers as the number given.


## Run

The easiest way to get this docker image installed is to clone  the latest version from the git repository and run bellow commands:

```sh
$ git clone https://github.com/lvntyldz/docker-multinode-hadoop.git
$ cd docker-multinode-hadoop
$ ./run.sh <SLAVE_CONTAINER_COUNT>
```


### Sample(Create Container)
To create a master container and 2 slave containers which will be related master containers run below commands.

```sh
$ git clone https://github.com/lvntyldz/docker-multinode-hadoop.git
$ cd docker-multinode-hadoop
$ ./run.sh 2
```

## Sample Word Count
Follow below steps to run the word count example that is "hello world" of  hadoop community.
```sh
$ cd codeSamples/
```
This script counts of word in a text file that contains A.SANCAR's summary of life.
```sh
$ ./src/run/wc/run.sh
```


## Web UI
Visit these urls from local browser

(http://localhost:50070/dfshealth.html#tab-datanode)
||
(http://localhost:8088/cluster/nodes)
