sudo docker container stop my-ubuntu
sudo docker container rm my-ubuntu
sudo docker image rm ivansla/my-repo:my-ubuntu
sudo docker build --tag=ivansla/my-repo:my-ubuntu .
sudo docker run -dt --name my-ubuntu ivansla/my-repo:my-ubuntu
sudo docker network connect my-network my-ubuntu
sudo docker network inspect my-network
sudo docker exec -ti my-ubuntu bash