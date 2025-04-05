-- Миграция Вверх (Создание схемы)
-- Версия: 1

-- +migrate Up
BEGIN;

-- Создание пользовательских типов ENUM
CREATE TYPE "user_role" AS ENUM (
  'admin',
  'user'
);

CREATE TYPE "order_status" AS ENUM (
  'created',
  'pending',
  'processed',
  'delivered',
  'canceled'
);

-- Создание таблиц
CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "username" varchar(255) UNIQUE NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "fullname" varchar(255) NOT NULL,
  "password" varchar(255) NOT NULL, -- Должен быть хешированным
  "role" user_role NOT NULL DEFAULT 'user',
  "phone" varchar(255) NOT NULL UNIQUE,
  "is_banned" boolean NOT NULL DEFAULT false,
  "bonus_points" integer NOT NULL DEFAULT 0 CHECK (bonus_points >= 0),
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "categories" (
  "id" bigserial PRIMARY KEY,
  "name" varchar(255) UNIQUE NOT NULL,
  "description" text,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "products" (
  "id" bigserial PRIMARY KEY,
  "category_id" bigint NOT NULL,
  "name" varchar(255) NOT NULL,
  "description" text NOT NULL,
  "price" decimal(10,2) NOT NULL CHECK (price >= 0),
  "stock" integer NOT NULL CHECK (stock >= 0),
  "photo_url" bytea, -- Изменен тип на text для хранения URL или пути к файлу
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "cart_items" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" integer NOT NULL CHECK (quantity > 0),
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
  -- Уникальный индекс будет создан ниже
);

CREATE TABLE "help" (
  "id" bigserial PRIMARY KEY,
  "email" varchar(255) NOT NULL,
  "topic" varchar(255) NOT NULL,
  "message" varchar(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "orders" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "total_amount" decimal(10,2) NOT NULL CHECK (total_amount >= 0),
  "status" order_status NOT NULL DEFAULT 'created',
  "payment_method" varchar(50) NOT NULL, -- Рекомендуется ENUM или отдельная таблица
  "delivery_address" text NOT NULL, -- Добавлено поле адреса доставки
  "delivery_status" varchar(50), -- Рекомендуется ENUM или отдельная таблица
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "order_items" (
  "id" bigserial PRIMARY KEY,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" integer NOT NULL CHECK (quantity > 0),
  "price" decimal(10,2) NOT NULL CHECK (price >= 0), -- Цена за единицу товара на момент заказа
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "reviews" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "rating" integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  "comment" text,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
  -- Уникальное ограничение будет создано ниже
);

CREATE TABLE "favorites" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  UNIQUE ("user_id", "product_id") -- Добавлено ограничение уникальности сразу
);

CREATE TABLE "promotions" (
  "id" bigserial PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "description" text, -- Добавлено описание
  "discount_percentage" decimal(5,2) NOT NULL CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
  "start_date" timestamptz NOT NULL,
  "end_date" timestamptz NOT NULL,
  "is_active" boolean NOT NULL DEFAULT true, -- Добавлен флаг активности
  CHECK (end_date > start_date) -- Проверка корректности дат
);

CREATE TABLE "product_promotions" (
  "id" bigserial PRIMARY KEY,
  "product_id" bigint NOT NULL,
  "promotion_id" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()), -- Добавлено поле created_at
  UNIQUE ("product_id", "promotion_id") -- Гарантирует, что продукт не связан с одной акцией дважды
);

CREATE TABLE "logs" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint, -- Может быть NULL для системных действий
  "action" varchar(255) NOT NULL,
  "details" jsonb, -- Добавлено поле для деталей в формате JSONB
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

-- Создание индексов
-- Индексы для часто используемых полей поиска и фильтрации
CREATE INDEX ON "users" ("email");
CREATE INDEX ON "users" ("username");
CREATE INDEX ON "users" ("created_at");
CREATE INDEX ON "users" ("is_banned");

CREATE INDEX ON "products" ("name");
CREATE INDEX ON "products" ("category_id");
CREATE INDEX ON "products" ("price"); -- Индекс по цене для сортировки/фильтрации

CREATE INDEX ON "cart_items" ("user_id");
CREATE INDEX ON "cart_items" ("product_id");
CREATE INDEX ON "cart_items" ("created_at");
CREATE UNIQUE INDEX "unique_user_product_cart" ON "cart_items" ("user_id", "product_id"); -- Уникальный индекс

CREATE INDEX ON "orders" ("user_id");
CREATE INDEX ON "orders" ("created_at");
CREATE INDEX ON "orders" ("status");
CREATE INDEX ON "orders" ("delivery_status");

CREATE INDEX ON "order_items" ("order_id");
CREATE INDEX ON "order_items" ("product_id");

CREATE INDEX ON "reviews" ("product_id");
CREATE INDEX ON "reviews" ("user_id");
CREATE INDEX ON "reviews" ("rating");
CREATE INDEX ON "reviews" ("created_at");

CREATE INDEX ON "favorites" ("user_id");
CREATE INDEX ON "favorites" ("product_id");

CREATE INDEX ON "promotions" ("start_date");
CREATE INDEX ON "promotions" ("end_date");
CREATE INDEX ON "promotions" ("discount_percentage");
CREATE INDEX ON "promotions" ("is_active");

CREATE INDEX ON "product_promotions" ("product_id");
CREATE INDEX ON "product_promotions" ("promotion_id");
CREATE INDEX ON "product_promotions" ("created_at");

CREATE INDEX ON "logs" ("created_at");
CREATE INDEX ON "logs" ("user_id"); -- Индекс по user_id в логах
CREATE INDEX ON "logs" ("action"); -- Индекс по действию в логах

-- Добавление комментариев
COMMENT ON COLUMN "users"."password" IS 'Хешированный пароль';
COMMENT ON COLUMN "users"."role" IS 'Роль пользователя (user или admin)';
COMMENT ON COLUMN "users"."bonus_points" IS 'Накопительные бонусные баллы пользователя';
COMMENT ON COLUMN "products"."photo_url" IS 'URL или путь к фотографии товара';
COMMENT ON COLUMN "orders"."total_amount" IS 'Общая сумма заказа с учетом скидок и бонусов';
COMMENT ON COLUMN "orders"."status" IS 'Текущий статус заказа (created, pending, processed, delivered, canceled)';
COMMENT ON COLUMN "orders"."payment_method" IS 'Выбранный способ оплаты (например, card, cash, online)';
COMMENT ON COLUMN "orders"."delivery_address" IS 'Полный адрес доставки заказа';
COMMENT ON COLUMN "order_items"."price" IS 'Цена за единицу товара на момент оформления заказа';
COMMENT ON COLUMN "reviews"."rating" IS 'Оценка товара пользователем по шкале от 1 до 5';
COMMENT ON COLUMN "promotions"."discount_percentage" IS 'Процент скидки, предоставляемый акцией';
COMMENT ON COLUMN "logs"."user_id" IS 'ID пользователя, выполнившего действие (NULL для системных)';
COMMENT ON COLUMN "logs"."action" IS 'Краткое описание выполненного действия (например, user_login, product_added)';
COMMENT ON COLUMN "logs"."details" IS 'Дополнительные детали действия в формате JSONB';

-- Добавление внешних ключей
ALTER TABLE "products" ADD CONSTRAINT "product_categories_fk" FOREIGN KEY ("category_id") REFERENCES "categories" ("id") ON DELETE RESTRICT; -- Запретить удаление категории, если есть товары

ALTER TABLE "cart_items" ADD CONSTRAINT "cart_users_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE; -- Удалить записи корзины при удалении пользователя
ALTER TABLE "cart_items" ADD CONSTRAINT "cart_products_fk" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE; -- Удалить записи корзины при удалении товара

ALTER TABLE "orders" ADD CONSTRAINT "user_orders_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE RESTRICT; -- Запретить удаление пользователя, если есть заказы

ALTER TABLE "order_items" ADD CONSTRAINT "order_items_orders_fk" FOREIGN KEY ("order_id") REFERENCES "orders" ("id") ON DELETE CASCADE; -- Удалить позиции заказа при удалении заказа
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_products_fk" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE RESTRICT; -- Запретить удаление товара, если он есть в заказах

ALTER TABLE "reviews" ADD CONSTRAINT "user_reviews_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE; -- Удалить отзывы при удалении пользователя
ALTER TABLE "reviews" ADD CONSTRAINT "product_reviews_fk" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE; -- Удалить отзывы при удалении товара
ALTER TABLE "reviews" ADD CONSTRAINT "unique_user_product_review" UNIQUE ("user_id", "product_id"); -- Пользователь может оставить только один отзыв на товар

ALTER TABLE "favorites" ADD CONSTRAINT "user_favorites_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE; -- Удалить избранное при удалении пользователя
ALTER TABLE "favorites" ADD CONSTRAINT "product_favorites_fk" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE; -- Удалить избранное при удалении товара

ALTER TABLE "product_promotions" ADD CONSTRAINT "product_promotions_products_fk" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE; -- Удалить связь при удалении товара
ALTER TABLE "product_promotions" ADD CONSTRAINT "product_promotions_promotions_fk" FOREIGN KEY ("promotion_id") REFERENCES "promotions" ("id") ON DELETE CASCADE; -- Удалить связь при удалении акции

ALTER TABLE "logs" ADD CONSTRAINT "user_logs_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL; -- Установить user_id в NULL при удалении пользователя

COMMIT;
