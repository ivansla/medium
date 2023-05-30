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
  local sslPath='/home/mqm/ssl'
  local keyDbPath=${sslPath}/key.kdb
  local keyDbPassword="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')"
  local caCertificatePath=$1
  local mqCertificatePath=$2
  local mqCertificatePassword=$3
  local qmgrName=$4
  local qmgrNameLowerCase="$(echo "$4" | tr '[:upper:]' '[:lower:]')"
  local mqAdminsGroup=$5

  su - mqm -c "mkdir -p ${sslPath}"
  su - mqm -c "strmqm ${qmgrName}"

  runmqckm -keydb -create -db ${keyDbPath} -pw ${keyDbPassword} -type cms -stash
  runmqckm -cert -add -db ${keyDbPath} -file ${caCertificatePath} -pw ${keyDbPassword}
  runmqckm -cert -import -file ${mqCertificatePath} -pw ${mqCertificatePassword} -type pkcs12 -target ${keyDbPath} -target_pw ${keyDbPassword} -target_type cms
  runmqckm -cert -rename -db ${keyDbPath} -pw ${keyDbPassword} -label 1 -new_label ibmwebpsheremq${qmgrNameLowerCase}

  chown mqm:mqm ${sslPath}/*

  echo ${keyDbPassword} > /home/mqm/ssl/kdb.password
  runmqsc ${qmgrName} < /home/mqm/mq_qmgr_ldap.mqsc
}

setup $1 $2 $3 $4 $5