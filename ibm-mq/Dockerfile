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

RUN groupadd --gid 1000 mqm
RUN groupadd --gid 2000 mqexplorers
RUN useradd --uid 1000 --gid mqm -s /bin/bash --create-home --home-dir /home/mqm mqm
RUN usermod -G mqm root

# important, don't put mqexplorer user into mqm group or mqexplorer will not work
RUN useradd --uid 3000 --groups mqexplorers -s /bin/bash --create-home --home-dir /home/mqexplorer mqexplorer

# The URL to download the MQ installer from in tar.gz format
ARG MQ_FILE=mqadv_dev925_ubuntu_x86-64.tar.gz
ARG MQ_URL=http://192.168.15.11:9000/$MQ_FILE
#ARG MQ_URL=https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/$MQ_FILE
ARG MQ_PACKAGES="./ibmmq-jre_9.2.5.0_amd64.deb ./ibmmq-runtime_9.2.5.0_amd64.deb ./ibmmq-gskit_9.2.5.0_amd64.deb ./ibmmq-server_9.2.5.0_amd64.deb ./ibmmq-java_9.2.5.0_amd64.deb ./ibmmq-samples_9.2.5.0_amd64.deb"

RUN export DEBIAN_FRONTEND=noninteractive \
  # Optional: Update the command prompt
  && echo "mq:9.0" > /etc/debian_chroot \
  # Install additional packages required by MQ, this install process and the runtime scripts
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    bash \
    bc \
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
    rpm \
    sed \
    tar \
    vim \
    telnet \
    iputils-ping \
    rsyslog \
    less \
    util-linux \
    ca-certificates \
  # Setting default shell to bash for new users \
  &&  sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd \
  # Download and extract the MQ installation files \
  && mkdir -p /tmp/mq \
  && cd /tmp/mq \
  && curl -LO $MQ_URL \
  && tar -zxvf ./*.tar.gz \
  && cd /tmp/mq/MQServer \
  #   Accept the MQ license
  && ./mqlicense.sh -text_only -accept \
  #   Install MQ using the DEB packages
  && apt install ./$MQ_PACKAGES \
  #   Recommended: Set the default MQ installation (makes the MQ commands available on the PATH)
  && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
  # Cleanup
  && rm -rf /tmp/mq \
  && rm -rf /var/lib/apt/lists/*

COPY --chmod=500 mq-setup.sh /home/mqm/mq-setup.sh
COPY --chmod=500 mq-start.sh /home/mqm/mq-start.sh
COPY --chmod=444 mq-setup.mqsc /home/mqm/mq-setup.mqsc
RUN ["/home/mqm/mq-setup.sh", "QMgr01", "1414", "mqexplorers"]
ENTRYPOINT ["/home/mqm/mq-start.sh", "QMgr01"]
