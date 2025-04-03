package sqlc

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/stretchr/testify/require"
)

func createRandomReview(t *testing.T) Review {
	user := createRandomUser(t)
	product := createRandomProduct(t)
	arg := CreateReviewParams{
		UserID:    user.ID,
		ProductID: product.ID,
		Rating:    int32(gofakeit.Number(1, 5)),
		Comment:   sql.NullString{String: gofakeit.Sentence(10), Valid: true},
	}

	review, err := testQueries.CreateReview(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, review)

	require.Equal(t, arg.UserID, review.UserID)
	require.Equal(t, arg.ProductID, review.ProductID)
	require.Equal(t, arg.Rating, review.Rating)
	require.Equal(t, arg.Comment, review.Comment)
	require.NotZero(t, review.ID)
	require.NotZero(t, review.CreatedAt)

	return review
}
func createReviewByProductID(t *testing.T, productID int64) Review {
	user := createRandomUser(t)
	arg := CreateReviewParams{
		UserID:    user.ID,
		ProductID: productID,
		Rating:    int32(gofakeit.Number(1, 5)),
		Comment:   sql.NullString{String: gofakeit.Sentence(10), Valid: true},
	}

	review, err := testQueries.CreateReview(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, review)

	require.Equal(t, arg.UserID, review.UserID)
	require.Equal(t, arg.ProductID, review.ProductID)
	require.Equal(t, arg.Rating, review.Rating)
	require.Equal(t, arg.Comment, review.Comment)
	require.NotZero(t, review.ID)
	require.NotZero(t, review.CreatedAt)

	return review
}
func TestCreateReview(t *testing.T) {
	createRandomReview(t)
}

func TestGetReviewByID(t *testing.T) {
	review1 := createRandomReview(t)
	review2, err := testQueries.GetReviewByID(context.Background(), review1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, review2)

	require.Equal(t, review1.ID, review2.ID)
	require.Equal(t, review1.UserID, review2.UserID)
	require.Equal(t, review1.ProductID, review2.ProductID)
	require.Equal(t, review1.Rating, review2.Rating)
	require.Equal(t, review1.Comment, review2.Comment)
	require.WithinDuration(t, review1.CreatedAt, review2.CreatedAt, time.Second)
}

func TestListReviews(t *testing.T) {
	product := createRandomProduct(t)
	for range 10 {
		user := createRandomUser(t)
		testQueries.CreateReview(context.Background(), CreateReviewParams{
			UserID:    user.ID,
			ProductID: product.ID,
			Rating:    int32(gofakeit.Number(1, 5)),
			Comment:   sql.NullString{String: gofakeit.Sentence(10), Valid: true},
		})
	}

	arg := ListReviewsParams{
		ProductID: product.ID,
		Limit:     5,
		Offset:    5,
	}

	reviews, err := testQueries.ListReviews(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, reviews, 5)

	for _, review := range reviews {
		require.NotEmpty(t, review)
		require.Equal(t, product.ID, review.ProductID)
	}
}

func TestCountReviews(t *testing.T) {
	product := createRandomProduct(t)
	initialCount, err := testQueries.CountReviews(context.Background(), product.ID)
	require.NoError(t, err)

	for range 10 {
		createReviewByProductID(t, product.ID)
	}

	finalCount, err := testQueries.CountReviews(context.Background(), product.ID)
	require.NoError(t, err)
	require.Equal(t, initialCount+10, finalCount)
}

func TestUpdateReview(t *testing.T) {
	review1 := createRandomReview(t)
	arg := UpdateReviewParams{
		ID:      review1.ID,
		Rating:  int32(gofakeit.Number(1, 5)),
		Comment: sql.NullString{String: gofakeit.Sentence(10), Valid: true},
	}

	review2, err := testQueries.UpdateReview(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, review2)

	require.Equal(t, review1.ID, review2.ID)
	require.Equal(t, arg.Rating, review2.Rating)
	require.Equal(t, arg.Comment, review2.Comment)
	require.WithinDuration(t, review1.CreatedAt, review2.CreatedAt, time.Second)
	require.NotZero(t, review2.UpdatedAt)
}

func TestDeleteReview(t *testing.T) {
	review1 := createRandomReview(t)
	err := testQueries.DeleteReview(context.Background(), review1.ID)
	require.NoError(t, err)

	review2, err := testQueries.GetReviewByID(context.Background(), review1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, review2)
}

func TestGetReviewByUserAndProduct(t *testing.T) {
	review1 := createRandomReview(t)
	arg := GetReviewByUserAndProductParams{
		UserID:    review1.UserID,
		ProductID: review1.ProductID,
	}

	review2, err := testQueries.GetReviewByUserAndProduct(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, review2)

	require.Equal(t, review1.ID, review2.ID)
	require.Equal(t, review1.UserID, review2.UserID)
	require.Equal(t, review1.ProductID, review2.ProductID)
	require.Equal(t, review1.Rating, review2.Rating)
	require.Equal(t, review1.Comment, review2.Comment)
	require.WithinDuration(t, review1.CreatedAt, review2.CreatedAt, time.Second)
}
