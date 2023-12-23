#!/bin/bash

usage="[-h] [caCertificatePath] [mqCertificatePath] [mqCertificatePassword] [qmgrName] [mqAdminsGroup]

where:
    -h  show this help text
    caCertificatePath  Path to the Certificate Authority certificate
    mqCertificatePath  Path to the certificate issued for this MQ server (pfx format)
    mqCertificatePassword  Password that unlocks pfx format of MQ server certificate
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

  su - mqm -c "mkdir -p ${sslPath}"
  su - mqm -c "strmqm ${qmgrName}"

  runmqsc ${qmgrName} < /home/mqm/mq_qmgr_ssl.mqsc
}

setup $1