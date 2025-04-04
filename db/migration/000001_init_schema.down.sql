-- Миграция Вниз (Откат схемы)
-- Версия: 1

-- +migrate Down
BEGIN;

-- Удаление внешних ключей и уникальных ограничений
-- Порядок важен: удаляем ограничения перед удалением таблиц, на которые они ссылаются
ALTER TABLE "logs" DROP CONSTRAINT IF EXISTS "user_logs_fk";
ALTER TABLE "product_promotions" DROP CONSTRAINT IF EXISTS "product_promotions_promotions_fk";
ALTER TABLE "product_promotions" DROP CONSTRAINT IF EXISTS "product_promotions_products_fk";
ALTER TABLE "favorites" DROP CONSTRAINT IF EXISTS "product_favorites_fk";
ALTER TABLE "favorites" DROP CONSTRAINT IF EXISTS "user_favorites_fk";
ALTER TABLE "reviews" DROP CONSTRAINT IF EXISTS "unique_user_product_review"; -- Удаление UNIQUE constraint
ALTER TABLE "reviews" DROP CONSTRAINT IF EXISTS "product_reviews_fk";
ALTER TABLE "reviews" DROP CONSTRAINT IF EXISTS "user_reviews_fk";
ALTER TABLE "order_items" DROP CONSTRAINT IF EXISTS "order_items_products_fk";
ALTER TABLE "order_items" DROP CONSTRAINT IF EXISTS "order_items_orders_fk";
ALTER TABLE "orders" DROP CONSTRAINT IF EXISTS "user_orders_fk";
ALTER TABLE "cart_items" DROP CONSTRAINT IF EXISTS "cart_products_fk";
ALTER TABLE "cart_items" DROP CONSTRAINT IF EXISTS "cart_users_fk";
ALTER TABLE "products" DROP CONSTRAINT IF EXISTS "product_categories_fk";

-- Удаление таблиц
-- Порядок важен: сначала удаляем таблицы, на которые есть ссылки,
-- или те, что были созданы позже / имеют меньше зависимостей.
DROP TABLE IF EXISTS "logs";
DROP TABLE IF EXISTS "product_promotions";
DROP TABLE IF EXISTS "favorites";
DROP TABLE IF EXISTS "reviews";
DROP TABLE IF EXISTS "order_items";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "cart_items"; -- Добавлено удаление таблицы cart_items
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "promotions";
DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "users";

-- Удаление пользовательских типов ENUM
-- Удаляются последними, после удаления всех таблиц, которые их используют
DROP TYPE IF EXISTS "order_status";
DROP TYPE IF EXISTS "user_role";

COMMIT;
