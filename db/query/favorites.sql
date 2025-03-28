-- name: CreateFavorite :one
INSERT INTO favorites (
  user_id, 
  product_id
) VALUES (
  $1, $2
)
RETURNING *;

-- name: GetFavoriteByID :one
SELECT * FROM favorites 
WHERE id = $1 LIMIT 1;

-- name: ListUserFavorites :many
SELECT * FROM favorites 
WHERE user_id = $1
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: DeleteFavorite :exec
DELETE FROM favorites 
WHERE id = $1;