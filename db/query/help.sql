-- name: CreateHelpMessage :one
INSERT INTO help (
  fullname,
 email,
  topic,
message
) VALUES (
$1, $2, $3, $4
  )
RETURNING *;

-- name: ListHelpMesage :many
SELECT * FROM help
ORDER BY created_at
LIMIT $1
OFFSET $2;

-- name: GetHelpMessageByID :one
SELECT * FROM help
WHERE id = $1
LIMIT 1;

-- name: CountHelpMessage :one
SELECT COUNT(*) FROM help;

-- name: DeleteHelpMessage :exec
DELETE FROM help
WHERE id = $1;
