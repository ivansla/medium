podman build --tag=ivansla/my-repo:my-mq .
podman container stop QM1
podman container rm QM1
podman run -dt --privileged=true --name QM1 ivansla/my-repo:my-mq
podman network connect my-network QM1
podman network inspect my-network
podman exec -ti QM1 bash

sudo docker run -dt --privileged \
-v /run/systemd/system:/run/systemd/system \
-v /bin/systemctl:/bin/systemctl \
-v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
-v /usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu \
-v /lib/systemd:/lib/systemd \
--name systemctl ivansla/my-repo:my-mq \
bash -c "ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6 /usr/lib/x86_64-linux-gnu/libtinfo.so.5 && bash & sleep 600"