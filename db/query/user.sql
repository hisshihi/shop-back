-- name: CreateUser :one
INSERT INTO users (
  username, 
  email, 
  fullname,
  password, 
  role,
  phone
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM users 
WHERE id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users 
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: CountUsers :one
SELECT COUNT(*) FROM users;

-- name: UpdateUser :one
UPDATE users
SET 
  username = $2,
  email = $3,
  fullname = $4,
  password = $5,
  phone = $6,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users 
WHERE id = $1;

-- name: GetUser :one
SELECT * FROM users
WHERE username = $1;

-- name: BannedUser :one
UPDATE users
SET is_banned = true 
WHERE id = $1
RETURNING *;
