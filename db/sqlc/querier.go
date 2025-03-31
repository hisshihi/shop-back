// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0

package sqlc

import (
	"context"
)

type Querier interface {
	BannedUser(ctx context.Context, id int64) (User, error)
	CountFavorit(ctx context.Context) (int64, error)
	CountOrders(ctx context.Context) (int64, error)
	CountProducts(ctx context.Context) (int64, error)
	CountPromotions(ctx context.Context) (int64, error)
	CountReviews(ctx context.Context) (int64, error)
	CountUsers(ctx context.Context) (int64, error)
	CreateCategory(ctx context.Context, arg CreateCategoryParams) (Category, error)
	CreateFavorite(ctx context.Context, arg CreateFavoriteParams) (Favorite, error)
	CreateLog(ctx context.Context, arg CreateLogParams) (Log, error)
	CreateOrder(ctx context.Context, arg CreateOrderParams) (Order, error)
	CreateOrderItem(ctx context.Context, arg CreateOrderItemParams) (OrderItem, error)
	CreateProduct(ctx context.Context, arg CreateProductParams) (Product, error)
	CreateProductPromotion(ctx context.Context, arg CreateProductPromotionParams) (ProductPromotion, error)
	CreatePromotion(ctx context.Context, arg CreatePromotionParams) (Promotion, error)
	CreateReview(ctx context.Context, arg CreateReviewParams) (Review, error)
	CreateUser(ctx context.Context, arg CreateUserParams) (User, error)
	DeleteCategory(ctx context.Context, id int64) error
	DeleteFavorite(ctx context.Context, id int64) error
	DeleteOrder(ctx context.Context, id int64) error
	DeleteOrderItem(ctx context.Context, id int64) error
	DeleteProduct(ctx context.Context, id int64) error
	DeleteProductPromotion(ctx context.Context, id int64) error
	DeletePromotion(ctx context.Context, id int64) error
	DeleteReview(ctx context.Context, id int64) error
	DeleteUser(ctx context.Context, id int64) error
	GetCategoryByID(ctx context.Context, id int64) (Category, error)
	GetFavoriteByID(ctx context.Context, id int64) (Favorite, error)
	GetLogByID(ctx context.Context, id int64) (Log, error)
	GetOrderByID(ctx context.Context, id int64) (Order, error)
	GetOrderItemByID(ctx context.Context, id int64) (OrderItem, error)
	GetProductByID(ctx context.Context, id int64) (Product, error)
	GetProductPromotionByID(ctx context.Context, id int64) (ProductPromotion, error)
	GetPromotionByID(ctx context.Context, id int64) (Promotion, error)
	GetReviewByID(ctx context.Context, id int64) (Review, error)
	GetUser(ctx context.Context, username string) (User, error)
	GetUserByID(ctx context.Context, id int64) (User, error)
	ListCategories(ctx context.Context, arg ListCategoriesParams) ([]Category, error)
	ListLogs(ctx context.Context, arg ListLogsParams) ([]Log, error)
	ListOrderItems(ctx context.Context, orderID int64) ([]OrderItem, error)
	ListOrders(ctx context.Context, arg ListOrdersParams) ([]Order, error)
	ListProductPromotions(ctx context.Context, productID int64) ([]ProductPromotion, error)
	ListProducts(ctx context.Context, arg ListProductsParams) ([]Product, error)
	ListPromotions(ctx context.Context, arg ListPromotionsParams) ([]Promotion, error)
	ListReviews(ctx context.Context, arg ListReviewsParams) ([]Review, error)
	ListUserFavorites(ctx context.Context, arg ListUserFavoritesParams) ([]Favorite, error)
	ListUsers(ctx context.Context, arg ListUsersParams) ([]User, error)
	UpdateCategory(ctx context.Context, arg UpdateCategoryParams) (Category, error)
	UpdateOrderItem(ctx context.Context, arg UpdateOrderItemParams) (OrderItem, error)
	UpdateOrderStatus(ctx context.Context, arg UpdateOrderStatusParams) (Order, error)
	UpdateProduct(ctx context.Context, arg UpdateProductParams) (Product, error)
	UpdatePromotion(ctx context.Context, arg UpdatePromotionParams) (Promotion, error)
	UpdateReview(ctx context.Context, arg UpdateReviewParams) (Review, error)
	UpdateUser(ctx context.Context, arg UpdateUserParams) (User, error)
}

var _ Querier = (*Queries)(nil)
