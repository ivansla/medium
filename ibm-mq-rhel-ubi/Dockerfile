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

FROM registry.access.redhat.com/ubi8/ubi-minimal
VOLUME /home

RUN microdnf update -y && microdnf install util-linux python3.9 sudo passwd vim openssh-server curl bc tar iputils procps net-tools tar hostname findutils less nano nc && microdnf clean all

# can solve problem for creating keystore on AMD processors. https://github.com/ibm-messaging/mq-container/issues/462
ENV ICC_SHIFT=3

RUN groupadd --gid 1000 mqm
RUN groupadd --gid 2000 mqexplorers
RUN useradd --uid 1000 --gid mqm -s /bin/bash --create-home --home-dir /home/mqm mqm
RUN useradd --uid 1200 --gid mqm -s /bin/bash --create-home --home-dir /home/ivansla ivansla
RUN useradd --uid 1400 --gid mqexplorers -s /bin/bash --create-home --home-dir /home/mqclient mqclient
RUN usermod -G mqm root

# important, don't put mqexplorer user into mqm group or mqexplorer will not work
RUN useradd --uid 3000 --groups mqexplorers -s /bin/bash --create-home --home-dir /home/mqexplorer mqexplorer

# The URL to download the MQ installer from in tar.gz format
ARG MQ_FILE=IBM_MQ_9.2.0.2_LINUX_X86-64.tar.gz
ARG MQ_URL=http://192.168.15.10:9000/$MQ_FILE
#ARG MQ_URL=https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/$MQ_FILE
ARG MQ_PACKAGES="./MQSeriesJRE-9.2.0-2.x86_64.rpm ./MQSeriesRuntime-9.2.0-2.x86_64.rpm ./MQSeriesGSKit-9.2.0-2.x86_64.rpm ./MQSeriesServer-9.2.0-2.x86_64.rpm ./MQSeriesJava-9.2.0-2.x86_64.rpm ./MQSeriesSamples-9.2.0-2.x86_64.rpm"

  # Setting default shell to bash for new users \
RUN  sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd \
  # Download and extract the MQ installation files \
  && mkdir -p /tmp/mq \
  && cd /tmp/mq \
  && curl -LO $MQ_URL \
  && tar -zxvf ./*.tar.gz \
  && cd /tmp/mq/MQServer \
  #   Accept the MQ license
  && ./mqlicense.sh -text_only -accept \
  #   Install MQ using the DEB packages
  && rpm -Uvh $MQ_PACKAGES \
  #   Recommended: Set the default MQ installation (makes the MQ commands available on the PATH)
  && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
  # Cleanup
  && rm -rf /tmp/mq \
  && rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -A
RUN /usr/sbin/sshd

RUN echo "ivansla ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ivansla
RUN cat >> /etc/ssh/sshd_config <<EOF
Match Host "*" User "ivansla"
    AllowGroups ivansla
    AllowUsers ivansla
    AuthenticationMethods publickey password
    AuthorizedKeysFile /home/ivansla/.ssh/authorized_keys
EOF

COPY --chmod=500 mq-setup.sh /home/mqm/mq-setup.sh
COPY --chmod=500 mq-start.sh /home/mqm/mq-start.sh
COPY --chmod=444 mq-setup.mqsc /home/mqm/mq-setup.mqsc
COPY --chmod=544 icc-shift.sh /etc/profile.d/icc-shift.sh

RUN ["/home/mqm/mq-setup.sh", "QMgr01", "1414", "mqexplorers"]
ENTRYPOINT ["/home/mqm/mq-start.sh", "QMgr01"]
