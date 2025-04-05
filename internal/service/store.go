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
	DeleteFavorits int64
}

func (store *Store) TransferTxDeleteProduct(ctx context.Context, arg DeleteProductTxParams) (DeleteProductTxResult, error) {
	var result DeleteProductTxResult

	err := store.execTx(ctx, func(q *sqlc.Queries) error {
		var err error

		deleteFavorite, err := q.DeleteFavoriteByProductID(ctx, arg.ProductID)
		if err != nil {
			return fmt.Errorf("ошибка при удалении избранного %w", err)
		}
		result.DeleteFavorits = deleteFavorite

		err = q.DeleteProduct(ctx, arg.ProductID)
		if err != nil {
			return fmt.Errorf("ошибка при удалении товара %w", err)
		}

		return nil
	})

	return result, err
}

type DeleteOrderTxParams struct {
	OrderID int64
}

type DeleteOrderTxResult struct {
	DeleteOrderOrderItem int64
	DeleteOrder          bool
}

func (store *Store) TransferTxDeleteOrder(ctx context.Context, arg DeleteOrderTxParams) (DeleteOrderTxResult, error) {
	var result DeleteOrderTxResult

	err := store.execTx(ctx, func(q *sqlc.Queries) error {
		var err error

		deleteOrderItem, err := q.DeleteOrderItemByOrderID(ctx, arg.OrderID)
		if err != nil {
			return fmt.Errorf("ошибка при твоаров заказа %w", err)
		}
		result.DeleteOrderOrderItem = deleteOrderItem

		err = q.DeleteOrder(ctx, arg.OrderID)
		if err != nil {
			return fmt.Errorf("ошибка при удалении заказа %w", err)
		}

		result.DeleteOrder = true

		return nil
	})

	return result, err
}

type DeleteCategoryTxParams struct {
	Category int64
}

type DeleteCategoryTxResult struct {
	DeleteProducts int64
	DeleteFavotits int64
}

func (store *Store) TransferTxDeleteCategory(ctx context.Context, arg DeleteCategoryTxParams) (DeleteCategoryTxResult, error) {
	var result DeleteCategoryTxResult
	err := store.execTx(ctx, func(q *sqlc.Queries) error {
		var err error

		favoritesCount, err := q.DeleteFavoritesByCategoryID(ctx, arg.Category)
		if err != nil {
			return fmt.Errorf("ошибка удаления избранного %w", err)
		}
		result.DeleteFavotits = favoritesCount

		productsCount, err := q.DeleteProductByCategoryID(ctx, arg.Category)
		if err != nil {
			fmt.Errorf("ошибка удаления товара %w", err)
		}
		result.DeleteProducts = productsCount

		err = q.DeleteCategory(ctx, arg.Category)
		if err != nil {
			fmt.Errorf("ошибка удаления категории %w", err)
		}

		return nil
	})

	return result, err
}

type OrderItemTxRequest struct {
	ProductID int64  `json:"product_id" binding:"required,min=1"`
	Quantity  int32  `json:"quantity" binding:"required,min=1"`
	Price     string `json:"price" binding:"required"`
}

// Транзакия для создания заказа и товаров в заказе
func (store *Store) CreateOrderTx(ctx context.Context, arg sqlc.CreateOrderParams, items []OrderItemTxRequest) (sqlc.Order, error) {
	var order sqlc.Order

	err := store.execTx(ctx, func(q *sqlc.Queries) error {
		// Создание заказа
		createOrder, err := q.CreateOrder(ctx, arg)
		if err != nil {
			return err
		}

		order = createOrder

		// Добавляем товары
		for _, item := range items {
			// Проверка, существует ли заказ
			_, err := q.GetProductByID(ctx, item.ProductID)
			if err != nil {
				return fmt.Errorf("товар не существует %w", err)
			}

			// Создание позиций заказка
			_, err = q.CreateOrderItem(ctx, sqlc.CreateOrderItemParams{
				OrderID:   order.ID,
				ProductID: item.ProductID,
				Quantity:  item.Quantity,
				Price:     item.Price,
			})
			if err != nil {
				return err
			}
		}

		// Удаление товаров из корзины после создания заказа
		err = q.DeleteAllCartItemByUserID(ctx, order.UserID)
		if err != nil {
			return fmt.Errorf("не удалось очистить корзину %w", err)
		}
		return nil
	})

	return order, err
}
