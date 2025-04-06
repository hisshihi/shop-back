package main

import (
	"database/sql"
	"log"

	"github.com/hisshihi/shop-back/internal/config"
	"github.com/hisshihi/shop-back/internal/service"
	"github.com/hisshihi/shop-back/internal/service/api"

	_ "github.com/lib/pq"
)

func main() {
	config, err := config.LoadConfig()
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	pgxPool := service.NewPgxPool(config.DBSource)

	store := service.NewStore(conn, pgxPool)
	server, err := api.NewServer(store, config)
	if err != nil {
		log.Fatal("cannot create server:", err)
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
