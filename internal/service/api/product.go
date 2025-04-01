package api

import (
	"database/sql"
	"encoding/base64"
	"errors"
	"io"
	"mime/multipart"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
)

type createProductRequest struct {
	CategoryID  int64                 `form:"category_id" binding:"required,min=1"`
	Name        string                `form:"name" binding:"required"`
	Description string                `form:"description" binding:"required"`
	Price       string                `form:"price" binding:"required"`
	Stock       int32                 `form:"stock" binding:"required,min=1"`
	PhotoUrl    *multipart.FileHeader `form:"photo_url" binding:"required"`
}

type productResponse struct {
	CategoryID  int64  `json:"category_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Price       string `json:"price"`
	Stock       int32  `json:"stock"`
	PhotoUrl    string `json:"photo_url"`
	PhotoMime   string `json:"photo_mime"`
}

const photoSize = 3 * 1024 * 1024

func (server *Server) createProduct(ctx *gin.Context) {
	ctx.Request.Body = http.MaxBytesReader(ctx.Writer, ctx.Request.Body, photoSize)
	var req createProductRequest
	if err := ctx.ShouldBind(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	// Проверяем, что категория существует
	category, err := server.store.GetCategoryByID(ctx, req.CategoryID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errors.New("категория не найдена"))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	var photoBytes []byte
	if req.PhotoUrl != nil {
		if req.PhotoUrl.Size > photoSize {
			ctx.JSON(http.StatusBadRequest, errorResponse(errors.New("размер файла привышает 3MB")))
			return
		}
		file, err := req.PhotoUrl.Open()
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			return
		}
		defer file.Close()
		photoBytes, err = io.ReadAll(file)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			return
		}

		contentType := http.DetectContentType(photoBytes)
		allowedTypes := map[string]bool{
			"image/jpeg": true,
			"image/jpg":  true,
			"image/png":  true,
		}
		if !allowedTypes[contentType] {
			ctx.JSON(http.StatusBadRequest, errorResponse(errors.New("данный тип файла не поддерживается")))
		}
	}

	arg := sqlc.CreateProductParams{
		CategoryID:  category.ID,
		Name:        req.Name,
		Description: req.Description,
		Price:       req.Price,
		Stock:       req.Stock,
		PhotoUrl:    photoBytes,
	}

	product, err := server.store.CreateProduct(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	contentType := http.DetectContentType(photoBytes)

	rsp := productResponse{
		CategoryID:  product.CategoryID,
		Name:        product.Name,
		Description: product.Description,
		Price:       product.Price,
		Stock:       product.Stock,
		PhotoUrl:    base64.StdEncoding.EncodeToString(product.PhotoUrl),
		PhotoMime:   contentType,
	}

	ctx.JSON(http.StatusOK, rsp)
}
