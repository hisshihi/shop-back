package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createFavoritRequest struct {
	ProductID int64 `json:"product_id" binding:"required,min=1"`
}

func (server *Server) createFavorit(ctx *gin.Context) {
	var req createFavoritRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.CreateFavoriteParams{
		UserID:    user.ID,
		ProductID: req.ProductID,
	}

	favorit, err := server.store.CreateFavorite(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Добавление в избранное. Пользователь ID: %v. Товар ID: %v", user.ID, favorit.ProductID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, favorit)
}

//type listFavoritRequest struct {
//	PageID   int32 `form:"page_id" binding:"required,min=1"`
//	PageSize int32 `form:"page_size" binding:"required,min=5,max=10"`
//}

func (server *Server) listFavorit(ctx *gin.Context) {
	//	var req listFavoritRequest
	//	if err := ctx.ShouldBindQuery(&req); err != nil {
	//		ctx.JSON(http.StatusBadRequest, errorResponse(err))
	//		return
	//	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	listFavorit, err := server.store.ListUserFavorites(ctx, user.ID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countFavorits, err := server.store.CountFavoritForUser(ctx, user.ID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"favorits":       listFavorit,
		"favorits_count": countFavorits,
	})
}

type getFavoritByID struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) deleteFavorit(ctx *gin.Context) {
	var req getFavoritByID
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.DeleteFavoritForIDParams{
		ID:     req.ID,
		UserID: user.ID,
	}

	_, err = server.store.GetFavoriteByID(ctx, req.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	err = server.store.DeleteFavoritForID(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Удаление избранного. Пользователь ID: %v. Товар ID: %v", user.ID, req.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusNoContent, nil)
}
