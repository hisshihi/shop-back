package sqlc

import (
	"context"
	"database/sql"
	"testing"

	"github.com/stretchr/testify/require"
)

func createRandomProductPromotion(t *testing.T) ProductPromotion {
    product := createRandomProduct(t)
    promotion := createRandomPromotion(t)
    arg := CreateProductPromotionParams{
        ProductID:   product.ID,
        PromotionID: promotion.ID,
    }

    pp, err := testQueries.CreateProductPromotion(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, pp)

    require.Equal(t, arg.ProductID, pp.ProductID)
    require.Equal(t, arg.PromotionID, pp.PromotionID)
    require.NotZero(t, pp.ID)

    return pp
}

func TestCreateProductPromotion(t *testing.T) {
    createRandomProductPromotion(t)
}

func TestGetProductPromotionByID(t *testing.T) {
    pp1 := createRandomProductPromotion(t)
    pp2, err := testQueries.GetProductPromotionByID(context.Background(), pp1.ID)
    require.NoError(t, err)
    require.NotEmpty(t, pp2)

    require.Equal(t, pp1.ID, pp2.ID)
    require.Equal(t, pp1.ProductID, pp2.ProductID)
    require.Equal(t, pp1.PromotionID, pp2.PromotionID)
}

func TestListProductPromotions(t *testing.T) {
    product := createRandomProduct(t)
    for range 10 {
        promotion := createRandomPromotion(t)
        testQueries.CreateProductPromotion(context.Background(), CreateProductPromotionParams{
            ProductID:   product.ID,
            PromotionID: promotion.ID,
        })
    }

    pps, err := testQueries.ListProductPromotions(context.Background(), product.ID)
    require.NoError(t, err)
    require.Len(t, pps, 10)

    for _, pp := range pps {
        require.NotEmpty(t, pp)
        require.Equal(t, product.ID, pp.ProductID)
    }
}

func TestDeleteProductPromotion(t *testing.T) {
    pp1 := createRandomProductPromotion(t)
    err := testQueries.DeleteProductPromotion(context.Background(), pp1.ID)
    require.NoError(t, err)

    pp2, err := testQueries.GetProductPromotionByID(context.Background(), pp1.ID)
    require.Error(t, err)
    require.EqualError(t, err, sql.ErrNoRows.Error())
    require.Empty(t, pp2)
}