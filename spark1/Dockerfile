# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM continuumio/miniconda:4.2.12
MAINTAINER Anup Ash

USER root

# Spark dependencies
ENV APACHE_SPARK_VERSION 1.6.1
ENV HADOOP_VERSION 2.6

# Temporarily add jessie backports to get openjdk 8, but then remove that source
RUN echo 'deb http://cdn-fastly.deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get -y update && \
    apt-get install --no-install-recommends -t jessie-backports -y openjdk-8-jre-headless ca-certificates-java && \
    rm /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
        wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

# adding s3 dependencies so that spark can query s3 file system
RUN cd /usr/local/spark/jars; wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar
RUN cd /usr/local/spark/jars; wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.6.0/hadoop-aws-2.6.0.jar



# Spark and Mesos config
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.9-src.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info


COPY environment.yml /install/
RUN cd /install && conda env update

# on demand
RUN apt-get update && apt-get -y install htop libgeos-dev libsnappy-dev

# remove authentication if any time for jupyter notebooks
RUN mkdir /root/.jupyter && printf "\nc.NotebookApp.token = u'' \n\n" >> /root/.jupyter/jupyter_notebook_config.py


