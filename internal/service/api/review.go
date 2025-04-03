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

	hashPuchased, err := server.store.HasUserPurchasedProduct(ctx, sqlc.HasUserPurchasedProductParams{
		UserID:    user.ID,
		ProductID: req.ProductID,
	})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	if !hashPuchased {
		ctx.JSON(http.StatusForbidden, errorResponse(errors.New("нельзя оставить отзыв на непокупной товар")))
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

type getReviewByIDRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

type getReviewsByProductIDRequest struct {
	ProductID int64 `form:"product_id" binding:"required,min=1"`
	PageID    int32 `form:"page_id" binding:"required,min=1"`
	PageSize  int32 `form:"page_size" binding:"required,min=5,max=10"`
}

func (server *Server) getReviewsByProductID(ctx *gin.Context) {
	var req getReviewsByProductIDRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.GetReviewByProductIDParams{
		ProductID: req.ProductID,
		Limit:     int64(req.PageSize),
		Offset:    int64((req.PageID - 1) * req.PageSize),
	}

	reviews, err := server.store.GetReviewByProductID(ctx, arg)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countReview, err := server.store.CountReviews(ctx, req.ProductID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	average, err := server.store.GetAverageRatingForProvider(ctx, req.ProductID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"review_list":  reviews,
		"count_review": countReview,
		"average":      average,
	})
}

type updateReviewRequest struct {
	Rating  int32  `json:"rating" binding:"required,min=1,max=5"`
	Comment string `json:"comment"`
}

func (server *Server) updateReview(ctx *gin.Context) {
	var req updateReviewRequest
	var reqID getReviewByIDRequest
	if err := ctx.ShouldBindUri(&reqID); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	review, err := server.store.GetReviewByID(ctx, reqID.ID)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			ctx.JSON(http.StatusNotFound, errorResponse(errors.New("отзыв не найден")))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	if review.UserID != user.ID {
		ctx.JSON(http.StatusForbidden, errorResponse(errors.New("можно обновлять только свои отзывы")))
		return
	}

	arg := sqlc.UpdateReviewParams{
		ID:      review.ID,
		Rating:  req.Rating,
		Comment: sql.NullString{String: req.Comment, Valid: true},
	}

	updateReview, err := server.store.UpdateReview(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, updateReview)

}
