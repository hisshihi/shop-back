package sqlc

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit"
	"github.com/stretchr/testify/require"
)

func createRandomCategory(t *testing.T) Category {
    arg := CreateCategoryParams{
        Name:        gofakeit.Sentence(3),
        Description: sql.NullString{String: gofakeit.Sentence(10), Valid: true},
    }

    category, err := testQueries.CreateCategory(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, category)

    require.Equal(t, arg.Name, category.Name)
    require.Equal(t, arg.Description, category.Description)
    require.NotZero(t, category.ID)
    require.NotZero(t, category.CreatedAt)

    return category
}

func TestCreateCategory(t *testing.T) {
    createRandomCategory(t)
}

func TestGetCategoryByID(t *testing.T) {
    category1 := createRandomCategory(t)
    category2, err := testQueries.GetCategoryByID(context.Background(), category1.ID)
    require.NoError(t, err)
    require.NotEmpty(t, category2)

    require.Equal(t, category1.ID, category2.ID)
    require.Equal(t, category1.Name, category2.Name)
    require.Equal(t, category1.Description, category2.Description)
    require.WithinDuration(t, category1.CreatedAt, category2.CreatedAt, time.Second)
}

func TestListCategories(t *testing.T) {
    for range 10 {
        createRandomCategory(t)
    }

    arg := ListCategoriesParams{
        Limit:  5,
        Offset: 5,
    }

    categories, err := testQueries.ListCategories(context.Background(), arg)
    require.NoError(t, err)
    require.Len(t, categories, 5)

    for _, category := range categories {
        require.NotEmpty(t, category)
    }
}

func TestUpdateCategory(t *testing.T) {
    category1 := createRandomCategory(t)

    arg := UpdateCategoryParams{
        ID:          category1.ID,
        Name:        gofakeit.Sentence(3),
        Description: sql.NullString{String: gofakeit.Sentence(10), Valid: true},
    }

    category2, err := testQueries.UpdateCategory(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, category2)

    require.Equal(t, category1.ID, category2.ID)
    require.Equal(t, arg.Name, category2.Name)
    require.Equal(t, arg.Description, category2.Description)
    require.WithinDuration(t, category1.CreatedAt, category2.CreatedAt, time.Second)
    require.NotZero(t, category2.UpdatedAt)
}

func TestDeleteCategory(t *testing.T) {
    category1 := createRandomCategory(t)
    err := testQueries.DeleteCategory(context.Background(), category1.ID)
    require.NoError(t, err)

    category2, err := testQueries.GetCategoryByID(context.Background(), category1.ID)
    require.Error(t, err)
    require.EqualError(t, err, sql.ErrNoRows.Error())
    require.Empty(t, category2)
}