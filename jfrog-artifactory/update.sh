sudo docker container stop jfrog-artifactory
sudo docker container rm jfrog-artifactory
sudo docker image rm ivansla/my-repo:jfrog-artifactory
sudo docker build --tag=ivansla/my-repo:jfrog-artifactory .
sudo docker run -dt -p 8082:8082 --name jfrog-artifactory ivansla/my-repo:jfrog-artifactory
sudo docker network connect my-network jfrog-artifactory
sudo docker network inspect my-network
sudo docker exec -ti jfrog-artifactory bash