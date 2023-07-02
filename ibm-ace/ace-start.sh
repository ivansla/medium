#!/bin/bash

RUNNING="BIP1325I"
SLEEP_FOR_SECONDS=15

isRunningACE() {
  local integrationNodeName=$1
  local integrationNodeStatus="$(mqsilist | grep ${integrationNodeName} | grep ${RUNNING})"
  echo "Integration Node name: ${integrationNodeName}"
  echo "Integration Node status: ${integrationNodeStatus}"

  # Keep container live while Queue Manager is Running
  while [[ "${integrationNodeStatus}" == *"${RUNNING}"* ]]
  do
    sleep $SLEEP_FOR_SECONDS
    integrationNodeStatus="$(mqsilist | grep ${integrationNodeName} | grep ${RUNNING})"
    echo "Checking Integration Node Status: ${integrationNodeStatus}" >> /home/aceadmin/heartbeat.log
  done
}

start() {
  local integrationNodeName=$1

  mqsistart ${integrationNodeName}
  isRunningACE ${integrationNodeName}
}

start $1
