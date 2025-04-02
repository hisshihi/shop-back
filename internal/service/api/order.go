package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
	"github.com/hisshihi/shop-back/internal/service"
)

type createOrderRequest struct {
	TotalAmount   string                       `json:"total_amount" binding:"required"`
	PaymentMethod string                       `json:"payment_method" binding:"required"`
	Items         []service.OrderItemTxRequest `json:"items" binding:"required,min=1"`
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
		Status:        sqlc.NullOrderStatus{OrderStatus: sqlc.OrderStatusCreated, Valid: true},
		PaymentMethod: req.PaymentMethod,
	}

	order, err := server.store.CreateOrderTx(ctx, arg, req.Items)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Создание заказа ID: %v с позициами %d", order.ID, len(req.Items))
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, order)
}

type getOrderByIDRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) getOrderByID(ctx *gin.Context) {
	var req getOrderByIDRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	order, err := server.store.GetOrderByID(ctx, req.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, order)
}

type listOrderByUserIDRequest struct {
	PageID   int32 `form:"page_id" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=10"`
}

func (server *Server) listOrdersFromUser(ctx *gin.Context) {
	var req listOrderByUserIDRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.ListOrdersByUserIDParams{
		UserID: user.ID,
		Limit:  int64(req.PageSize),
		Offset: int64((req.PageID - 1) * req.PageSize),
	}

	listOrders, err := server.store.ListOrdersByUserID(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countOrders, err := server.store.CountOrderByUserID(ctx, user.ID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"orders":       listOrders,
		"count_orders": countOrders,
	})
}

type listOrderRequest struct {
	PageID   int32 `form:"page_id" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=10"`
}

func (server *Server) listOrders(ctx *gin.Context) {
	var req listOrderRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.ListOrdersParams{
		Limit:  int64(req.PageSize),
		Offset: int64((req.PageID - 1) * req.PageSize),
	}

	listOrders, err := server.store.ListOrders(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countOrders, err := server.store.CountOrderByUserID(ctx, user.ID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"orders":       listOrders,
		"count_orders": countOrders,
	})
}

type updateOrderStatusRequest struct {
	Status sqlc.OrderStatus `json:"status" binding:"required"`
}

func (server *Server) updateOrderStatus(ctx *gin.Context) {
	var req updateOrderStatusRequest
	var reqID getOrderByIDRequest

	if err := ctx.ShouldBindUri(&reqID); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.UpdateOrderStatusParams{
		ID:             reqID.ID,
		Status:         sqlc.NullOrderStatus{OrderStatus: req.Status, Valid: true},
		DeliveryStatus: sql.NullString{},
	}

	updateOrder, err := server.store.UpdateOrderStatus(ctx, arg)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Обновление заказа ID: %v", updateOrder.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, updateOrder)
}

func (server *Server) deleteOrder(ctx *gin.Context) {
	var req getOrderByIDRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := service.DeleteOrderTxParams{
		OrderID: req.ID,
	}

	result, err := server.store.TransferTxDeleteOrder(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	if !result.DeleteOrder {
		ctx.JSON(http.StatusNotFound, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Удаление заказа ID: %v", req.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusNoContent, nil)
}
