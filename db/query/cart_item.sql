-- name: CreateCartItem :one
INSERT INTO cart_items (
  user_id,
  product_id,
  quantity
) VALUES (
  $1, $2, $3
  )
RETURNING *;

-- name: GetCartItemByID :one
SELECT * FROM cart_items
WHERE id = $1
LIMIT 1;

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

-- name: DeleteCartItemByIDAndUserID :exec
DELETE FROM cart_items
WHERE id = $1 AND user_id = $2;

-- name: UpdateQuantityCartItem :one
UPDATE cart_items SET
quantity = $3,
updated_at = NOW()
WHERE id = $1 AND user_id = $2
RETURNING *;
