package sqlc

import (
	"context"
	"database/sql"
	"fmt"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/stretchr/testify/require"
)

func createRandomProduct(t *testing.T) Product {
	category := createRandomCategory(t)
	arg := CreateProductParams{
		CategoryID:  category.ID,
		Name:        gofakeit.ProductName(),
		Description: gofakeit.Sentence(10),
		Price:       fmt.Sprintf("%.2f", gofakeit.Price(10, 1000)),
		Stock:       int32(gofakeit.Number(1, 100)),
	}

	product, err := testQueries.CreateProduct(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, product)

	require.Equal(t, arg.CategoryID, product.CategoryID)
	require.Equal(t, arg.Name, product.Name)
	require.Equal(t, arg.Description, product.Description)
	require.Equal(t, arg.Price, product.Price)
	require.Equal(t, arg.Stock, product.Stock)
	require.NotZero(t, product.ID)
	require.NotZero(t, product.CreatedAt)

	return product
}

func TestCreateProduct(t *testing.T) {
	createRandomProduct(t)
}

func TestGetProductByID(t *testing.T) {
	product1 := createRandomProduct(t)
	product2, err := testQueries.GetProductByID(context.Background(), product1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, product2)

	require.Equal(t, product1.ID, product2.ID)
	require.Equal(t, product1.CategoryID, product2.CategoryID)
	require.Equal(t, product1.Name, product2.Name)
	require.Equal(t, product1.Description, product2.Description)
	require.Equal(t, product1.Price, product2.Price)
	require.Equal(t, product1.Stock, product2.Stock)
	require.WithinDuration(t, product1.CreatedAt, product2.CreatedAt, time.Second)
}

func TestListProducts(t *testing.T) {
	for range 10 {
		createRandomProduct(t)
	}

	arg := ListProductsParams{
		Limit:  5,
		Offset: 5,
	}

	products, err := testQueries.ListProducts(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, products, 5)

	for _, product := range products {
		require.NotEmpty(t, product)
	}
}

func TestCountProducts(t *testing.T) {
	initialCount, err := testQueries.CountProducts(context.Background())
	require.NoError(t, err)

	for range 10 {
		createRandomProduct(t)
	}

	finalCount, err := testQueries.CountProducts(context.Background())
	require.NoError(t, err)
	require.Equal(t, initialCount+10, finalCount)
}

func TestUpdateProduct(t *testing.T) {
	product1 := createRandomProduct(t)
	category := createRandomCategory(t)
	arg := UpdateProductParams{
		ID:          product1.ID,
		CategoryID:  category.ID,
		Name:        gofakeit.ProductName(),
		Description: gofakeit.Sentence(10),
		Price:       fmt.Sprintf("%.2f", gofakeit.Price(10, 1000)),
		Stock:       int32(gofakeit.Number(1, 100)),
	}

	product2, err := testQueries.UpdateProduct(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, product2)

	require.Equal(t, product1.ID, product2.ID)
	require.Equal(t, arg.CategoryID, product2.CategoryID)
	require.Equal(t, arg.Name, product2.Name)
	require.Equal(t, arg.Description, product2.Description)
	require.Equal(t, arg.Price, product2.Price)
	require.Equal(t, arg.Stock, product2.Stock)
	require.WithinDuration(t, product1.CreatedAt, product2.CreatedAt, time.Second)
	require.NotZero(t, product2.UpdatedAt)
}

func TestDeleteProduct(t *testing.T) {
	product1 := createRandomProduct(t)
	err := testQueries.DeleteProduct(context.Background(), product1.ID)
	require.NoError(t, err)

	product2, err := testQueries.GetProductByID(context.Background(), product1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, product2)
}

