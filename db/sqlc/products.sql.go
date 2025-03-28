// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: products.sql

package sqlc

import (
	"context"
)

const createProduct = `-- name: CreateProduct :one
INSERT INTO products (
  category_id, 
  name, 
  description, 
  price, 
  stock
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING id, category_id, name, description, price, stock, created_at, updated_at
`

type CreateProductParams struct {
	CategoryID  int64  `json:"category_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Price       string `json:"price"`
	Stock       int32  `json:"stock"`
}

func (q *Queries) CreateProduct(ctx context.Context, arg CreateProductParams) (Product, error) {
	row := q.db.QueryRowContext(ctx, createProduct,
		arg.CategoryID,
		arg.Name,
		arg.Description,
		arg.Price,
		arg.Stock,
	)
	var i Product
	err := row.Scan(
		&i.ID,
		&i.CategoryID,
		&i.Name,
		&i.Description,
		&i.Price,
		&i.Stock,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteProduct = `-- name: DeleteProduct :exec
DELETE FROM products 
WHERE id = $1
`

func (q *Queries) DeleteProduct(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteProduct, id)
	return err
}

const getProductByID = `-- name: GetProductByID :one
SELECT id, category_id, name, description, price, stock, created_at, updated_at FROM products 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetProductByID(ctx context.Context, id int64) (Product, error) {
	row := q.db.QueryRowContext(ctx, getProductByID, id)
	var i Product
	err := row.Scan(
		&i.ID,
		&i.CategoryID,
		&i.Name,
		&i.Description,
		&i.Price,
		&i.Stock,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const listProducts = `-- name: ListProducts :many
SELECT id, category_id, name, description, price, stock, created_at, updated_at FROM products 
ORDER BY id
LIMIT $1
OFFSET $2
`

type ListProductsParams struct {
	Limit  int64 `json:"limit"`
	Offset int64 `json:"offset"`
}

func (q *Queries) ListProducts(ctx context.Context, arg ListProductsParams) ([]Product, error) {
	rows, err := q.db.QueryContext(ctx, listProducts, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Product{}
	for rows.Next() {
		var i Product
		if err := rows.Scan(
			&i.ID,
			&i.CategoryID,
			&i.Name,
			&i.Description,
			&i.Price,
			&i.Stock,
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

const updateProduct = `-- name: UpdateProduct :one
UPDATE products
SET 
  category_id = $2,
  name = $3,
  description = $4,
  price = $5,
  stock = $6,
  updated_at = NOW()
WHERE id = $1
RETURNING id, category_id, name, description, price, stock, created_at, updated_at
`

type UpdateProductParams struct {
	ID          int64  `json:"id"`
	CategoryID  int64  `json:"category_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Price       string `json:"price"`
	Stock       int32  `json:"stock"`
}

func (q *Queries) UpdateProduct(ctx context.Context, arg UpdateProductParams) (Product, error) {
	row := q.db.QueryRowContext(ctx, updateProduct,
		arg.ID,
		arg.CategoryID,
		arg.Name,
		arg.Description,
		arg.Price,
		arg.Stock,
	)
	var i Product
	err := row.Scan(
		&i.ID,
		&i.CategoryID,
		&i.Name,
		&i.Description,
		&i.Price,
		&i.Stock,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
