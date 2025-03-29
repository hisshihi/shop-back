-- name: CreatePromotion :one
INSERT INTO promotions (
  name, 
  discount_percentage, 
  start_date, 
  end_date
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: GetPromotionByID :one
SELECT * FROM promotions 
WHERE id = $1 LIMIT 1;

-- name: ListPromotions :many
SELECT * FROM promotions 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePromotion :one
UPDATE promotions
SET 
  name = $2,
  discount_percentage = $3,
  start_date = $4,
  end_date = $5
WHERE id = $1
RETURNING *;

-- name: DeletePromotion :exec
DELETE FROM promotions 
WHERE id = $1;