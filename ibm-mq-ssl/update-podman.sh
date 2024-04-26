podman container stop my-mq-with-ssl-2
podman container rm my-mq-with-ssl-2
podman image rm ivansla/my-repo:my-mq-with-ssl
podman build --tag=ivansla/my-repo:my-mq-with-ssl .
podman run -dt --privileged=true --name my-mq-with-ssl-2 ivansla/my-repo:my-mq-with-ssl
podman network connect my-network my-mq-with-ssl-2
podman network inspect my-network
podman exec -ti my-mq-with-ssl-2 bash


