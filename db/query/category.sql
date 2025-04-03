-- name: CreateCategory :one
INSERT INTO categories (
  name, 
  description
) VALUES (
  $1, $2
)
RETURNING *;

-- name: GetCategoryByID :one
SELECT * FROM categories 
WHERE id = $1 LIMIT 1;

-- name: ListCategories :many
SELECT * FROM categories 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: ListCategoriesAll :many
SELECT * FROM categories 
ORDER BY name;

-- name: CountCategory :one
SELECT COUNT(*) FROM categories;

-- name: UpdateCategory :one
UPDATE categories
SET 
  name = $2,
  description = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteCategory :exec
DELETE FROM categories 
WHERE id = $1;
