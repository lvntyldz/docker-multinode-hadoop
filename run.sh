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
    echo "Exporting worker$i to slaves file..."
    echo "worker$i" >> ./conf/workers
done

# Create a network named "hadoopNetwork"
docker network rm hadoopNetwork && docker network create -d bridge --subnet 172.25.0.0/16 hadoopNetwork

# Create base hadoop image named "base-hadoop:1.0"
docker build -t base-hadoop:1.0 .

# Run base-hadoop:1.0 image as master container
docker run -itd --network="hadoopNetwork" --ip 172.25.0.100 -p 9870:9870 -p 8088:8088 -p 9864:9864 --name master --hostname master base-hadoop:1.0

for (( c=1; c<=$workerCount; c++ )); do
    tmpName="worker$c"
    # Run base-hadoop:1.0 image as worker container
    docker run -itd --network="hadoopNetwork" --ip "172.25.0.10$c" --name $tmpName --hostname $tmpName base-hadoop:1.0
done

# Run hadoop commands
docker exec -ti master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && yarn --daemon start resourcemanager && yarn --daemon start nodemanager && mapred --daemon start historyserver"
docker exec -ti master bash
