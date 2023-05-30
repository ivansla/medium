sudo docker container stop QM1
sudo docker container rm QM1
sudo docker image rm ivansla/my-repo:my-mq-with-ldaps
sudo docker build --tag=ivansla/my-repo:my-mq-with-ldaps .
sudo docker run -dt --name QM1 ivansla/my-repo:my-mq-with-ldaps
sudo docker network connect my-network QM1
sudo docker network inspect my-network
sudo docker exec -ti QM1 bash


