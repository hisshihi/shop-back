package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createCartItemRequest struct {
	ProductID int64 `json:"product_id" binding:"required,min=1"`
	Quantity  int32 `json:"quantity" binding:"required,min=1"`
}

func (server *Server) createCartItem(ctx *gin.Context) {
	var req createCartItemRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	arg := sqlc.CreateCartItemParams{
		UserID:    user.ID,
		ProductID: req.ProductID,
		Quantity:  req.Quantity,
	}

	cartItem, err := server.store.CreateCartItem(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Добавление товара в корзину ID: %v", req.ProductID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, cartItem)
}

func (server *Server) listCartItem(ctx *gin.Context) {
	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	listCartItem, err := server.store.ListCartItemByUserID(ctx, user.ID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, listCartItem)
}

type getCartItemByIdRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) deleteCartItem(ctx *gin.Context) {
	var req getCartItemByIdRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	_, err = server.store.GetCartItemByID(ctx, req.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.DeleteCartItemByIDAndUserIDParams{
		ID:     req.ID,
		UserID: user.ID,
	}

	err = server.store.DeleteCartItemByIDAndUserID(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusNoContent, nil)
}
