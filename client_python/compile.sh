#!/bin/bash

#This will generate protocol buffer files from PROTO file

rm -f *_pb2*
python -m grpc_tools.protoc -I../proto --python_out=. --grpc_python_out=. ../proto/payment.proto

