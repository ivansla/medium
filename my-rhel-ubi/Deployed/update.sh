sudo docker build --tag=ivansla/my-local-repo:my-rhel-policy-deployed .
sudo docker container stop my-rhel-policy-deployed
sudo docker container rm my-rhel-policy-deployed
sudo docker run -dt --name my-rhel-policy-deployed ivansla/my-local-repo:my-rhel-policy-deployed
sudo docker network connect my-network my-rhel-policy-deployed
sudo docker network inspect my-network
sudo docker exec -ti my-rhel-policy-deployed bash