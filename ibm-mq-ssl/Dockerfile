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

# can solve problem for creating keystore on AMD processors. https://github.com/ibm-messaging/mq-container/issues/462
ENV ICC_SHIFT=3

COPY --chmod=544 icc-shift.sh /etc/profile.d/icc-shift.sh

RUN ["/home/mqm/mq-setup.sh", "QMgr01", "1414", "mqexplorers"]
ENTRYPOINT ["/home/mqm/mq-start.sh", "QMgr01"]
