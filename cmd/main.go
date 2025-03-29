package main

import (
	"database/sql"
	"log"

	"github.com/hisshihi/shop-back/internal/service"
	"github.com/hisshihi/shop-back/internal/service/api"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://root:secret@localhost:5432/shop_db?sslmode=disable"
	serverAddress = "0.0.0.0:8080"
)


func main() {
	conn, err := sql.Open(dbDriver, dbSource)	
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := service.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
