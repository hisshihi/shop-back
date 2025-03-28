-- name: CreateLog :one
INSERT INTO logs (
  user_id, 
  action
) VALUES (
  $1, $2
)
RETURNING *;

-- name: GetLogByID :one
SELECT * FROM logs 
WHERE id = $1 LIMIT 1;

-- name: ListLogs :many
SELECT * FROM logs 
ORDER BY created_at DESC
LIMIT $1
OFFSET $2;