package sqlc

import (
	"context"
	"database/sql"
	"testing"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/stretchr/testify/require"
)

func createRandomHelpMessage(t *testing.T) Help {
	arg := CreateHelpMessageParams{
		Fullname: gofakeit.Username(),
		Email:    gofakeit.Email(),
		Topic:    gofakeit.Sentence(10),
		Message:  gofakeit.Sentence(30),
	}

	help, err := testQueries.CreateHelpMessage(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, help)

	require.Equal(t, arg.Email, help.Email)
	require.Equal(t, arg.Topic, help.Topic)
	require.Equal(t, arg.Message, help.Message)
	require.NotZero(t, help.ID)
	require.NotZero(t, help.CreatedAt)

	return help
}

func TestCreateHelp(t *testing.T) {
	createRandomHelpMessage(t)
}

func TestListHelpMessage(t *testing.T) {
	for range 10 {
		createRandomHelpMessage(t)
	}

	arg := ListHelpMesageParams{
		Limit:  5,
		Offset: 5,
	}

	helps, err := testQueries.ListHelpMesage(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, helps, 5)

	for _, help := range helps {
		require.NotEmpty(t, help)
	}
}

func TestDeleteHelpMessage(t *testing.T) {
	help1 := createRandomHelpMessage(t)
	err := testQueries.DeleteHelpMessage(context.Background(), help1.ID)
	require.NoError(t, err)

	help2, err := testQueries.GetHelpMessageByID(context.Background(), help1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, help2)
}
