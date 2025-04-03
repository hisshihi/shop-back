package api

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"net/http"
	"slices"
	"strings"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
	"github.com/hisshihi/shop-back/internal/config"
	"github.com/hisshihi/shop-back/internal/service"
	"github.com/hisshihi/shop-back/pkg/util"
	"github.com/lib/pq"
	"golang.org/x/time/rate"
)

const (
	authorizationHeaderKey  = "authorization"
	authorizationTypeBearer = "bearer"
	authorizationPayloadKey = "authorization_payload"
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
	store      *service.Store
	tokenMaker util.Maker
	router     *gin.Engine
	config     config.Config
}

func NewServer(store *service.Store, config config.Config) (*Server, error) {
	tokenMaker, err := util.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot load config: %w", err)
	}
	server := &Server{
		store:      store,
		tokenMaker: tokenMaker,
		config:     config,
	}

	server.setupServer()

	return server, nil
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

	// Маршруты доступные всем
	apiGroup := router.Group("/api/v1")

	apiGroup.POST("/login", server.loginUser)
	apiGroup.POST("/users", server.createUser)
	apiGroup.GET("/product/:id", server.getProductByID)
	apiGroup.GET("/product/list", server.listProduct)
	apiGroup.GET("/review/list", server.getReviewsByProductID)

	// Маршруты доступные всем авторизированным пользователям
	authRoutes := apiGroup.Group("/")
	authRoutes.Use(server.authMiddleware())
	authRoutes.GET("/users", server.getUserByID)
	authRoutes.PUT("/users", server.updateUser)
	authRoutes.POST("/favorit", server.createFavorit)
	authRoutes.GET("/favorit/list", server.listFavorit)
	authRoutes.DELETE("/favorit/:id", server.deleteFavorit)
	authRoutes.POST("/order", server.createOrder)
	authRoutes.GET("/order/:id", server.getOrderByID)
	authRoutes.GET("/order/list", server.listOrdersFromUser)
	authRoutes.GET("/order-item/:id", server.getOrderItemByID)
	authRoutes.POST("/review", server.createReview)
	authRoutes.PUT("/review/:id", server.updateReview)
	authRoutes.DELETE("/review/:id", server.deleteReview)

	// Маршруты доступные администратору
	adminRoutes := apiGroup.Group("/admin")
	adminRoutes.Use(server.authMiddleware())
	adminRoutes.Use(server.roleCheckMiddleware(string(sqlc.UserRoleAdmin)))
	adminRoutes.GET("/users/:id", server.getUserByIDForAdmin)
	adminRoutes.GET("/users/list", server.listUsers)
	adminRoutes.DELETE("/users/:id", server.deleteUser)
	adminRoutes.POST("/users/banned/:id", server.bannedUser)
	adminRoutes.POST("/category", server.createCategory)
	adminRoutes.GET("/category/list", server.listCategory)
	adminRoutes.PUT("/category/:id", server.updateCategory)
	adminRoutes.DELETE("/category/:id", server.deleteCategory)
	adminRoutes.POST("/product", server.createProduct)
	adminRoutes.PUT("/product/:id", server.updateProduct)
	adminRoutes.DELETE("/product/:id", server.deleteProduct)
	adminRoutes.GET("/logs", server.listLog)
	adminRoutes.GET("/order/list", server.listOrders)
	adminRoutes.PUT("/order/:id", server.updateOrderStatus)
	adminRoutes.DELETE("/order/:id", server.deleteOrder)

	server.router = router

	// Создание пользователей
	if err := server.createDefaultUser(); err != nil {
		fmt.Printf("Не удалось создать пользователей по умоланию: %v\n", err)
	}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}

