package api

import (
	"database/sql"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createReviewRequest struct {
	ProductID int64  `json:"product_id" binding:"required,min=1"`
	Rating    int8   `json:"rating" binding:"required,min=1,max=5"`
	Comment   string `json:"comment"`
}

func (server *Server) createReview(ctx *gin.Context) {
	var req createReviewRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	_, err = server.store.GetReviewByUserAndProduct(ctx, sqlc.GetReviewByUserAndProductParams{
		UserID:    user.ID,
		ProductID: req.ProductID,
	})

	if err == nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(errors.New("вы уже оставляли отзыв для этого товара")))
		return
	}

	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := sqlc.CreateReviewParams{
		UserID:    user.ID,
		ProductID: req.ProductID,
		Rating:    int32(req.Rating),
		Comment:   sql.NullString{String: req.Comment, Valid: true},
	}

	review, err := server.store.CreateReview(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, review)
}
