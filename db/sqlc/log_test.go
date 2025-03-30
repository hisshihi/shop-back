package sqlc

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit"
	"github.com/stretchr/testify/require"
)

func createRandomLog(t *testing.T) Log {
    user := createRandomUser(t)
    arg := CreateLogParams{
        UserID: sql.NullInt64{Int64: user.ID, Valid: true},
        Action: gofakeit.Sentence(5),
    }

    log, err := testQueries.CreateLog(context.Background(), arg)
    require.NoError(t, err)
    require.NotEmpty(t, log)

    require.Equal(t, arg.UserID, log.UserID)
    require.Equal(t, arg.Action, log.Action)
    require.NotZero(t, log.ID)
    require.NotZero(t, log.CreatedAt)

    return log
}

func TestCreateLog(t *testing.T) {
    createRandomLog(t)
}

func TestGetLogByID(t *testing.T) {
    log1 := createRandomLog(t)
    log2, err := testQueries.GetLogByID(context.Background(), log1.ID)
    require.NoError(t, err)
    require.NotEmpty(t, log2)

    require.Equal(t, log1.ID, log2.ID)
    require.Equal(t, log1.UserID, log2.UserID)
    require.Equal(t, log1.Action, log2.Action)
    require.WithinDuration(t, log1.CreatedAt, log2.CreatedAt, time.Second)
}

func TestListLogs(t *testing.T) {
    for range 10 {
        createRandomLog(t)
    }

    arg := ListLogsParams{
        Limit:  5,
        Offset: 5,
    }

    logs, err := testQueries.ListLogs(context.Background(), arg)
    require.NoError(t, err)
    require.Len(t, logs, 5)

    for _, log := range logs {
        require.NotEmpty(t, log)
    }
}