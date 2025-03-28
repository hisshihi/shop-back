-- name: CreateProduct :one
INSERT INTO products (
  category_id, 
  name, 
  description, 
  price, 
  stock
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING *;

-- name: GetProductByID :one
SELECT * FROM products 
WHERE id = $1 LIMIT 1;

-- name: ListProducts :many
SELECT * FROM products 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProduct :one
UPDATE products
SET 
  category_id = $2,
  name = $3,
  description = $4,
  price = $5,
  stock = $6,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteProduct :exec
DELETE FROM products 
WHERE id = $1;