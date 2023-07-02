#!/bin/bash

setup() {
  local integrationNodeName=$1

  su - aceadmin -c "mqsicreatebroker --integration-node ${integrationNodeName} --workpath /home/aceadmin/mqsi"
  su - aceadmin -c "mqsistart ${integrationNodeName}"
  su - aceadmin -c "mqsicreateexecutiongroup ${integrationNodeName} -e default"
}

setup $1
