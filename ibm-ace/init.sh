#!/bin/bash

init() {
  local queueManagerName=$1

  su - aceadmin -c "mqsistart ${queueManagerName}" > /home/aceadmin/init.log
}

init $1

