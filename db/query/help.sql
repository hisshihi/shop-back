-- name: CreateHelpMessage :one
INSERT INTO help (
 email,
  topic,
message
) VALUES (
$1, $2, $3
  )
RETURNING *;

-- name: ListHelpMesage :many
SELECT * FROM help
ORDER BY created_at
LIMIT $1
OFFSET $2;
