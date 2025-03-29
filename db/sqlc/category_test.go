package sqlc

import (
	"context"
	"database/sql"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCreateCategory(t *testing.T) {
	arg := CreateCategoryParams{
		Name: "Наушники",
		Description: sql.NullString{String: "Беспроводные TWS наушники", Valid: true},
	}	

	category, err := testQueries.CreateCategory(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, category)

	require.Equal(t, arg.Name, category.Name)
	require.Equal(t, arg.Description.String, category.Description.String)

	require.NotZero(t, category.ID)
	require.NotZero(t, category.CreatedAt)
}