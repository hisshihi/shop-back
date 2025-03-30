-- name: CreateOrder :one
INSERT INTO orders (
  user_id, 
  total_amount, 
  status, 
  payment_method, 
  delivery_status
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING *;

-- name: GetOrderByID :one
SELECT * FROM orders 
WHERE id = $1 LIMIT 1;

-- name: ListOrders :many
SELECT * FROM orders 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: CountOrders :one
SELECT COUNT(*) FROM orders;

-- name: UpdateOrderStatus :one
UPDATE orders
SET 
  status = $2,
  delivery_status = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteOrder :exec
DELETE FROM orders 
WHERE id = $1;