#!/bin/bash

RUNNING="(Running)"
SLEEP_FOR_SECONDS=5

isRunningQM() {
  local qmgrName=$1
  local qmgrStatus="$(dspmq | grep ${qmgrName} | grep ${RUNNING})"
  echo "qmgrName ${qmgrName}"
  echo "qmgrStatus ${qmgrStatus}"

  # Keep container live while Queue Manager is Running
  while [[ "${qmgrStatus}" == *"${RUNNING}"* ]]
  do
    echo "checking qmgr"
    qmgrStatus="$(dspmq | grep ${qmgrName} | grep ${RUNNING})"
    sleep $SLEEP_FOR_SECONDS
  done
}

start() {
  local qmgrName=$1
  strmqm ${qmgrName}
  isRunningQM ${qmgrName}
}

start $1
