package sqlc

import (
	"context"
	"database/sql"
	"fmt"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/stretchr/testify/require"
)

func createRandomPromotion(t *testing.T) Promotion {
    arg := CreatePromotionParams{
        Name:              gofakeit.Sentence(3),
        DiscountPercentage: fmt.Sprintf("%.2f", gofakeit.Price(10, 50)),
        StartDate:         gofakeit.Date(),
        EndDate:           gofakeit.FutureDate(),
    }

    promotion, err := testQueries.CreatePromotion(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, promotion)

    require.Equal(t, arg.Name, promotion.Name)
    require.Equal(t, arg.DiscountPercentage, promotion.DiscountPercentage)
    require.WithinDuration(t, arg.StartDate, promotion.StartDate, time.Second)
    require.WithinDuration(t, arg.EndDate, promotion.EndDate, time.Second)
    require.NotZero(t, promotion.ID)

    return promotion
}

func TestCreatePromotion(t *testing.T) {
    createRandomPromotion(t)
}

func TestGetPromotionByID(t *testing.T) {
    promotion1 := createRandomPromotion(t)
    promotion2, err := testQueries.GetPromotionByID(context.Background(), promotion1.ID)
    require.NoError(t, err)
    require.NotEmpty(t, promotion2)

    require.Equal(t, promotion1.ID, promotion2.ID)
    require.Equal(t, promotion1.Name, promotion2.Name)
    require.Equal(t, promotion1.DiscountPercentage, promotion2.DiscountPercentage)
    require.WithinDuration(t, promotion1.StartDate, promotion2.StartDate, time.Second)
    require.WithinDuration(t, promotion1.EndDate, promotion2.EndDate, time.Second)
}

func TestListPromotions(t *testing.T) {
    for range 10 {
        createRandomPromotion(t)
    }

    arg := ListPromotionsParams{
        Limit:  5,
        Offset: 5,
    }

    promotions, err := testQueries.ListPromotions(context.Background(), arg)
    require.NoError(t, err)
    require.Len(t, promotions, 5)

    for _, promotion := range promotions {
        require.NotEmpty(t, promotion)
    }
}

func TestCountPromotions(t *testing.T) {
    initialCount, err := testQueries.CountPromotions(context.Background())
    require.NoError(t, err)

    for range 10 {
        createRandomPromotion(t)
    }

    finalCount, err := testQueries.CountPromotions(context.Background())
    require.NoError(t, err)
    require.Equal(t, initialCount+10, finalCount)
}

func TestUpdatePromotion(t *testing.T) {
    promotion1 := createRandomPromotion(t)
    arg := UpdatePromotionParams{
        ID:                promotion1.ID,
        Name:              gofakeit.Sentence(3),
        DiscountPercentage: fmt.Sprintf("%.2f", gofakeit.Price(10, 50)),
        StartDate:         gofakeit.Date(),
        EndDate:           gofakeit.FutureDate(),
    }

    promotion2, err := testQueries.UpdatePromotion(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, promotion2)

    require.Equal(t, promotion1.ID, promotion2.ID)
    require.Equal(t, arg.Name, promotion2.Name)
    require.Equal(t, arg.DiscountPercentage, promotion2.DiscountPercentage)
    require.WithinDuration(t, arg.StartDate, promotion2.StartDate, time.Second)
    require.WithinDuration(t, arg.EndDate, promotion2.EndDate, time.Second)
}

func TestDeletePromotion(t *testing.T) {
    promotion1 := createRandomPromotion(t)
    err := testQueries.DeletePromotion(context.Background(), promotion1.ID)
    require.NoError(t, err)

    promotion2, err := testQueries.GetPromotionByID(context.Background(), promotion1.ID)
    require.Error(t, err)
    require.EqualError(t, err, sql.ErrNoRows.Error())
    require.Empty(t, promotion2)
}