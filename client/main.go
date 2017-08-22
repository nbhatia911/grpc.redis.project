package main

import (
	//"fmt"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"log"
	pb "mygocode/payment.project/server/proto"
	"os"
)

const (
	defaultAddress       = "localhost:50051"
	defaultName          = "Nikhil"
	defaultTransactionId = "77777777"
)

func main() {

	// read arguments from cmd line
	address := defaultAddress
	name := defaultName
	transactionid := defaultTransactionId
	oper := "NULL"
	if len(os.Args) > 3 && os.Args[2] == "GET" {
		address = os.Args[1]
		oper = os.Args[2]
		name = os.Args[3]
	} else if len(os.Args) > 4 && os.Args[2] == "SET" {
		address = os.Args[1]
		oper = os.Args[2]
		name = os.Args[3]
		transactionid = os.Args[4]
	} else {
		log.Printf("Eg: ./client ip:port GET/SET username id")
		return
	}

	// set up a connection to grpc server
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	c := pb.NewPaymentServiceClient(conn)
	// contact the server using gRPC calls
	if oper == "SET" {
		r1, err := c.SendPayment(context.Background(), &pb.PaymentRequest{Username: name, TransactionId: transactionid})
		if err != nil {
			log.Fatalf("could not send payment: %v", err)
		}
		log.Printf("payment sent for user: %s id: %s rv: %s", name, transactionid, r1)
	} else if oper == "GET" {
		r, err := c.GetPayment(context.Background(), &pb.PaymentRequest{Username: name})
		if err != nil {
			log.Fatalf("could not get payment: %v", err)
		}
		log.Printf("payment get for user: %s id: %s", name, r.Message)
	} else {
		log.Printf("operation: %s not supported", oper)
	}

}
