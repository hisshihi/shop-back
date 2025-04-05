-- name: CreateReview :one
INSERT INTO reviews (
  user_id, 
  product_id, 
  rating, 
  comment
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: GetReviewByID :one
SELECT * FROM reviews 
WHERE id = $1 LIMIT 1;

-- name: GetReviewByProductID :many
SELECT reviews.*, users.fullname AS full_name FROM reviews
JOIN users ON reviews.user_id = users.id
WHERE product_id = $1
ORDER BY reviews.created_at
LIMIT $2
OFFSET $3;

-- name: ListReviews :many
SELECT * FROM reviews 
WHERE product_id = $1
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: CountReviews :one
SELECT COUNT(*) FROM reviews
WHERE product_id = $1;

-- name: UpdateReview :one
UPDATE reviews
SET 
  rating = $2,
  comment = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteReview :exec
DELETE FROM reviews 
WHERE id = $1;

-- name: GetReviewByUserAndProduct :one
SELECT * FROM reviews
WHERE user_id = $1 AND product_id = $2
LIMIT 1;

-- name: GetAverageRatingForProvider :one
SELECT COALESCE(AVG(rating), 0) as avearage_rating,
COUNT(*) as total_reviews
  FROM reviews
WHERE product_id = $1;
