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

func createRandomOrderItem(t *testing.T) OrderItem {
    order := createRandomOrder(t)
    product := createRandomProduct(t)
    arg := CreateOrderItemParams{
        OrderID:   order.ID,
        ProductID: product.ID,
        Quantity:  int32(gofakeit.Number(1, 10)),
        Price:     fmt.Sprintf("%.2f", gofakeit.Price(10, 100)),
    }

    item, err := testQueries.CreateOrderItem(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, item)

    require.Equal(t, arg.OrderID, item.OrderID)
    require.Equal(t, arg.ProductID, item.ProductID)
    require.Equal(t, arg.Quantity, item.Quantity)
    require.Equal(t, arg.Price, item.Price)
    require.NotZero(t, item.ID)
    require.NotZero(t, item.CreatedAt)

    return item
}

func TestCreateOrderItem(t *testing.T) {
    createRandomOrderItem(t)
}

func TestGetOrderItemByID(t *testing.T) {
    item1 := createRandomOrderItem(t)
    item2, err := testQueries.GetOrderItemByID(context.Background(), item1.ID)
    require.NoError(t, err)
    require.NotEmpty(t, item2)

    require.Equal(t, item1.ID, item2.ID)
    require.Equal(t, item1.OrderID, item2.OrderID)
    require.Equal(t, item1.ProductID, item2.ProductID)
    require.Equal(t, item1.Quantity, item2.Quantity)
    require.Equal(t, item1.Price, item2.Price)
    require.WithinDuration(t, item1.CreatedAt, item2.CreatedAt, time.Second)
}

func TestListOrderItems(t *testing.T) {
    order := createRandomOrder(t)
    for range 10 {
        product := createRandomProduct(t)
        testQueries.CreateOrderItem(context.Background(), CreateOrderItemParams{
            OrderID:   order.ID,
            ProductID: product.ID,
            Quantity:  int32(gofakeit.Number(1, 10)),
            Price:     fmt.Sprintf("%.2f", gofakeit.Price(10, 100)),
        })
    }

    items, err := testQueries.ListOrderItems(context.Background(), order.ID)
    require.NoError(t, err)
    require.Len(t, items, 10)

    for _, item := range items {
        require.NotEmpty(t, item)
        require.Equal(t, order.ID, item.OrderID)
    }
}

func TestUpdateOrderItem(t *testing.T) {
    item1 := createRandomOrderItem(t)
    arg := UpdateOrderItemParams{
        ID:       item1.ID,
        Quantity: int32(gofakeit.Number(1, 10)),
        Price:    fmt.Sprintf("%.2f", gofakeit.Price(10, 100)),
    }

    item2, err := testQueries.UpdateOrderItem(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, item2)

    require.Equal(t, item1.ID, item2.ID)
    require.Equal(t, arg.Quantity, item2.Quantity)
    require.Equal(t, arg.Price, item2.Price)
    require.WithinDuration(t, item1.CreatedAt, item2.CreatedAt, time.Second)
    require.NotZero(t, item2.UpdatedAt)
}

func TestDeleteOrderItem(t *testing.T) {
    item1 := createRandomOrderItem(t)
    err := testQueries.DeleteOrderItem(context.Background(), item1.ID)
    require.NoError(t, err)

    item2, err := testQueries.GetOrderItemByID(context.Background(), item1.ID)
    require.Error(t, err)
    require.EqualError(t, err, sql.ErrNoRows.Error())
    require.Empty(t, item2)
}