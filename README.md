
[Written Duy Nguyen, Jan 2021]

# Installation

### Create a Kafka Cluster

Let's create a custom network

```bash
# A non-default bridge network enables convenient name-to-hostname discovery
docker network create --subnet=172.20.0.0/16 mynet
```
Next, create a Zookeeper container.

```bash
docker pull zookeeper:3.4
docker run -d --hostname zookeepernode --net mynet --ip 172.20.1.3 --name my_zookeeper --publish 2181:2181 zookeeper:3.4
```

Finally, create a Kafka container. Note that if you're using OSX, substitute the value of the two `env`parameters with your machine ip (e.g. `192.168.1.100`). See more here: https://github.com/ches/docker-kafka/pull/30/commits/daa8f3e480d04c13f6aac4719637ca7a5b78ef53
```bash
docker pull ches/kafka
docker run -d --hostname kafkanode --net mynet --ip 172.20.1.4 --name my_kafka --publish 9092:9092 --publish 7203:7203 --env KAFKA_ADVERTISED_HOST_NAME=10.32.161.205 --env ZOOKEEPER_IP=10.32.161.205 ches/kafka 
```

### Create Single Node Hadoop and Spark cluster

`cd` into `hadoop_spark_cluster_image` folder. Then then the following two commands. In short, the first command is to create the Docker images for Hadoop, Spark, Hive, and PostgreSQL. The second command is to create the clusters from these images.

```bash
sh ./1_create_hadoop_spark_image.sh

sh ./2_create_hadoop_spark_cluster.sh create
```

# Usage

### Event simulator

First, run the `simulator.py` file to send generated event details to the Kafka cluster.

At the same time, we can also run `kafka_consumer_demo.py` file to test if the Kafka cluster received the data.

### Set up the PostgreSQL database

In short, we create a user, the `event_message_db` database and grant all privileges on `event_message_db` to the newly created user. Later when we run the streaming data pipeline, data will be saved into this database.
```bash
psql -U postgres

CREATE USER my_user WITH PASSWORD 'my_user';

ALTER USER my_user WITH SUPERUSER;


CREATE DATABASE event_message_db;


GRANT ALL PRIVILEGES ON DATABASE event_message_db TO my_user;
``` 
### Streaming Data pipeline
First, you need to download Apache Spark. https://spark.apache.org/downloads.html. For Java 15+, you need Apache Spark 3.0.1.

Run the `streaming_data_pipeline.py` file. Note that you need to change the path to jar files in line 49-56 to `jar_files` folder location. 

Here, events are consumed from Kafka topic; and then transformed, processed, aggreated and then stored in PostgreSQL database. Meanwhile, raw data is stored in the HDFS.


### Set up the web app

Setup the dashboard
```bash
django-admin startproject server_status_monitoring

python manage.py startapp dashboard

python manage.py makemigrations dashboard

python manage.py migrate dashboard

```
Then run the server locally
```bash
python manage.py runserver
```

### Reference: 
https://github.com/ches/docker-kafka
https://www.youtube.com/channel/UCFQucNX7WsUwaWGNTrn6bIQ
