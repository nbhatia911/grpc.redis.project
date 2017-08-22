package main

import (
	"fmt"
	"github.com/go-redis/redis"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"log"
	pb "mygocode/payment.project/server/proto"
	"net"
)

const (
	port = ":50051"
)

// server is used to implement proto/PaymentServiceServer
type server struct{}

func (s *server) SendPayment(ctx context.Context, in *pb.PaymentRequest) (*pb.Void, error) {
	//var rv string
	fmt.Println("[SendPayment] username: %s transaction_id: %s", in.Username, in.TransactionId)
	SetDataToDB(in.Username, in.TransactionId)
	return &pb.Void{}, nil
}

func (s *server) GetPayment(ctx context.Context, in *pb.PaymentRequest) (*pb.PaymentReply, error) {
	var rv string
	fmt.Println("[GetPayment] username: %s transaction_id: %s", in.Username, in.TransactionId)
	rv = GetDataFromDB(in.Username)
	return &pb.PaymentReply{Message: rv}, nil
}

func GetDataFromDB(Username string) (rv string) {
	client := redis.NewClient(&redis.Options{
		Addr:     "10.44.0.1:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	val, err := client.Get(Username).Result()
	if err != nil {
		rv = "nil (Username not found in DB)"
		return
		//panic(err)
	}
	fmt.Println(Username, val)
	rv = val

	return
}

func SetDataToDB(Username, TransactionId string) {
	client := redis.NewClient(&redis.Options{
		Addr:     "10.44.0.1:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	err := client.Set(Username, TransactionId, 0).Err()
	if err != nil {
		return
		//panic(err)
	}

	return
}

func main() {
	// open tcp socket for grpc
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterPaymentServiceServer(s, &server{})

	// register reflection service on gRPC server.
	reflection.Register(s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
