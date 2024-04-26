sudo docker build --tag=ivansla/my-repo:my-mq-rhel .
sudo docker container stop RHELMQ
sudo docker container rm RHELMQ
sudo docker run -dt --name RHELMQ ivansla/my-repo:my-mq-rhel
sudo docker network connect my-network RHELMQ
sudo docker network inspect my-network
sudo docker exec -ti RHELMQ bash