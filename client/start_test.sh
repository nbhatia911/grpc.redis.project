#!/bin/bash

i=0
transaction_id=6217363

while [ $i -lt 100 ]
do  
    ./client1 SET Nikhil${i} ${transaction_id}
    i=`expr $i + 1`
    transaction_id=`expr ${transaction_id} + 1`
done

i=0

while [ $i -lt 100 ]
do  
    ./client1 GET Nikhil${i}
    i=`expr $i + 1`
done


