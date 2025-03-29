package api

import (
	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/internal/service"
)

type Server struct {
	store *service.Store
	router *gin.Engine
}

func NewServer(store *service.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	router.POST("/user", server.createUser)

	server.router = router
	return server
}