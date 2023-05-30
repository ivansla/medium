#!/bin/bash

usage="[-h] [qmgrName] [mqAdminsGroup]

where:
    -h  show this help text
    qmgrName  Queue Manager name
    mqAdminsGroup  MQ Administration Group defined in LDAP"

while getopts 'h' option; do
  case "${option}" in
    h)  echo "${usage}"
        exit 0
        ;;
    *)  echo "${usage}" >&2
        exit 1
        ;;
  esac
done
shift $((OPTIND - 1))

setup() {
  local qmgrName=$1
  local mqAdminsGroup=$2

  su - mqm -c "endmqm ${qmgrName}"
  sleep 4

  su - mqm -c "strmqm ${qmgrName}"
  su - mqm -c "setmqaut -m ${qmgrName} -t qmgr -g ${mqAdminsGroup} +connect +inq +dsp +chg"
  su - mqm -c ". /opt/mqm/samp/bin/amqauthg.sh ${qmgrName} ${mqAdminsGroup}"
}

setup $1 $2