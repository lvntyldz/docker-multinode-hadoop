#!/bin/bash

# Set default slave container count if it's unset
if [ -z "$1" ]; then
    slaveCount=1
else
    slaveCount=$1
fi

echo "$slaveCount slave and 1 master container will be created..."

# Add all slave container names to slaves file
for (( i=1; i<=$slaveCount; i++ )); do
    echo "Exporting slave$i to slaves file..."
    echo "slave$i" >> ./conf/slaves
done

# Check if the hadoopNetwork exists before attempting to remove it
if [[ $(docker network ls -f name=hadoopNetwork -q) ]]; then
    docker network rm hadoopNetwork
fi

# Create a network named "hadoopNetwork"
docker network create -d bridge --subnet 172.25.0.0/16 hadoopNetwork

# Create base hadoop image named "base-hadoop:1.0"
docker build -t base-hadoop:1.0 .

# Run base-hadoop:1.0 image as master container
docker run -itd --network="hadoopNetwork" --ip 172.25.0.100 -p 50070:50070 -p 8088:8088 --name master --hostname master base-hadoop:1.0

# Run base-hadoop:1.0 image as slave containers
for (( c=1; c<=$slaveCount; c++ )); do
    tmpName="slave$c"
    # Run base-hadoop:1.0 image as slave container
    docker run -itd --network="hadoopNetwork" --ip "172.25.0.10$c" --name $tmpName --hostname $tmpName base-hadoop:1.0
done

# Run Hadoop commands inside the master container
docker exec -ti master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"

# Sort and remove duplicate entries in slaves file
docker exec -ti master bash -c "sort /usr/local/hadoop/etc/hadoop/slaves | uniq > /tmp/slaves_temp && mv /tmp/slaves_temp /usr/local/hadoop/etc/hadoop/slaves"

# Drop into a bash shell within the master container for further interaction
docker exec -ti master bash

