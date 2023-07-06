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

FROM ivansla/my-repo:my-ubuntu
VOLUME /home

ARG PRODUCT_VERSION="7.59.11"
ARG PRODUCT_FILE="jfrog-artifactory-oss-$PRODUCT_VERSION-linux.tar.gz"
ARG PRODUCT_URL="https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/$PRODUCT_VERSION/$PRODUCT_FILE"

SHELL ["/bin/bash", "-c"]
RUN export DEBIAN_FRONTEND=noninteractive \
  # Optional: Update the command prompt
  && echo "jfrog-artifactory" > /etc/debian_chroot \
  && curl -SL $PRODUCT_URL -o /home/ivansla/$PRODUCT_FILE \
  && mkdir -p /home/ivansla/Tools/jfrog \
  && mv /home/ivansla/$PRODUCT_FILE /home/ivansla/Tools/jfrog \
  && cd /home/ivansla/Tools/jfrog \
#  && export JFROG_HOME=/home/ivansla/Tools/jfrog \
  && tar -xvf $PRODUCT_FILE \
  && mv artifactory-* artifactory \
  && chown -R ivansla:ivansla ./artifactory \
  && . /home/ivansla/Tools/jfrog/artifactory/app/bin/installService.sh

CMD ["/bin/bash"]
