-- name: CreateCartItem :one
INSERT INTO cart_items (
  user_id,
  product_id,
  quantity
) VALUES (
  $1, $2, $3
  )
RETURNING *;
