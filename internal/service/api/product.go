package api

import (
	"database/sql"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/db/sqlc"
	"github.com/hisshihi/shop-back/internal/service"
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
	ID          int64  `json:"id"`
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
			"image/webp": true,
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
		ID:          product.ID,
		CategoryID:  product.CategoryID,
		Name:        product.Name,
		Description: product.Description,
		Price:       product.Price,
		Stock:       product.Stock,
		PhotoUrl:    base64.StdEncoding.EncodeToString(product.PhotoUrl),
		PhotoMime:   contentType,
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Создание товара ID: %v", rsp.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, rsp)
}

type getProductByIDRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) getProductByID(ctx *gin.Context) {
	var req getProductByIDRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	product, err := server.store.GetProductByID(ctx, req.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	rsp := productResponse{
		ID:          product.ID,
		CategoryID:  product.CategoryID,
		Name:        product.Name,
		Description: product.Description,
		Price:       product.Price,
		Stock:       product.Stock,
		PhotoUrl:    base64.StdEncoding.EncodeToString(product.PhotoUrl),
	}

	ctx.JSON(http.StatusOK, rsp)
}

type listProductRequest struct {
	PageID     int32  `form:"page_id" binding:"required,min=1"`
	PageSize   int32  `form:"page_size" binding:"required,min=5,max=12"`
	CategoryID int64  `form:"category_id"`
	Search     string `form:"search"`
	Sort       string `form:"sort"`
}

func (server *Server) listProduct(ctx *gin.Context) {
	var req listProductRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	sortParams := parseSrot(req.Sort)
	arg := sqlc.ListProductsParams{
		Column1:    req.CategoryID != 0,
		CategoryID: req.CategoryID,
		Limit:      int64(req.PageSize),
		Offset:     int64((req.PageID - 1) * req.PageSize),
		Column5:    req.Search != "",
		Column6:    sql.NullString{String: req.Search, Valid: true},
		Column7:    sortParams["name_asc"],
		Column8:    sortParams["name_desc"],
		Column9:    sortParams["price_asc"],
		Column10:   sortParams["price_desc"],
	}

	listProducts, err := server.store.ListProducts(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	countProducts, err := server.store.CountProducts(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"products":       listProducts,
		"products_count": countProducts,
	})
}

func parseSrot(input string) map[string]bool {
	result := make(map[string]bool)
	for _, part := range strings.Split(input, ",") {
		result[strings.TrimSpace(part)] = true
	}
	return result
}

type updateProductRequest struct {
	CategoryID  int64                 `form:"category_id" binding:"required,min=1"`
	Name        string                `form:"name" binding:"required"`
	Description string                `form:"description" binding:"required"`
	Price       string                `form:"price" binding:"required"`
	Stock       int32                 `form:"stock" binding:"required,min=1"`
	PhotoUrl    *multipart.FileHeader `form:"photo_url" binding:"required"`
}

func (server *Server) updateProduct(ctx *gin.Context) {
	var reqID getProductByIDRequest
	var req updateProductRequest
	if err := ctx.ShouldBindUri(&reqID); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	if err := ctx.ShouldBind(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	findProduct, err := server.store.GetProductByID(ctx, reqID.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	var photoBytes []byte
	if req.PhotoUrl.Header != nil {
		if req.PhotoUrl != nil {
			if req.PhotoUrl.Size > photoSize {
				ctx.JSON(http.StatusBadRequest, errorResponse(errors.New("размер файла превышает 3МБ")))
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
		} else {
			photoBytes = findProduct.PhotoUrl
		}
	} else {
		photoBytes = findProduct.PhotoUrl
	}

	arg := sqlc.UpdateProductParams{
		ID:          findProduct.ID,
		CategoryID:  req.CategoryID,
		Name:        req.Name,
		Description: req.Description,
		Price:       req.Price,
		Stock:       req.Stock,
		PhotoUrl:    photoBytes,
	}

	updateProduct, err := server.store.UpdateProduct(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Обновление товара ID: %v", updateProduct.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusOK, updateProduct)
}

func (server *Server) deleteProduct(ctx *gin.Context) {
	var req getProductByIDRequest
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := service.DeleteProductTxParams{
		ProductID: req.ID,
	}
	result, err := server.store.TransferTxDeleteProduct(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	user, err := server.getUserDataFromToken(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	action := fmt.Sprintf("Удаление товара ID: %v", req.ID)
	server.createLog(ctx, user.ID, action)

	ctx.JSON(http.StatusNoContent, gin.H{
		"deleted_products": result.DeleteFavorits,
	})
}

func (server *Server) getTopProduct(ctx *gin.Context) {
	topProduct, err := server.store.GetTopProducts(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, topProduct)
}
