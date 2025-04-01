package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createOrderRequest struct {
	TotalAmount   string `json:"total_amount" binding:"required"`
	PaymentMethod string `json:"payment_method" binding:"required"`
}

func (server *Server) createOrder(ctx *gin.Context) {
	var req createOrderRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.CreateOrderParams{
		UserID:        user.ID,
		TotalAmount:   req.TotalAmount,
		Status:        string(sqlc.OrderStatusCreated),
		PaymentMethod: req.PaymentMethod,
	}

	order, err := server.store.CreateOrder(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, order)
}
