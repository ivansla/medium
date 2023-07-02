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

FROM ivansla/my-repo:my-mq
VOLUME /home

RUN groupadd --gid 1001 aceadmin
RUN useradd --uid 1001 --gid aceadmin -s /bin/bash --create-home --home-dir /home/aceadmin aceadmin

ARG ACE_FILE=12.0.8.0-ACE-LINUX64-DEVELOPER.tar.gz
ARG ACE_URL=http://192.168.15.11:9000/$ACE_FILE

RUN export DEBIAN_FRONTEND=noninteractive \
  # Download and extract the MQ installation files \
  && mkdir -p /tmp/ace \
  && mkdir -p /opt/ibm \
  && cd /tmp/ace \
  && curl -LO $ACE_URL \
  && tar -zxvf ./*.tar.gz -C /opt/ibm \
  && cd /opt/ibm/ace* \
  && ./ace make registry global accept license silently \
  && rm -rf /tmp/ace \
  && echo "source /opt/ibm/ace-12.0.8.0/server/bin/mqsiprofile" >> /home/aceadmin/.profile

RUN usermod -a -G mqbrkrs,mqm aceadmin
RUN usermod -a -G mqbrkrs root
COPY --chmod=500 ace-setup.sh /home/aceadmin/ace-setup.sh
COPY --chmod=500 init.sh /var/scripts/init.sh
RUN ["/home/aceadmin/ace-setup.sh", "QMgr01"]
ENTRYPOINT ["/home/mqm/mq-start.sh", "QMgr01"]
