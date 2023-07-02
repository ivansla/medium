#!/bin/bash

# Following IBM guideline on naming integration node https://www.ibm.com/docs/en/app-connect/12.0?topic=command-mqsicreatebroker-linux-aix-systems
setup() {
  local queueManagerName=$1

  su - aceadmin -c "strmqm ${queueManagerName}"
  su - aceadmin -c "mqsicreatebroker --integration-node ${queueManagerName} --queue-manager ${queueManagerName} --workpath /home/aceadmin/mqsi"
  su - aceadmin -c "mqsistart ${queueManagerName}"
  su - aceadmin -c "mqsicreateexecutiongroup ${queueManagerName} -e default"
}

setup $1
