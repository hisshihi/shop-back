// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0

package sqlc

import (
	"context"
)

type Querier interface {
	BannedUser(ctx context.Context, arg BannedUserParams) (User, error)
	CountCategory(ctx context.Context) (int64, error)
	CountFavorit(ctx context.Context) (int64, error)
	CountFavoritForUser(ctx context.Context, userID int64) (int64, error)
	CountHelpMessage(ctx context.Context) (int64, error)
	CountLogs(ctx context.Context) (int64, error)
	CountOrderByUserID(ctx context.Context, userID int64) (int64, error)
	CountOrders(ctx context.Context) (int64, error)
	CountProducts(ctx context.Context) (int64, error)
	CountPromotions(ctx context.Context) (int64, error)
	CountReviews(ctx context.Context, productID int64) (int64, error)
	CountUsers(ctx context.Context) (int64, error)
	CreateCartItem(ctx context.Context, arg CreateCartItemParams) (CartItem, error)
	CreateCategory(ctx context.Context, arg CreateCategoryParams) (Category, error)
	CreateFavorite(ctx context.Context, arg CreateFavoriteParams) (Favorite, error)
	CreateHelpMessage(ctx context.Context, arg CreateHelpMessageParams) (Help, error)
	CreateLog(ctx context.Context, arg CreateLogParams) (Log, error)
	CreateOrder(ctx context.Context, arg CreateOrderParams) (Order, error)
	CreateOrderItem(ctx context.Context, arg CreateOrderItemParams) (OrderItem, error)
	CreateProduct(ctx context.Context, arg CreateProductParams) (Product, error)
	CreateProductPromotion(ctx context.Context, arg CreateProductPromotionParams) (ProductPromotion, error)
	CreatePromotion(ctx context.Context, arg CreatePromotionParams) (Promotion, error)
	CreateReview(ctx context.Context, arg CreateReviewParams) (Review, error)
	CreateUser(ctx context.Context, arg CreateUserParams) (User, error)
	DeleteAllCartItemByUserID(ctx context.Context, userID int64) error
	DeleteCartItemByIDAndUserID(ctx context.Context, arg DeleteCartItemByIDAndUserIDParams) error
	DeleteCategory(ctx context.Context, id int64) error
	DeleteFavoritForID(ctx context.Context, arg DeleteFavoritForIDParams) error
	DeleteFavorite(ctx context.Context, id int64) error
	DeleteFavoriteByProductID(ctx context.Context, productID int64) (int64, error)
	DeleteFavoritesByCategoryID(ctx context.Context, categoryID int64) (int64, error)
	DeleteHelpMessage(ctx context.Context, id int64) error
	DeleteOrder(ctx context.Context, id int64) error
	DeleteOrderItem(ctx context.Context, id int64) error
	DeleteOrderItemByOrderID(ctx context.Context, orderID int64) (int64, error)
	DeleteProduct(ctx context.Context, id int64) error
	DeleteProductByCategoryID(ctx context.Context, categoryID int64) (int64, error)
	DeleteProductPromotion(ctx context.Context, id int64) error
	DeletePromotion(ctx context.Context, id int64) error
	DeleteReview(ctx context.Context, id int64) error
	DeleteUser(ctx context.Context, id int64) error
	GetAverageRatingForProvider(ctx context.Context, productID int64) (GetAverageRatingForProviderRow, error)
	GetCartItemByID(ctx context.Context, id int64) (CartItem, error)
	GetCategoryByID(ctx context.Context, id int64) (Category, error)
	GetFavoriteByID(ctx context.Context, id int64) (Favorite, error)
	GetHelpMessageByID(ctx context.Context, id int64) (Help, error)
	GetLogByID(ctx context.Context, id int64) (Log, error)
	GetOrderByID(ctx context.Context, id int64) (Order, error)
	GetOrderItemByID(ctx context.Context, id int64) (OrderItem, error)
	GetOrderWithItems(ctx context.Context, id int64) (GetOrderWithItemsRow, error)
	GetProductByCategoryID(ctx context.Context, categoryID int64) ([]int64, error)
	GetProductByID(ctx context.Context, id int64) (Product, error)
	GetProductPromotionByID(ctx context.Context, id int64) (ProductPromotion, error)
	GetPromotionByID(ctx context.Context, id int64) (Promotion, error)
	GetReviewByID(ctx context.Context, id int64) (Review, error)
	GetReviewByProductID(ctx context.Context, arg GetReviewByProductIDParams) ([]GetReviewByProductIDRow, error)
	GetReviewByUserAndProduct(ctx context.Context, arg GetReviewByUserAndProductParams) (Review, error)
	GetUser(ctx context.Context, username string) (User, error)
	GetUserByID(ctx context.Context, id int64) (User, error)
	HasUserPurchasedProduct(ctx context.Context, arg HasUserPurchasedProductParams) (bool, error)
	ListCartItemByUserID(ctx context.Context, userID int64) ([]ListCartItemByUserIDRow, error)
	ListCategories(ctx context.Context, arg ListCategoriesParams) ([]Category, error)
	ListCategoriesAll(ctx context.Context) ([]Category, error)
	ListHelpMesage(ctx context.Context, arg ListHelpMesageParams) ([]Help, error)
	ListLogs(ctx context.Context, arg ListLogsParams) ([]Log, error)
	ListOrderItems(ctx context.Context, orderID int64) ([]OrderItem, error)
	ListOrders(ctx context.Context, arg ListOrdersParams) ([]Order, error)
	ListOrdersByUserID(ctx context.Context, arg ListOrdersByUserIDParams) ([]Order, error)
	ListOrdersByUserIDWithItems(ctx context.Context, arg ListOrdersByUserIDWithItemsParams) ([]ListOrdersByUserIDWithItemsRow, error)
	ListOrdersWithItems(ctx context.Context, arg ListOrdersWithItemsParams) ([]ListOrdersWithItemsRow, error)
	ListProductPromotions(ctx context.Context, productID int64) ([]ProductPromotion, error)
	ListProducts(ctx context.Context, arg ListProductsParams) ([]ListProductsRow, error)
	ListPromotions(ctx context.Context, arg ListPromotionsParams) ([]Promotion, error)
	ListReviews(ctx context.Context, arg ListReviewsParams) ([]Review, error)
	ListUserFavorites(ctx context.Context, userID int64) ([]Favorite, error)
	ListUsers(ctx context.Context, arg ListUsersParams) ([]User, error)
	UpdateCategory(ctx context.Context, arg UpdateCategoryParams) (Category, error)
	UpdateOrderItem(ctx context.Context, arg UpdateOrderItemParams) (OrderItem, error)
	UpdateOrderStatus(ctx context.Context, arg UpdateOrderStatusParams) (Order, error)
	UpdateOrderStatusWithItems(ctx context.Context, arg UpdateOrderStatusWithItemsParams) (UpdateOrderStatusWithItemsRow, error)
	UpdatePassword(ctx context.Context, arg UpdatePasswordParams) error
	UpdateProduct(ctx context.Context, arg UpdateProductParams) (Product, error)
	UpdatePromotion(ctx context.Context, arg UpdatePromotionParams) (Promotion, error)
	UpdateQuantityCartItem(ctx context.Context, arg UpdateQuantityCartItemParams) (CartItem, error)
	UpdateReview(ctx context.Context, arg UpdateReviewParams) (Review, error)
	UpdateUser(ctx context.Context, arg UpdateUserParams) (User, error)
}

var _ Querier = (*Queries)(nil)
