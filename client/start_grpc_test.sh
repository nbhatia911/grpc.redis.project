#!/bin/bash

# ./start_grpc_test.sh 127.0.0.1 50051 0 1

IP=$1
PORT=$2
TID=$3 
ITR=$4

./grpc_client1 127.0.0.1:50051 SET test "hello grpc redis"
./grpc_client1 127.0.0.1:50051 GET test

i=0
transaction_id=${TID}

while [ ${i} -lt ${ITR} ]
do  
    ./client1 ${IP}:${PORT} SET Nikhil${transaction_id} ${transaction_id}
    i=`expr ${i} + 1`
    transaction_id=`expr ${transaction_id} + 1`
done

i=0
transaction_id=${TID}

while [ ${i} -lt ${ITR} ]
do  
    ./client1 ${IP}:${PORT} GET Nikhil${transaction_id}
    i=`expr ${i} + 1`
    transaction_id=`expr ${transaction_id} + 1`
done


