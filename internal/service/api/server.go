package api

import (
	"errors"
	"net/http"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/internal/service"
	"golang.org/x/time/rate"
)

var limiter = rate.NewLimiter(1, 300)

func rateLimiter(c *gin.Context) {
	if !limiter.Allow() {
		c.JSON(http.StatusTooManyRequests, errorResponse(errors.New("too many requests")))
		c.Abort()
		return
	}
	c.Next()
}

type Server struct {
	store *service.Store
	router *gin.Engine
}

func NewServer(store *service.Store) *Server {
	server := &Server{store: store}

	server.setupServer()

	return server
}

func (server *Server) setupServer() {
	gin.SetMode(gin.DebugMode)

	router := gin.Default()

	router.Use(rateLimiter)

	// Настраиваем доверенные прокси
	router.SetTrustedProxies([]string{
		"127.0.0.1",      // локальный прокси
		"10.0.0.0/8",     // внутренняя сеть
		"172.16.0.0/12",  // Docker сети
		"192.168.0.0/16", // локальные сети
	})

	// Правильная настройка CORS - не используем wildcard с credentials
	corsConfig := cors.Config{
		AllowOrigins:     []string{"http://localhost:8080", "http://localhost:8081", "http://localhost:5173", "https://order-of-venhicles-services.onrender.com"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}
	router.Use(cors.New(corsConfig))

	router.POST("/users", server.createUser)
	router.GET("/users/:id", server.createUser)

	server.router = router
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}