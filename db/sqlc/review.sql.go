// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: review.sql

package sqlc

import (
	"context"
	"database/sql"
)

const countReviews = `-- name: CountReviews :one
SELECT COUNT(*) FROM reviews
`

func (q *Queries) CountReviews(ctx context.Context) (int64, error) {
	row := q.db.QueryRowContext(ctx, countReviews)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const createReview = `-- name: CreateReview :one
INSERT INTO reviews (
  user_id, 
  product_id, 
  rating, 
  comment
) VALUES (
  $1, $2, $3, $4
)
RETURNING id, user_id, product_id, rating, comment, created_at, updated_at
`

type CreateReviewParams struct {
	UserID    int64          `json:"user_id"`
	ProductID int64          `json:"product_id"`
	Rating    int32          `json:"rating"`
	Comment   sql.NullString `json:"comment"`
}

func (q *Queries) CreateReview(ctx context.Context, arg CreateReviewParams) (Review, error) {
	row := q.db.QueryRowContext(ctx, createReview,
		arg.UserID,
		arg.ProductID,
		arg.Rating,
		arg.Comment,
	)
	var i Review
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.Rating,
		&i.Comment,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteReview = `-- name: DeleteReview :exec
DELETE FROM reviews 
WHERE id = $1
`

func (q *Queries) DeleteReview(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteReview, id)
	return err
}

const getReviewByID = `-- name: GetReviewByID :one
SELECT id, user_id, product_id, rating, comment, created_at, updated_at FROM reviews 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetReviewByID(ctx context.Context, id int64) (Review, error) {
	row := q.db.QueryRowContext(ctx, getReviewByID, id)
	var i Review
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.Rating,
		&i.Comment,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const listReviews = `-- name: ListReviews :many
SELECT id, user_id, product_id, rating, comment, created_at, updated_at FROM reviews 
WHERE product_id = $1
ORDER BY id
LIMIT $2
OFFSET $3
`

type ListReviewsParams struct {
	ProductID int64 `json:"product_id"`
	Limit     int64 `json:"limit"`
	Offset    int64 `json:"offset"`
}

func (q *Queries) ListReviews(ctx context.Context, arg ListReviewsParams) ([]Review, error) {
	rows, err := q.db.QueryContext(ctx, listReviews, arg.ProductID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Review{}
	for rows.Next() {
		var i Review
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.ProductID,
			&i.Rating,
			&i.Comment,
			&i.CreatedAt,
			&i.UpdatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const updateReview = `-- name: UpdateReview :one
UPDATE reviews
SET 
  rating = $2,
  comment = $3,
  updated_at = NOW()
WHERE id = $1
RETURNING id, user_id, product_id, rating, comment, created_at, updated_at
`

type UpdateReviewParams struct {
	ID      int64          `json:"id"`
	Rating  int32          `json:"rating"`
	Comment sql.NullString `json:"comment"`
}

func (q *Queries) UpdateReview(ctx context.Context, arg UpdateReviewParams) (Review, error) {
	row := q.db.QueryRowContext(ctx, updateReview, arg.ID, arg.Rating, arg.Comment)
	var i Review
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.Rating,
		&i.Comment,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
