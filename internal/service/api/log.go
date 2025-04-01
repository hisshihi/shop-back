package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

func (server *Server) createLog(ctx *gin.Context, userID int64, action string) {

	arg := sqlc.CreateLogParams{
		UserID: sql.NullInt64{Int64: userID, Valid: true},
		Action: action,
	}

	_, err := server.store.CreateLog(ctx, arg)
	if err != nil {
		fmt.Errorf("Ошибка при создании логов %w", err)
		return
	}
}

type listLogRequest struct {
	PageID   int32 `form:"page_id" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=50"`
}

func (server *Server) listLog(ctx *gin.Context) {
	var req listLogRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.ListLogsParams{
		Limit:  int64(req.PageSize),
		Offset: int64((req.PageID - 1) * req.PageSize),
	}

	logList, err := server.store.ListLogs(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countLogs, err := server.store.CountLogs(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"logs":       logList,
		"count_logs": countLogs,
	})
}
