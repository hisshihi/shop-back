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
ORDER BY created_at
LIMIT $1
OFFSET $2;

-- name: ListOrdersByUserID :many
SELECT * FROM orders
WHERE user_id = $1
ORDER BY created_at
LIMIT $2
OFFSET $3;

-- name: HasUserPurchasedProduct :one
SELECT EXISTS (
    SELECT 1 
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE 
        o.user_id = $1 
        AND oi.product_id = $2
        AND o.status = 'canceled' -- Если статус заказа важен
) AS has_purchased;

-- name: CountOrders :one
SELECT COUNT(*) FROM orders;

-- name: CountOrderByUserID :one
SELECT COUNT(*) FROM orders
WHERE user_id = $1;

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

-- name: GetOrderWithItems :one
SELECT 
  orders.*,
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
GROUP BY orders.id;

-- name: ListOrdersWithItems :many
SELECT 
  orders.*,
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
OFFSET $2;

-- name: ListOrdersByUserIDWithItems :many
SELECT 
  orders.*,
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
OFFSET $3;

-- name: UpdateOrderStatusWithItems :one
WITH updated_order AS (
    UPDATE orders
    SET 
        status = $2,
        delivery_status = $3,
        updated_at = NOW()
    WHERE id = $1
    RETURNING *
)
SELECT 
    uo.*,
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
    uo.created_at, 
    uo.updated_at;
