package sqlc

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/hisshihi/shop-back/pkg/util"
	"github.com/stretchr/testify/require"
)

func createRandomUser(t *testing.T) User {
	hashedPassword, err := util.HashPassword(gofakeit.Password(true, true, true, true, false, 6))
	require.NoError(t, err)
	arg := CreateUserParams{
		Username: gofakeit.Username(),
		Email:    gofakeit.Email(),
		Fullname: gofakeit.Name(),
		Password: hashedPassword,
		Role:     UserRoleUser,
		Phone:    gofakeit.Phone(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user)

	require.Equal(t, arg.Username, user.Username)
	require.Equal(t, arg.Email, user.Email)
	require.Equal(t, arg.Fullname, user.Fullname)
	require.Equal(t, arg.Password, user.Password)
	require.Equal(t, arg.Role, user.Role)
	require.Equal(t, arg.Phone, user.Phone)

	require.NotZero(t, user.ID)
	require.NotZero(t, user.CreatedAt)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t)
}

func TestGetUserByID(t *testing.T) {
	user1 := createRandomUser(t)
	user2, err := testQueries.GetUserByID(context.Background(), user1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.ID, user2.ID)
	require.Equal(t, user1.Username, user2.Username)
	require.Equal(t, user1.Email, user2.Email)
	require.Equal(t, user1.Fullname, user2.Fullname)
	require.Equal(t, user1.Password, user2.Password)
	require.Equal(t, user1.Role, user2.Role)
	require.Equal(t, user1.Phone, user2.Phone)
	require.WithinDuration(t, user1.CreatedAt, user2.CreatedAt, time.Second)
}

func TestUpdateUser(t *testing.T) {
	user1 := createRandomUser(t)

	hashedPassword, err := util.HashPassword(gofakeit.Password(true, true, true, true, false, 6))
	require.NoError(t, err)

	arg := UpdateUserParams{
		ID:       user1.ID,
		Username: gofakeit.Username(),
		Fullname: gofakeit.Name(),
		Email:    gofakeit.Email(),
		Password: hashedPassword,
		Phone:    gofakeit.Phone(),
	}

	user2, err := testQueries.UpdateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.ID, user2.ID)
	require.Equal(t, arg.Username, user2.Username)
	require.Equal(t, arg.Email, user2.Email)
	require.Equal(t, arg.Fullname, user2.Fullname)
	require.Equal(t, arg.Password, user2.Password)
	require.Equal(t, arg.Phone, user2.Phone)
	require.WithinDuration(t, user1.CreatedAt, user2.CreatedAt, time.Second)
}

func TestDeleteUser(t *testing.T) {
	user1 := createRandomUser(t)
	err := testQueries.DeleteUser(context.Background(), user1.ID)
	require.NoError(t, err)

	user2, err := testQueries.GetUserByID(context.Background(), user1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, user2)
}

func TestListAccount(t *testing.T) {
	for range 10 {
		createRandomUser(t)
	}

	arg := ListUsersParams{
		Limit:  5,
		Offset: 5,
	}

	users, err := testQueries.ListUsers(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, users, 5)

	for _, user := range users {
		require.NotEmpty(t, user)
	}
}

func TestCountUsers(t *testing.T) {
	initialCount, err := testQueries.CountUsers(context.Background())
	require.NoError(t, err, "Не удалось получить исходное кол-во пользователей")

	for range 10 {
		createRandomUser(t)
	}

	finalCount, err := testQueries.CountUsers(context.Background())
	require.NoError(t, err)

	require.Equal(t, initialCount+10, finalCount)
}
