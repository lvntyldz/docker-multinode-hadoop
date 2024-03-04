#set default worker container count if its unset
if [ -z "$1" ]; then
    workerCount=1
else
    workerCount=$1
fi

echo "$workerCount worker and 1 master container will be created..."

# Cleanup workers file
> ./conf/workers

# Add all worker container names to workers file
for (( i=1; i<=$workerCount; i++ )); do
    echo "Exporting worker$i to workers file..."
    echo "worker$i" >> ./conf/workers
done

# Check if the hadoopNetwork exists before attempting to remove it
if [[ $(docker network ls -f name=hadoopNetwork -q) ]]; then
    docker network rm hadoopNetwork
fi

# Create a network named "hadoopNetwork"
docker network create -d bridge --subnet 172.25.0.0/16 hadoopNetwork

# Create base hadoop image named "base-hadoop"
docker build -t base-hadoop .

# Run base-hadoop:1.0 image as master container
docker run -itd --network="hadoopNetwork" --ip 172.25.0.100 -p 9870:9870 -p 8088:8088 -p 9864:9864 --name master --hostname master base-hadoop

for (( c=1; c<=$workerCount; c++ )); do
    tmpName="worker$c"
    # Run base-hadoop:1.0 image as worker container
    docker run -itd --network="hadoopNetwork" --ip "172.25.0.10$c" --name $tmpName --hostname $tmpName base-hadoop
done

# Run hadoop commands
docker exec -ti master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"

docker exec -ti master bash