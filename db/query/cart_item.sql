-- name: CreateCartItem :one
INSERT INTO cart_items (
  user_id,
  product_id,
  quantity
) VALUES (
  $1, $2, $3
  )
RETURNING *;

-- name: ListCartItemByUserID :many
SELECT
  cart_items.*,
  products.name,
  products.price,
  products.description,
  products.stock,
  products.photo_url
  FROM cart_items
JOIN products ON cart_items.product_id = products.id
WHERE cart_items.user_id = $1;
