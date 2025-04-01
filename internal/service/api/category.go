package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
	"github.com/lib/pq"
)

type createCategoryRequest struct {
	Name        string `json:"name" binding:"required,min=1"`
	Descritpion string `json:"description"`
}

type categoryResponse struct {
	ID          int64  `json:"id"`
	Name        string `json:"name"`
	Descritpion string `json:"description"`
}

func (server *Server) createCategory(ctx *gin.Context) {
	var req createCategoryRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.CreateCategoryParams{
		Name:        req.Name,
		Description: sql.NullString{String: req.Descritpion, Valid: true},
	}

	category, err := server.store.CreateCategory(ctx, arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "unique_violation":
				ctx.JSON(http.StatusConflict, errorResponse(err))
				return
			}
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Создание категории ID: %v, название %v", category.ID, category.Name)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, category)
}

type listCategory struct {
	PageID   int32 `form:"page_id" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=30"`
}

func (server *Server) listCategory(ctx *gin.Context) {
	var req listCategory
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.ListCategoriesParams{
		Limit:  int64(req.PageSize),
		Offset: int64((req.PageID - 1) * req.PageSize),
	}

	listCategory, err := server.store.ListCategories(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	categoryCount, err := server.store.CountCategory(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"categories":     listCategory,
		"category_count": categoryCount,
	})
}

type getCategoryByIDRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

type updateCategoryRequrest struct {
	Name        string `json:"name" binding:"required,min=1"`
	Descritpion string `json:"description"`
}

func (server *Server) updateCategory(ctx *gin.Context) {
	var req updateCategoryRequrest
	var reqID getCategoryByIDRequest
	if err := ctx.ShouldBindUri(&reqID); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := sqlc.UpdateCategoryParams{
		ID:          reqID.ID,
		Name:        req.Name,
		Description: sql.NullString{String: req.Descritpion, Valid: true},
	}

	updateCategory, err := server.store.UpdateCategory(ctx, arg)
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

	action := fmt.Sprintf("Обновлениe категории ID: %v, название %v", updateCategory.ID, updateCategory.Name)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, updateCategory)
}

func (server *Server) deleteCategory(ctx *gin.Context) {
	var req getCategoryByIDRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	err := server.store.DeleteCategory(ctx, req.ID)
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

	action := fmt.Sprintf("Удаление категории ID: %v", req.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusNoContent, nil)
}
