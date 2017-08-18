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
	address              = "localhost:50051"
	defaultName          = "Nikhil"
	defaultTransactionId = "77777777"
)

func main() {

	// set up a connection to grpc server
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	c := pb.NewPaymentServiceClient(conn)

	// read arguments from cmd line
	name := defaultName
	transactionid := defaultTransactionId
	oper := "NULL"
	if len(os.Args) > 2 && os.Args[1] == "GET" {
		oper = os.Args[1]
		name = os.Args[2]
	} else if len(os.Args) > 3 && os.Args[1] == "SET" {
		oper = os.Args[1]
		name = os.Args[2]
		transactionid = os.Args[3]
	} else {
		log.Printf("Eg: ./client GET/SET username id")
		return
	}

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
