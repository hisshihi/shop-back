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

func createRandomOrder(t *testing.T) Order {
	user := createRandomUser(t)
	arg := CreateOrderParams{
		UserID:         user.ID,
		TotalAmount:    fmt.Sprintf("%.2f", gofakeit.Price(50, 500)),
		Status:         "pending",
		PaymentMethod:  "card",
		DeliveryStatus: NullOrderStatus{OrderStatus: OrderStatusProcessed, Valid: true},
	}

	order, err := testQueries.CreateOrder(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, order)

	require.Equal(t, arg.UserID, order.UserID)
	require.Equal(t, arg.TotalAmount, order.TotalAmount)
	require.Equal(t, arg.Status, order.Status)
	require.Equal(t, arg.PaymentMethod, order.PaymentMethod)
	require.Equal(t, arg.DeliveryStatus, order.DeliveryStatus)
	require.NotZero(t, order.ID)
	require.NotZero(t, order.CreatedAt)

	return order
}

func TestCreateOrder(t *testing.T) {
	createRandomOrder(t)
}

func TestGetOrderByID(t *testing.T) {
	order1 := createRandomOrder(t)
	order2, err := testQueries.GetOrderByID(context.Background(), order1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, order2)

	require.Equal(t, order1.ID, order2.ID)
	require.Equal(t, order1.UserID, order2.UserID)
	require.Equal(t, order1.TotalAmount, order2.TotalAmount)
	require.Equal(t, order1.Status, order2.Status)
	require.Equal(t, order1.PaymentMethod, order2.PaymentMethod)
	require.Equal(t, order1.DeliveryStatus, order2.DeliveryStatus)
	require.WithinDuration(t, order1.CreatedAt, order2.CreatedAt, time.Second)
}

func TestListOrders(t *testing.T) {
	for range 10 {
		createRandomOrder(t)
	}

	arg := ListOrdersParams{
		Limit:  5,
		Offset: 5,
	}

	orders, err := testQueries.ListOrders(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, orders, 5)

	for _, order := range orders {
		require.NotEmpty(t, order)
	}
}

func TestCountOrders(t *testing.T) {
	initialCount, err := testQueries.CountOrders(context.Background())
	require.NoError(t, err)

	for range 10 {
		createRandomOrder(t)
	}

	finalCount, err := testQueries.CountOrders(context.Background())
	require.NoError(t, err)
	require.Equal(t, initialCount+10, finalCount)
}

func TestUpdateOrderStatus(t *testing.T) {
	order1 := createRandomOrder(t)
	arg := UpdateOrderStatusParams{
		ID:             order1.ID,
		Status:         string(OrderStatusCanceled),
		DeliveryStatus: NullOrderStatus{OrderStatus: OrderStatusDelivered, Valid: true},
	}

	order2, err := testQueries.UpdateOrderStatus(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, order2)

	require.Equal(t, order1.ID, order2.ID)
	require.Equal(t, arg.Status, order2.Status)
	require.Equal(t, arg.DeliveryStatus, order2.DeliveryStatus)
	require.WithinDuration(t, order1.CreatedAt, order2.CreatedAt, time.Second)
	require.NotZero(t, order2.UpdatedAt)
}

func TestDeleteOrder(t *testing.T) {
	order1 := createRandomOrder(t)
	err := testQueries.DeleteOrder(context.Background(), order1.ID)
	require.NoError(t, err)

	order2, err := testQueries.GetOrderByID(context.Background(), order1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, order2)
}

