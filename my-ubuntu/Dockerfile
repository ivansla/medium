# expanded from deprecated repository: https://hub.docker.com/r/ibmcom/mq/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:20.04
VOLUME /home

RUN useradd --uid 1000 -s /bin/bash --create-home --home-dir /home/ivansla ivansla
RUN usermod -aG sudo ivansla

RUN export DEBIAN_FRONTEND=noninteractive \
  # Optional: Update the command prompt
  && echo "my-ubuntu:20.04" > /etc/debian_chroot \
  # Install additional packages required by MQ, this install process and the runtime scripts
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    bash \
    sudo \
    bc \
    systemctl \
    coreutils \
    curl \
    debianutils \
    findutils \
    gawk \
    grep \
    libc-bin \
    mount \
    passwd \
    procps \
    net-tools \
    rpm \
    sed \
    tar \
    vim \
    gnupg \
    telnet \
    iputils-ping \
    rsyslog \
    less \
    util-linux \
    ca-certificates \
  # Setting default shell to bash for new users \
  &&  sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd \
  && echo "ivansla ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENTRYPOINT ["bash", "-c", "sleep 600"]
#CMD ["/bin/bash"]
