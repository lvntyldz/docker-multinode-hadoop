FROM ubuntu:16.04

MAINTAINER Levent YILDIZ <dev.levent.yildiz@gmail.com>

RUN apt-get update
RUN apt-get install openjdk-8-jdk -y
RUN apt-get install -y wget
RUN apt-get install -y openssh-server
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.5/hadoop-2.7.5.tar.gz -P ~/Downloads
RUN tar zxvf ~/Downloads/hadoop-2.7.5.tar.gz  -C /usr/local
RUN mv /usr/local/hadoop-* /usr/local/hadoop

RUN mkdir /var/hadoop

ENV  JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV  PATH $PATH:$JAVA_HOME/bin
ENV  HADOOP_HOME /usr/local/hadoop
ENV  PATH $PATH:$HADOOP_HOME/bin
ENV  HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop

RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY conf/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config
RUN mv /tmp/core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml
RUN mv /tmp/mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
RUN mv /tmp/hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
RUN mv /tmp/masters /usr/local/hadoop/etc/hadoop/masters
RUN mv /tmp/slaves /usr/local/hadoop/etc/hadoop/slaves

RUN /tmp/env.sh

CMD [ "sh", "-c", "service ssh start; bash"]