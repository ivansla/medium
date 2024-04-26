sudo docker network connect --ip 192.20.10.11 skoda-stack_discovery skoda-stack-amlen-server-01-1
sudo docker network connect --ip 192.20.10.12 skoda-stack_discovery skoda-stack-amlen-server-02-1


sudo docker network connect --ip 192.20.20.11 skoda-stack_replication skoda-stack-amlen-server-01-1
sudo docker network connect --ip 192.20.20.12 skoda-stack_replication skoda-stack-amlen-server-02-1