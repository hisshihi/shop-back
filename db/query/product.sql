-- name: CreateProduct :one
INSERT INTO products (
  category_id, 
  name, 
  description, 
  price, 
  stock,
  photo_url
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: GetProductByID :one
SELECT * FROM products 
WHERE id = $1 LIMIT 1;

-- name: GetProductByCategoryID :many
SELECT id FROM products
WHERE category_id = $1;

-- name: ListProducts :many
SELECT * FROM products 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: CountProducts :one
SELECT COUNT(*) FROM products;

-- name: UpdateProduct :one
UPDATE products
SET 
  category_id = $2,
  name = $3,
  description = $4,
  price = $5,
  stock = $6,
  photo_url = $7,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteProduct :exec
DELETE FROM products 
WHERE id = $1;

-- name: DeleteProductByCategoryID :execrows
DELETE FROM products
WHERE category_id = $1;
