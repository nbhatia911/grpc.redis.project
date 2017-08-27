#!/bin/bash

PID=`ps -ef | grep start_grpc_test | grep -v grep | awk -F" " '{print $2}'`

echo $PID

for i in ${PID}
do
  str="kill -9 "$i
  ${str}
done

