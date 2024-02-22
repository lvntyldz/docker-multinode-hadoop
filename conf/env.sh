echo "
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/
export ENV HDFS_NAMENODE_USER=root
export ENV HDFS_DATANODE_USER=root
export ENV HDFS_SECONDARYNAMENODE_USER=root
" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

echo "
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
" >> /usr/local/hadoop/etc/hadoop/yarn-env.sh 

