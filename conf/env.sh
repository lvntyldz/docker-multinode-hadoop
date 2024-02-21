echo "
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/
export ENV HDFS_NAMENODE_USER=root
export ENV HDFS_DATANODE_USER=root
export ENV HDFS_SECONDARYNAMENODE_USER=root
export ENV YARN_RESOURCEMANAGER_USER=root
export ENV YARN_NODEMANAGER_USER=root
" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh