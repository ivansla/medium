sudo docker container stop apache-ds
sudo docker container rm apache-ds
sudo docker image rm ivansla/my-repo:apache-ds
sudo docker build --tag=ivansla/my-repo:apache-ds .
sudo docker run -dt --name apache-ds ivansla/my-repo:apache-ds
sudo docker network connect my-network apache-ds
sudo docker network inspect my-network
sudo docker exec -ti apache-ds bash


