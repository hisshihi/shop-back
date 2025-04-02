CREATE TYPE "order_status" AS ENUM (
  'created',
  'pending',
  'processed',
  'delivered',
  'canceled'
);

CREATE TYPE "user_role" AS ENUM (
  'admin',
  'user'
);

CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "username" varchar(255) UNIQUE NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "fullname" varchar(255) NOT NULL,
  "password" varchar(255) NOT NULL,
  "role" user_role NOT NULL,
  "phone" varchar(255) NOT NULL UNIQUE,
  "is_banned" boolean NOT NULL DEFAULT false,
  "bonus_points" integer NOT NULL DEFAULT 0,
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
  "price" decimal(10,2) NOT NULL,
  "stock" integer NOT NULL,
  "photo_url" bytea,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "orders" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "total_amount" decimal(10,2) NOT NULL,
  "status" order_status,
  "payment_method" varchar(50) NOT NULL,
  "delivery_status" varchar(50),
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "order_items" (
  "id" bigserial PRIMARY KEY,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" integer NOT NULL,
  "price" decimal(10,2) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "reviews" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "rating" integer NOT NULL,
  "comment" text,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "favorites" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "promotions" (
  "id" bigserial PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "discount_percentage" decimal(5,2) NOT NULL,
  "start_date" timestamptz NOT NULL,
  "end_date" timestamptz NOT NULL
);

CREATE TABLE "product_promotions" (
  "id" bigserial PRIMARY KEY,
  "product_id" bigint NOT NULL,
  "promotion_id" bigint NOT NULL
);

CREATE TABLE "logs" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint,
  "action" varchar(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "users" ("email");

CREATE INDEX ON "users" ("username");

CREATE INDEX ON "products" ("name");

CREATE INDEX ON "products" ("category_id");

CREATE INDEX ON "orders" ("user_id");

CREATE INDEX ON "orders" ("created_at");

CREATE INDEX ON "order_items" ("order_id");

CREATE INDEX ON "order_items" ("product_id");

CREATE INDEX ON "reviews" ("product_id");

CREATE INDEX ON "reviews" ("user_id");

CREATE INDEX ON "favorites" ("user_id");

CREATE INDEX ON "favorites" ("product_id");

CREATE INDEX ON "promotions" ("start_date");

CREATE INDEX ON "promotions" ("end_date");

CREATE INDEX ON "product_promotions" ("product_id");

CREATE INDEX ON "product_promotions" ("promotion_id");

CREATE INDEX ON "logs" ("created_at");

COMMENT ON COLUMN "users"."username" IS 'Имя пользователя для входа';

COMMENT ON COLUMN "users"."email" IS 'Для авторизации и восстановления пароля';

COMMENT ON COLUMN "users"."password" IS 'Хешированный пароль';

COMMENT ON COLUMN "users"."role" IS 'user или admin';

COMMENT ON COLUMN "users"."bonus_points" IS 'Накопительные бонусы';

COMMENT ON COLUMN "categories"."description" IS 'Описание категории, может быть пустым';

COMMENT ON COLUMN "products"."description" IS 'Подробное описание товара';

COMMENT ON COLUMN "products"."price" IS 'Цена с двумя знаками после запятой';

COMMENT ON COLUMN "products"."stock" IS 'Количество на складе';

COMMENT ON COLUMN "orders"."total_amount" IS 'Общая сумма заказа';

COMMENT ON COLUMN "orders"."status" IS 'pending, processed, delivered, canceled';

COMMENT ON COLUMN "orders"."payment_method" IS 'Способ оплаты: card, cash';

COMMENT ON COLUMN "orders"."delivery_status" IS 'Статус доставки, может быть пустым';

COMMENT ON COLUMN "order_items"."quantity" IS 'Количество товара в заказе';

COMMENT ON COLUMN "order_items"."price" IS 'Цена на момент заказа';

COMMENT ON COLUMN "reviews"."rating" IS 'Оценка от 1 до 5';

COMMENT ON COLUMN "reviews"."comment" IS 'Текст отзыва, может быть пустым';

COMMENT ON COLUMN "promotions"."discount_percentage" IS 'Процент скидки';

COMMENT ON COLUMN "logs"."user_id" IS 'Может быть пустым для системных действий';

COMMENT ON COLUMN "logs"."action" IS 'Описание действия, например, product_added';

ALTER TABLE "orders" ADD CONSTRAINT "user_orders" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "reviews" ADD CONSTRAINT "user_reviews" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "favorites" ADD CONSTRAINT "user_favorites" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "logs" ADD CONSTRAINT "user_logs" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "reviews" ADD CONSTRAINT "product_reviews" FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "favorites" ADD CONSTRAINT "product_favorites" FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "order_items" ADD CONSTRAINT "order_items_orders" FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "order_items" ADD CONSTRAINT "order_items_products" FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products" ADD CONSTRAINT "product_categories" FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "product_promotions" ADD CONSTRAINT "product_promotions_products" FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "product_promotions" ADD CONSTRAINT "product_promotions_promotions" FOREIGN KEY ("promotion_id") REFERENCES "promotions" ("id");

ALTER TABLE reviews ADD CONSTRAINT unique_user_product_review UNIQUE (user_id, product_id);
