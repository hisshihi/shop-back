// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0

package sqlc

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"time"
)

type OrderStatus string

const (
	OrderStatusCreated   OrderStatus = "created"
	OrderStatusPending   OrderStatus = "pending"
	OrderStatusProcessed OrderStatus = "processed"
	OrderStatusDelivered OrderStatus = "delivered"
	OrderStatusCanceled  OrderStatus = "canceled"
)

func (e *OrderStatus) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = OrderStatus(s)
	case string:
		*e = OrderStatus(s)
	default:
		return fmt.Errorf("unsupported scan type for OrderStatus: %T", src)
	}
	return nil
}

type NullOrderStatus struct {
	OrderStatus OrderStatus `json:"order_status"`
	Valid       bool        `json:"valid"` // Valid is true if OrderStatus is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullOrderStatus) Scan(value interface{}) error {
	if value == nil {
		ns.OrderStatus, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.OrderStatus.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullOrderStatus) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.OrderStatus), nil
}

type UserRole string

const (
	UserRoleAdmin UserRole = "admin"
	UserRoleUser  UserRole = "user"
)

func (e *UserRole) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = UserRole(s)
	case string:
		*e = UserRole(s)
	default:
		return fmt.Errorf("unsupported scan type for UserRole: %T", src)
	}
	return nil
}

type NullUserRole struct {
	UserRole UserRole `json:"user_role"`
	Valid    bool     `json:"valid"` // Valid is true if UserRole is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullUserRole) Scan(value interface{}) error {
	if value == nil {
		ns.UserRole, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.UserRole.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullUserRole) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.UserRole), nil
}

type Category struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
	// Описание категории, может быть пустым
	Description sql.NullString `json:"description"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
}

type Favorite struct {
	ID        int64     `json:"id"`
	UserID    int64     `json:"user_id"`
	ProductID int64     `json:"product_id"`
	CreatedAt time.Time `json:"created_at"`
}

type Log struct {
	ID int64 `json:"id"`
	// Может быть пустым для системных действий
	UserID sql.NullInt64 `json:"user_id"`
	// Описание действия, например, product_added
	Action    string    `json:"action"`
	CreatedAt time.Time `json:"created_at"`
}

type Order struct {
	ID     int64 `json:"id"`
	UserID int64 `json:"user_id"`
	// Общая сумма заказа
	TotalAmount string `json:"total_amount"`
	// pending, processed, delivered, canceled
	Status string `json:"status"`
	// Способ оплаты: card, cash
	PaymentMethod string `json:"payment_method"`
	// Статус доставки, может быть пустым
	DeliveryStatus NullOrderStatus `json:"delivery_status"`
	CreatedAt      time.Time       `json:"created_at"`
	UpdatedAt      time.Time       `json:"updated_at"`
}

type OrderItem struct {
	ID        int64 `json:"id"`
	OrderID   int64 `json:"order_id"`
	ProductID int64 `json:"product_id"`
	// Количество товара в заказе
	Quantity int32 `json:"quantity"`
	// Цена на момент заказа
	Price     string    `json:"price"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Product struct {
	ID         int64  `json:"id"`
	CategoryID int64  `json:"category_id"`
	Name       string `json:"name"`
	// Подробное описание товара
	Description string `json:"description"`
	// Цена с двумя знаками после запятой
	Price string `json:"price"`
	// Количество на складе
	Stock     int32     `json:"stock"`
	PhotoUrl  []byte    `json:"photo_url"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type ProductPromotion struct {
	ID          int64 `json:"id"`
	ProductID   int64 `json:"product_id"`
	PromotionID int64 `json:"promotion_id"`
}

type Promotion struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
	// Процент скидки
	DiscountPercentage string    `json:"discount_percentage"`
	StartDate          time.Time `json:"start_date"`
	EndDate            time.Time `json:"end_date"`
}

type Review struct {
	ID        int64 `json:"id"`
	UserID    int64 `json:"user_id"`
	ProductID int64 `json:"product_id"`
	// Оценка от 1 до 5
	Rating int32 `json:"rating"`
	// Текст отзыва, может быть пустым
	Comment   sql.NullString `json:"comment"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
}

type User struct {
	ID int64 `json:"id"`
	// Имя пользователя для входа
	Username string `json:"username"`
	// Для авторизации и восстановления пароля
	Email    string `json:"email"`
	Fullname string `json:"fullname"`
	// Хешированный пароль
	Password string `json:"password"`
	// user или admin
	Role     UserRole `json:"role"`
	Phone    string   `json:"phone"`
	IsBanned bool     `json:"is_banned"`
	// Накопительные бонусы
	BonusPoints int32     `json:"bonus_points"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}
