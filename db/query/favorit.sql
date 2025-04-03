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
ORDER BY id;

-- name: CountFavorit :one
SELECT COUNT(*) FROM favorites;

-- name: CountFavoritForUser :one
SELECT COUNT(*) FROM favorites
WHERE user_id = $1;

-- name: DeleteFavorite :exec
DELETE FROM favorites 
WHERE id = $1;

-- name: DeleteFavoritForID :exec
DELETE FROM favorites
WHERE id = $1 AND user_id = $2;

-- name: DeleteFavoriteByProductID :execrows
DELETE FROM favorites
WHERE product_id = $1;

-- name: DeleteFavoritesByCategoryID :execrows
DELETE FROM favorites
WHERE product_id IN (SELECT id FROM products WHERE category_id = $1);
