package service

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/hisshihi/shop-back/db/sqlc"
)

type Store struct {
	*sqlc.Queries
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{
		db:      db,
		Queries: sqlc.New(db),
	}
}

func (store *Store) execTx(ctx context.Context, fn func(*sqlc.Queries) error) error {
	tx, err := store.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}

	q := sqlc.New(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(); rbErr != nil {
			return fmt.Errorf("tx err: %v, rb err: %v", err, rbErr)
		}
		return err
	}

	return tx.Commit()
}

type DeleteProductTxParams struct {
	ProductID int64
}

type DeleteProductTxResult struct {
	DeleteFavorit int64
	DeleteProduct bool
}

func (store *Store) TransferTxDeleteProduct(ctx context.Context, arg DeleteProductTxParams) (DeleteProductTxResult, error) {
	var result DeleteProductTxResult

	err := store.execTx(ctx, func(q *sqlc.Queries) error {
		var err error

		deleteFavorite, err := q.DeleteFavoriteByProductID(ctx, arg.ProductID)
		if err != nil {
			return fmt.Errorf("ошибка при удалении избранного %w", err)
		}
		result.DeleteFavorit = deleteFavorite

		err = q.DeleteProduct(ctx, arg.ProductID)
		if err != nil {
			return fmt.Errorf("ошибка при удалении товара %w", err)
		}

		result.DeleteProduct = true

		return nil
	})

	return result, err
}

