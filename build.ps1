docker build -t esrysf/hadoop-base:3.2.1 ./base
docker build -t esrysf/hadoop-namenode:3.2.1 ./namenode
docker build -t esrysf/hadoop-datanode:3.2.1 ./datanode
docker build -t esrysf/hadoop-resourcemanager:3.2.1 ./resourcemanager
docker build -t esrysf/hadoop-nodemanager:3.2.1 ./nodemanager
docker build -t esrysf/hadoop-historyserver:3.2.1 ./historyserver