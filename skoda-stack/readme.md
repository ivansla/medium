sudo docker compose up -d --build --remove-orphans
sudo docker compose exec amlen-webui bash

https://10.1.1.13:9087


sudo docker network disconnect skoda-stack_discovery skoda-stack-amlen-server-01-1
sudo docker network connect --ip 192.20.10.11 skoda-stack_discovery skoda-stack-amlen-server-01-1