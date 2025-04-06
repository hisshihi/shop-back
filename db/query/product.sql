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
SELECT 
    id, 
    category_id, 
    name, 
    description, 
    price, 
    stock, 
    photo_url 
FROM products 
WHERE
    CASE WHEN $1::bool THEN category_id = $2 ELSE TRUE END
    AND 
    CASE WHEN $5::bool THEN name ILIKE '%' || $6 || '%' ELSE TRUE END
ORDER BY
    CASE WHEN $7::bool THEN name END ASC,
    CASE WHEN $8::bool THEN name END DESC,
    CASE WHEN $9::bool THEN price END ASC,
    CASE WHEN $10::bool THEN price END DESC,
    id ASC
LIMIT $3
OFFSET $4;

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

-- name: GetTopProducts :many
SELECT 
  p.id,
  p.name,
  SUM(oi.quantity) AS total_sold,
  SUM(oi.quantity * oi.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id
ORDER BY total_sold DESC
LIMIT 10;
