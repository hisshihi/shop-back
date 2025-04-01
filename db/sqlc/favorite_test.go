package sqlc

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func createRandomFavorite(t *testing.T) Favorite {
	user := createRandomUser(t)
	product := createRandomProduct(t)

	arg := CreateFavoriteParams{
		UserID:    user.ID,
		ProductID: product.ID,
	}

	favorite, err := testQueries.CreateFavorite(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, favorite)

	require.Equal(t, arg.UserID, favorite.UserID)
	require.Equal(t, arg.ProductID, favorite.ProductID)
	require.NotZero(t, favorite.ID)
	require.NotZero(t, favorite.CreatedAt)

	return favorite
}

func TestCreateFavorite(t *testing.T) {
	createRandomFavorite(t)
}

func TestGetFavoriteByID(t *testing.T) {
	favorite1 := createRandomFavorite(t)
	favorite2, err := testQueries.GetFavoriteByID(context.Background(), favorite1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, favorite2)

	require.Equal(t, favorite1.ID, favorite2.ID)
	require.Equal(t, favorite1.UserID, favorite2.UserID)
	require.Equal(t, favorite1.ProductID, favorite2.ProductID)
	require.WithinDuration(t, favorite1.CreatedAt, favorite2.CreatedAt, time.Second)
}

func TestListUserFavorites(t *testing.T) {
	user := createRandomUser(t)
	for range 10 {
		product := createRandomProduct(t)
		testQueries.CreateFavorite(context.Background(), CreateFavoriteParams{
			UserID:    user.ID,
			ProductID: product.ID,
		})
	}

	arg := ListUserFavoritesParams{
		UserID: user.ID,
		Limit:  5,
		Offset: 5,
	}

	favorites, err := testQueries.ListUserFavorites(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, favorites, 5)

	for _, favorite := range favorites {
		require.NotEmpty(t, favorite)
		require.Equal(t, user.ID, favorite.UserID)
	}
}

func TestCountFavorit(t *testing.T) {
	initialCount, err := testQueries.CountFavorit(context.Background())
	require.NoError(t, err)

	for range 10 {
		createRandomFavorite(t)
	}

	finalCount, err := testQueries.CountFavorit(context.Background())
	require.NoError(t, err)
	require.Equal(t, initialCount+10, finalCount)
}

func TestDeleteFavorite(t *testing.T) {
	favorite1 := createRandomFavorite(t)
	err := testQueries.DeleteFavorite(context.Background(), favorite1.ID)
	require.NoError(t, err)

	favorite2, err := testQueries.GetFavoriteByID(context.Background(), favorite1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, favorite2)
}

func createRandomFavoriteForProduct(t *testing.T, productID int64) Favorite {
	arg := CreateFavoriteParams{
		UserID:    createRandomUser(t).ID,
		ProductID: productID,
	}

	favorite, err := testQueries.CreateFavorite(context.Background(), arg)
	require.NoError(t, err)
	return favorite
}

func TestDeleteFavoriteByProductID(t *testing.T) {
	product := createRandomProduct(t)
	favorite := createRandomFavoriteForProduct(t, product.ID)

	deleteRows, err := testQueries.DeleteFavoriteByProductID(context.Background(), product.ID)
	require.NoError(t, err)
	require.Equal(t, int64(1), deleteRows)

	_, err = testQueries.GetFavoriteByID(context.Background(), favorite.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
}
