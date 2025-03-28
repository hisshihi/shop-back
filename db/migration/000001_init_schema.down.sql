-- Удаление внешних ключей
ALTER TABLE "product_promotions" DROP CONSTRAINT "product_promotions_products";
ALTER TABLE "product_promotions" DROP CONSTRAINT "product_promotions_promotions";
ALTER TABLE "order_items" DROP CONSTRAINT "order_items_orders";
ALTER TABLE "order_items" DROP CONSTRAINT "order_items_products";
ALTER TABLE "reviews" DROP CONSTRAINT "product_reviews";
ALTER TABLE "favorites" DROP CONSTRAINT "product_favorites";
ALTER TABLE "logs" DROP CONSTRAINT "user_logs";
ALTER TABLE "orders" DROP CONSTRAINT "user_orders";
ALTER TABLE "reviews" DROP CONSTRAINT "user_reviews";
ALTER TABLE "favorites" DROP CONSTRAINT "user_favorites";
ALTER TABLE "products" DROP CONSTRAINT "product_categories";

-- Удаление таблиц
DROP TABLE IF EXISTS "product_promotions";
DROP TABLE IF EXISTS "order_items";
DROP TABLE IF EXISTS "reviews";
DROP TABLE IF EXISTS "favorites";
DROP TABLE IF EXISTS "logs";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "promotions";

-- Удаление пользовательских типов
DROP TYPE IF EXISTS "order_status";
DROP TYPE IF EXISTS "user_role";