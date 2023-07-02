#!/bin/bash

RUNNING="(Running)"
SLEEP_FOR_SECONDS=15

isRunningQM() {
  local qmgrName=$1
  local qmgrStatus="$(dspmq | grep ${qmgrName} | grep ${RUNNING})"
  echo "qmgrName ${qmgrName}"
  echo "qmgrStatus ${qmgrStatus}"

  # Keep container live while Queue Manager is Running
  while [[ "${qmgrStatus}" == *"${RUNNING}"* ]]
  do
    sleep $SLEEP_FOR_SECONDS
    echo "checking qmgr"
    qmgrStatus="$(dspmq | grep ${qmgrName} | grep ${RUNNING})"
  done
}

start() {
  local qmgrName=$1

  su - mqm -c "strmqm ${qmgrName}"
  source /var/scripts/init.sh ${qmgrName} || true
  isRunningQM ${qmgrName}
}

start $1
