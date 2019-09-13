from __future__ import print_function

import random
import logging
import sys

import grpc
import payment_pb2
import payment_pb2_grpc

def get_data(stub, _PaymentRequest):
    _PaymentReply = stub.GetPayment(_PaymentRequest)
    if not _PaymentReply.message:
        print("Server returned incomplete PaymentReply")
        return

    if _PaymentReply.message:
        print("PaymentReply called %s" % (_PaymentReply.message))
    else:
        print("Found no PaymentReply at %s" % _PaymentRequest.username)


def set_data(stub, _PaymentRequest):
    stub.SendPayment(_PaymentRequest)

def payment_get_rpc(stub, name):
    print("Creating and sending GET RPC")
    get_data(stub, payment_pb2.PaymentRequest(username=name, transaction_id=""))

def payment_set_rpc(stub, name, transactionid):
    print("Creating and sending SET RPC")
    set_data(stub, payment_pb2.PaymentRequest(username=name, transaction_id=transactionid))

def run(address, oper, name, transactionid):
    with grpc.insecure_channel(address) as channel:
        """ Open GRPC channel with SERVER"""
        stub = payment_pb2_grpc.PaymentServiceStub(channel)
        if oper == "SET":
          payment_set_rpc(stub, name, transactionid)
        elif oper == "GET":
          payment_get_rpc(stub, name)
  
if __name__ == '__main__':
    logging.basicConfig()
    _nargs = len(sys.argv) 
    print("Argument: %s" % (sys.argv))

    if _nargs == 4 and sys.argv[2] == "GET":
        address = sys.argv[1]
        oper = sys.argv[2]
        name = sys.argv[3]
        transactionid = ""
    elif _nargs == 5 and sys.argv[2] == "SET":
        address = sys.argv[1]
        oper = sys.argv[2]
        name = sys.argv[3]
        transactionid = sys.argv[4]
    else:
        print("Eg: python client.py ip:port GET/SET username id")
        exit()

    run(address, oper, name, transactionid)

