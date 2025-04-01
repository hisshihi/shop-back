// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: favorit.sql

package sqlc

import (
	"context"
)

const countFavorit = `-- name: CountFavorit :one
SELECT COUNT(*) FROM favorites
`

func (q *Queries) CountFavorit(ctx context.Context) (int64, error) {
	row := q.db.QueryRowContext(ctx, countFavorit)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const createFavorite = `-- name: CreateFavorite :one
INSERT INTO favorites (
  user_id, 
  product_id
) VALUES (
  $1, $2
)
RETURNING id, user_id, product_id, created_at
`

type CreateFavoriteParams struct {
	UserID    int64 `json:"user_id"`
	ProductID int64 `json:"product_id"`
}

func (q *Queries) CreateFavorite(ctx context.Context, arg CreateFavoriteParams) (Favorite, error) {
	row := q.db.QueryRowContext(ctx, createFavorite, arg.UserID, arg.ProductID)
	var i Favorite
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.CreatedAt,
	)
	return i, err
}

const deleteFavorite = `-- name: DeleteFavorite :exec
DELETE FROM favorites 
WHERE id = $1
`

func (q *Queries) DeleteFavorite(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteFavorite, id)
	return err
}

const deleteFavoriteByProductID = `-- name: DeleteFavoriteByProductID :execrows
DELETE FROM favorites
WHERE product_id = $1
`

func (q *Queries) DeleteFavoriteByProductID(ctx context.Context, productID int64) (int64, error) {
	result, err := q.db.ExecContext(ctx, deleteFavoriteByProductID, productID)
	if err != nil {
		return 0, err
	}
	return result.RowsAffected()
}

const getFavoriteByID = `-- name: GetFavoriteByID :one
SELECT id, user_id, product_id, created_at FROM favorites 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetFavoriteByID(ctx context.Context, id int64) (Favorite, error) {
	row := q.db.QueryRowContext(ctx, getFavoriteByID, id)
	var i Favorite
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.ProductID,
		&i.CreatedAt,
	)
	return i, err
}

const listUserFavorites = `-- name: ListUserFavorites :many
SELECT id, user_id, product_id, created_at FROM favorites 
WHERE user_id = $1
ORDER BY id
LIMIT $2
OFFSET $3
`

type ListUserFavoritesParams struct {
	UserID int64 `json:"user_id"`
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

func (q *Queries) ListUserFavorites(ctx context.Context, arg ListUserFavoritesParams) ([]Favorite, error) {
	rows, err := q.db.QueryContext(ctx, listUserFavorites, arg.UserID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Favorite{}
	for rows.Next() {
		var i Favorite
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.ProductID,
			&i.CreatedAt,
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
