// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: log.sql

package sqlc

import (
	"context"
	"database/sql"
)

const countLogs = `-- name: CountLogs :one
SELECT COUNT(*) FROM logs
`

func (q *Queries) CountLogs(ctx context.Context) (int64, error) {
	row := q.db.QueryRowContext(ctx, countLogs)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const createLog = `-- name: CreateLog :one
INSERT INTO logs (
  user_id, 
  action
) VALUES (
  $1, $2
)
RETURNING id, user_id, action, created_at
`

type CreateLogParams struct {
	UserID sql.NullInt64 `json:"user_id"`
	Action string        `json:"action"`
}

func (q *Queries) CreateLog(ctx context.Context, arg CreateLogParams) (Log, error) {
	row := q.db.QueryRowContext(ctx, createLog, arg.UserID, arg.Action)
	var i Log
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.Action,
		&i.CreatedAt,
	)
	return i, err
}

const getLogByID = `-- name: GetLogByID :one
SELECT id, user_id, action, created_at FROM logs 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetLogByID(ctx context.Context, id int64) (Log, error) {
	row := q.db.QueryRowContext(ctx, getLogByID, id)
	var i Log
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.Action,
		&i.CreatedAt,
	)
	return i, err
}

const listLogs = `-- name: ListLogs :many
SELECT id, user_id, action, created_at FROM logs 
ORDER BY created_at DESC
LIMIT $1
OFFSET $2
`

type ListLogsParams struct {
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

func (q *Queries) ListLogs(ctx context.Context, arg ListLogsParams) ([]Log, error) {
	rows, err := q.db.QueryContext(ctx, listLogs, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Log{}
	for rows.Next() {
		var i Log
		if err := rows.Scan(
			&i.ID,
			&i.UserID,
			&i.Action,
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
