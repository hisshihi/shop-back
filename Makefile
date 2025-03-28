postgres:
	docker run --name shop -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres:17-alpine

createdb:
	docker exec -it shop createdb --username=root --owner=root shop_db

dropdb:
	docker exec -it shop dropdb shop_db

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/shop_db?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/shop_db?sslmode=disable" -verbose down

.PHONY: createdb dropdb postgres migrateup migratedown