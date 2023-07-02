sudo docker build --tag=ivansla/my-repo:my-ace-with-mq .
sudo docker container stop ace
sudo docker container rm ace
sudo docker run -dt --name ace ivansla/my-repo:my-ace-with-mq
sudo docker network connect my-network ace
sudo docker network inspect my-network
sudo docker exec -ti ace bash
