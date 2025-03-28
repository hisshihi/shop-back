-- name: CreateOrderItem :one
INSERT INTO order_items (
  order_id, 
  product_id, 
  quantity, 
  price
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: GetOrderItemByID :one
SELECT * FROM order_items 
WHERE id = $1 LIMIT 1;

-- name: ListOrderItems :many
SELECT * FROM order_items 
WHERE order_id = $1
ORDER BY id;

-- name: UpdateOrderItem :one
UPDATE order_items
SET 
  quantity = $2,
  price = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteOrderItem :exec
DELETE FROM order_items 
WHERE id = $1;