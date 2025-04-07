# Официальный образ Go на основе Alpine
FROM golang:1.24-alpine

# Установка клиента PostgreSQL и зависимостей для migrate
RUN apk add --no-cache postgresql-client gcc musl-dev

# Установка утилиты migrate для работы с PostgreSQL
RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Устанавливаем рабочую директорию внутри проекта
WORKDIR /app

# Копируем go.mod и go.sum для установки зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем весь код приложения
COPY . .

COPY ./internal/service/api/dist ./dist

# Собираем приложение
RUN go build -o main ./cmd/main.go

# Запускаем миграции и приложение
CMD sh -c "migrate -path db/migration -database \"postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=disable\" -verbose up && ./main"
