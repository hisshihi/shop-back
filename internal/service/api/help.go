package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createHelpMessageRequest struct {
	Fullname string `json:"fullname" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Topic    string `json:"topic" binding:"required"`
	Message  string `json:"message" binding:"required"`
}

func (server *Server) createHelpMessage(ctx *gin.Context) {
	var req createHelpMessageRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.CreateHelpMessageParams{
		Fullname: req.Fullname,
		Email:    req.Email,
		Topic:    req.Topic,
		Message:  req.Message,
	}

	help, err := server.store.CreateHelpMessage(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, help)
}

type listHelpMessageRequest struct {
	PageID   int32 `form:"page_ID" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=20"`
}

func (server *Server) listHelpMessage(ctx *gin.Context) {
	var req listHelpMessageRequest
	if err := ctx.Copy().ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.ListHelpMesageParams{
		Limit:  int64(req.PageSize),
		Offset: int64((req.PageID - 1) * req.PageSize),
	}

	help, err := server.store.ListHelpMesage(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, help)
}
