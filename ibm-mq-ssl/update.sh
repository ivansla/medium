sudo docker container stop my-mq-with-ssl-2
sudo docker container rm my-mq-with-ssl-2
sudo docker image rm ivansla/my-repo:my-mq-with-ssl
sudo docker build --tag=ivansla/my-repo:my-mq-with-ssl .
sudo docker run -dt --privileged=true --name my-mq-with-ssl-2 ivansla/my-repo:my-mq-with-ssl
sudo docker network connect my-network my-mq-with-ssl-2
sudo docker network inspect my-network
sudo docker exec -ti my-mq-with-ssl-2 bash