// authMiddleware Middleware аунтификации (проверка токена)
func (server *Server) authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authorizationHeader := c.GetHeader(authorizationHeaderKey)
		if len(authorizationHeader) == 0 {
			err := errors.New("заголовок авторизации не предоставлен")
			c.AbortWithStatusJSON(http.StatusUnauthorized, errorResponse(err))
			return
		}

		fields := strings.Fields(authorizationHeader)
		if len(fields) < 2 {
			err := errors.New("неверный формат заголовка")
			c.AbortWithStatusJSON(http.StatusUnauthorized, errorResponse(err))
			return
		}

		authorizationType := strings.ToLower(fields[0])
		if authorizationType != authorizationTypeBearer {
			err := fmt.Errorf("неподдерживаемый тип авторизации %s", authorizationType)
			c.AbortWithStatusJSON(http.StatusUnauthorized, errorResponse(err))
			return
		}

		accessToken := fields[1]
		payload, err := server.tokenMaker.VerifyToken(accessToken)
		if err != nil {
			// Более информативные сообщения в зависимости от типа ошибки
			var errorMsg string
			if errors.Is(err, util.ErrExpiredToken) {
				errorMsg = "срок действия токена истек, необходимо пройти авторизацию повторно"
			} else if errors.Is(err, util.ErrInvalidToken) {
				errorMsg = "недействительный токен"
			} else {
				errorMsg = fmt.Sprintf("ошибка проверки токена: %v", err)
			}
			c.AbortWithStatusJSON(http.StatusUnauthorized, errorResponse(errors.New(errorMsg)))
			return
		}

		// Двойная проверка срока действия токена на уровне middleware
		if err := payload.Valid(); err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized,
				errorResponse(errors.New("срок действия токена истек, необходимо пройти авторизацию повторно")))
			return
		}

		// Проверяем, не заблокирован ли пользователь
		user, err := server.store.GetUser(c, payload.Username)
		if err == nil && user.IsBanned {
			err := errors.New("ваш аккаунт заблокирован")
			c.AbortWithStatusJSON(http.StatusForbidden, errorResponse(err))
			return
		}

		c.Set(authorizationPayloadKey, payload)
		c.Next()
	}
}

// roleCheckMiddleware Middleware для првоерки роли
// Функция-генератор middleware, принимает список разрешённый ролей
func (server *Server) roleCheckMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Получаем payload из контекста (установленный authMiddleware)
		payload, exists := c.Get(authorizationPayloadKey)
		if !exists {
			err := errors.New("требуется авторизация")
			c.AbortWithStatusJSON(http.StatusUnauthorized, errorResponse(err))
			return
		}

		tokenPayload, ok := payload.(*util.Payload)
		if !ok {
			err := errors.New("неверный тип payload")
			c.AbortWithStatusJSON(http.StatusInternalServerError, errorResponse(err))
			return
		}

		// Проверяем, есть ли роль пользователя в списке разрешённых
		roleAllowed := slices.Contains(allowedRoles, tokenPayload.Role)

		if !roleAllowed {
			err := errors.New("доступ запрешён: недостаточно прав")
			c.AbortWithStatusJSON(http.StatusForbidden, errorResponse(err))
			return
		}

		c.Next()
	}
}

func (server *Server) getUserDataFromToken(ctx *gin.Context) (sqlc.User, error) {
	// Получаем payload из токена авторизации
	payload, exists := ctx.Get(authorizationPayloadKey)
	if !exists {
		err := errors.New("требуется авторизация")
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return sqlc.User{}, err
	}

	// Приводим payload к нужному типу
	tokenPayload, ok := payload.(*util.Payload)
	if !ok {
		err := errors.New("неверный тип payload")
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return sqlc.User{}, err
	}

	// Получаем пользователя по ID из токена
	user, err := server.store.GetUser(ctx, tokenPayload.Username)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(errors.New("пользователь не найден")))
			return sqlc.User{}, err
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return sqlc.User{}, err
	}

	return user, nil
}

func (server *Server) createDefaultUser() error {
	if err := server.createUserWithRole("admin", "admin", "admin@example.com", "123456", "79999999999", sqlc.UserRoleAdmin); err != nil {
		return fmt.Errorf("ошибка при создании администратора: %w", err)
	}

	if err := server.createUserWithRole("user", "client", "client@example.com", "123456", "78888888888", sqlc.UserRoleUser); err != nil {
		return fmt.Errorf("ошибка при создании пользователя: %w", err)
	}
	return nil
}

// Создание пользователей по умолчанию
func (server *Server) createUserWithRole(username, fullname, email, password, phone string, role sqlc.UserRole) error {
	hashedPassword, err := util.HashPassword(password)
	if err != nil {
		return fmt.Errorf("ошибка при хешировании пароля: %w", err)
	}

	arg := sqlc.CreateUserParams{
		Username: username,
		Email:    email,
		Fullname: fullname,
		Password: hashedPassword,
		Role:     role,
		Phone:    phone,
	}

	_, err = server.store.CreateUser(context.Background(), arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "unique_violation":
				fmt.Printf("Пользователь %v (%v) уже существует в системе\n", username, role)
				return nil
			}
		}
		return err
	}
	fmt.Printf("Пользователь %v (%v) успешно создан\n", username, role)
	return nil
}
