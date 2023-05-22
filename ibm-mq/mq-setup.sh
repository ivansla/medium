#!/bin/bash

install() {
  local qmgrName=$1
  local qmgrPort=$2
  local mqExplorerGroup=$3

  echo "mqm             hard    nofile          10240" >> /etc/security/limits.conf
  echo "mqm             soft    nofile          10240" >> /etc/security/limits.conf
  echo "mqm             hard    nproc           131072" >> /etc/security/limits.conf
  echo "mqm             soft    nproc           131072" >> /etc/security/limits.conf

  su - mqm -c "mkdir -p /home/mqm/qmgrs/data"
  su - mqm -c "mkdir -p /home/mqm/qmgrs/log"
  chown -R mqm:mqm /home/mqm/qmgrs

  su - mqm -c "crtmqm -p ${qmgrPort} -u SYSTEM.DEAD.LETTER.QUEUE -md /home/mqm/qmgrs/data -ld /home/mqm/qmgrs/log ${qmgrName}"
  su - mqm -c "strmqm ${qmgrName}"
  su - mqm -c "setmqaut -m ${qmgrName} -t qmgr -g ${mqExplorerGroup} +connect +inq +dsp +chg"
  su - mqm -c ". /opt/mqm/samp/bin/amqauthg.sh ${qmgrName} ${mqExplorerGroup}"
  su - mqm -c "runmqsc ${qmgrName} < /home/mqm/mq-setup.mqsc"
}

install $1 $2 $3