// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: order.sql

package sqlc

import (
	"context"
	"database/sql"
	"time"

	"github.com/sqlc-dev/pqtype"
)

const countOrderByUserID = `-- name: CountOrderByUserID :one
SELECT COUNT(*) FROM orders
WHERE user_id = $1
`

func (q *Queries) CountOrderByUserID(ctx context.Context, userID int64) (int64, error) {
	row := q.db.QueryRowContext(ctx, countOrderByUserID, userID)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const countOrders = `-- name: CountOrders :one
SELECT COUNT(*) FROM orders
`

func (q *Queries) CountOrders(ctx context.Context) (int64, error) {
	row := q.db.QueryRowContext(ctx, countOrders)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const createOrder = `-- name: CreateOrder :one
INSERT INTO orders (
  user_id, 
  total_amount, 
  status, 
  payment_method, 
  delivery_status,
  delivery_address
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at
`

type CreateOrderParams struct {
	UserID          int64          `json:"user_id"`
	TotalAmount     string         `json:"total_amount"`
	Status          OrderStatus    `json:"status"`
	PaymentMethod   string         `json:"payment_method"`
	DeliveryStatus  sql.NullString `json:"delivery_status"`
	DeliveryAddress string         `json:"delivery_address"`
}

func (q *Queries) CreateOrder(ctx context.Context, arg CreateOrderParams) (Order, error) {
	row := q.db.QueryRowContext(ctx, createOrder,
		arg.UserID,
		arg.TotalAmount,
		arg.Status,
		arg.PaymentMethod,
		arg.DeliveryStatus,
		arg.DeliveryAddress,
	)
	var i Order
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.TotalAmount,
		&i.Status,
		&i.PaymentMethod,
		&i.DeliveryAddress,
		&i.DeliveryStatus,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteOrder = `-- name: DeleteOrder :exec
DELETE FROM orders 
WHERE id = $1
`

func (q *Queries) DeleteOrder(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteOrder, id)
	return err
}

const getOrderByID = `-- name: GetOrderByID :one
SELECT id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at FROM orders 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetOrderByID(ctx context.Context, id int64) (Order, error) {
	row := q.db.QueryRowContext(ctx, getOrderByID, id)
	var i Order
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.TotalAmount,
		&i.Status,
		&i.PaymentMethod,
		&i.DeliveryAddress,
		&i.DeliveryStatus,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getOrderWithItems = `-- name: GetOrderWithItems :one
SELECT 
  orders.id, orders.user_id, orders.total_amount, orders.status, orders.payment_method, orders.delivery_address, orders.delivery_status, orders.created_at, orders.updated_at,
  COALESCE(
    json_agg(
      json_build_object(
        'id', oi.id,
        'product_id', oi.product_id,
        'quantity', oi.quantity,
        'price', oi.price,
        'created_at', oi.created_at
      )
    ) FILTER (WHERE oi.id IS NOT NULL),
    '[]'
  ) AS items
FROM orders
LEFT JOIN order_items oi ON orders.id = oi.order_id
WHERE orders.id = $1
GROUP BY orders.id
`

type GetOrderWithItemsRow struct {
	ID              int64                 `json:"id"`
	UserID          int64                 `json:"user_id"`
	TotalAmount     string                `json:"total_amount"`
	Status          OrderStatus           `json:"status"`
	PaymentMethod   string                `json:"payment_method"`
	DeliveryAddress string                `json:"delivery_address"`
	DeliveryStatus  sql.NullString        `json:"delivery_status"`
	CreatedAt       time.Time             `json:"created_at"`
	UpdatedAt       time.Time             `json:"updated_at"`
	Items           pqtype.NullRawMessage `json:"items"`
}

func (q *Queries) GetOrderWithItems(ctx context.Context, id int64) (GetOrderWithItemsRow, error) {
	row := q.db.QueryRowContext(ctx, getOrderWithItems, id)
	var i GetOrderWithItemsRow
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.TotalAmount,
		&i.Status,
		&i.PaymentMethod,
		&i.DeliveryAddress,
		&i.DeliveryStatus,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.Items,
	)
	return i, err
}

const getSalesStats = `-- name: GetSalesStats :many
SELECT 
  DATE(o.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Etc/GMT-5') AS date,
  COUNT(DISTINCT o.id) AS total_orders,
  SUM(oi.quantity) AS total_items,
  SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.created_at >= (NOW() AT TIME ZONE 'Etc/GMT-5' - INTERVAL '1 month') AT TIME ZONE 'UTC'
GROUP BY DATE(o.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Etc/GMT-5')
ORDER BY date DESC
`

type GetSalesStatsRow struct {
	Date         time.Time `json:"date"`
	TotalOrders  int64     `json:"total_orders"`
	TotalItems   int64     `json:"total_items"`
	TotalRevenue string    `json:"total_revenue"`
}

func (q *Queries) GetSalesStats(ctx context.Context) ([]GetSalesStatsRow, error) {
	rows, err := q.db.QueryContext(ctx, getSalesStats)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []GetSalesStatsRow{}
	for rows.Next() {
		var i GetSalesStatsRow
		if err := rows.Scan(
			&i.Date,
			&i.TotalOrders,
			&i.TotalItems,
			&i.TotalRevenue,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const hasUserPurchasedProduct = `-- name: HasUserPurchasedProduct :one
SELECT EXISTS (
    SELECT 1 
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE 
        o.user_id = $1 
        AND oi.product_id = $2
       -- AND o.status = 'canceled' -- Если статус заказа важен
) AS has_purchased
`

type HasUserPurchasedProductParams struct {
	UserID    int64 `json:"user_id"`
	ProductID int64 `json:"product_id"`
}

func (q *Queries) HasUserPurchasedProduct(ctx context.Context, arg HasUserPurchasedProductParams) (bool, error) {
	row := q.db.QueryRowContext(ctx, hasUserPurchasedProduct, arg.UserID, arg.ProductID)
	var has_purchased bool
	err := row.Scan(&has_purchased)
	return has_purchased, err
}

const listOrders = `-- name: ListOrders :many
SELECT id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at FROM orders 
ORDER BY created_at
LIMIT $1
OFFSET $2
`

type ListOrdersParams struct {
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

func (q *Queries) ListOrders(ctx context.Context, arg ListOrdersParams) ([]Order, error) {
	rows, err := q.db.QueryContext(ctx, listOrders, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Order{}
	for rows.Next() {
		var i Order
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.TotalAmount,
			&i.Status,
			&i.PaymentMethod,
			&i.DeliveryAddress,
			&i.DeliveryStatus,
			&i.CreatedAt,
			&i.UpdatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const listOrdersByUserID = `-- name: ListOrdersByUserID :many
SELECT id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at FROM orders
WHERE user_id = $1
ORDER BY created_at
LIMIT $2
OFFSET $3
`

type ListOrdersByUserIDParams struct {
	UserID int64 `json:"user_id"`
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

func (q *Queries) ListOrdersByUserID(ctx context.Context, arg ListOrdersByUserIDParams) ([]Order, error) {
	rows, err := q.db.QueryContext(ctx, listOrdersByUserID, arg.UserID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Order{}
	for rows.Next() {
		var i Order
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.TotalAmount,
			&i.Status,
			&i.PaymentMethod,
			&i.DeliveryAddress,
			&i.DeliveryStatus,
			&i.CreatedAt,
			&i.UpdatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const listOrdersByUserIDWithItems = `-- name: ListOrdersByUserIDWithItems :many
SELECT 
  orders.id, orders.user_id, orders.total_amount, orders.status, orders.payment_method, orders.delivery_address, orders.delivery_status, orders.created_at, orders.updated_at,
  COALESCE(
    json_agg(
      json_build_object(
        'id', oi.id,
        'product_id', oi.product_id,
        'quantity', oi.quantity,
        'price', oi.price,
        'created_at', oi.created_at
      )
    ) FILTER (WHERE oi.id IS NOT NULL),
    '[]'
  ) AS items
FROM orders
LEFT JOIN order_items oi ON orders.id = oi.order_id
WHERE user_id = $1
GROUP BY orders.id
ORDER BY orders.created_at
LIMIT $2
OFFSET $3
`

type ListOrdersByUserIDWithItemsParams struct {
	UserID int64 `json:"user_id"`
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

type ListOrdersByUserIDWithItemsRow struct {
	ID              int64                 `json:"id"`
	UserID          int64                 `json:"user_id"`
	TotalAmount     string                `json:"total_amount"`
	Status          OrderStatus           `json:"status"`
	PaymentMethod   string                `json:"payment_method"`
	DeliveryAddress string                `json:"delivery_address"`
	DeliveryStatus  sql.NullString        `json:"delivery_status"`
	CreatedAt       time.Time             `json:"created_at"`
	UpdatedAt       time.Time             `json:"updated_at"`
	Items           pqtype.NullRawMessage `json:"items"`
}

func (q *Queries) ListOrdersByUserIDWithItems(ctx context.Context, arg ListOrdersByUserIDWithItemsParams) ([]ListOrdersByUserIDWithItemsRow, error) {
	rows, err := q.db.QueryContext(ctx, listOrdersByUserIDWithItems, arg.UserID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []ListOrdersByUserIDWithItemsRow{}
	for rows.Next() {
		var i ListOrdersByUserIDWithItemsRow
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.TotalAmount,
			&i.Status,
			&i.PaymentMethod,
			&i.DeliveryAddress,
			&i.DeliveryStatus,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.Items,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const listOrdersWithItems = `-- name: ListOrdersWithItems :many
SELECT 
  orders.id, orders.user_id, orders.total_amount, orders.status, orders.payment_method, orders.delivery_address, orders.delivery_status, orders.created_at, orders.updated_at,
  COALESCE(
    json_agg(
      json_build_object(
        'id', oi.id,
        'product_id', oi.product_id,
        'quantity', oi.quantity,
        'price', oi.price,
        'created_at', oi.created_at
      )
    ) FILTER (WHERE oi.id IS NOT NULL),
    '[]'
  ) AS items
FROM orders
LEFT JOIN order_items oi ON orders.id = oi.order_id
GROUP BY orders.id
ORDER BY orders.created_at
LIMIT $1
OFFSET $2
`

type ListOrdersWithItemsParams struct {
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

type ListOrdersWithItemsRow struct {
	ID              int64                 `json:"id"`
	UserID          int64                 `json:"user_id"`
	TotalAmount     string                `json:"total_amount"`
	Status          OrderStatus           `json:"status"`
	PaymentMethod   string                `json:"payment_method"`
	DeliveryAddress string                `json:"delivery_address"`
	DeliveryStatus  sql.NullString        `json:"delivery_status"`
	CreatedAt       time.Time             `json:"created_at"`
	UpdatedAt       time.Time             `json:"updated_at"`
	Items           pqtype.NullRawMessage `json:"items"`
}

func (q *Queries) ListOrdersWithItems(ctx context.Context, arg ListOrdersWithItemsParams) ([]ListOrdersWithItemsRow, error) {
	rows, err := q.db.QueryContext(ctx, listOrdersWithItems, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []ListOrdersWithItemsRow{}
	for rows.Next() {
		var i ListOrdersWithItemsRow
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.TotalAmount,
			&i.Status,
			&i.PaymentMethod,
			&i.DeliveryAddress,
			&i.DeliveryStatus,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.Items,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const sumTotalAmount = `-- name: SumTotalAmount :one
SELECT SUM(total_amount) FROM orders
`

func (q *Queries) SumTotalAmount(ctx context.Context) (string, error) {
	row := q.db.QueryRowContext(ctx, sumTotalAmount)
	var sum string
	err := row.Scan(&sum)
	return sum, err
}

const updateOrderStatus = `-- name: UpdateOrderStatus :one
UPDATE orders
SET 
  status = $2,
  delivery_status = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at
`

type UpdateOrderStatusParams struct {
	ID             int64          `json:"id"`
	Status         OrderStatus    `json:"status"`
	DeliveryStatus sql.NullString `json:"delivery_status"`
}

func (q *Queries) UpdateOrderStatus(ctx context.Context, arg UpdateOrderStatusParams) (Order, error) {
	row := q.db.QueryRowContext(ctx, updateOrderStatus, arg.ID, arg.Status, arg.DeliveryStatus)
	var i Order
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.TotalAmount,
		&i.Status,
		&i.PaymentMethod,
		&i.DeliveryAddress,
		&i.DeliveryStatus,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updateOrderStatusWithItems = `-- name: UpdateOrderStatusWithItems :one
WITH updated_order AS (
    UPDATE orders
    SET 
        status = $2,
        delivery_status = $3,
        updated_at = NOW()
    WHERE id = $1
    RETURNING id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at
)
SELECT 
    uo.id, uo.user_id, uo.total_amount, uo.status, uo.payment_method, uo.delivery_address, uo.delivery_status, uo.created_at, uo.updated_at,
    COALESCE(
        json_agg(
            json_build_object(
                'id', oi.id,
                'product_id', oi.product_id,
                'quantity', oi.quantity,
                'price', oi.price,
                'created_at', oi.created_at
            )
        ) FILTER (WHERE oi.id IS NOT NULL),
        '[]'
    ) AS items
FROM updated_order uo
LEFT JOIN order_items oi ON uo.id = oi.order_id
GROUP BY 
    uo.id, 
    uo.user_id, 
    uo.total_amount, 
    uo.status, 
    uo.payment_method, 
    uo.delivery_status, 
    uo.delivery_address,
    uo.created_at, 
    uo.updated_at
`

type UpdateOrderStatusWithItemsParams struct {
	Column1 sql.NullInt64   `json:"column_1"`
	Column2 NullOrderStatus `json:"column_2"`
	Column3 sql.NullString  `json:"column_3"`
}

type UpdateOrderStatusWithItemsRow struct {
	ID              int64                 `json:"id"`
	UserID          int64                 `json:"user_id"`
	TotalAmount     string                `json:"total_amount"`
	Status          OrderStatus           `json:"status"`
	PaymentMethod   string                `json:"payment_method"`
	DeliveryAddress string                `json:"delivery_address"`
	DeliveryStatus  sql.NullString        `json:"delivery_status"`
	CreatedAt       time.Time             `json:"created_at"`
	UpdatedAt       time.Time             `json:"updated_at"`
	Items           pqtype.NullRawMessage `json:"items"`
}

func (q *Queries) UpdateOrderStatusWithItems(ctx context.Context, arg UpdateOrderStatusWithItemsParams) (UpdateOrderStatusWithItemsRow, error) {
	row := q.db.QueryRowContext(ctx, updateOrderStatusWithItems, arg.Column1, arg.Column2, arg.Column3)
	var i UpdateOrderStatusWithItemsRow
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.TotalAmount,
		&i.Status,
		&i.PaymentMethod,
		&i.DeliveryAddress,
		&i.DeliveryStatus,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.Items,
	)
	return i, err
}
