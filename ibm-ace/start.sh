#!/bin/bash

start() {
  su - aceadmin -c ". ace-start.sh $1"
}
start $1
