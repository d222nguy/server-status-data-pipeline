#!/bin/bash

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Building Hadoop Docker Image
docker build -f ./my_hadoop/Dockerfile . -t hadoop_spark_cluster:my_hadoop

# Building Spark Docker Image
docker build -f ./my_spark/Dockerfile . -t hadoop_spark_cluster:my_spark

# Building PostgreSQL Docker Image for Hive Metastore Server
docker build -f ./my_postgresql/Dockerfile . -t hadoop_spark_cluster:my_postgresql

# Building Hive Docker Image
docker build -f ./my_hive/Dockerfile . -t hadoop_spark_cluster:my_hive

