// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: cart_item.sql

package sqlc

import (
	"context"
)

const createCartItem = `-- name: CreateCartItem :one
INSERT INTO cart_items (
  user_id,
  product_id,
  quantity
) VALUES (
  $1, $2, $3
  )
RETURNING id, user_id, product_id, quantity, created_at, updated_at
`

type CreateCartItemParams struct {
	UserID    int64 `json:"user_id"`
	ProductID int64 `json:"product_id"`
	Quantity  int32 `json:"quantity"`
}

func (q *Queries) CreateCartItem(ctx context.Context, arg CreateCartItemParams) (CartItem, error) {
	row := q.db.QueryRowContext(ctx, createCartItem, arg.UserID, arg.ProductID, arg.Quantity)
	var i CartItem
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.Quantity,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
