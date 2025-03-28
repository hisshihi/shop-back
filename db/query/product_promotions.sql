-- name: CreateProductPromotion :one
INSERT INTO product_promotions (
  product_id, 
  promotion_id
) VALUES (
  $1, $2
)
RETURNING *;

-- name: GetProductPromotionByID :one
SELECT * FROM product_promotions 
WHERE id = $1 LIMIT 1;

-- name: ListProductPromotions :many
SELECT * FROM product_promotions 
WHERE product_id = $1
ORDER BY id;

-- name: DeleteProductPromotion :exec
DELETE FROM product_promotions 
WHERE id = $1;