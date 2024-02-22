#set default slave container count if its unset
if [ -z "$1" ]
  then
    slaveCount=1
  else
  	slaveCount=$1
fi

echo "$slaveCount slave and 1 master  container will be created..."

#add all slave containers name  to slaves file
for (( i=1; i<=$slaveCount; i++ ))
do
    echo "Exporting slave$i to salves file..."
    echo "slave$i" >> ./conf/slaves
done

#Create a network named "hadoopNetwork"
docker network rm hadoopNetwork && docker network create -d bridge   --subnet 172.25.0.0/16  hadoopNetwork

#Create base hadoop image named "base-hadoop:1.0"
docker build -t base-hadoop:1.0 .

#run base-hadoop:1.0 image  as master container
docker run -itd  --network="hadoopNetwork"  --ip 172.25.0.100  -p 9870:9870  -p 8088:8088 -p 9864:9864 --name master --hostname master  base-hadoop:1.0


for (( c=1; c<=$slaveCount; c++ ))
do
    tmpName="slave$c"
    #run base-hadoop:1.0 image  as slave container
    docker run -itd  --network="hadoopNetwork"  --ip "172.25.0.10$c" --name $tmpName --hostname $tmpName  base-hadoop:1.0

    # Start datanode service inside the slave container
    docker exec $tmpName hdfs --daemon start datanode
    docker exec $tmpName yarn --daemon start nodemanager

done

#run hadoop commands
docker exec -ti master bash  -c "hadoop namenode -format && usr/local/hadoop/sbin/start-dfs.sh && yarn --daemon start nodemanager && yarn --daemon start resourcemanager"
docker exec -ti master bash
