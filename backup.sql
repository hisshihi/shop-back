--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4 (Ubuntu 17.4-1.pgdg24.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: root
--

CREATE TYPE public.order_status AS ENUM (
    'processed',
    'delivering',
    'delivered',
    'canceled'
);


ALTER TYPE public.order_status OWNER TO root;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: root
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user'
);


ALTER TYPE public.user_role OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT cart_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.cart_items OWNER TO root;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO root;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO root;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO root;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.favorites (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.favorites OWNER TO root;

--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favorites_id_seq OWNER TO root;

--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: help; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.help (
    id bigint NOT NULL,
    fullname character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    topic character varying(255) NOT NULL,
    message character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.help OWNER TO root;

--
-- Name: help_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.help_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.help_id_seq OWNER TO root;

--
-- Name: help_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.help_id_seq OWNED BY public.help.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.logs (
    id bigint NOT NULL,
    user_id bigint,
    action character varying(255) NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO root;

--
-- Name: COLUMN logs.user_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.logs.user_id IS 'ID пользователя, выполнившего действие (NULL для системных)';


--
-- Name: COLUMN logs.action; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.logs.action IS 'Краткое описание выполненного действия (например, user_login, product_added)';


--
-- Name: COLUMN logs.details; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.logs.details IS 'Дополнительные детали действия в формате JSONB';


--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO root;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT order_items_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_items OWNER TO root;

--
-- Name: COLUMN order_items.price; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.order_items.price IS 'Цена за единицу товара на момент оформления заказа';


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO root;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status public.order_status DEFAULT 'processed'::public.order_status NOT NULL,
    payment_method character varying(50) NOT NULL,
    delivery_address text NOT NULL,
    delivery_status character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.orders OWNER TO root;

--
-- Name: COLUMN orders.total_amount; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.orders.total_amount IS 'Общая сумма заказа с учетом скидок и бонусов';


--
-- Name: COLUMN orders.status; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.orders.status IS 'Текущий статус заказа (created, pending, processed, delivered, canceled)';


--
-- Name: COLUMN orders.payment_method; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.orders.payment_method IS 'Выбранный способ оплаты (например, card, cash, online)';


--
-- Name: COLUMN orders.delivery_address; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.orders.delivery_address IS 'Полный адрес доставки заказа';


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO root;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: product_promotions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.product_promotions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    promotion_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_promotions OWNER TO root;

--
-- Name: product_promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.product_promotions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_promotions_id_seq OWNER TO root;

--
-- Name: product_promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.product_promotions_id_seq OWNED BY public.product_promotions.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    photo_url bytea,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT products_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.products OWNER TO root;

--
-- Name: COLUMN products.photo_url; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.products.photo_url IS 'URL или путь к фотографии товара';


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO root;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.promotions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    discount_percentage numeric(5,2) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT promotions_check CHECK ((end_date > start_date)),
    CONSTRAINT promotions_discount_percentage_check CHECK (((discount_percentage >= (0)::numeric) AND (discount_percentage <= (100)::numeric)))
);


ALTER TABLE public.promotions OWNER TO root;

--
-- Name: COLUMN promotions.discount_percentage; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.promotions.discount_percentage IS 'Процент скидки, предоставляемый акцией';


--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.promotions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_id_seq OWNER TO root;

--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO root;

--
-- Name: COLUMN reviews.rating; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.reviews.rating IS 'Оценка товара пользователем по шкале от 1 до 5';


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO root;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO root;

--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    fullname character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    phone character varying(255) NOT NULL,
    is_banned boolean DEFAULT false NOT NULL,
    bonus_points integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_bonus_points_check CHECK ((bonus_points >= 0))
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: COLUMN users.password; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users.password IS 'Хешированный пароль';


--
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users.role IS 'Роль пользователя (user или admin)';


--
-- Name: COLUMN users.bonus_points; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users.bonus_points IS 'Накопительные бонусные баллы пользователя';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO root;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: help id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.help ALTER COLUMN id SET DEFAULT nextval('public.help_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: product_promotions id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product_promotions ALTER COLUMN id SET DEFAULT nextval('public.product_promotions_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.cart_items (id, user_id, product_id, quantity, created_at, updated_at) FROM stdin;
4	13	2	1	2025-04-06 11:10:13.519279+00	2025-04-06 11:10:13.519279+00
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
1	Наушники		2025-04-06 10:18:30.482199+00	2025-04-06 10:18:30.482199+00
2	Смартфоны		2025-04-06 10:53:25.394876+00	2025-04-06 10:53:25.394876+00
3	ПК		2025-04-06 10:53:33.447624+00	2025-04-06 10:53:33.447624+00
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.favorites (id, user_id, product_id, created_at) FROM stdin;
7	13	2	2025-04-06 11:10:16.019427+00
\.


--
-- Data for Name: help; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.help (id, fullname, email, topic, message, created_at) FROM stdin;
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.logs (id, user_id, action, details, created_at) FROM stdin;
1	1	Создание категории ID: 1, название Наушники	\N	2025-04-06 10:18:30.489934+00
2	1	Создание товара ID: 1	\N	2025-04-06 10:19:01.991566+00
3	2	Вход пользователя ID: 2	\N	2025-04-06 10:29:13.309029+00
4	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 1	\N	2025-04-06 10:29:15.925222+00
5	2	Добавление товара в корзину ID: 1	\N	2025-04-06 10:29:16.999943+00
6	2	Создание заказа ID: 1 с позициами 1	\N	2025-04-06 10:29:29.236575+00
7	1	Вход пользователя ID: 1	\N	2025-04-06 10:29:37.09169+00
8	1	Вход пользователя ID: 1	\N	2025-04-06 10:53:09.695889+00
9	1	Создание категории ID: 2, название Смартфоны	\N	2025-04-06 10:53:25.400407+00
10	1	Создание категории ID: 3, название ПК	\N	2025-04-06 10:53:33.453722+00
11	1	Создание товара ID: 2	\N	2025-04-06 10:53:59.806552+00
12	1	Создание товара ID: 3	\N	2025-04-06 10:54:33.350997+00
13	2	Вход пользователя ID: 2	\N	2025-04-06 11:03:06.67122+00
14	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 2	\N	2025-04-06 11:03:12.106599+00
15	2	Удаление избранного. Пользователь ID: 2. Товар ID: 2	\N	2025-04-06 11:03:13.498247+00
16	2	Удаление избранного. Пользователь ID: 2. Товар ID: 1	\N	2025-04-06 11:03:15.633596+00
17	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 2	\N	2025-04-06 11:03:17.544127+00
18	2	Удаление избранного. Пользователь ID: 2. Товар ID: 3	\N	2025-04-06 11:03:21.585527+00
19	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 3	\N	2025-04-06 11:03:22.544912+00
20	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 2	\N	2025-04-06 11:03:24.210945+00
21	2	Удаление избранного. Пользователь ID: 2. Товар ID: 5	\N	2025-04-06 11:03:24.955641+00
22	2	Удаление избранного. Пользователь ID: 2. Товар ID: 4	\N	2025-04-06 11:03:26.531287+00
23	2	Добавление в избранное. Пользователь ID: 2. Товар ID: 3	\N	2025-04-06 11:03:27.897773+00
24	2	Добавление товара в корзину ID: 3	\N	2025-04-06 11:03:35.242308+00
25	2	Обновление пользователя ID: 2	\N	2025-04-06 11:04:22.180167+00
26	2	Вход пользователя ID: 2	\N	2025-04-06 11:04:32.750121+00
27	1	Вход пользователя ID: 1	\N	2025-04-06 11:04:59.389159+00
28	1	Обновление товара ID: 1	\N	2025-04-06 11:07:15.073078+00
29	1	Обновление товара ID: 1	\N	2025-04-06 11:07:25.012689+00
30	1	Удаление товара ID: 3	\N	2025-04-06 11:07:38.041637+00
31	1	Обновление заказа ID: 1	\N	2025-04-06 11:07:46.089636+00
32	2	Вход пользователя ID: 2	\N	2025-04-06 11:08:13.254724+00
33	1	Вход пользователя ID: 1	\N	2025-04-06 11:08:23.834353+00
34	2	Вход пользователя ID: 2	\N	2025-04-06 11:08:35.943862+00
35	2	Добавление товара в корзину ID: 2	\N	2025-04-06 11:08:42.267385+00
36	2	Создание заказа ID: 2 с позициами 1	\N	2025-04-06 11:09:00.267364+00
37	1	Вход пользователя ID: 1	\N	2025-04-06 11:09:25.172425+00
38	13	Создание пользователя ID: 13	\N	2025-04-06 11:10:09.735643+00
39	13	Добавление товара в корзину ID: 2	\N	2025-04-06 11:10:13.524137+00
40	13	Добавление в избранное. Пользователь ID: 13. Товар ID: 2	\N	2025-04-06 11:10:16.023541+00
41	1	Вход пользователя ID: 1	\N	2025-04-07 08:54:21.778874+00
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.order_items (id, order_id, product_id, quantity, price, created_at, updated_at) FROM stdin;
1	1	1	1	12000.00	2025-04-06 10:29:29.224555+00	2025-04-06 10:29:29.224555+00
2	2	2	2	120000.00	2025-04-06 11:09:00.253981+00	2025-04-06 11:09:00.253981+00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.orders (id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at) FROM stdin;
1	2	12000.00	delivering	card	Гоголя 12	\N	2025-04-06 10:29:29.224555+00	2025-04-06 11:07:46.079862+00
2	2	240000.00	processed	card	Гоголя 122	\N	2025-04-06 11:09:00.253981+00	2025-04-06 11:09:00.253981+00
\.


--
-- Data for Name: product_promotions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.product_promotions (id, product_id, promotion_id, created_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.products (id, category_id, name, description, price, stock, photo_url, created_at, updated_at) FROM stdin;
2	3	ПК	Современный пк	120000.00	3	\\x89504e470d0a1a0a0000000d4948445200000100000001000802000000d3103f3100011ca3494441541819ece179d0af697ad0f77dafe5be9fe7f92def397d4eef333d3d3dab46331242eb20042a15d80522224004019bc455c18ec1496c07a7a0304efe6009152506078b32ab170c295901c92084658310d68624c4683669343d8ba67b667a3b7dfa2ceff2fb3dcf73dfd795f7ed6e2411e4aaa84a555246fdf9f8335fffd57bd7faee2ffa8e1ffdb1eb52ce33df59ca02b75a7b765d3fbff6db3d5f893c72e56195b79afdda6d39115d326faffda5e4cb063f8b54e15d27f5cdffeeffa9ffc80f0451bff17711e40b2f1cfffa5f391e0e172de624c916245712045c69c167e6f6f2daffdafdf3e77a26dc34b9e9fe9b37e58b4a198513f32f3ad9f85bdedac77afca99ffcc4c5f1872fe68fcd7dce3c31b91ff90fca63b7366f627c80f101ca866c9c3ecf7a465fa023151ff02dc39eb2e1d2f13ef31dd619829fa595c7bf9c4cda29f342ae2ce7d0c94e362e454290099dd70457d41043051db001af6098d01bf3293113894f0cd7d9dfe0fa130cd71847ea8428ea0857fa0a490a08222844673e72ff0eedc0a532b1bb86152e458062806220c2f1c847bf0b8232f1c897f29ef7fcaedffeeeeff8810b32198d417daf26ccb7fbeffbf2e1ef3c3d5f7ce03398330d5ceac9da50a33ae3c8d2b87f8fbb2f72e779ee7e968b5bb40b6226926c105c6aa08af2aae035c1957e24575d8e3a5f8c679fffe38f9ebcb71487ef3fbbf8afcf0e2f97ebebf4500c3b6c62b88e8f58e552c272c1e1659deff9c58b94a9defd6c94cdd02e064360ee1ccbd0cb3e5104e951d6db634f87c9a44bbeb2f2a6225fbba90efff862f9bab19aaac38366ef1af5ba6825150154100cba70c5b7d7ca875f3e3efd631f78f7383dbbb437d5fa5ce4d3eb7a778d3b91b77ade496eb5983342586a19347e7da917d1d6ee3f19fd89a2e276beb401ef08371e9427de25775e6c1ff8a7ac6bfbd047fa1ae265b49c40824b81b4ece73d0e911d12525c9dc74b1d4b6e44be74283be21da516e1915a06e4f9c3eccf3e7b6dbbf9c459fbd89c3f35c779ca56e49fb2ff7cd9debaf62ec66bd43d5239de67b9c7f11e578c7a0d9b18af4370bccfbdcfe3033eb2cef40ba181f1aa8c95e73ec066c7ee6d6cafd1577c6439d02ec0a0a39d5008827f4108a660a4702941840e6920bc2ec9866e59026968a220e0a05c49a505971c12bad08426f46099c9c632d33a9b13eac46b3a57125028c8403b100b4df8e0876effa6777ee3978f7fff47ce31a5642c7932305fb41fb9e5bff9c9fa773f3cb2cc487029939e58b226d2581a6bd0830e3dc8243a3da18310c625054d5ea704575420d10d11a1bb28c7b3dd8dff703dcadca1a3d7f39aa50c9491b2651cb111af20f484993cc0913c4332fa3a799c4ac7b20b90b311a574011241b565ef615c52d1a3248ea934c9465e48364b259ad24d56d1b0ecd041b8a28a8a915cf21f7ffe6c32fff4c5fc63a7c7dfb69f9e9d2f3eb772b7f543e62b9d177bbfd5fa4b1973c78d93a667e8455b23792e0e9f59d777d529e94b66b29e2d2cdfff0f86dff2dbf5953b79e71619c3577ed5d0597fe87beffd8fdf7fbfc592b9753d31bbf927fe1fb7ffa33f7c58a2c39accb4907c73d527941b2a4f161d45df31fa24f272c411d6e06db9feb3e79ffbc1e3f2cc1a8be608df576ebc506fce9bc7196f32eee99dc3e799efd18f58c12a3eb27b90e305e3406f1c17e28c68f8c0cd2720b3f32ac1153172653ee7b91f64d870ed49768f339f73843e932b1d1412120822a18383a2208a2ba288618a38244c2cc0cca5e05589808208a6a861ca2529488304e19209a290a892d03a92e4192852280397124c41106185e13abd83309fb1bdf9033ff8b1ffec777cc9df7f78e44ec7ada8a808693f7327bef16167dad23a280a3d4040404040414031c72ae2c88019d1202140b914407025794d083f4b131da067b1a411812a08e6d8840f8821035db8948da5d34396d5e759125fef57b0086969c279d2eb361914012191484fa421821a99290d172c9983e31a74204946cd585be220900902d95b887029d3ef04ffe9ddd38735bf761a9e5df3de9a0d8ec945e4dd1eb7d6fe528b6372a9058b06a6046be6b387fea8e8906830c09d162f1edbee7bfee1f43f7cafc021f2ee9a9f5ae7971a02a387c1b1f3b65a1e2f65fa3b7f5bb464ef1de6d6899c882f71aba615ae8bbc7dacf77a606c83f3ce3bdef1e4673ef9cc77dc3bbcdc531211fec7f1b167774f627bc66bd8c4f91d0eb7116339921d1d3001874abbcbb33fc2f6417ccfe67196fb9cdee2de67b9d413ba242982193a50b6dcf862e8dc7d81f3bb5c7b0a9fe88dbe920a4126bd43e74ac20a42773ce95c51a13b165c490c22899926b4539ad294d8d217280888827025a173c520d18e34a4c34c1c21e8c0010fca4dcc41f000459411a613e69730585fc4aec7a73ef7f7ee7df1b77c55f923ffb851822247159c4be95005074b54b8248a42114c286082096e94ca38a19d9e74ae18578457295782e4559d34ae742e8971490c844b564010a58e4801410c3a99b4c49c15c94e46baf9c5459ad2d7145da1d721eb262982f22a613151210145e85aa08a1ab2048138a650c03045254545842bca1549830ee21f6b5d95eb831f4c2f3a596c4de6c699e6197a4f62154de15242171d5c9bca69f032ba775954c26c088ef03cac6b8e9a010e7bd5144b4920d1142e3dbb6451def4811f3f5d56d0249b225d55f47ac130c094bdd7e7db5c538aa966ee6edc7cbe7dfab926816c84237cb65ca33c80556c440aadd356e21c71ea96ed9b9081fbcf72789ae921f66f62becf7c8e806d2827d80d4441203383f99c982556397b918b5b315e63b8c1a5e7fe098fff7ac4594e59ce484010a70b347ebe0e16a2820822847129555250e592c2ba602bbe922bddb00e4680724520852b41402601a174688d7ee0525b90019ccd35cc598144831086ebc8489f7359b8ff32f2d0cb877cc7432a5d7249543292b971407a22c69294064a0f48dc58021a4ba7750232415983802e6064f29a04172ef504e53502c2ab8c4b09a298704531431c33500414e844922bd961a69d9267c2d2a36c2c1601938080304b910094d758867a269712c9262920852e792a89d32c0c4259546667d54b189724b89442e755fe436787a7aa3d8c9cae2d05c96cc179ef77a3bfd4fafd35829f13296f525d225e5cd63bad0de87de542b8177de9f14ae7eeba06243ce4fa96ea4f0dfef8d097c4c44638affd23174bb5b2ff13ffd7cffc07fffe2c9cf576b7670a2274c1359f78cbcdfef97bcfafc7774c36677e7eee21fd2fffd03ff9deb33945de54e5959edfbd7b1f274f5247c6139695fb4f339fe3866d191f6099e5d60772fb28db2d8723ed456c62ff205af1821a28578c2b4234a6956c192dd703c7dbd2ceb21f39799207dec9bd4f72e36d582516b2d14140170248b2232e6298e22e18e2e28eba8810216bb04222c52903b5e215738aa3052ba823c2256b74e39272259238502aeeb48a069744215128052918a024644b1bb081cc54232565f3639f6c7fa3e8b77cedf447beffb89cb0005d18ecc40431d44140b8222058610512140c2a183e911d83de90e0754ae7e7487045b992bc4600a12be688818173492b080124197488c6da89ae73a3a39a054ed3a4f50e88c630812a10c1ab645d4bcb15c4d04c7a56280acad9da3689f714c53aa6d95ba42bc9ab92d725aff2aafa8419e48014748978a1f763e4bd16f7d6cc14e17522ec441f32c9e4bc45243df3229883b7fbf056efc088cdf0525b7ff0e2f88f4fe7a2b21319e0e162bf66a8246ff7f255fffb7fe7f93ffa87d7ce12fdac27a050e1112beffddffcfb1ffc2fffe3774eb5a89e2efdf9399ea8fa479fbfffd908858dea5f1ddf078dcd9bb1011979e5731c5e21167c627a987596173f92fbb7e4f8207de57046b9815754c011e8ca9540949f251577ae24b6a16c72b960becfdd4f31dc607a80973fc6fe2d686559c8201b91f406299978133ae1d2ab9426da4545544510413ab8486fa28a1ea0828b9e902081291298a242802709c295ec34588392d0998f108842705c988cedcd44b1e05297bc36e57cc2b1a50d29a7b9f1fcfeefdd7cf96ffdb0a45e27cf3b04238fdd945281a0062802168872c9039404178ae28215bcc288246e64125c51418c2b9de4e7492220798d0a18629821064e266a60bc263a96f419545005d40575d14855c94cd22b5a50e38af23a1153010441b01430379006ef1daa22050404a9a8230511505e275cca44fcc9c94dcda098028b701afdb6f052e61992c2cf11a6620f947a3ff38eea2c3cd7398bfe99c813d673e5e5b93fdd22899dea970cfe6b6bdd39678de7636deee9fee2da7ef79fff0bcffcb13f7cbb71a67268746410a962ef7ceba32f7cf6c5d36ffb0bef1c3755a5f77cf0ebbeee27fefb7ff097ee2ccf843c6e765bf89eddfbd83e89c1f671e6032f3f4d3fa095cd63c828f79fcd7292bb3783323c8839bd61060e82280897ba4240273b0401aa88618e186547d93174c623a7cfc87c3f7d4b7980b3e7d93f49efb47370e88088902989a4888b9a4aaa8a0aaaa82297b456e92221a28a22dac8c672645052c8020512318c572597025a80a28a0aaaa89209c9ba90f7397b19df5007f04c41c93a643dc9f96e584d2132c2367ffb2ffee0effc377ffd7ff415c39ffba9f5fc65766fb65f7b62cf9f27879925a1e3424b0c0c5a42a377e6236b90c96b1210121094d72508e0086442e7e70897b2f1bae48a40431de95870a92504b29207e2907911392378ce5da2cb405fb3945e6b18d049851581c4730ec904111a92a48baae4a2dccd7c48258c451920556767515c7108ae08af91047f3018250a38d181ccb9c7456fa711c9bf28f9f26a96f1caba1e7b6fe42b3d3edfe3307391096c54be762c4fd5fa589107d52b72ccb84d7b716d5fb6291f9c8fdf7c7df3537ff4dfbb1fbd25e72d43a9ca9b8bbd651a9e7df1c5c7b77a967d777d38bd77716fcdbff55ddffd3de70b1ad7dcffd6ee1d79ed6d20b833dee0ce4f33df47a1ec191fe0de67d83c9275c0049fe882039d61c0844ba220a05c1248aeb44e7672666eb090891686eb941dc3c050a9efc8e35d4e3fc7ee21fa4c1d581d940686c8407691aea6a25545d5447db0e25aaad9a82a4a688836937475a31629856a5202ebc84a5114447045859f15a04acef4c232c0195248e3522612c419ed4efa4d7c48119288317727d176a1256c8cf9b4ef1f8be3f9a9e8678ef94d6f299fbae19bc23593effdcc2a6bcf003552a083801002420429a820052fb481d6b8242b2457842bcacf59c121b9d2788d54025448a71b565001230b1d1262219396b4465f753e5af6d4b12c17f38aba0a96d464a0831aa0c16b745d0f5005375d49ed592c3c636e7abac650938e248308d159250b99c6ab842b822409f889ca2414b0ae3394decf8397d7985704e1e71994770c225c9221d82677233a4cf0542d6f757973f1371775d4124b31e195357ee262fdba4d598efddffecd5fff997ff2a3f7d6de60c9d46410de5ecbbd25576da5e731fba3fb4d3bdaf99adf79fbfcbbcf8f5bd721fc1f6edf95db279181cd4d8e77b9f73cc7532ee996f3dbe068a1af3090490311b283d33b6988f01a0b50303012acd33b92d038dc6339d3f5221efa12cc698257ccb12dcb39f3c0c93b79e5d35c7b2bf7ee910baf12e98a4876653135d3d124dc30532f698a19d65d4b6aa69a4a416a52577c463b545261c20b454031e19228bd531ad988c61aa8d08454081002f440de263a2659a64c0921f635d6a1ab77f1ae73b3a55fdbfe939f78fe2bbee4d16de1f1eb52859b553ef3f90b72a50a2a5c3245a028aa10ac4251501643c01d0a1620449280f03a85e08af373123a195c51c4b9248a5644b08af0ba15fa118384de898614b494f5305340d2c7f02deaaa86a824a05c899deb5913272b72ded3d14164c057f2983a208e192862a8a0028e38082908024942827b71a0c10a07b817bcd89697ba20c26b84d76cab8c5a9604d171f01b2db7aa83ea89c913e68343e756e7d260ecc52f82ef3bccbffffac92797f5eb6fee3ef9a33ff64a67c53a88f08ec906614e44f327e778b8d853bffb9b5ffae407f78fbdff0ffcd5fff45e8f370df5ee1acf6c1fcdf1616404e3fe6dd67bac17d8403b82a897c8c44f48c10a08081470c4511083c2251344c110430584384270a97510cd56d60b7be67b7bddcdd7dec2a35f894c8c13d7de21673f93fde3d875d6fbf88665154140ba8b76452c71a96ee9c58a7bb932b8e18a15b3341357555197e2520a9668a20bfd0202adb8e1861a18249eb4c40283c110c781a00704afd14096ec73d6295563d0be943e0c3db29936749d4fd7f2e0fa539ffd67c7be3cf2e0d7bdb97ce622fffbdbabbc748f79064d87ce155732b14e24bdd3820e3dc94e747a421249021d0c0115ae28c1eb1422b8148042404022828203425f315e95b0c0429f892379ee397733e2309538da267a62d65c509044834bc6953545326ac99c113d90a3e02e689c472c1e488605aa5de94a1822d204510437e5353d3ae0de5b402673721a7927fa67fa4af073922bc24ecd3221b61206370ab59a43c09cedb4e592ccc4883e617237f85ba7877ff56478210e7fe83ffbab1ffa23ff87dbbdf7c806059e9aca1a7d70fddcc502f2c4c637371f599efec8279e7de1f6f33f7041ec0a9f186fdedd8cb7f64fb27f9c75e6e265d6330872c1ae83202d862d74d420d1c00ce18a269298a040271d5130cc30418c2b7bae74c61dd5e3b85d8907d75b37d785975ff9f87c677ef3d7303ec6cdb7e7b0e5ced3dc78847b1fe7c617d32ec8869a98286a1a6eeeaec5863ad45a876133d63214b742b874a71b61a65a06b18255f101051c49b4a1a047ac602396889082424f10b452b664a77708085ea396dad143fa365c7bb33e0d6dddb5755e6db36a5d5accbde9382d9fbeed77da3fbdb73f3f44bfb5c871490c35105e9720205c110c1a6048451b2424ba108081a0404100c1f8e712055630ae0897142888d00d330c7a87201bbdb3769685e55c97a3b4ae5ecbd98b86742b92c7d48d06642090c63fe7672f2e24160a25b3b514473a286b0bef90d0d3b24b887892813b028948931020419224dd5205ce93d3e8a73d3e7ae8d911fe25c975554b040690644078554f7ad021028713970dfad18bf54b8b3f21be9bf2fe0ffdd0bc76223579b8c8dd352520a073686c14e93c70f391e3c73efcc117cffefee199638f87d47fbcdc9cc79be81e99e807ce5fc6041df4781e54b4a24e3462410dab08f404818e09d248c78140b8a21d9c2e1098f23ac78c31c063ce8bdb9f7862b43799bef3f0d90f7ef4539f7ed3d7f0d8af67bcc9035fccf94b5cff6291c44d96552d34c50d3775a316a985a1e838328c3a56ad4507f522e174d73053f5a25a70173104482461c1024db4208d610281c4562469423572a477b241f2ba242555b139ea79147ab566d264588f319b2d3e1dd7c563b6dd752d4d8ff797670f2545c2a46457099114c1934ba698a146262d580ad172e3b401e928b404cf0c5030102e89f03ae55206977284c6a50e063897c410e735d2c84e4f58b96448768d9e22445eb35cb582a3438a8122a086185744320c02951e62a2a2900506549043f280a9210531a85841152d48411c1c5308485048ba3757e9ccc441e534f442744e4de15ff6b6c15324317795a4c179e790713fa2434742f3612bd78a3eb3c6e793dfbfdb3e5cf501d14f7dc7b75f842df4020f7add5b22bcdcf9f8b2bc7b284f7dd9afc9175ef8990f7fe8cfdf39fbe18b6311bd26fedf5dfb32b64f520be584973eaceb59f8846ffdecd9b679141f2059ce11b001ada02424a8628e54cc411107c3141c11a89880225c11e735ae8c956817e3f58b7eba717f7331544e0e9ffb505f452b752ba79f411e956c524fa42f2a6a260e45a4aa552fe358c7a14ce3300dc3340c632d834b35aaa54b9a89595575ccc59c2b8a008215c450c7470444c8a418e644650d702288cecf4920012de1d68b76bc992f392ed2671b8e5aabca614933b5e2dabbb67509538da6555342c8c8ec814157323081c87525838c4c214911904c05a1372e59cf34445110e3528240722500233bc61505154430aeb4466fc84ace3013478e776867ace758fae1d6a0bc42106b3821098182189abc26a2783f62960da593e1890a8550ee495e37e94613509ad235d258454d054594ce9514622530bf686d80b3de5fe9f9d9d69feb2d495e9320fcac1398734d983b33dc8f7c7e8d73528351a986ab3c586c22beff38ffdefdb0b7acc4d3eb32472e509527ab1fe92ef2d3c70595b74dfece7fe37ff599ffeaafdfeffc81e76e1fe0bacafd69f7e1cddbb9f618e375ce9ee3eec7c939bc4a3b4b5adb3d4cacac472eb9a315e18a417150d4f18a3852514504142fa0e0b8816046174cb8a208b40e03758ae1e4ece2ecda543abca30c8ff5d38fbef8a3f2966f90e1ba1c7612a79221d7dfa67930696ee622b5c850742875bab2d96ef79bed66334e9ba18c8541a92e4570332ba6e2a2863a3f9f28a2a06822822497020627042abd414042925c912413483444bb641359575f749cab1c65b8d069586a3d2cee7819ad0cdec232d7d055bd2791129188a29922a8220aa4789a639e56b28c496648c69a644ac9040101b10c50e3350961d0c9ce15e7356984a046132e052474e841ebb44eeb165d1309085e6748a02424412824caa524bab5c4ccdbea2e5c6aa98e37f09c977c68348914d0442271203025533ad0794d9099809ff5dc9af4cedd96cf2dfd7c451048102e253feb62cd97345be0cadd16cff7f8992516e209f749c5bbbc6fb04f5fac7fffb0fcb987ae7dedeffde69ff9dbdff9b9e37a1124bc65f00292f2e2b19d663ce8fabe87ae6dffe07ff0e2b7fcc9efbb77f8d63be71db961f213d39bdbee51766fc6b6bcf063b21ed042ac4864d990c1f13e97ccc020898e3a45a0d01473426920608d744451a78101490b2e6582d08c2bc1a5e8b088582b9bb31e12e1a2a279bdd8d79f3ffdc3b74ff491afd2071e97fbcf687d40246c182dce8b7b31862a83d93894cd54b69bb2dd8dbbedb09dca66a853b541198a16a5b899b9aa8a3aaa5ccae43522a08880a0caa50c52c90a41265921c884e48a8040109942241d5d616d360f755ef49065943a74ca585dd2456c340ff560895cc55b644f726d1920820aa6290292aa299ae6212d9b87d6d0c8b28d1699112999896aa2229a0221bc2ec9800e414f102e99218e0a9164d0850013da0c02464240f6947a8d15915507514d2d804288a829295c11d2c244c406d78a2c20a92e22d81c2ce875554d29220a151960408b50c1911a06742e7581047f26e2a60f07c917a27d3e692a5c11924bc2eb123e9bb0c6edc64f2dcb8b6b0209d70b5f5dcaa03c6afe375e39fcde1bd3ef7b6078f7f59b1ffc5b7fe7b471482fcedbaa2da4a73c33f762fe4583bcf50ffd6f5ffccb7fcdbfeb3b7ff733afdc8ae8e89bcc7ff8da7bf2e42d8c0f33bfa4b73f045d29ba9caff506862ea75c124f71f044b0112aa5a0150c040c0c712848c58ce89064d2121a9702e828608840c5a077899536ab0a628a55311141e4eb27cb8b8f7fb0bf53b78fea7aaad34debb76dffa0cfad9452dd0693b1f834d5cd346d37c37e33ee36e36e1a3743dd0c3616194c8b4b7133755515551044c8e435222088220ac295842081241382844c085e2790e4a588cc1eb2a6ac8dd9ebd1ed226c102bab7aaab5b06caea5989690b9b1260d7a66284822a40864924058a61391410f9748e9a981f6c84895cc104924425243b054ae043f8f4270c912e9a822604aefb0a29d9c91461ec953f2403f8884cdb746e52ca3d74a5a27355b2a41412112053a7d3eaa910724453824145ce99e1741f334916eb208555994a62e1e4d655511b51504027a58d013fcb9b5fd1ab7e871dafad2827f51f2737ee4ecf823fc7ffb9a61b8ae79d3e5072f0eff8b9be59b4e86159ebe7dfb2cb2278f8d7243fd2c7aa7bfd079d354defeaffd1e7fefd79cfec8777deffdb3bffe8fbeffd968d74d77ee3ff4d0fbd93e840fbcf4a33edf0fadda0e51a63e6de867b22e60298e67aa618e55d411858e7524a0a220822b222848473bed9c76c1321333eb05b17245d04a29943d5eb14220eba9c5a22e54435d4c4255cdbfcef8fcfd0f5ddcf8268b9b36ededf4ae5f7b8b9fddafb5d4e2a3db38d83494ed30ed769bfdc966b7d9eca6713bfa546caa36b816d3e276495545842b02c91541201511c41040204920c8e44a9201492624570c1232a347668f5c5bae3de6560e6b0c5d6b0ebe883bb6345fcdad16b476999da5d3227b64f4cc0606a288a5484606166991a5d7dafbd88596d2455ab61ed943908c448b459080008206740212084cb922a48392068d6674581bb9b02e2c2b4b9375d6b6a4e8c97a5493732a6189284ddb925a55a1134087e8b62ee4e0eb990856645e4340c4a2b525289964d241202192d2a4a9785aa2d1f9e7329357f9450b0121e744925f94df797d7ca7d912f1575e39fce5476fbc75575f9efbfdb59f468af096e2b92295be62665ff6805dfb77fec317bee54f3ffa6f3ef467fff3bffb37cf0e2bb2838f3df8951933bbb730df93e73f62b168a2eb691bf6746c3dd32444c245202948218c4b09925ce988614980410bacb15cb0ccac2f73fecab8de2d7da9b1d4b6089d24c51ad6ddcf755ccb26c7eba22ad9eac5bd494535cd44dd4c4cdd6e787d6279fe7343b83f62ccbe6639392939d4c1ab97b1d8586d33d4cd38eeb6c37e53f7bbba9bea6628bfe7377c09bf1cbefd879f2e59bc622b7a14eb52cc6a97019d3b4b488bec3da2933d10504db514c9c858a317ef16dd8666ad355d8bacabead05bef12c2dc49c25452494832051201565a4290802082171048d288852c58a3151032a0595f11c1a6c9ed7e661faf9308296b687ab8212511e355696539c5ea242a505216b4828b667091f12673475ca42a0a1519f002152de09841d2852b091d7ce3be8a5e603396c2ffefdeb3b577d7dad7e85afead07865ff3d6b77cf473cfdd6fccc9035ebeeca9277ef299cfed8c63f2e8893ffcc7ffe4fcad7ffede9ffdbfffc37bf34ffedfbee5bf399b0315b14f3ef045393dcc785d6e7fb89cdd02251a5aa2ec7d5db82208aa1e5211470a386a600468220a06151b10e752762e2eb87841e7bbd3e1a5cd726f97eb28b21135502184cc9eb02cf1f9f5ceb10ebdcde155456ace5bf311dfb88dee564a94225ae5e1afde0d6351f14eb107cb7653fba6ba0f431d4cc7c136e3b099c6dd66da6fa7dd346ec7613b567e995c9b8a773315b334f035abe42072845975c96c5dba124a0a982420a4123d7b4a0f69455a671d74555d1a73aa92424232283d91cce889934926247422314021798df1ba9ed088058ec481bca05f707c857e1166b084e4b90c5d80b45c9463684d956e82260874fafc80c769ce7826cc424886b1d257e57ee4a3ae4db2298b498545b539abd08566884a40e2092d5a0b50fca660c479b4b937487e567245f8970870b3c843ca79ae7732bff6c927e5c517cf8f87a3b4ae2986a82ccbb95b0c2ae56d4ff9f13cefdd39ce172faef34fb6f9991e29b91179a5eea26e90e4f002ed3c3440c9c4323489e09212e6a4442950f08a29af4b08542982196ea010cc33ed153dbc500eb787f5ee89ca5ec515c744041052b832224fb89f67bf3dbfd0db809622b9194a8c83946198ea50aaf9b094f2d0fc7c3ff9aa41b4b45678b09e4c55f7d5ca30d4a1eae8360d65338edb69dc6d37bbcdb81987cde0fc32d94fa37573c7d634b532c7808da14764495b9316d99b4697ec09a40a22814448ef34b3567cb59cad2fe4711c7d5d2c555355439a0a88242048e425c84c1449689020204901e552266da505d15916d69579669db51db52f582df79f3bcf68db9d0612cdd683f485ea1928490a97a2fbf17e236b4324372691804aebcd1191d6521c140990e44aa7858ae2422769bcaaf76c9040c7af2313da8396480aaf4b5e93fc4bf2f1a2bf65333c66f6fcdaef45feb66ff8fa17bff33b3ff9d2ad63cf1393f7fedb7fe8c5ffea6f9cbf7ce7b1ebd7c78bf3ddfb7f63fbc8c75efcd6ffe767ef9effbfee5dfcbdc3bcf6c4e44d6e9f3a793bbb27e84d6eff6459cfa52dddabaad345db2918a281a5d6d40acea5dee88d4b32a082395ac942e74aaef42367b7e4f87c3dfdecd4e613d72141a4752e5867914eac5d3ab888996c84aa7a43f2186dcddcb899b9987bf5b19493a9ea50d7323ed19779f2c1b5b652d5867dadbaadd587526ab1b1d858cb348e9b69dc4ec3761aa6a14cb5f0cb643715ebea055bd34bd41a63f83199531774edd2327b647632822445308ba447f626adb1ccbab8ce9563b13adbe158adaeb6745d457b2c999248488f8c4e425e92202249d69e1dcc110187c8e8e49174105220c924165f5730dafa90734b4e9002f87acfdb1aa25d27b4620e4e7692b12d87328d322b1892202088a073e69cba5535a85053146a889b163070c4c28004a11548ae788aa468aaa428647245107e9ee48a70e5c1627ff081dddde89f5afbbff6e0c9cde0e9eff86fcf4316ac1aefd88faffcb5bfb61f06a3ecdffddee77eecc7ecdbbfad677ecf2b67f75a7cf761b968e22ecbf5277f40afb17d525ef9e470fe9cae4b2fa378557189061d31c47a1960a014c13285d709e2a8638e3a362015352e45a32fc4a1ce476fa1882201c76421cf42661fb021b6d7f022221aed743d2febd94619dcaa7975f3b16a19eb306d36d36e33310e598787f13bbb61741ba20d9e75370df5a416ab5e6ab16a360c3ed6611a87cd384ce330561f8bf3cb643bb87571c32d8bc9e0ba099d83055d425b664fe92d332553b9222904d283d6746db2a8ceaa47b10bb101af826bba8819beaab5b0a419adf76e19914966cfb49e973c532569593cb343102bcb9a3ed367a4c1822cb086ae44b73e874437423a09d29148d3b0163aa0099d2b914e4a8a1308c20c215a2567b848c225451a2c2a2e54653166d759e8caaa7410087a834408c0fc67b27db959634d7af2bae41720c8cd22fffab5fad9b6fcf4bc7cdde36f7a1bc7e77bbfdbda0a272e5bf33bcbf2e060e5e6c9fd176fadcf7ef2270e179f3d8f0794ffe4eed99dc805a6ca1df462f330dbc7f4c50f8cf73fd7cbb65785a5895bae5d04314cc38754c72425a181200e81555411c19ce258c51d51a2839186d6751865a91a79945855563874cdddf53e3e98e384efb58e52b65936296d3d7f79397fb6b68bc118c46d3bc4761bdb89ddc6a74d9926db4c8f48bdb5db4cd50664d456f79b61ded7eac54b752b26b5f850cb50eb340c43f5a1f8508c5f265375ed629a6ee9aa83e71cb284ac484b69d03b9192a1198108488a44d283b5f77565769d5d0e9ee3ac836ab9585dd3556cc535ddc283b5b3aaf6a06766ef1191a99111d2d33c92c443c85869640be991ebcabad06696a3ae47ed1dd81def7593282389ae6b5d57157a27d289008384b4e3d9d0e3a02eed0888ebda026c25120e8900e9010402241919d95269ee16b83681840c8204aa363f49ddc0185a32e64cfea7bd6bd03f787dfa6ccb1f383bfcc987ae7dfd1ffac31ffc4ffee445f42578c0fd9dc56672e342e795cfbff8bdf72fe657ce1e32bf7fe8ffe5f9f1568b481ea9f6f1ebef4933ba0fcffe902fa709d266a2a4aa694b8a8a000d4f8c84964807c1946c60d0c028064a03ed3483002101c33d74ccb25de738b4b9982c494e0fe470c2f686fba41266a8868e83ca646ec50e633bad9283890e7a1c877533e638b19d7cb3cbcdb4b5e181ad6f86329a0d713e6cbd0e9b5a2e99ab16b762568ad55286eab578752faefc32a96ea2a8629166597b8e296b4a4b69480f828c908ccc542e89a448243d726dac5de6458ece85e7e0ad28ee6a4735efdeb2ac593aa5c7d259d768913db24746f4b894d15b8668c74390cc58257b069a81a465763a74b477c1484e4c0f5a44dc128fb351a4216026050a2824c8385f9c49b1c8828a539086081ae89220f28eaa8218181444c1a1908264929284001d048c2b25f1a2aae2279e67d25384d724af1324b9f4f6a1fc7b37a667d7f8de65fe738f3ff8a0cb87fefc9fbedffb927cc3effca68f7dd7f79c832189ffe7b7ee0fa28f7bf9a9b9ff95bb879762edb0a66e0a1f3f794f8c3768cbf6a50f4a2e1566a9aa0508ad09228659caa0ee819182209929029e0862c81605a98863033240e14a471c01d9527a0cb38ac77a4fda6c665a3ceb9065e3c3e0ed50fa79e122d9daee4d363de5879b7e7c79eaf747e6d1b20db461dba71ddb4dd9ed6cb3196d78603b4ed5a6aa43cf61d2cab61477535735533775b352bcba17773775537e9914570954b19e2659345b4a4b3ad2914822892013521010c924a087acceda72563da80e6ad5d235dc30c54d7c89e2517b1e9b2d2d17a565b6c8de5b0fe95d7a6ab3ec484be9113d0369c1aa3a074b722066382017f4f32e31f4239af7cdba85f5c5f35c8ab435d7dd03dd140d5e13514b9efa64c7d37444e8d0209d25492ee5e8da0483aeb2885665563908837911426406152e19228902c57d4b923c6261198d7f4992f05bae0ddfb419beedf4f0dcdafef8232755f256cf0bfa4c3e35f9a7bee7bf3bd9c84ef8abb74ebbf054b5b38cefbe58fed1c53c932ef4c6bb26fbf1dddbb2b8dffbe474fefc289c6b3d22218246dad005508a851a577a6a82f3aaf4e4921aee1888531475048a7245b8944a82a9548f5e234b4459142995cd5eb70fd8c943c57438bd7b23ee3cd05a59faf9d2ce4f86f2e89795e3dd7afedcb0de1e9526f78fdbcd613bcdbb7ddfedca7623365cdb0dbfe7fd4ff18b11ef7f1fbf1c7433f04be1db3ff8725171c4682a62aac5b32e31ac39582c968bc7da63edd9c27ab4d6b3f5be1a6b98266d45a2d382bec4b24a5b5866da92f3518e076d4da28debf9b1472b5b6dddcfefee5c72cd96648af6200bafe9fd624d641d491a661240262d3213d1c97a894015b020e924206be892ed42e946451d5540d21111b435df2b15dee4f6a4cba7d7e45f34aa7ccba3db09ffbbf70f7fece6c97bb7e513e7eb71ed87cc0ebfe96bbef2a31ff8e097fd9fff2f7fed8ffdb1e797fe70b113e7874fe78fcced536b07b6c669637ef09d1f5a17d2c6977efa4996cf753d6620813b4262995db3a04a5702e860d0bb07625c6a0583149a600e95a63828444080d23b047d811548f3b42986903e9bb9988b7b1d37b594cdd9e13da37ee9f6dacd515fcee77ef2ecfcc537bfab5e7b4b3d6c868b3268afabe968b9dbe576abdbad6f376ef5da54f855e6daa6b8a999989b15f3d2eb9a758d63cb79cdb9c5b2c492b176d6355ad4b5f7b5c7b232a31a22b672e898d056202333921e44b758101f63dd4b7fa95c47ab1fef5c73aae8810c29424515842b29eb5186139fcf0651310aa8208802e2447bc0adaa1a08e25010010b5524a1a7b6ae02622838181470f08d3922fb5a7ec3c9e6dee9f1e535f9e706e15b1ebb764cfee2dd8bafdf969b837de2d0cf548e5887f70ce5e33ff1a1f7fcb6fff57cff10b82a82af3d8e292b2aa4180908a08258eb435bac88a02a049aa8e2818380a196080838aa8020e090402260a0e05c3247aba813c6952056322557d225bbd968a50fb6758a9b7a9d7498eab41fa7697fafbc7b377ee96e378df55deeef15fee672ab3efcbeba2fc3e9719075dbabb1b09bfa76d7375bdb6ea7e91a63e157997d55235dcc14532bc6b0c458e4d8626e31775d5696264b8f35646dcc4d966ec7161662bdcbb1892ca24772468f99a7c859c83979a41fc2ac1cef2e22cb346aac1b2e26d52067b2d7a13ba87025893ecc77dab0993c531041910629a407991b67e39a120d536886024a281d5d0417c5104105524410240529ee4636b2c2170f3247f97bf7e6d3c89b557fe3b6fef6edf8ccb2fc17772ffed29b1ffce25ff70d4ffff0f7cdf4804e56733ce6d6e6f9de9ffdd37f518487064be227e6f58796f92c11672bf252daeab1b473673d39ffec5449016bab284298a44a6a0f0aaa48a28402c9ab52c14814317ca00c88532631c52b8848d0bac40a4d62a1cd22088b68a88a9731b39a8cc5dd36bb613b8dbbedb47b607f7aedf16b5eb7db3b6a52ca7e187ea73cfda3fda1fad053c366a9711c73bf91d93d631c62b765bb1977377c2afc2ab3ab6a822b26e222d574f438b63caeb1f49c5b2c35979673ebcb1a8bc7dcecd8b3ae59029b457356090960a51db32facc75c6659cf2dbae4b28333addad1e57c9f68662357347dd00e9940802d17279ef7e78b411230132543443259bbc2ce75884015924bc99500228805358b68208863a982aae02a25d36b6049151ec6bfa6ea230fd800ef1eed7b2e16c920a9887558ba04026bcb13975ffbe49bf4b77ff3b7ffa93ff377bfe36fde547bc411f8c0c5fa91e372b632383b04b1d393b7f9f92bd3c5ed87637ed2ec9fcdeb7d844bc503cf5090c0b812a8d293003a5704b704cc90014664102d20d293f5546291d6240e924d6311ba24228888aa98b99bb97a2d3e9452379b69da4da36df7dbfd8d076f6c4336d3997a96aae3f0f6a9de8c4f7c787c739d6ed676511907e993c550c4c62ad3346da65a9d5f65b6839b869bba45711dd69c5acc9da5e5d263e9b9f43e2f2c11738bb9e761cdc3da874e5930565d1759ab940577ccb08a3a56912a524a2c2226e2822baaa22402622e28aa88009a48245d15c44440442c33411001070507094431b02e2a628a050aae7852452d294981011961c2261197621d49918434222048ec1b37d3336b7e2ae25b1eb9b933f9e48fffc0118e61efdc9624ea37fdee3ff1a7fecc1179dc861bce11ce1a1f5de2533d77ae37d53f9b716b7cb49ebe54f2f81e6b7783150d349114478a8a863aea86220e9262813b970c682e22257d4427ca886f44840c39dc9568bade1ddaaa2c1a4da499a4aa88b8a88a0ceaa66a5acba55aa7611c8671b7d99f6c77bbed7ebb5b1fdb8f673a4ec58ad41ac370af96374fe3b23c7defe1afa8514b0c556370195caa67adc5865aabf1abcc5444454cd5155706cfb9c912b9462eabac3d962e738da5cbb1c9dce2b0e6f99a754dd7d4486da1eb2aad5116d1153be21d39a41ed4dbb5e5de6c76ea156d23e72a19924be6ea4353c182d7f45ee6bbf785ea829020422a99222525c58441cd8ab6049106b381682a83d2a1218baa9802abe2489a889a98aae0645f24067111aec3af55153866ffe871fd588fffe3832743709179a4df8fac85076f5cfb7f7ff6854ffc993fb537bd2172afad2f6604dc69f991e37c6ef22697adf1fcf8d67affb3fb9cdf3fd6e796b82d796b59c225d541c3345511eb222898843a18100844aaa51774a45cc714903ca3add2679fef5b3b782c4e53d43445c46c501371171bd4abd5a275e3c350ea380c9b71da4e9bdd66bbdb9eecf627bb9d3c325ae9e330945a87a1d4eab59ed6229b476fecaa774a4ab12c4a35192db598d7525cf955a69a08aa9226984ab5185dd660edd19c356269b9f4985bce2d8e6b5c5856b3a26134594434901042e8a28104d1341a6db1e3bd2dfa920ee8a8f3e9b54c4d1658ba441d48e8bc4a75393f91bce3dba19df3aa6222a290de32c9adc94448e78aaa40ebb8744f32a44155854e86392529f81052b58f4131f10d928de2bc26604efed1d9f265bbfa6feda6db73acb0d28f3ddf64fee43bbff8cfffd88fdd836be802e64970afe7dd9e4fcfadc36f1ceaf795c75a6bd3ed4fbfc9f3cb86fa628bd31ed97249d22a21a19a28a1a9280225c2343c148d0684d62c5b7cc44608968568aca7b61e9cc5fba27497303535ac4c565cad9a1735b7324aadeec586a996a90ee3386dc7719c3627dbed76b7dbee37c34eae8d3af771dad53a0c63a957c65a1e1c6bdfb8a758882bae524cab6631ac982bbfda14134154d2444cb3a8b6c896d9c35a64ebb9f65c7acc2de79e87358696e518eea9406b7274195c66c10597344f97b0dead3c6484e85af6166cd6c3609a6423bba98819855014907271e754c4b21b0a98a150a04335b12e1bb10175104209c31c8c94100c078302052d9dd174142618c3aa51c007f5a3b1a0bcea136bfbd871f986ddf496c16f35bae921f3b872b3962786fa173ef013676a151e775f92e7d7f5c51e1f6f7c625d4ff5e45fd91c81b87865bb9c3d54e4eb379befbf38dccb5c9a2c29d42a588aa968d792085aa38c60a8684b625188b2c9b2c13760ac33d9886369dddbb94453baa89ab959752f56aa0f9be24587d14af15ad427f75a2e0d53ad5eeb388ed3a8b1d94d9b69da6d86fda6ec6d1aeca40fc357ff96dfca2f46bcff7dfcff8378fffbf8a5a0a3f38bf1ed1f79c54decd82592351983b95357c660219bc81cabf665acbed80b4db278397be9e62092b92473c8416b17c5120255221fa8dc9741620ee78aa022099920628a09a1d234411d9aca0ca874d1aa812a8889aaeb28c82513313705956ee2a3b5d3c61d67817b6b0e22bfeb91f1abdef7eb5efcc83fed1147388f664576cab7be7ce715e2eb36c3fd8cc74dbee3fee1136bbfb5f69f91e9bae4374d87ffa63ceec78b87f2c5c7a6f254d533d6fbc481ec90455308112e39a904a08471298570c0025224158a81d021202db8e8868a8aa02ae226567418ca507d1c86329471f4329452bd8ca5d6e2b5d6a9561f8671a8c3b89936d366336d76fb93fd7edad54dd5d6c68137fc923a19dc24345356cd2ab8e2892746164b0d8ff5602ecb594fcdcd83a5b507253d6841cf38a6a64f9a41e74a2a6d3e5f13ef534f401c4b15844b8981834b28105cead0a081252e3123d2c384ee992d702d588d2ca4722933c54fd094b8b792e4432a5fb999e8bcf2910fe4ca0a73b41bea1bf8f63be76711bfe3647a73f13b6beee0670efd9968afacf98ddb764387a797ac87971e888b770fc3af2bfa5d17cb7babd3928484ce154d24223410d411cf14407a231aeae1133e40656eb0d057faa2d9a4370555351fb40ee6c586c9c65a867118b6e3388de358cb380ca594b1d4524badc3506b194a19ea304ec3348c9b71dc6ea7dd5476e850373a0cbce197d47e30433493d5b219a3319bccca38d29a2ce7c7eac9eee1f9f6e7b60f15197cb9b375a7d124d64eea945428288282483ba60fd6962a2250920a852b96082894c440c040c010834892a4139a2012524d87ae43615429e0e060e082eddd1e14df19777a4f4461e979349957aa974f2deba7977551f93d27fb975a3691376ffc87ee1dee25d7c4bf62e78fb9fe1779e32bb9a520208860a03f74be2ea991890a561157f150c5aaca10a6a80be6ad430f3c6cc2378883919d442304445d44f0226a52061b47afc3306ec73a8dd3b0d96ca76198a6691ceb50c75a875acb504b2da5963a54afa58ed5c7719c86b29986ede0fbde87ed56ebc01b7e49edaa9aa48ad02184396549594da28a145952f793bf725bc7a1da491cd6c117471b462732d248e3520a2897cc255370424420848ea428444f124908d33005321150a5814357e9228bb2556be822d69d66d2d5bbb0aa7468e0b32412037cf17e78f602327b32d3ce7b2e4a5bf303c7b929df388c1f9e8f5fb71d1e1cedd06321bb04f0e8a8442c913fa2fb27fbedc707fff2c93fb6b6bbb4336385104931204cd34a17c5345cb8923087262abd0ca9032660109241066689092a5ec5ab4d93fb50eb308e751cc66998b6d366bb1db79bcd661aa6719c6a1d8671a8a59632d45a8b56b7eaa5561b8a8f43998a6d341f6163e348adbce197d4b688a11a2ad564551955e7a2bd6a4ed2571f8a6f3617e75be939c9905d8a57cf9e4146cc5da85b41208904cbbef8d91dd44652483124651084c88404d214e9c1cf27745460e998255d3a3d48344895b0d436a7cd3d132af8132e4fd5e98525ee5cf431c9206189d4648e04964e819aac3d4a8a26b7cefbb7dd3dbcabf89b5dbff3f6f9739b877cbdfd701e1f527f9fdb0bf3fae387f9d0599380f44a4aa8259689026934e152ae10a0a12571107ac22c2264882014d1a25eac8c65188ad7a1966118a7a16ec661bbd96cb7e37eb3db6da7ed66bb9dc6692c431dc6eab5f8504aad5acc6ab1625a5d07b7c165eae70f6c375aaad5ca1b7e494d45559054bad15dda247d51414525ba1df79af9e0bc7da90cdbd52cfbc9e0c8182c86281b552f9989269288f4f944e598514404a930202eca9510d29082b8a88272c541baa2bc263a082a5a104bdda1046dcd85d6924b5b153fb17217f1a22d804c08483c84a4fdd861fdcddbf1136b7eb2e56fd86eafd5fac9f3f95bef9c8d265f3ad60f1f97e7c787eac5eda78a15f17ffddaf6db4e0fcfaeeb05da210531413431a48a3a08588a83294d02d4523c6480020a22e28098a815f1aa66e683fb54cc87b18cb54c63d90c75b339d9ed36fbedf664bfdf6fa6dd6edc0e65339471f0a1fa50bc9a55d7e2e2a645a59814a5d2f62c431dc38bb8f3865f52838b20a4924e3a5de9550821e8475d36e3727b3dd9698de9d0c6e5e5cd763a98a86693d069a34d7b64422291bdae7796229699a082204008011d4234414443350c924b0d490111aea42a267497156dae0765858043e4022a3c8cbb682ed9153a74613596de67cd4f1efb6762fdd2ddf0ccb2cee483b53cb8b14f9f1fffebfba7bbc27bccffe397cf8e5e6ecacb5fb4abb796f6cdd7a60f2cc717da724e7674355224a58418aa6989d0d5b0126ad089440913b0a80322a870c944d4d40651d3329815b7526aa9ee43f5693b6ec6cd761c77fb07f653d9c7e9fbee7fec9dbadfeba6e6a6305606b21e9b1fcd64dab96ebc6c4dd589d28f1b9393715077315333def04baaa86092a169922e598c6910900c598b6dc6bedfdfcddc99c9faf266da1c600d4aef4b16cf21b537fada09116fcb36b8881c49c00c174c848c8c0c08d244203202949fa5642aaf4910a0a3b9acfdbe0ae84c1c224d185ce6c0357088cea58416fd98f9d179f9f4dabf6133be34b7db6ba2bc7da8cf9cae3f753cfc1af76797fc4bf7cf97cc719dbf623b7cecb0fe1bd7a79796fe8fcfe68b9e3d598984f44282420f89082f4088105d33214009d28500e192489134c922a22a6e984381aa31ba4c43dd8cbbed60fbb3a7bfb1cd87e376dc6dafef776d9cd6cdc6a6e9ab7feb37f28b11ef7f1f6ff89f16ef7f1fbf183a39bf90bffbfd1f90a596655cdac97d194f7cd9adf7600bb2224b8fb14e313758a58ba01d74392ba22a59483207644851d196bd43704925d3450b108822e0a806ae6260e0a423061aa09cb66cf40ed755b6e050130fd51ea41170ccbcd7b9089e5ef9df3d78ed0387e599a4b8fcaedda6221f6beb9dd0ffe17c7ea13790c78bbebbba21ffee03273f7a983fb62c87ce8a0402880862204a828416d16a5a5003b47741530aea5d0b5210830e0a26a22a6ae66eeaa6c5cba0652c75336e3743dd4d76bd0fd7261d76dbbaddecf6fbcd6e376d36d366e20dbf22eda6c23a581b4ffb76679be4155bb717c20c4542336a8cabcc21d93b124acbaa6d76299109a4201242271658854e1aa2c82ab1ba1a9a209088032202021826d65d0eb0422a8e5e577dc8a5081551cc978884800ee7adbd18ebd3737ff7c63e729c3fbfb6b3d61f2f7a27d6d1ca0f1e8f3f35c7290dcb874d1e32bf0bbf7f5f7ffc303f9dedf98cd93392d6c1244591840c01b574ef45420d3aff5c2897d24141112ba245cdd406abc5cd4a198b33141fc7cd6637eeef7df47712e7eb249bedbcdf3fb0df4efbfdb0dd4dbbddb4d90cd3c41b7e45da0e2edbedd4e79572a2e7b61ea4ed49e6cca5f5b39643afbd67f6c85410e130246b2713225553533b04ace40a4922d14053a28510a82a24341053c0c040b2f7108184eb66d7249438362daeae8cda9dcea580857e67c94f2ffd5db51c5a7ca6af2ff758231facf290c9ede3faa1c342f0a86a5596e04daeef287a6bee1fbc58ee662e2d33092e255d3025b92290a0d093e8bc260382e8599c54c9201055e95d51d3ee7841aac4a03e56db56befaa51f3cd9efee94dda3fbddb5ddae6c770fedf737afedafedf7b6d9f571cc61e00dbf22eda6c1623df6dd89b6448676b164ebb0044b6323c3ba049104225dd658458a7a1384549122a289408280f404dc50c440c0410255140c2c31502841513cd4c061301d2109034b6a6281ab6a8325f2acf3a9d6fe97d7f71f9d97e757ee463f47c7c2976fa74787e15b5fb97d1afa54f149f8a9b97dedc6bf761a3fbbe63f381c5e49bdc89ea89080206020bc4aa58439a88a2b1608348314c387d051c4d10a5d53d5aba917f762a5161f6b19ebb48bf51bcf7e62de9f3c756d27dbddc97eff5537af5f3fd90fbb9d6db7b9d9c6b839949ab5f2865f91a67128d95465f525b26f627fa6d284593828dbda97f3c39ab166acaaa63d9a595511b52e1192d0930e2bb9a434174890145168288e862aa01441440125d364d54b32c24ebc111f8b68f084a88b6ccd07536f1217d9ef457c6e6d47cdcfb6e5c5d66e473b870bf261f3993e3d72539e7f19e2d97579fbe87fe0e6f0f1b56f8df3b5dd8bd68524d358213ab8a528af935eacaba305f7401034b347a043d49222a222d245542b6652062f5e87ea43f169b3d99f3efd3ba6f9de66fbd4f593edc9fe8b1eb8fee8b5936bfb93b2ddeac98e615acab00c2343ddd48137fc8a34165b63ec6847653d2e7d47668b683de7b52ff4a5b32e6d5d5acfd67b46b40c2c928e042af4cc95583a4b92204292dd08b469b0621209121aa08522b86249a14f21d74ceff6f599b5390c26b7b56fdd6e42c13d3be72d3fb7b69f59fa170df63373bbbde6d259325b725264e9a8570f082e32bcf3362d4f0ce5074f8f9fef71b7c7dc73853509ae64030332541103d714225aeb605ce92429426ba2a6124257c5d2dcac0883323ad350bfeace8f3cbed9dc1b378fedb73e6d7eddcd1bfbfd6edcefcb76a3fb2d7558ca701c86ac75330c8b396ff81569a85545423450d6a564f68cd673596317ccba2c3d97656dad475a2ca19a6e4e8f55422d2de864ebda48810449ba609d6e4026427245c2d09a0cc90083b20d19d04faded98bcddf5d16245f8e9b99fafa832197e019f6bf962ea53834fc6fd95466b58120126ae181787fff97ef3f621de39e863c5efaced6c8d675a7e74692b9226d9b824644a1557aea84ae9aa2926523057ad4440d38ea8062662292a8194342d5ea6a25ed5062fd3b87994b347b75ba6e9adbbfd4327275ff2e003d7f6fbbadff966ab9b1d75ca3a2c75c852875a572bbad9f3865f916a29021d8d4cede345f625fadafb146d129df2e262598679f075d510598ea64b16911490de45c839589c9e02044447c11c1759c0a08b1a1455313111141155978be0a797fe4563e98d5b9a5bf485a5bf6d186e455bc571f59576966d26af177d796df7c8538d8b8c63d084b18469bf73ffd657ddd87c59c6adb9bdd2db85e4f72dc78fb6e5202c644bc2899e98a67229c4704f2d1dc11cd550e392a291a19a66a292aeaa213e9a552f4319bcba8d6399c6bad90c5f7bf6f175bb7972bfcbedeebd0f3e70ede4c4f75bd96e64b3ad5ffb75fc42e2fdefe30dbf7ce2fdefe317a2fb3dbf906ffb8eff766a32cd6d1aea4529631de7b92ff40415091020af4446effcac48147a9248229d4bdd108d70554f3550cdb3997b997bf8e421de3ae96f2a03f0be6a7febecf06891c70724d36f1f7380af28e5feda2e1ae711738b155a92e02d6e54fbfc793c60cbed3593fe997579e6901f38acc7ce4264e3527049b20312a240a2192042870ca273a5919d4b695817543db5871775b12239988caa9b617ae2f4a7eb667373bb8d71b3d9ee7cb3b1ed46a78d4e1b9926def005619a3687c65897a9d6a196eacd4d5d52c47b9aa669744112e8a2c9cf2740474c785511a9c2a83a628320c945cb7338115cf8a2ea8faa9db698e12dc5c6401a35288a7f34da57d47a37e33cfd9c768055b4254d804cf38ddb798b3b5d362677175e5ef59fadf39c24d035794d8a28e629aea221060eaaa8a8a5a862205c0ac45cc490821657b73a7a194bad4319c7aa9bb16ea7f1c1c676bbbdbedbe776fbaeeb27d74f4e86edce365b9db63a8cbce10b421986bab43a54afc56bd5baaa9b996ad5de8dd00c5a13255793e08a40901d015468220a0e222a206a29320b678928274881f74ce551f33b3d56e1d205f2d661bc174dcc10fcf75d9bfed961bee87141dea79f2717e402ab889021712476452239cffce958bf6f9e3f17ed829c2557a7251d12521d244c5315911442411495500394941e381409c45c54cd86e243ad631d8671ac753b0ebb69dadbe1ab1eba79316d7cbf3dd99d3cf2c0b5badfdb76ab9b9d4e13c3c01bbe2014f7e256cc8ab9abbb98811124d2537a4a870822680188407245924b0608085702e192a12d99330a5a0c82eb1e25e3345713f1644e1fa5dda54324f8d3176befb104c760e9f49e2409bd77016d7168b9335e5edba78eedbbcf0f9f5be398b96466cf480212100542840842d14421410292e86222911281a21d144bdcd345aaeb586cacbaa9b61bfc643bbcf9f8393d79e064bfabbbfd2327fbdd7eef9bad6db6328d0c23b5f2862f08c54bf1528b1777372ba645b508a16e6a2aaaa24534494114049234881487d2298683405106d51a74658ed8a83e68f252cb6f98ca71d5177a0319541f2971b7b58de826b22405bc210b3e471ce91102022474a82a053f06c7c64f2ff1a1b9bfb8d293401a7424854b82a4b9882a05082e0988a1a0899a3881d244545244cdac58a9c5479fb6b56ea661da0c753b4efbcd74b2dd3e35de98f6fb7ab2db6ef7fb93bd6ff7b6d9cab461187318b214def005c15cd5544dd54d5d31c515155cd248271b2d2552c225c1844c593b09e95c11010444355417e43c78d4fd9af242cf7f653b5d433e11eb29cc91127dd4d292cff6f64829aa9ae067d2ef67dcd33c8b7ed09c83599893599b899e597b3eb8d3e34796f5d3bd1da5cfb0904b122e910420a470290454d30448215411b2144004e98998a8697531d33ad866b8346dc7cd66d8d471bf994eb69b93fd6613dbcdb5fdb0df4f9b2ddb6d4c9b3e4d328c51074ac59d377c41505115515145f412221102420a29404f2288a0850a18743231a88de26a990a26624127d6e089a24f16f9f81abfe3a4dc5bda4f46bfdfb30b0d5acf5bc975954f1dd7f75ed720043cd6587a1e22d6243b24977a44ef60dc9af3a06b0f5e5ee3ac4524119964762233b8a4298a110ad98900074181408dd64444058950151357ac8817f3c1eb54eba6d66d1d769bbadf0c27dbe9da7658daf664bfd3ed76bfd9e6342dc3e075d052d25dfd0a6ff88220222aa2222aa2208481444a1709918e22dea523820878674e488a329a0cc9a541a572295a67107dccf447cfdbffeca4debac8dbc4a167239724a1c39adc70be6af41b6996b88837f1335aa0014827512e697249cf83d3ce8badbfb08488f6888eb41e992290206298018a810722086a29a698888bb888185dd555cddd8a9b8ec338d6619c36d3b49da6dd38ecc7cdc9767bb29b4e36db717cdb342cbed97ec56ffa4dfc42e2fdefe30d5f0084144248d554452415b14807d734d259437a977051a1c1da48a82e05523001bc652cc9b5628fa9fcf812ffea7eda887e9c754e3d10c79406264892220f5b7da5c7ae1644d3d5ef661cc89968124d5991995c618db8303ed3db59701a11ca0a8be64a8690992b649774454024008d544504915010a4480a2aa80898ba69a9328c759886edb479d56ebbd9efa6fd389decb627dbcdc97eda4fe3c14e1fd96e79c317b644121232882482e8b4a025195cea291999410f8cdec9a40a13ea2429c2a5b69037cd9ef47c6ee9dfbc1fcea37f7c594f7b1c93396942034b1ca6ae9febcbad96ae05cb247c5efb9c7d097a1289913d2e91c9bac44bc29a0134983322257b0299242090416a882010010a89260992488a36d74b69220e45b5988fd546afdba1ecc6b21feb7eacd7b6e3c96638d90c27d378b2db52c661e00dbf1a2808a288201a29882012221d01ef72eca229340406f2c4981015212141722bf26eb7a797febec96f2f792ffb6970112474683d125002ddab1c1a3754361d5794f445856ea6bd7701e9a02a4417b40189a0404282480a22a060d0115010c54041030149c44431155105074f2deea5945aea304ed330edb6dbed66b3df6cf7dbedb5cd74b2dd5cdb6daeedb627db71bf197663997ce10d5ff084104991504948953449274dd224559b4b4742045861275204441b205ceac483c59f09dc2cd41222acd1134924a1a90022906cc56f65dc5035513103fc42fb1ad932d3889e1d66a2691024da350cedd0223a0484d3205302125225c450e5556902d6453011539114d55430936a3654db94320cd376dc6cc6fd6e7bb2df5cdb4dd7b6db6bfbcdc97673b29b4eb6d36e1ab6d3d011def0852d934832c82082ecf46611ad253de84944b4e82d2e7548d81719529408e1526606ec846797f5e1ea6f97fcc9de5be479d285859c3316302049d19312b796fe5055f3e055ce0a01c9952481804012212c900c2033482e2969103d3509044f147a20249704eda44007114d2125452d4c70d3c1ea586c2c753b0ebbb1eca7e164339c6c8793cd70b2194fa66137d5ed58a7eae627bce157014504514440c152141144411190e05589c024a208e00999c7e461b3f3a5bdbdf8af9fca4f1ed73939260de68863d009405151f68aa1d7246e2053cad005f0162a8480808080a00a051004120c2431ae14b2831a747a4a8a2b060a04020e18020a187852cc8a58d5329a4d364ce3b41987ed386cc771378ebb69da6fa6dd34ee36c3761a36439d8632d652dd78c31736012185144212e1529a84932661122add24d1be40612f08969042103332a83e55edd3c97b6bf9f0d24fd10b40b8d763869e9839a02a293c39fa6796589a4ebb52dd4d54145f2c1af4cc15d62e2b34e3521202096b9080215041a02701b364c810225c72081270e9086ac82515215cd39562524c6ad5b19652867118c771bb99b6bbcd6e3b6da7613b8d9b619886320e65a8a5162b66bce10b5b2609996412901d9a106492414f22e616198133110f8b42c0ff873d3c81ba36bb0efaceffdee79ce7b9f7bed3377f354faa2a8d25d958b2e5016c6c06433098c1400733850e24ed6016a11b924ee28e49481b13027443921506036df084914ddb60882c4f58b2846559d6ec52954a350fdff00ef7de673867efddef5b1290aca5d56b79ad8a84e4eff7c323a66022eeebf4c786f11b96fdf373adb081864fc6dabc094500e78c1abcb6e48f4ef5fe65520d15cf7d92becf58702a2010025077754e056752d038532043425ac414810529d000a739a734e3c1a97004c40995536a1a49218b16d5be68df956557965db72a6559f2effddab7f099f85bdfc02d5fe80404241c0f9a251735c150202410212d5abb2dab20040816d488f3aacf8dfe7b7716cfb568b0756f30b90f4e8d282a45c039254e523af8e2bef4e8d2e93b5d7cd997c77ace684a106e840467044984a28e3b2874d00b0b749101199aadcd231c4d8a40067754d040120a194445129a251529594aa7a5d354522a39f525f75dd77779d19765df71cbaf4a01413838e22a41704af14c243c3142942c6dbe9854452b9e51878dd8aee8d5ae3b8cf8b89144d616aea9b6387137e83415214353c53178a0d7c7277d28a7d249ca9a977d7add9bedc31fcb216ee04a23a6a0499860ca29877004547547e59cb212d6c69875f036655c129fa2044222445c39238400a2e05928294aa2242d25e7be94beebbbbeeffaaeebbbc22dbf2ab99b9bb9b99b79336f55dda259548fe6115189082e482c607253a1e153780f97baf42f67fff2e293d1f0ea6af83a7c4432d183824175cfd0e0e16ef9e45c0ff18b9444d047a4ea87cf652c2022b020413307d471ce14c8ca9e70af725ed2806fbdb5ea538dc83d6e0888e3a0292c5c83330d1455c4859050095789242925495973a224292a254949ca2dbf2ab9b97bf8990877dc24820808053304516bbd88bb132470c2821d91975aba82cd8e3a1104de2c3c20228b48209c11101020d0400309249086cc664f3f939594b106092a22a0e09020c142b93beb5da53cd06bc0e3539bddd7e12122888a70460107d12c080128b80659352309cd92b2644d39a5923527cd5953c9a9a45472e2965f95e666736b73b36ad63cdccc71134c30610e71952e21a44d840aa7c6882a72dc2d374dee4f3181e3335a61c067914c24045107040f029aa0e457757991c952148d89fae33fbebd7e3d7bf24ab460361ad1d45d304059095793ee16dd51b2ca444c1a5b6510a69c4d13282899704125445d38a53811411898e092bc242f2572273949ce29a79434e594b2a694b8e557a55a6b6badb6566bb536b779726b6ecdddbc7973cbaded11b39b8517648a982c5296ebcdef8869edb284010f640c66710f5414618b6b0051a1095d962763fa3d7bbb4f4c53d33a491e877178fc631bf38c8504678233ce19479d9dc279e4752a7b89ddc09b1f4e76bdb6c3ea9132ee9c12a781661c51d7004c389524d050404422445c04974023544225945050e5965f9de6b94ef39956db3c57b1ca6c569d1ab89760374bae32052938550d8102fb3638da2b271e82ccc468d120279681e18a380411c816fec0fef2d9b17dbc0c8755af08b532841b5890054990414120a3ce1955ee4cfafaae9c4f9a9084806e9c8dd3504115451228b8a39c72844f09305115912459551222a0206e824b8410829c41b8e557a5619ac6b98eb50dadce7536b78acfe20d37a1682c4c8e890956aa271e2d09c811fd0193a88c50451ca6604680a5c82c7848068159c489160ce8aacfcf567570648b2493a4b110c9969883c96842236aa202891d9147560578c6fc52d14592676afb2471437cce390417014715343438d3105e96419a2452e7b9b866cf2512e0a2228288228a082208b7fcff27dff4413e93f88137f04a906ffa209f49fcc01bf895d09ffb209fc9d1c9bad53ad77918c7ed76586fb7ebf5e668bd393a596f876198c653d338da34d63ad7a9bad5296c0fdfb86dc2339e4266dc8d93fd3b969be78bf818d4e05483d930289cd2313c2315717c762a7235e9b53a7fedfef2a4d54ef224b12542b9a42c772587458b539c71071476555fdfc9b6f98d6a45f5eea416fef1b13d3dcda3492425020d4e7903c4f994d00c829a9195c08d98892436e319339a11166e841341041edcf205ad99d556e7699ea67918a7611837c3a971338cdb611ab7d3384c6dd8d8d4a6a94973abde551f3d8ee630635ff57af58069f74a6eb5b7a848854cd4a0814141561216ee464b11167350214b7cc9224f2d2e927b183c54f0d64076b55cfcfa3f984525993442405060075e5fca1df0ecdc26e4ce24bbaa8f4dedf1c9d60dc98933a2012284227c8aa382420249a0480a4dae6a912cb27b82842b08ff4670cb17bad66cae6daaf3384dc3346dc669338c27c3b01ea693613c99a6cd308ec3bab569b066d15cbc579e1f638452e4d0428a6c16575b2addf65a246910d0106fb84080409200122138b8e0b0c8b297f2e4be71e414229280f349fb3beeaa2fbc901b3e27694685a620dc93f39dcbfce4546f8a74b097f30bf87bdafc2c3e65421411c04540f914053492704a08f0902044081534459210714da1c911541045b8e55783dada3ccfd3340fe3b4d90e9bcd66bdd99eacb79bed7abddd6ed6db717324e3fa7833318fd6e6bed9bab5c99d3089081c2214b54a78b37042c11117ce083987410d042298920488c57d5db9a393a76b7cd28657a502410a606fb95cbdfec117dff12f7233e214381ece7ed2073287433d6e2d84459273f87bd6f327663bac064a724239a506c119c101878c4218244e4510cd5ddc9347f66878738c70dc70238c08086ef982566b9de77918a76118b7c3b8d90e9bcdb0de8cebf5b85d0fc376331dbe54b7539d269f6ab46acd66f770ef60273869442e469fdab1d66a88108e384216d0bed5dc9802900626122981f7f81797ec35eec82919aa5282cee892ec2cfaed4ffccc983c0b2220a0ae01f7a762e88da8862c907b737962e0138d6bd55ba8888082806828224420bc4c1d704e892284422252a011c9488e42729287381241008228b77c41abadcdb54eb56ee7693b0eeb693a1987f5389c0cc3c938afb7431da7a1cecdaa794bc1b1fb9173aacfba6ee6391fadaee255ac7ae9058f68880609112252b6d170c15272c9024448b3bda2f794fe666d0f96bc83ac24052c93ac92ecfd5ffeace4d4ff95efcc2d512d1acc8a087b1d2f981d4b788a7325ddd3e9f74de328cc4acb84688870465d0414e18c2a1049207346001344c4445dc4925a4aae12aa962494504113aa8870cb17b4d65a6d6d9ae7719c8761da0ec37618b7c3b0de6eb7c3301f5fa70eeb614875a2d56dad877334d185bab9cfe6e3eac0ba83b27e360427693892f99408c45ac49c1068a9e75444aa9bbec86b5765a7f8476afbf58b6e535d3309eb25f59993ffe12f80cfc573b22038e39e010bdcb1e054730a78bc54db50cd0344488022460862a020b8070a0a8d532a9088c01d6f78c21a66b881838313ce2dbf3a586bb5da5cdb5ceb34d7719887711e86711ce7691cd91ecfc35ce656a7266e37a7304931d7a572b352727fbcbab3cc6b0134d39a84188242a011a9d60a02ad2c2377b897717390b92cfae525b7eac72df648d76d3e28452ded1676116f4d45cfffbadf9e41326190d0732a05264342ce2579ddb254f3171b271e354410ce280821498850100450c05d504070501412a1110a12a1a080875860200949a07cfe936ffa209f49fcc01b7825c86ef099388ff04a90dde033711ee19560eed5ac9a4dcd865a87da86b96ee73a349f86ad5a3d9a2b5e11db864db9a3cd12ed5ab09bb8b6ba1a40b4484522104c1594332eb129a233b4b2ebdd4a88d48e0eb2ddab8bd72fd2035dfffe7156d1b52152767371b59d9296a2bb5ffb9bc777fc8beffe81efcdb350910aa671d72a9f444c29022e94d489beb34d37a20d42cb128010c2a7388a089fa20a0482f2b2849cd2100d514443b26b8a504ea986e620051a424470cb17b476ca6c9edb3cd769aee3344fd3348ed3388eb63d9aa669b429d7b9b576383592d0e6bd64cde3a5fdbbebe2b24ed7dd0d44a9240407e79459369b52b2b468dd0ad56eb87e8ee9deaebc2ac71b5792f0e76a3dd7eb47eb74674a07bbddaab6e5830f747ff84fd83fffe1bf7378f44c580e0f87801db868f1a25972b272b7e807b7d313d5b71ecddc0350049223ca19030105c11b67329f16a8102288e31616d122ccc23cbc5933dc233cdc3ddc835bbea035f3daac36abb5d5b9d5f94c6b6ee3ba8c9bc3463fdb3cdbe1dc5a5eca3cec861db668cbf3b5bf8247ae8e165a1317e15481c05aaab3918212dd41d2828deade21c5e9a1330c2ce81a882349348bcd6c07bf766dbc7654ab5bf30cc299b89ab5d3949c7de56a110b1eaffe426d411092a1e2903815402434007148a080f3bf2320410a3444107591082cc4c51be698b9999b3bb77c419b9b4dadcdcda6e693d9dcda546dae73196e6edc639c26fc9898fb7d6b6da93e34d9cdf2dcb907d05e6cdd4aa75e31d19441c009c49ca49c921c5a1011e40ee5bed2dd9df5be5456496f34cfa2af5ef60b238bc4958be989697ceab91bdff1dffdd3a3e1e916a3696e1215e660997416ba2ce7546fcbfac1b15e1306d12a1199060188068a2867d401114ea9a2048243821048a1ea224d240b8e1a7848435ab8410baf16d5bc5a70cb17b4b9d6b9b6a9ced33c9daa759eebac272f58abeb71766bf3dc26d9759bc43629cc352a82267c439da04140404040039401ccb5b36ed58ae669b8305f7fa8d7bb8b9c535d282f99bf1476db42ef4b72a83549f9a58f3c7af7c12aa6fa8347eb27dc06102547702adc2f410abb2872113f9afde9b94de6e646734e0567c44810bc2c405040f186039953ca19374209222cdc9cd6c2aad739ea6c56add6d6aab5da5a35e3962f68f3dce6b9d6b9b6b9b6799ac7c9c629553b9e9aabbad9a459cda28dee1116025e32810402dad030422038e52234a916a910445e9571e8c69b0f257fb8e473e81229e173b0e3dcd3a70bc835e755ab7268ede2fdaffa9177bfffe3938d110df69364e14c815e65577211c6e0f13a6d837014e992603854ce0804c21951fe779c97354713208104299090688105cd7df66656abcfd33c4d75aa6d9a1bb77c411b5b9be636cc75acd3d4e62934eaa68635c12c1a1260224852aaa129a7ebb77d396de09416b2511b92408210156a8bb274f0e52590321dbd2af9ab978b8b292d4457099085852a77a632848d96979a77247fdfcfbeff4373dd042d2409972565532c68499bea9c10616ade12d568aa8eb790267810064942130867d41104505481408533a1407239d34434e59cb4c21c74505b4cd5a666536de35c87dab8e50bda304ee3344ef3344d739de756e7d6e61ab689246d9c446a2ab23d8a3aef25af395d3bff3036400d4c7ca055c710230222794d7e62ba886eb79645bf79e16e9ddfb028570b8b4cc10b2425ab76704c7b31ecb75edc3dacb584feab3add24462149ec245645324ee019ea6c2dfb044fb7f6520b33c7291e1d046e467308a51828671c9433813b20fc1b190c7128611ededc3aaf567babf334d571aae3306c87c562dbe5be94efffc95fd8df59edad16bbcb7e6751965de9bb5272d255cf67e26f7d03bf12f24d1fe433891f7803af04d90d3e13e7115e09fe5d8ff07f24ffae47f895d09ffb209fc9d1c9bab536cdf3304e9b615a0fc3c96638596f8e4e4e86611c87711ab6d36cb63deeea74bd65198faae379c53469b3159c341d6e7b43a43d7c940054dd34c02190e094d4d158445ad6bc93da74a16ddebcc8f74ada0fd1e62a94c4c2f34204587b88f9474ec6676d7edf60d7ab8f9cd911cea307908104826e026b71147ec3c2830e968a9272f8e49a531031e344c7bf968890c419e57fc31d14213b914370303f65d5dbdceadca6611aba69d38f5dce25e79c72d29c54936a525151d1bceb5b6ef9bcd25a9b6a9de636d6b69de7ed386fc669338eebedb81e87ed306ce73a4e73994f6e1ad636cd99736f9ec58e72e218ed733ae9cf81314b4896a89091194d18810992449a2eadbf404efdd193afefd2bda5db51b228a0898cac24ef66318feab6df751fd8b6476bdc70d688c139914b59af6629a239441c05791a2bc1e834110352ea851ef64953c4c65cb41d5726e55f13c00510505438e501840a9a91531a925d52d5a4e129985dc6995cbd9be66e9c4a5772b74ca56a699aaabe4c342fdb8da1ebb8e5f3ca38d779aedb69da8cd36618d7dbed7abd3e599fac37ebf5c97a7372320c633e79e1641c4fe6d6a6b9a22649c61bd471125f8a5f3bf76a30bc224134acb95670dca021916d6ab98836cf528617ef91e9d57dbf48e6a409cfe2cd4839ef74763ea563b72f59947f7c7d53154fee84111684e0ea4d922532110a426c1ac21985043bc2beca2549cb4c6d3c2ff6283cedf69c07c2bf158e28344e39109c29d0205b409884634d35eb5c2567a9439aba9253eec69493e6224945957004c93d52776454825b3eaf4cf33ccc7533ce9bedb83ed9aecf6c4e4eb6eb93f5767d326c377af3c5e3ed787333d561a89ee6d4c5b09569c6631171dc9f0f3d4783000f31136fb9066e0404e22db5c17439ef5c2d27d72fdaf15b97e5363405600e118220010d15c48806c107c77a1c8cf8d828ca852e9d77dd4974e659900201c219850ef694d72df283b9a820d0f551a3bc733bfd02fac2d82215085ea60208a198f3af3982839044240423c0456a4e5a9992e8d0529a350d228a16340729021049cbbb36cf94dd9d2cdcf2f9653bd7ed38adb7e3c97a7db4599fac3747279be3f5f678bd3e3939391aab0dc37a983669679436a6dc6a8bb631a4cf32549d2ebe9e5c88462b8809289004121e02a98dad3b67cb0bc8e2623c892808a4c4bfa102bdc8819655925f1aeb3f5f6f9ead761832798cae02fb49afa47221e99e501239345a8048430416c42ac903255dccf9bdad1e460874c86bfbf2d6dde5a336902234814380388a280228ff5aa8203944438b66f554341575b090e63493da74ac9aab6493dc480615c9e4e56dcfbdbfed1f98ea4d736ef9bcb2d98edb61bb5e6fd74737879bd7d69bedd1e847ebcdf6e8e8649c397a6e3b6e0eb5ab473726e9e656d95e0fab3bdadcfde48e2f892460b81395982266f71933dc504fd61087e67888417b4daf77f619f1115ae0b010efb31ec1511b4e1a1f9aea75f3a3e0d8bde20617bb7c31c54ea22b4e809071ce4440003bc26b4abe22bc6f3b85c4d59c57c2183c31ccf7affa7b14694e31083ecdf93407e5d3123422e316487843652a5d96f0b0b026d6a44e3a153449cee482f8ededfac327eb83837dcde9d9f0de77b8e5f3cab059d7e39b97c6edaba6cdcd79fae9f5f664ebdbf5f17ab3f19317d727db9bd1b793a3b9790bd3e1469ae6ece60e8b45e8124f6038a7c490401d7508b048e3c6ca128fd0c5f2c6a3af2dfad6dc2d0882d630ce186cc3b7c4ba7118f6628b237cd3d8babbb0808bc17984b05a4505832c502090008544f4689f18dc765416e812c219dc0a2c500df110ce04a0c29900e1940708e28212220a626a6828e60953244b13199bb8884ca2bde4868ee455b9f1cbc707fbb777e9a9409a8370cbe7952fb66d52d73e4d27f37a1a5e1ca6e3cdb85d1f0fdb93ed30cec6304e9333c9c2b637729bdd3d244241129a8904c2a9d6245007cd84e3813b6989769197fdd153f7697d4dbf5c650d989daa1e6060b076b6ce26fcc8e486c7e08cee35a2485a895e10bd58d2b77ee5972dffbddf31febdbff7b68f3d9643a505080102f7f5652ff3d353bd6751eeeef46a2a4519dd3e36fa531ebb25a112aae020a08e202010899471072265106411595a2aa41c7929b2206534218a8305b34927cc50e4e18ffff3dd83fd0b7df7d11b1abbec210b4dbff88e77f4abd5ce6a75e7d52bb399954e4ba98b3d5d243e137feb1bf84ce207dec067a27ff4037c26fe5d8ff02be1dff508af0479d707f8778988f0991c9d6c6a6b739da7619069bad8a67eb592dd5d75a7d6309f7efcc7fed58d9bd74f6c7374633dd77674733b6c9bc534b5b9d5298adae4731d555278864f5e7c632878038311a660769dd5c39988487533774ba0adf65f3b3cf5eabe9c2f3199393465c61bea8ee393731cb1714e224edca7f02621c22af94e4edf76cf79112d5ffff556d7b51d49918c07a702810c7728ef59cf25f1c8321d24296a4a5a69ba9af4b8556be14988c6a785828728e19af0460492886692d08a1752b822e12a7880396d2605de49cad21ad366f7e8a3fb79bb3fa7e78ee346abbb12e7b29065d4c8cae545b979e346ea7b816179ae0b6ef9dc6a66b5b55adb344d791ab54d69b110d1101015627bfde6c9c9fa6413c37ab36de1c3b6afe34bb66c356a14c64d99c6d163d7bd084fdcfe95907130e354338948d520340c0bb14a5ae6b069e7ceeee4fa43a53c98540d731c6fce1c3836c3e4b1758ef14d631bbef59889044bd515faa7ceafcefdc6dfe4f5448649f6f6babb1ec89fbc9e81cca72de0d1c94ae2f5255f4902b8a3d0c1bea8247fdc1cb204e0a0bc2c11a119b2e25021392985e0c98a4620a408f510691142f81c0d1c3a65acaf7ffedde73b7dd5b9d56337582fdbcae5f69457250fd0070fdc71bb6fb643f3701f1617172eaadcf2b9256d5eb6f992d774fb5544ea873e387de271df6ebafd7d7de8d5acb73ff6e28df76c657d72b46dc8d1f3d33c5dd773731baa94dae6ae1e0f1e25f0c413777c1d12211d5e49091a0d694e1675112320b5c9f2aa2def486d7e8bdd78b02f7b599bbb732a39848407cd7d74b6ce89330653300b8ef421f794f2dd7ff0f71e7ee05df34ffd6c8b96dffda17ce54aba7ab7426e2288f0b2d72ed293d51e592eee4a6a29cf41f5e8558a504dae76abc74e8e4d3318243e2d3912a990c40dbca0c951444819cd68ef5224f7213d4230e381021dd1fd99a35f78e7f6e8a1bcfbe8f1f65ad716f0d0a27ba02e9f5b6f22b87c7ee7b9a79e498bfed9d97def9e3d53359272cbe7d6b9bdddb87e6d9ea6f1138ffb6663ebb56fd6ba5d2f1e7e089b8ffff1f7fce8713b5e6fb7e3568f5e381c26973c4e83599b6acb27cfab86b897c4d89f8329a483190ddcb02d3105d5a978034f75d3fabe2d7643e3f69327eedfd1ddc41c3ea999d2a03993c7446ce1105fe35b628649982304fec30babafd8e916e7766efb23dfb2fdeb7fb959104da60d4937663947b488040a27337725ee85f38ad55623a6a0649194a61a7d6a9f982b11d25a644594000ccd6810815720545d1c51d49d081a42841313386df298c37b72f77f3d79d787b7eb3bba6ce3f6714dbdf77777fa65b2336c8ed76dd6b0a8fb87ebb1dfdf3b6c9e3de5d4a52005b77c6eb5ebd799a634cf328d6ddcfa7693866d678368bef6f7feeefff2f48beb0dd3d1cdd81eaf37d3d2e7676465756acdbbe317961127cd57c4dcb8b9ff70d071ca01a7ceb86973b5a666b8e3861622213b176f3efadaecb79393c5ec6e108113b333448cc191fbda7df440082788b0103848794f93ecec1efde5ef38ff5f7cfb4b7ffeffb1ffa7fe747ddb0fe4875f9d832c5010e0bc9085fb73b994b4270d9c32213ae802927f7cf49b81b6c6a9704281908c66699cd2c0115c920a48b8b826c88442c2236c963a9389c5ae9b3e7df3469f728f3ddaa66d4ad9c95d594de3b6fad1dc5ebf2877bd70f43f2eef397f34ed3ff4a6f3bae85dbba0e396cfb17ce102736d9f7cdce6b98d93d47979c76d9cac3ff83ddff3d79e7ee1295b6ed72f6e9aeb70d2da7c3d5fa8cd9b67198f9629361541b6c1f11d6f89b247ea8940c127ce0401082884788dd491178be3a75f9fe5beae5b6a1add674db3870b1a2efc1b091c64701a514d04b954d2972fbafbeebbf7e8ef7fcf2f6ea6ffe68f7feb8dd6beef2fffe587bff11b8476ae5f64548233772f720df64bca25379889d9538875a954704d3fb19e6f844602215044212c754200a1b827d0481d08923d97d02e72472aa48c3522438b00168e5e6f7ea7f0ba9c7f6c6e385f76907fcbe5837df79fdd6c58c4dd53fbe7b17332b77ce181b2d85f4a9942564944855b3eb786ad3dfffc3c8e3e4f25a6fecbbebcfef43b7ef693cffcf0e1f8a297f1e470dc6ed3f6c676180ffb83c9bc798db6ddf1c3936a162c34ae5f7e7d743b24410c1a66c4484cc4846ff1709f3466bc795e59b7ffe0f47c9f44923b52351a383623e6ac8923612236f896188489a8e0996fd8597cfbed0759d53bfd789bbfe5dad1b9922e77f96debed9fbd78a13dfb618a643c382560069a0889082c3c2248828607a7e2c89b990990103cc89c09bc1288430402e18e90dc6924471ada40612606528bfe9cf47ce7cd9ffc58e6a15e7e607d52527ac3a2fb5dbfefebce3ffcd65ffc7fffd58f56f9edfbab6fd9fdb283eef2b95c17bbb78f294fc25c5005e196cfad7afd86785bdc7957dcbc317fe4da477eeaa7fee5e34f7ff0c49e5eb7ed66aceba37e3af4693ac93bb5aab7ca3ced4e37a379a07bf8497f10fd15c89071e3944db42651a5ba7a68402086846bd0482bb85bb8c3b5bacdd02226c7f06d70186cdd67f7d1638a9889d9f0e091ddf2c7f677b545dff19deffae00f6dc7cee3027a5e78616e7172acc3ea8571931324b0e0722adbf003a4772a2945d3e0406447786c6a37e7f64bd3ac28e134412039d22537cc50758453c129453090e462e4122d8163a3b60988c5ea7f39fca91f5bb7afdae9fec9f1762fa5d715f9e3e756bb1f7ee9c60f7fc70f1ecd779ddbf9e3bfe6dbf69ffd407f7238def9d09856a3cbac728a80e095e2dff508bf12f2ae0ff07f2411e1f3c160edfa30bfb879f1f0787b6d5c7ee2daf0942d8fa61be33c8d734dd3daa6f9b97430b9347383be1e15f123d53e624d599f7b90bc429453a19c999020b2b61104772292cdad3bd7f62e2e8e9f7d20ebed2965d52dd23c2a0c6153c8806c5b4c30870ee115cc2482bb3af91b972feef6da1b7ff1e91b1f6b5c4cf939af1d7220f2457d49da85b51ecd216ac2a91bc1852ea7924d640e2ae2ce6a518e83f754fb994dbd66420a310984a421d97347ab2ab82434e1862a289ad0e2a58f5c420a9a70971644f1beffe6fae88f9dd8abfbfe6d47d36e97c6e08f5edcbbedab7ec37421fff4bb37d563befcd6e9a94f8eadf58bbd69b13b95c5dca55434ab2441b8e573ac9a1dcdf59993f54b27d34b935f6b0cce346ec7691ce679318fadcd5b8db9d666cdab2d6372336b22392c84d423955438e384c10423563dcfda9aaba5f9785eee279f743a7abd5fbfd277aa3150d7ce4454e20446610a1bf1011a316a583027be7e77f15fdfb63f5bdcf617bee31ffdc96f7d78a77b84f4b1b97eef710b25157ee3c5957cf5d74d7fedaf1ca49c259c604739f67a772b391b2430b1582452f83b4f86af5b76fff3b5634e35427859b8a4c0129533060ec12909c7a186584846029fb0069397cce282bdf8c17389e7dabc28cc61779774f9abbfe2e883efdd88bc6bd87ecd85fdffecea6f8ae367e7f3e7e7834bd36a39159505a59032aeb870cbe7d6e3e5cae16abfce876d7db3dada86e338be5e6bb039bab8b979bdda0be5361fb7d12ce67967f3e22a712dba8ebaadb2bded8d941da2d000271a75a256b126de7275dc708bbca7cdebeae23d878f3ddce70baeee4cd02c6ac4269860729fddabd3881a38518d0757e9f7ef2c5af53d4dbff03ffcb54b2a574a3f874db3e2b1885093cb7ff88fd5b7ffb39ffbe8c7ce2b3923c08e6216a54721418285c88af4f16d5dc23f3d1e66478553e12080a86437970044118c53e62a2a0985e201210184499b24887470e7b55f22d811f9f8e4285754fecc377e5d7bf413c3732f3c3ad89b92fe77aff9d69b87e34ece737f61ee0f66cf73d6854a068d0813e796cf31f7e675b0e1d086ebbeb9e675aa91ca70e3c0c6e7addde8afda3859a4988ece4f37fbac2f462fcce6b1beeb2b589c4384d4638d70dc000109511c1c547deb79e5fd5ee49d87fa7c3e69426698d086cfc14c34a7392db4e111124433d9cff2670ef65fbbec0e727961aacb679fbaf760b7586c5b7bbed02107a23fbd9dbbdd03bf76e3d1f5f8eb77fb1c2206b9a4d9c324cd9a1015649924c32f6dfd9ce6ff7598505570088104524c8bb8856697842aeea8465a80228954420a9291243e250beb77bb9367ee9e6f2ebafc44f350d915f9eae5e2b69bc3cd279fbef48637fdfccfbcfbe1ddfec37a7131bdd4f66f6f7b976abf33974caf2589aa446060dcf239e6c3cdd81ec57412f360ee56c7b27e7eb4f1e9b47bb25cb4e39366add5ede57688c44958d41649ecc21d2cf7891932cce0e0c4800dd886684e03d3a8015ed4baae3f7eecae1cfb998138761f9c0d312a43f8166f300a13d124e6e0be55fe4fcfedbc6659aefeee6f7cf407dfa659eeffbdbfbb2babe9c7fe891c9e8ce2ae9074169c1a7b3b8340962ce109ac918839acba14502588c7e7fa60d1bf79b879c66a0e4e392f332c071ee00ea883438402ee02495d2d52200d8236b87ae8e2def1b93b16acbd0d5084d72ed297ec95fac4c7bb1cef7af2894fdafc7df77eb3af9fb74567fbfb6d516a969ac2952661d0441accc12d9f5b5227bc81023a6dbbe1f8a6fb497791e144a64922d2e6c6a5f158c28e66dff417344f97d83c79fef578e394642c08b04633bc8a8736232cb52675f2b2f0b45b36371fac2797f2a26b9ce05344b568c104b5615083ea61442380ffe2dccec35d77fedcfe133ffbf38763bbdce7c595fba4eb551216517d5fd851ff4b570ee4c26db2d87d63a7393c679108085622ad611a24dcb961eda5ea1f9eed86599808012844704ac14003101c8253e68aa240084e9804675275cfe05cc6cf7bbae1b64081db44ceab507d093ff1d89327cec72e7d7139792948e6d94c9b4b4d64429cf030a72285e096cf2d159714de64daa84d635ed4e5c5a81bd31492faf1c63999e7accf559df62e97e1a503292f5c7e33d211866652078dda88c09b5828286048ab51964802ee186f3e5cca5293b9cfa1b3bb89cc6011867a60e12ee24043130f2e4a41fac5e2854f7ce2be55b9f75bbe55f676589c93b9813c57fdb65c765dbff63bff321f78df7fff37ffce371cac7ad11c097706e16a492fc21e2c90801b81657d7ca847100822bc2c0001c9022e99532ab8a18954908c26a4f7bc24772080e784a4376d9f7aeda2531017882b39bdbe5fdef567ffcba7ffe25f78b1c5b5d0effff77f243df18120fbb97bbd5f59ee8cd4422dc48316d2425a30bb70cbe7560411daa64224026fd246a6936efd02b53a66f818decaaeceebd6ef1f9e7b70dabb8336a2990ccc84e3033e11234cf8e434a57a16177cd19fdb3ef5aa3cdfd6a5aa36e25bf349a98e8b34a2aa3777231ad2a0ebf46fdd71b0d7a545d2679e7be9f5975717ffabffa77dfc43da5d64deccd37882ff82b58bbd6c13e6535c3e7fa9682e3211190f60b25864bde136b83fe576d4fc69b3703e324d355c13a7cc503e451d03e15404cd510dcd46100ec9d5020f0c4952c7108bddbbbfeee8f123e752d6673de6882b1df7eca6e3bff617f7fef0effc6b7fe5efa604d71f47e6e852f4d97b31f52651dd6f1ad79b2c0aea8412c43b0f6d9558a82c13bd50942292044dc267e26f7d03bf12f2ae0ff09988089f0b4f3cf1049f0bf7dd771f9f89444838209c11ce0808f4750ad8460ca1911669ded4b2b7ddbb0f9bb120271a670222b026e6d2422d70c742346b844bbf9c36fb7dbf72c1bd42380416cc6e0ddcdca039815f50fdce4bfbf7e7b2837e725dbb6539fffbff88fdec4fe95d77ca72d71f7dbcb6f6fcd03e38d55f9fba976a4bfff447fee6db7f72019d317be41234b0608ff46c9d1f7369b44b39dd9ecaf7af37b545e64c704a3c90e054f2080c1022104846d20055501c4325a0ce62cdfbfddff9e24fdf505edde77fb699f75477e12e49777ef31f7ce1effdfd9b7ffb1f6d6afcc6e5e26f1b111a91ddc3a7b0ce9b463d6c37494f3899e42dbc134f420e102112a88a826870cb674d0444e4de553a951d69936d946191e524a523b8e13a2ccee938d6fd3b76f62ecd04ada185d473266803de88904041dc0992cf96763d2f962f3dfac69de57d7dda434fdc3cbc855888714af030707790cba57cc7e5833b8b5e79e8bef7ffd263a9c8eb7fcbef8a6b2fa5abf7e8c5ab4889279f998d276777c8e82fcf7379f56bbbb7fff441228140aea2ae9cfac5660f2eba6be15fd4956bd57e74985f8228420881414085300410840009329a2d9710250492a70289d421488c68ee8e9f012daa6f3b6977953c4191b8b3cbfed827ac97fce097f93b7fa22f8aec502c68dec4cc5bf5dac53cc7b8896b295af39b2bb97d2997bab05e802464440509c241b8e5b34308f1e69aa6b4d878109188e63e846fc38e49e3ce659fa6d67597b69f7cf68eb730de241aba0733a284611b7c20666244aba9251b5a164fb4d5ce1b26eeecd951d6d42d311803312b1546b109778faa20fcc7179777aee4ce2f7dd361dbcbe5b12ffef63f6f1ffea05cb8ccc573bedbd3065b5f3f8ef8d169daedf290f94f5e77f9b9f7be87c4c5be9f9254c8397c6a88702cbe56ee50f9e993e185662f985b7896302120050118a702881a92403da7501073409584639124a4499ba0f9de1dbf63faf84279ff3cdf5572e040820b25d5673fa9b07df19388bf273a9629b40f97681baf58953a33494a432ee165d6ebb3b6498f1772bcd2ab0bb9bc90d431362458297d126ef9ac08105037d1e2ddc1869313d3c96434464a5beca561eca6139c671ffe036caf5127fa152806386da236e659a369ab6ab37895798e7ecffa8b797bf470ceb7b9aa470b66a711117884e1d108684e0edebad33d98f5e2030fa683bb5e7ce7bb1ff8437fc81fffb89c3baf57aeb2dc95bc88179e6e4f7ef2b1edf4c1edf4258bf2f866fef3dff8cd3ff33fffaddeb892a44d565472461a5890221e9bdbc783ebee27e6d52321044204544320070d02302129a2ea38128a222044c293a744f33437cfe9ff7cf28b82e01ca012042824a157fcf917170dbbf94cb2b8bdaebfe4e3ffdcdafc81feaadff94516d16ad3cda0a5a4e1c623feac9652165db7d3b32cdb9dfee64eb7bd7a65bcb49752da475a9155166ef9acf0bcb05c5de7004710206a2e73d9af08d31065d99fbfe7f8f25b98b6d848d9417749c2299b89c09a8463a601a152275f1ca02a6efb874fde7561d5a1330cee4dc58c5301b802129e91dfbabbf8faddd543f7deb998e6c73ff4b1bdfbaf1eac56fef427f3977d0d3bbb92728c9bb8fe52bdf6d23b4ea63d49f7a4f2eac24ed93f697e479f774537f842349b4883061312b0c1b7ae331ada141c09202212011801019133886b8adc4146044968f2545c131409d00c696cad2097523a1722a040445129e8e2ad5f25bff8f3775e3c77ffc73e7412fcd65ffede4ed2ee6d6f69ba71c4920422492fad9ffc5a7f7c28bdad56b65c5ed8db592f56ecec5cbfefcbdbf0da73e77665a7e4859c5f28b77c5688cfdac6d4865437a9ad01ef7a2b6a8bd97debd803f5a9f7dff33b194f185f44a1efc1108720267c0b23312ad519158bae77c5cba23bfaf8d54ebac41c3e090d9a459398442a5185aa5e1bbf66b7fb1d07abababd4edee7cf8638fee7de99baebee94bda277f59efbd2f0e56289188f5a63efdd8e138bca3b54796d9947fff5bffa3fadc3391b52fc98b1a114533e1060e0135dc9d080f9088e0d30ce7650ec1a7382811e0480b49ae82e0da4220675a738da01dc7b403bb593d1c5030238419d72f7d8b3ef9c1bddb1fbcfd898f7c60a8a6ec0bdf74f8f3ddf17b074dc71e27a2929297f26859466f2abe757b3662d7e29e24af7beebd2f1e7ef8fa9b7fbf6c8fb951dbfe1eb77c5684a4489d6be769e179e969749949a1b6d566abe3173efad037b3bec1f1f3b489e579289871ca27ea24752d6dcaad7a8436f016da8106e93cf6863ee71a060d370b8f533861ee0161de0bbf7f777947d6bdfb1e7ef18927af0ff535af7e5379e1267be7f4f29d6c4752a2f378e986bf78636c7edcec629f9bd9d5b77c391f7cc26857b4f36698772239410e4e3570c71d01850404058c5312168006c2cb424110c10585400344012f294c529d3ce7afafcfed1a3b223f7a323e587227b2505e88c0e2d9b1ddff97bee3fc7ff65fc68b2f7df3afff4b71b2f61b2fe97d0fd4b7ffd4b577bde3d839721d70524a392f7bfa2ef5251dacd2ced54e4c7ea90eefb91e9be574e9ddfff0e0dcf9e35ff38d320edcf25951bce2269c0a0144908c3b29dfdf6ebcef35df840bf33118fd39ca1e086468b870cad08020b9430812d29116a9f9c359ef4d455527dc5cc101e794f0b29da4bf6bb77f6ddf9d7bedebeb387de270f3c55ff555ddb5c338be961e784877cf630d015486a97df4979f9cea235d777b4e03e8cffcc4f51ff84777a56ea132353ad52e6936d126183498c1c09d08451a2f73ce44124e199f12224e868c664441483d229e7be841bcacbcecde5f9fad593f36f9ab4ab79ff45c9209c4da1cbc77989b73d77ffde7ef2ef9d2d7fd067df8f5d33ff8ee39dc3cede6eeea577f457dff2f6d4e4e8e8563673dd6ad919a9f183bc6a5ddd523cbbd372ce5dd36bfef78f3a8964b3fffb6b4bff74f3e74b4ab7567510e2eed76c241270a45d1acfc8a88f0b9f0c4134ff0f92040c2f08a37c20887967c2c6dfdd2b9fb4986071818cc48259404ccb406134c4e430cad891a84256b3975d3fa52a6cf54bc110dab11d5a9304b34f16a9ccffa15fb8bd26979ddc32ffdd0db8e939d7beb97d82ffe0245f5d2795f146693aed0a5f6c4474e683f33d5479679527decb557ca9bdffc837fefef7ff5eea225d6113b593d69062738159c721c707004f04034302208a04104884220164911334014dc358510d9c52ad1eeb8f6a19b7d7fd7225f6cbee8b8a4d22993071243f0786dcfbb2fa7f95c92733ffc43bdfc10c1646c8939f01ffa1111cd22a22aaa9e92955cf3d4c621b68bd5c9e2fc6a7d756fef8e83bd121caf73564d8a54a3a8b4d0adedad520b5428dcf20a7344c2254cc308275c224a1bfb7af2e21d5fc1686c5e643a869eb44314cc38d526ea888d6936686a266e52272fbb5e76f230ee0dcfdcbbbbe85a0cb80515ccb02020cc0370fe9b4bfb7714ddfd9aaf79ee07fff1db0e37dff0c05df1fcb37ebcd6f3fb34a419242471b41d7fea5fbeb4b19f1dc6afdf593e37d5ff6a539ffecfffdc01ac82a9fa5cd9c5919609726090419c041608944043e64041410c010d222043888ae2b8a68404020ae292b148adb5dd3b7e677d7aebfcc2f17cb1e86de815e1c4c3aa8763d060db7cc2d722cf400251122c452e967441e4be2ef7225d9221642d1c357bbcf990bcb66866cdc21c41ae2cfd232dae4b6e113b2f3c29773e20cd75a8caa974b997c1b8e595156888200a8a16f22ab5174fce3d7874c7abd98c0ccf30dc4017943db447148498b0869b10685333c2c56b743ba405daefcc2fbca1740724d08638162e02020282020f75724f5f58601f7aec6d87d3ed39dff96bbf321e7b5aa759b64d365b69ce729756e3783b36ffe9612a9ad5f547b6c39fff0dbff57ddffd7d1d24a88e42026d9a43b4418041280101b8028e23ee41402409ce440349844071d45134a1c5934217247187f4db6fbe77d2f44c6be74ada17b93d971e6e9a3f6f6e48810c492483a8263cc345d17bbaf29a4579a02f8fcfedea977c718644ccd7ae1d3df37cef4ec8fb5bad16c7e637abbc38fb8b8d73bb5e976d96249af2277efef8d2fdb228a9924ae4395a27bb49b8e51515aaaec5b458e9a46d6fafd76ff43de7dec0c9097ec2f8146ce9f7d14c0461a44adde25b62a4cd78755c31d42d658ae87c78b76e1eec3bcb547cf418a10935a21a834813eecbfa7fbbbc67890bffd17ffe33ffedb769f6472e2ef2eef9da1e0d1b64821bcfa593f342a5ace2e4f804de37d7afd9595ef7f69f5cdaeb762f7dd8fcb692669163f044131db2e6399c9705e0a7103ce1164010010201118803197013482df2d20914c45c350492e1a3a59cdd6f865fc9b8c6e5228be24795a79807a2082a18a081904194f349ef2be9aeae5c7ee0ce7eb9fbc8b5e7cb97bd39ac4535f9c4a397b02bae379e797637d8449b2b2ea7fc44e41a9ebd8596c8c573d97fee937adfab92938ddc62ed2c12b7bcb2d44d22529bf7ebf6a694a7ae7c69ad0b0e6f30cfac5fc21c7a6449242230c347a6099ba5d6d4466d8d7069d5f3429de6e5e0f089d7eef61780168147048e813b67221e50f9b397f62e263df8d37f8e563e34d6d7f6e5ce9219364cc6d482294e4e38d9907b8cf6cb1ffbd866fcc830bfaea4f70cc3fff7fff407e6c79eea6917e8a6eab31b309370cf2908080850280a4e40821c58a0448018426810101955709aa3223824a1252f995ab5d1bac541f355926723ee10bd5b93547f61b6c92010ce046020ac94bb537a6d575ebd28e7babcf79637e6ab0f8e3ff07dd7fed6dfaa1116ac523af7f0c3975ffdc5577ff01f3e6b7ec36858731733b798c34bf3122a9a2595fea36fdfdcfe4087f425fa149345cbdcf2ca5a48aca21d1387175e3b2e134713ed046f0c379907d21259200bdc09272a35f0aacdd54d03220404413b2b4bb5785ddfdf95f32ea92a2078a080e1025cd5f46d771ea879beed4e4ed6c71ffd40160e52eeeeb8478e366ae693510779f11a975e92b294cbe7e75ffec83f3b19efedca4b357ecf830f2dee7ef0c9f77c689f7c5ef3e4118e9006182d72a846e0308783724651701c0fdc3915912400e365d9499011450a9a50754d2020e4dcb5b5a27c9a265451818db722d2438040820c574bf9e22edfb3c8e734174dba9ef4befd18660f2c30a74ad4c71f5ffeb63fb213dfbb139edd94a4b54688f9682a53489fb276abbcac27fd45b9716371f9e26af649811cc12dafac4dead73b5726bdcac6d89e100336305ea31dc24cb780440b68448311dd125b6280ea3e219e6d688b5d9258ea56d373f72fe8b35768f804339813e08a056fdc2b26ec5cd8ebdefc45e32ffedcbb7efc5fe692cff59abff4adf6ec739ec235c25a6c8f637b98b95b6c7ef1a9c73eecf635abfee3b3fd85dff78df37b7fe627def9afee2c4a628d1949918d1290c10d02549c7fcb0d9c0830a2453470c3200069504271027504570d1124249a930e4e1edbae7a132e745ccd920b2fceed316b6be5406370087292a5c8ed253dd227d378a2d667b42d3d5ff8173f79db7b7f61f51f7ecbea7ffccee466b0d2bcfa86df3afed4db4ea49db8cfee3398a8783397a8b5a66c754ad398a621d7b1988da293fbdc6c706e346e79852d2e12c634602778a335e68979c003145d608235aae1c63c5147ad555b53abb88b371c756d6521367775ee55a42960604044381e614182af5d76bbf7dc938e0ef5e0c24b3ff423d7acdea56501a2258c988dd698e7385e7374225d7ffc5d7ffbb1f578a7a673b024f4eaed927b680b3af7682d661a10c614917360c1a9401d0f707027051a788413d5b090c6a9e0548000a22138a8784b1424d0266de7d21fd879f2c4e2198f37957c3e10f7e7e676e2b107cd312870ce39972835de5b67c34157995d99ef2c796c87b7ffadbf72e1cf7d1b01ccfef8e3c7dfffbd2f4cf1d438df341f1b8a5ba4f0f05312ae3a6d5229dbb2598fcbddf1e478ba7465566a6de6518d5b5e61a2e020a04802a5ae11410a29900e1724d08c1b244491a464c1021344d1202949bdbdb9b483941608602483e2d170850c0ba17339ff6b7fc3d177ffddbc7fe9c4a243f72417928e55ba5d47dc90406aa8b9eeee8d9ff8f83353bb2fa514fcbffec65fe743bff477fec54fdf5ef22ea91ad571228209df1ad99286136011a16a1088a3981bde84daa4055584a4980b1164956c085ad08428390b9900d537bdf49eedb27bd2ed7695dbbbb44ada8c67cc96221073d041121cb9615cc31504043f0e7ad1c13ca21dbfb4bdf2eddf56442438a971e4f142b5a7673f21cc43d10e371054aa430d99e7719ec7a94d6d1edb3cb739e7d6e5086e79e569222630a8c4486cb1018c0cd6138138183213136c6186c919d1a638de2ce7daf7a19187e76f5b4a97a99c8a096667c61b5844826f3ed8b9eb37ffdae3effdbbba205e756fc95ce9f32a29993a1d8a0f9e311c9ce4babb6bebe347277bb7c783cbf2be61f277fcb3f19927a5689f752eb2b118a08a34894de894c8b813082468e2040e8157614b4cee2d81419210a264f11971d71669e90ae29e2504a441b4fd4b5fc9279fb7762593454af2863f1fba9528b0862218a8324b74c8525134f0d91960c26765db78013b184928c836e22478d6eb5a630c2625221c77a4e2e23e47c35dbdcdd1666f6ddab4c0929a79c992945b5e61e184e38e35cc9827cc88048552181d6f58631aa923b5ea34aa55b54a84780bd7d002a96c0fafd8fa80656e4004a79c000f4e055fb42c8ff4a57bf51b8e7efc5fee5ebd333ef6d13b1fbc7ff5f12780a592ef7ab0bdffe7192b758c6692552f5fdcfed5effcc07a78b6cdb70d5cf8756fecbff1f77de77ff047afa82cb41ba736464c1135da640c81073907119c6a9051dcd5918008221668078bc2e8dc6cb64d454c23116409d41d4d34f10281d6f98b9efbb96d57f69129e2b64ed418838f0d93041b48a050847d64075942760d7ce665160da6b0436ca8b242c180864fb08e682168e01211ae124108214aa4f016758e5abdcefedcfbfcfed7f86e71cc23d633b7bcc2020202025ac50c29a49e5420c38c386184614dac29ae38888040e40eedd4bddb5cbb7bb1d8d5a42850dd125aa0e14618f23bcfedbe805ffae82f2bd8e18bd2ac7be35b6effedbf47ee7c80e3a378fa495eb8217315434829f769b1bf99fd83d52e4afe91f5f0aeeef6f59ffb33b76b498944721a11820ba4500d0f279314c722f8346d4a756dd2ce9176b39e13d911b919c4dcb688a322095550214146336422c8fd972e162f357f55498766b7a75ef043f3178c5e25418185b02bb227baa7d2a149314fe2068482138ec1a4be124e2922688284076064c121074d2810d08240042444dd529dd044337abd36c4ed0be19657988143c3677c84098594c90d6be80c03b6c5d7c428be85d9bd2296c242cdb4f7c5220fd72f15ae6624e1e140532630a70a1592ca5ea763f6b87cb165e6b1e6c73fd0bdf9abdcf077bfdd6f1eb13eb43638e62902d1839dfa91479f70fb247151d31b77fab87ae9855fb496e854e6cce43204033a8636610b96c8b83b24681081e181e72027ee487a25c995248b949eacf662752244dc44114c20e11984c82175ab2db6e2bb85b7d7e1eb97cb9a7ddbfc3d73d32c63441651429426787621a16e415542694e85108c33a6dc049453e15468aea6118839a8ba082949527222252d498a4a1292b2d8d1bd954ad59c65b4cb07855b5e5901e1b86315371c348340e046ad54a34ed4a6ad69ab58c53d61d266d78edc53a35fdfb86359ce43aa0104a79c53817b0871a0b8b98da1f73fb4b77f7078e3f0d91f7f67f78e771decefadbee1b7952fff6a52d69f7f677dcf7bdc204c9212723cd5f068d1beedabdf1ae7563f71789c0a5de4b9d63118c247f339a83047b893bbe0d414240898411c85e42c124b64892e833ec8011e5868160b1430205c214c1b50b0c8cad2291e34778b5312887b52e55480f0b2208383039e204534e794410a662c19a70cc21111408482041148c393e410cd2983164925a59235979cdb94b4a55412be9bb8e59517413804289a494a9a21b04a8035bc89b5683599118088879223754857da785b4e57359d4fb9a8825727934c49c644a8faaeea428a5a1cfef77fe9dc6fff1d570f87e77efc4708daa9e75fcc8bbdb47f90ce5fe2b6bbe3f038205fbebd6eda4faeebe49e7796777ff5af3ff9e17fb650cdd083072d181b11ca29f7e40264130d0882e08ca642caca81c87d8b7497e885a219d9ba26f110d524210932524819cdaac94968f7bbede96dc825d15775b2938ae2875e4767a962aa8a002de8a0430b2981b92ba75420e10a1502c4498a7246c1c11015091183a45a35494ea414394b29745de9ba45d72f4ae952ee5e7caabbf3ee2c6491e7a6e09657561838d1c09020092a24d04a9a6082091989099d4d2bee8906662559972d699ed61717ba934572541cc294060d1c42dc61164ca364466273f8a29ccca5a44dd8cde341defef6bdfc8edbffd01f2e6f78a320fec4a35895875e77f36d3ff4de6624fdcdafb9dbdef9134f3ffbc99ab508b3c8188c121bd1190c0fd5aa189e4dbd39670403c217ca81ea5dbddc53f4b2ea4ac42025332a528270c1245047c3b5852061ae987b9f79779d1fce6994d6a18f99a72ceb08609010a483acd13233ee4294005a30b94f1082f3690128671c727211e45444a8ab4ace91732a9df45df4bdae16dd6ad9ad16dd62d12f97fdf6e96ef9aa9234671967fe5df3c4134ff0792d2002770c227070b0a01a2d688119ee62212dd482083c70ce980824b3044522e1a07c9a732ac02360c25ed84e772cd2a39bedf0a36f3f9fd3d5920e9204f6dc6887b0f3fddf77f1dbbf582fdd2e01a9e8edf7dd7ce9fa51ad5fb9bff82d57ce2f7ed71ffa999ffd53bb42ced92326da1434c788e654081cc8c908ceb420434277e1b2ca3d92ee12dd450ab2719f2b9323011651928660b8a09e2c436bbe3c88d1f792bc4ef5c194f098dd86e6aeeaee02bdaa100dbac0c50768904139131102e184724a00010381000c4410d1944422a98ae49424a9a6ec25775ddf956ed5f7cbbe5ff6dd52a6be688717cde777b8e59517c12911a49016e88c0a24c2c130d31660441022a28284e6484525e3b6887a41d34a25930a6782c828d0c0f11926e36d3787bbbafc965577779f33fe89c19eb1fad0a2bb5cf20b35ae9d0c173ff211bdeb21b643b9ff3e5d8fd75b2bf0277ff7d71d2ceeb9feedfff73dd145220586bba9874344232186010299a4e640000105d9cfba9fe55229bb39778e2acde3246408113c72272941460a5a40854c4efd8d4ff6457f7e6caf2e5948ee84639af0e8d0ab5957e88b6e014588d04920bc13cd60b820c971488e4026501421c009115795536868ca295b2ed175b974ba58a4e5aa2c96cbd56a67b1da5d2e578b7ed5a53e6b9fbd28ca2daf38231a341492a020861bb125267c2b7e021334c7541d22d4d1e29abc649d37bd4ccbdc49a70604a70c0c1a54989d701c3e817d62b677cd535216aa6feccaafd9e99e18e6552acba22f59dcfb8e1f5dfef1ffd49294573d30fcd83fba89fce9db0fae1e97f5cfffe8771f4de7929a308a4ca12789a9e98047c6f12009289ac113340543a19758682c25f71286cd199c6b624f781d94f016d285868993ccb5410e69e0bfae6c4bd67b9376c2ac0e3c4f4322252e25ee2de5d86d5349c1a484702a27ed54200c9d9bd7a406090450174ea9012a21674892927a4a5eb29692ba12cb655e2c7567b558eeac767757bbbb3ba796a77499a54fd225b1106e796579e08e0728ae84628e35ac5207da2c73d5b979adb42a34dc71b72c68c1228fc7e744564e575d513ecd810435e88819921360c4145438c27f6c683f793cfc910b3b1f198687fa22303df3ec623b48587ef0f5476fff1757325ff4c03dfaf095a1ffda734f7e5f1824a66034aa6344341c0f4540d184e5ec4460460e4e15249998c7563c073d82c4331b7b6ef6a93a11de292e9a8280c61975eb57770a4fd776a7eae5c4d4ac471f9dec82eac52c779784dbd3d536b35dc85a0d68492407e29261866661182f5390a0e39401168288a826cd828aaaa4a439d375745db75cfa72b9dc5dedeeececeeae767796bbab7e67a1ab852c9d3e91b8e59516ce291124933b987108a355dcc54241dd345c0871d471ed35f79e3ab596a7edb9beac52ea54129a38132e02417442048abb467631a449a420602286e01f1f0f7f647feffde3784fc962c87ad35dba9c1f7c98d04776568b5ff7f5d34ffe583d898c0667bc110178344904a71c0185ac64348b7b221a2424844134ab3c173a063b12e6f211f31bee53083943410b5248593db79cb4b547ae7d382dd28224b0a29ce05ba2a1b767bd24656c7ecdec86d3a04700858cf4b024399102f04c8024c84a163ab48509240891105124a9a24952a674a974da2dca62c162b5b35aedeeececedeeeead767697cbdd45daeba4afd22945b8e59566088892141c7174c667a8301313ccaee6624283e68a273ca925924dcb12cb024a531238a7dc950681347027c0919608d7c629f300c48cc75b7cdcea0b705b22fa642f3d2baf7ad05e789aa4ab6ff9d6e7fec65f3db6f413c727cba4808bcc3966a30655313c4828194da04206430327a0119bc0cc2b326363e8beca8d661f6fb3498404e2888784aba3e11aa1e105cf3ea7e4d0127376236688e673d2aa3e110d1c227b53151503114c31c5606ade541107e594a24a439cec4e15403525c939722117fa4efa5e96cbb45a94d5aaecee2c7676577b7bab9d9de5ce6ab55cf48bb49325857449b270cb2b2c0204140777ac521b5669559aa5365badda5a72a235c2113c177705d238ec067db898e340f0699ea0410207092000714b6004c1a91498fbbbd6c3fd5dc62299b50ffc829cdb679eb5243fbc5ef6f6e7970e97d1c21098610aa6a07904040e8803214a4272720222c8418306eb6005418453336684c551759c88cca910350747cc1154eed63c59dc8eec2163338527ab17472c9e98eb61d0f04d434032e1214a828c24a2e17304de381349e99c1e49cea9111090104425841015114daa9e522945fbaeef17cbc56267b95c2d163bcbc56ad12d1765991097a2646e79c5099ad182cc209c713c14d7308d107705772414d4559376d0e34dbcee882e2477a402094d38674ae00219840881f004a184239c69a044e24c871691948b342b0fbc5ac669e7d7bcf9e81ffcc3cbffc17ffcbffec5ef48e09c5282085727b9389640d0827499048ae6d0048e0701082fbbee6c23a6e4b9f26c8b6bc148120d24431634a42009ed14c76237cbbea52d7e9ba60d643874ef353d3ec7c63da13310ec240514e96085eca13db275c53d7346911e7a74e52c1003215e26849610150d4d39e5548a777de9bad22ffac562b55a2e178b6ffa2dbf817f973cf1c4137c41d2041571d491400275d44323245c31259448e60dc123a9255c0308c18896624e9114c59d338607d1c0a18183bb3a3430c1700b827013d3f494c96b8a9293de779fcd9b72cffd316ee4d56fdad90e87dff53f6db3a65003831186464b5425084114ad4212526808d9c50c5cc3c123267c0e1c5270dd74b476e4713d8214216aea91310952a0e66ad00a8185255b253956b66e1dcc8a491c24b9bbcf5979dfc62db193930539d110522a49677cc21b3410c8209abac442b44387f0089f41909cd452969c25254b5972915cb42c7277aaef97cb7eb5cb2d9f1dc1990033acd11a73c566999bb459dbac6eb486b9444320122e818bb7d5bceeba942c0417c7d1c41905c74539953813167c8a7326c20203dcd7e035f559f148af79989cfca9c76e7edff777a27fffdaf17ea61906359822c271051c4751c14a82a06238391b67020d12a8e3ce8457c7f0217c6b41d0c19495501c4db83924dca044e998f964d89b244fd6268f1614f7db73baa068c4ca25e138cbd0314886082bb14e63746a0d238453a21a9ddb52754f5c7183e201210a38e108a1a22a292b595249a5eb4adff55dd777855b3e3b4441410921205cc2d543700542058148e64e762d4142bb046ab610ed848c28245441115e26a83a0e1584532ea020209c1122238a1a4cc141caf6d8e3fd57fe5afb47df73f8fe5f4abfed37fdc83ff8a10b993002086a70c6512740a080405112677a918c268584e3a44092a882eb1cbe0ddf22812c841640528aa3501212242539b17bed23771d2c9f1f9a95e41e842591bb92ac60743229ab1472811e09e861a1723e97a5e8e02d208170a68715e99ce89544c3d5d218de8b1322689792aa92732a25e7422e6772e9bad2757ddf75dcf2d921208118d2880a35a44654a81ee6521113ccc43c49645cb3270847831caea9097302955ee880c051f0260418d488700d7c06131a6141353198945347a25dd60af3bffac0f3efffa567267ff5138753d2acda6086c998c0c26bc63825ea5aa14b181808dcdfe51c62042f0b418a30111992b81285884cc01c84e2e291c4c4494ac631c8af5a49551e5ceaa0b68e10e813828ce6fb491def3459634fa52a61b80849b5a8c136988240445202cf14d145d1454a73842a88d4503477a5b49cba522217ba8eaed37ea15d97bbbeeb17a5ebbbd271cb674d04e698610dabd29a34a339ada907b56146108139e05487469b69817853ad95ac16c20c995316fc6f0410bc2c1c880082006beda0640f2b84e22fbdefe77e79ac5ff5c6879f99a62ccd83d9a881834554c738e5a08229b4204182fd225fbad7e52ea880d30733d19c1e025f06ee2834982c1ce154722c6b720c0725b5aebb8dfc0b9bf1b55d49c6e4b1122647141c084e79d09cac04041038a9354e35c38333c6a764c442541592d9919b8812a12229e5941239e59472ce29a75272e972d795aee45c32b77c7604042038a72420489082440808aaa024471229520f099a724a1a6a2eae129c4a99504e0920109c0a7003830e82332d382560c17d49cf238be0e02ffef50ffe893ff6ea65b1279ef9d9eb1fe9933643c313b4405dd4810055c89c1208553a589896c522e794c5634e147302130c2c49430b6ee10e960213910419cd9021a1599dd5e153b98883220a02190439b2b89a75179d828c243887b4888c24d84397e86458440a1711900c1d9cd37c3ea5f3aa23cc85856b40e49c53ea722ea54829b994dc9554baaeebcba95c4ee59cb9e5b34302093068d0421a98ab993434420c6d0e9e3c245b828c63409ac69a99b131e9a42411c90108c2cb021c02a9ae8e3b3a392d61e10daac50c037adfaabf98d0bebcf0e7fe94957cdb6ff9fa1ffac7ff24159da00a43d31a54f1594109ceb8d3389314172e95f4ba657ff14ffcc99cd55c291e2d1002874041b48911844b38788a1023a790f0e488407315a8cb827b1e136344854939f158664ad6b573aa6a44d6beb0699285505296c83a8a0f78434e25704053c9bad39545d6e6887b64f3945329d295d4f7d22fa45fca62a15d9ffa3e755d2e5de9fa5c4a4e995b3e3b2270279c70c2a4859a6b330dc78cea58e01e288a1a2ea1841398d3822c9883220406122010cabf654080e19c896881f1b230690d41add1a01916e10de14c4040000104386712386712b2147ddd32bfeecdf7f98bcfe665436184de01e9226a50800601010116209c6a4e0673243967eef62959797d966c71dd0398830e962153b5c959aa8c35927bb6440420ce15016b738b668e934000a5083b2afb6aaba44db444848a2a9a35e7a2a5942ed395d477a594d495d295d275f9659a945b3e3b8233ee9c8a334410084aa82012282aa8904015010111728478d0d0400c9140441308e09c0a984139e540e25404224442ccc3907de16e2d07bffff77eecef7ccf237ff8f77ce4fff3b6d9e812612450488481364e092824ce089c4f7a6fd1377cd95bba2ffb6a79f0a19c721177f550ce089ea04122275c70418810242407451121a3a7fa96cad5525e68dc9ba553c225131a2c547645af35cb4221ada32d553392881e3a645fb405eeae2e0596e0a0c812ce21079a7734b5903ed1199eba94babe3bd5f7fd22168bd22ff27259fa45d7f5a7baae2bf90cb77c56041e61112da2850442280621116a68b8e04aa878882725271725f0a273655021b11144232541299000c121c002733768ce9434c267188c8968ca2c7a9cf285be1bdff6c3dd8e743ffbfe5fa87555ba8a4f426b4cb809631019e74c8081c081eabdabf2dadb0fcad7fde62829e6213b9e34c0ab46b844b8390d22bb35f7080f3c47806b50c2091748b8ce6ae3ff8f3d3c01d66d4feb3acfeff3fcff6badf7dd7b9f73ee3977cebc37e781644a100a485050104c44143170e85269c356534bcb014571c0a93402b54a2da104ed2e47b46c87b690c664c6440a90a104129284ccbc79a7cc3b9fb387f77dd75afffff3fc7aef9b84151541106104dc928efbf9dc53edd1b5bdc287c416d36486e3c5d7cc3b7002adb0609bb4a57848abb1194aafbe88bdf22026b3e6281d8752c63a8c632d43212d5ae95618a6b2d9f8d1d68fb7657b644747c3d1d1b03d1a8e8e36dbed346da6691a86a1d6c2cb5e12792994a94ca9f56cb37a939ab22b52d15140d21def84639d8f48526a2d7af1eede4407458419608e20201349014af09e494088c88c644b96e8273e7a6f6ffabffdf6777fe3b76d415a4344b0248156a083f311099e8cd55e33948f79e8c6039ff3d96c376cb7cfffc92fabde0559611099eaa2880274481020ebc20c873073dc9228b4e5c6c5878e4fa657d56a492024433598e099c8596c8088e8b931a2a7890a5344edb6176b8b922ace18b612356d248f8de3e2c5bc60bd64a13094611cc6699ab69b61bbf1a3edb0dd4c479bbadd4c9bcd76338d978661a89597bd24223232e352cf082c93c4d22cdcc0294e71d230a3140651f1429af9804d9dd633bb7b8a9ae01430dc938f28ca1586a461259140280308e5278ec36b867a527cf3968f9dbffe9fbcf7f462c043ee810b230b944e819614922b3ec203ee6fdd0eaff8ac5f5edefc2996e453f38857bc18a6244de9586640403a08486420c39c213130288097ebf794a727fc7a4549c2041b1821935359a20973a8d8d6ec85ccc96c32ae9532501599c4885fc3cd52a2c0163b2e366d464f55bcc86bf53a4cd3386d37dbcd663b1c1f97e393e1e87873745c8eae6cb747dbcd348de3380cbcec25d17a6fd15a44cf166a5dbd45efea612d2cc3324c81549194052a09381e4583f564c51763325f0a38c21dc3b99224342c8dc057658396acf8921c8c371c8d0f6fa652ebfc93ef79d7f92c2b012ba51796a0c12ac249472414c0d24f8abf6633bce2533fb57cf267a322b5d3bff6a76f7cd5dface9d1c815b5a043071982959e4647015125b32ca820238b2063e0dae036b04f4a21444073dc3895e65435a2d0077ac2406f18746775eb95261a1e643373f70666165ea98561c8106659dcbd306dead1b61e6d87e3e3f1e8b81e1f4fd7ae4dc727c3c9c9d1d1d166b399c669b8540b2f7b49b4d6dbdadadafada6269b1f48cae88ec5297329442d08507d1b002382d1524d933dd3208e75284358f112c0c104ac824210849213ab4ccc83ca46e95bc67cbc9277dea7bdff5dd77d407d1212cd72020a4965c8a442460f8cd920f0ffeda5b9bf137fe1602ddfef0c5dff96abdf284e79eaade311064220991bc28c90449880e15b2c3608e93e070b817bf963c1b12da2505aaa8661feec125770b61205992493195b4070df57e08f5880a23412264660371ddd8bcfae1f5038fa77b267829e3300c539d36e3b49d8eb675bb9db6dbcd76336c36d366da6ca6691cc6a1d65278d94b62697d59dbb2b6b5e5dae2233252691252750bb73499e1852acc3130a3e0c53170c3c1106e3680817325b102818c4b0aaeec322d91d849afb47acf1b3eaaf4f8c979de82e1224b7717268c1892e08ab872e4f6eac1df3c0d0f7ce247990f7ae2116eefb8d8dbfd5bcbacdb5ab2db017125f98814b88343a204a33a353030a3e065da3f7df7e8b318b1448063050a0654a8301926ab62232b688023e7c8dc41192447ce09de60548e94eb564fdcc6cff8a57af4ff5dd2cc4a2dc358c7611a379bcdb8dd0c9bed78b4dd6cb6dba3a3bad96e379bcd344ee338d45a4be1652f89c3baccad2d7d5ddaba645bb2af116b46b708537a864598b220c80295343ca060860f74a33bdd595c056be68323ae081a9958e061d9454f12027a12267ce0f85a96bac78fcc04cd3c8c2eb213d02a82e0920193553373379b36f8200cca3e78e0777ee5e12ffee98ae38388e8624d2d468395bcd45d2135a18a2cd3536ee950c0295a29c36a1685c04ec5b542c050bca78f66402f259c9ea95222540d2fc5aacfb0cf6ca20ca598ad624d2fc5ea60e366f2377c02c3bfeaabada5da3096692ad3346ca661b3addbed346d3fe70b7e35bf18bce635afe167f3c10f7e90ff92bce635afe16773ba3bb41e6b8fc3d276f37ab19fcff787d3f3dde9f9f9fe30cf87659ee7e530aff312ad65efd15bb650a42289c41c0b8f9656a073292013096576545d222c0b5aa182430a4124410845d2217a06b98bfcc44d7dd5c0f4eb7fc7d99ff9031b28522353d9832656244192802750f1570ebc7653ef3fa9c3aff875f153ffbb96dedff3defbffc657e7e3cf4c7ffebfab8332834dda2e3527e25292202410841054c884028248ca518f2987bb0ab743057a84e3d5583226d8480d6a44174a912015d8640ebdefc5d23aa929a98ea5c8182ac7c6f4e99f1a8ffc442a975a9b64c5ac7a1d061f461f87611a87cdc8cb5e123db2f55cd698d7382c6d3fafbbc3ba9fdbeeb0eee7753f2ffbb9ad4b6f2d7bcf88cc3065519a6531c230a70a73700a740337b76ed55560800a4560360638971c5952b812324090648a7df0c6717aa096c39ffdb26fbc73764415187850c04581483c815452f06bd55e5b87878672fd4b7f378f3eceee54a7b95b1edd2c733cfa03ed6bbeadba55f7ac6985008c4b5ec0481360c8b8521c876a1814a79e9472ecf6fd877cd3e8039c7819e01af654ea6e33837351b1012a4c30c284dd557d2aae962d19e09a73622c308a4de79ad9f4996fefdff7ad2e5328dcabfbe065ac751886691cc7611c869197bd247a648b587b5f5a3bac6dbf2cfb65d92df36e39ece679bfce87f5b08ff9d0dba1f7b9f7963d2cc2338834c99159b8532d314fa3b89965b586b54a33160ca316122f80a3cc2c7424b1c22159922ebf509e62afdf0c6bf5efbe7d566c48e8d0f0a5941eea46231b84a7bc187e64dc3dfa0347c3b5cfff7c7bed5bfabbbeb57ee6e7defe87ffc3ad2ffaedfd877fc85ff1b6d6bfa566c9505a9539d968b088c5b325e1a4509502b9d2c9421a14e1cb8dc9c7c19f9b9787186a21b0e6ac85f366d70b2108f5e2c5894c55ef5d149b7ce8ce39cca51472f0c10b77a26729d4320d433cf5f8f2f823bd9403652d430e95b13254ab83d5c187a10c032f7b49f4c8d663697d5edbbcac87a5ed0fcb6ebfecf6f3feb0ec7787c3615ef6eb32cfebb2646fd15bb6a69ecaae4c702c49304187243a925a66b5eca423f70e352424402408144a43d0c542cee48542b2fb9d1f393f3cad768f558984881e85159ae8482092a4b86e567b85d5bb5ef5e0f0a99faea73f5c3eed6d2ffcadbf72ed333f91b6f8c77fdceeaffff7f5e157d6a927302753689410ca2b122481e8429060698e4b60f476173e6416d99a2c49411b6c17798f590d0c4c42e10992750c0db0a12bfd902d7a4ec526fa186476a0a49f6c4afb966f8ea167e69aa6126e7ec9dc4b2da5d6524ba99597bd247a64ebb9b6585a1c967e58da7e69fb79ddcf7d3f2ffbb9cfabfa1ab1b6ec3d23334de9ea32c9411858a10883e2c87097192eccb8625c29c28c4b96382418201091a9a0a50e9d0d2279b4c58dea4524385db877466864e9241430fcbadbbd56ef1bcaf4cbdf6e5df1e33f3cfff88fd7a73f3cbef9bf61a887ffe97f8ce79f5fefdca937ebf0a1a60d399a558b2a0ce3452213ec0a9841350c0c77c2af9bcdc98de2053a0cd8c6ed85ce756384060394b4c97d54147c20b7d8061fc2497734615bbcc2204b34c01b6edd63e02028668615ccf062c5dd8b7bf152bcf0b29744a47a66cf5c7bacd197d697d696de97de96de17f5a5b78396b9f796d195498637694d48234d3841522d8134cccdab2ae134bc159fb109d662c528381024524f5bddd664365b8833b1d6f2e6e24f48d70677b380263a75a9a8b342887082748abb9f0ce5817178e84daff6d7bd317ef2ddc2970f3f7df30ffe713bbeb6ffdb7f63f9d053893fb15bebaf7ee0c6373d7de7fd6b14cf824032049929974416047254919106c59cb2315bddefab2e6c169b4216d684620b18acb0148eaa459a2a0ab3e21abc25bd5ac8549ce232d6ee09b594cd7ffd3b767ff7abedd50f745b66ac799117ab6eee72c70beeb8f3b29744be282223a2b76c3d5a8bd67a5b5b6bbd2dbdb735d754f4ec913d14524fc94553020115444fae08127a86d210190d550fe82187282201094264d702adf7965cb43478d3b6127da81455aea4483a2b34b1a270c8049f2c6f15bf59d97cdc1bf5c287e2a77fc26fdd73f28edf6d0f3f18ef7b7279ecfd0789b00fac4bfdd0f9e153a6f103732f49092cb14c22534a2942884b6985041782884c36ae25e22e6c41889ab644565028b10296c22919a62431a9649afa0287de0d5518e921d68c01b656505b7b1b3ce78883a9694c925422400803c4cb5e12122952649222a54822083c0225ca24858c4b0261984b50208583153361509c6eb8cb0be6c28c020e052a6650938fe8a24040050703e78ac120465120c14883220690543a090506989c8d98a04e477671b0c3d2dfffe4f4e99fe52a3adb59404012492d22b08fafc30fafbef1d864acee87c0158e571460e06689196638e1323fb6f281a5bfae3a506002c100060e2354a8a98d9527a3bf2a7dc48ef041bef68c6084e3c296bad0475128b7f0febffe8b08a6ea21224d552e8a70405c11ff7fe09def7c273f9bb7bffdedfc17c5f81906c6150717068e0a328b42180972e4a894185c91692e778c70a75a62644561c543164637ef9566060cc5b864208145d2ddd660469d3ad3a396573aaf9c86cd508b79a02e1ab58b662cd0c8560912cad6fc68f09be3786d1acbeb3f7ef9e7ff64f3255f7af11ffeedf6fa3d1217ffcbd7dee98c563eb4f4271bf568b4d396f71dd945869140262a19d051374908d2904ba6ac1525e6547b61c987dd3b96508b9f298f8c452a6606c21647d55af75edd94546bee7bf35684a7d762c5ee842f5636d53643999f7c6a2e4cdb694edb635d5ecdbb596218600261bcec2561e0861b6ee6c8cd8a51dc8a593177e1662e3364980913284c960999c871a1480304418aeca914246422774029408e81820e4b688116b92a0fcaa1ebd5c7d3949a48170da40cb2074d34a98312c8c1fdc4b865dcac9cbced93f3a9e7a7dff1bb1efb535ff1aabff1d5623efd135ff6dcba50ed7489f7c5f218ad1e8f136d362bde7380315444092cb912425c7191e010498657c6d4aec752dccc4a0a84349a9d4bc504464a82022da9e9a9bb0db5bea4d6dea762dba241f448112376bdb0466b5974b19f157bd415ae50a694571491978297bd24fc9279f152bcd452865a873a0c5e873a0e751cc7cd50e6d1875ec62c99d1ddd2ad26e114405c29182f7230d2e535cc0ad5d2d3cd19a18a0225b81450402232335852bbae0786f286ead7ddb6f20112040421040ed6b954f0c9ed46c95b941bd8f8b95f9c3ffa834ffda9af7de8f7fdb736afe77ffacbb7af7bc3e127deb32e7aacb547965843f5e8d33e33ffdd771ed4063ca1a00a6eee0450b00e068e2518661488927e6466b0c2319c98816dc1b1822a54ac8281a5434ef8448c5cc9e4d2168eb009483c38725ef331af5a3ff08c0cdbb7b5876454294466462852918ac8085ef692286eb57a1d7c1ccb38d669aad352a7cd30f5616ac3b00ce3d1b8ac83b7c1b25b16cbb0748a91a49c8af070cf5ac0481056bca7a5d3b0563d8cd5bc3a97824b52b2c06c361b33790173f5d74dc3f5329c0cc5cc1a74b2e12a9e615dd18c5eb9e4c9d639f67a7d1cae7df62f25d87fc7bfbbf9a637f81bded2bee5df4dbff2f33ff4ceffef39f6546fefebf94870cf50abbdfad55e51f09bef3efedbb777b55a09514921e8662984a5214746162e5909068573c04637471d9959832eeb18e67876e8d59a7b5483b25a753878efc519bcd68ad9c13c4b194b191e7b619fac4e1e9603b67335e46457f6cc1eb1f6ee3d6aefbcec25518b0fc5c752a65ab6e3b0aec3ba19d7755cd7b50de33a8deb3c2ec3d4ead87c09f73473658950ae2889114b52580783a407d989c494323aaab8407c84a01b4dac8a96b4887d4b2ff68a6ab76a4e96a20a820ce5022b04ea22c1a01436c54e4cd7ab361ff586c3dff9ab71f6fcf157fc713dfdc1f5d91f39ff8f3ff95387758f9e547f5ab12d3e42f557bd7e7ae39beb8ffd584b79e691749ab29e0ea40821c07191e02202197d3d57781252260501c5094472491ea4049128930c435d96d0339469492191850245c14ab44cc9f2f8e6bdfdb9c7d33c4bcfe8193da2f7dea2b7ded7d61b2f7b49d4e243add3a01eb9b6be4e63ebd1b6bdb5ded6beae9b755dfab2e6b2cf36aa2d692e25ea88f4c9a840c179918381cb2be6a2600615af50c1f8199924f424335baa897b8cfbf1bbe0587580954b49e04072a9740a186caa5dc36f79bd75ece56cc857bec6eebf97175e58bee99bcac93d4feddb2ef5e8da1f6ff142e6c3c523551d86d77ff4d1bbdfb378bc6dd87c5f5b8f2d26770f8aa52107b3e258620686635e721514e899475e0d4be4698106518d923648c01c189464144504909898d2b750419d21ed2e7c0c4590463ef34c660a32225bf435fadafadadab2fab29665e5652f895a4a8ac8ec59b731f6cc9ed9235af4166d6dd3dc36f37ca8eb58da5857ab4b64895687f42a2b4aba847b56834a6f6ea491c5d2094c5ec32cb0281408d483669c89155ff19d75ab7af5345c1f87b182f90a2b6ad4159660b55c45563c191d371fcd8e8672f2199f6baf78e0f45defbceb577dfefa0dffa6bef9134ebfebbbdedff56cb70f76bd101c99cbed2255e3fc396dac8e6c82cd10672da68a894c12544921230d39724b92520a5a8b792db3fb5218f120c1431260d6f1262e6571558fea99cce618075700d5dc4a585d3d420cb54cd7ef9a6f9fba11873e270bd6523532227a6b6d6d97b436e68597bd246a31c935d44cc595217af4b6b636add3b24cd33c0ef3302e5616a32b42d971ab4e0b532243e2520a3a0a481444623897baab6252125c9108c84c6536a9492770b731a9bb1c106040e7ff20209d34b03ca943f5ac6f7ab3ae6f6e3ff5d83d37af9fffd48f5dfba22f3effe7ffe854f18272479fe1d86df19851e5f44c73b3a474aee11132b79278264a42080c06914a73d4c1e96d743c322002105702c90c87209000379149a6271d28285364318ad546df6753d175d7e657fd86f99f7edd88b55866b5466de1ded7719ddb3aadcba1cc531faa86faafbff11b8faf5d3f39b97e7472edf8e868bb19a7611c867ae378cb2f66ef7ce73bf9d9bcfded6fe7ff0a378eb7fc6cfef1377fff326de769de4e9bed38ace3b0d41aa5f652fc92f0226b69a2c884930638b87051c065c51892d1a962e04a8700652a91e8c979d72baadf72db18235e44820b824b45b8543b0273366e47c63dd4579c1c975b0fdcfe3b7fff8dbfebbfeddff9fdd7bff2ab5ef8ca3ff6817d7bfa104f44bc905c375e61e5c92516a99a0dbeb4c1cbd678c538f69c0527ee035454b18400c7122b5458c10c9bccabe180ecd200024715732ea972a56296587204242448456cc54620429a8237beeade7cef8fc79a10b48cc89e0141eb7d6d6d59d679b1fdc14b4dafdddc4af53a5a1d4badee6e3866bcec25b1dd8cf33a4cd3308e431d8732541fdc6a611894b226d470304542a9e9854bbd6386a16a98614e25dd05cdb994a90eab7b83257df536567ffd66bc77a843ad860b1a74b295da83661644af5c1a0d371f2aaf381a36bfe7f7cffff29f5dff922f617ba2b73cfdcc57fef167167da0e929b8239b8c87c7f27ce44136cb2a77df88a79503185b6c1cb813aad548083049c82c0db945494fb2f05ba63530b9a7fb6236162f90801466451e9621aed42277d5b272a5c2da4b78161f4af543e76065ac363c777e7afa83ad5875ef66ad5993c2a3f768eb6af3eac3ac6174afe1a5785119ac4e5626af8359c15c182f7b494c834f439d863a561f6badc5aa7971dcdc7123884674e1c84891c1a5de88e619166983bbd2d2cd1223934bab68b066b6c8453aebf9e0585e5bb96e1ab9940982a007042c499af8193696bc4ebdefaffe0fcbdffd1b4f3ef6c8ebeefd6dfbaffb2a3df4094fb7f664f4e7e877d4f7c69b263fcdf87008d8399571cbf377ac8527a3f8af86fa6dad9d4825d325ebe223069110813a5e2db3009115127001024345900112574ac7327b4606b3313a179188a22851ced4bae21ab629b96beb9a3a41495f2cd6d49a64335572a9594bab6ea66a2a288babd4f4815230c390c4cb5e12431d86e243ad431d6b29431d875207afc58bbb9ba5e386195ea8c2785141860c390cc9e054a8c285438784bc42a25dcf967cd450efa7dcc006314040230dbc7369400875ac32896378e0c8f543df77fb3d8fbcfecfffa5f5ebffc1f16ffec33ffa17bee290716822d43ac7cedaf444578040a21aeec3915971a75abe651cbe6ddf0c365e2fb219b83033a7a4536496587a3537086899e6a5a40d5c312830628b18a043c10b0cc90124791ac2c4848d666ba0d4512f4761cff7ae94a568b2b55958a621ef78e160e632eba91ab250c7c386f48952b10226192f7b490c4319c63a0ca556f7a130141baa4ab1e2569dee944a4a7299f75ac1a07b3703b98dee8651bc94222c8d0682553ab82f99e7d8ae7829bc62336cad0e03c257c34440977723449082523118ddef717fcb8da3b37ff62feefbe22f21eaf0399ffffd7fe14f2d89519ddebd84e5ade21fec79401bbc9b126aff89efb557be322a29c01f628cb3c3b9b3313c0b3552c8c882bc04b8916e54eb682d7e1d9713c581e052022b1e911d02c22ddd7b2dd1054435824baaf5a40e6dcdf0f03a94e3ebfdf434e909b8874a53f6485a1fccadd4f0b996b26015029ad72c1b950d75341fc084f3b29744312b66c5bdb857c23107238d248544768884c4c8e0522a151edd72ad46314a621e8687102c1064ebd95207b2c32bdd6f99b6b50f3820b11a4dbd43034198020c1c8e2a6f3e1a37f73cd49f7bca5efbea7ceeb1effceb7ffde968af284324dd74de5b2919e876c4e074b34032eaf21fbe7ffbf6df682d94a8674d7d62293fd0d61be6b7c9aaf40e189ecae0520a1a16807a3f19479350f07f121d05a4682052198be450d38214383d19ced42373b23ebdf96376dffbae26ad6a9287d608353924052d180c667374cfe852b39275cc61c330592918b8f1b29784bb39b8991b6e65302f56aa15a7b8b95b1a8252a82623b95424034f59d366b0ad313947145081852bd11134581ad78db76ec66bd851508b3b240cca165c1ac42a0a14ae54ec355e5ff5b99fbbfee84f1e7ddeaf29db6b87bffb753f7e68f7553a74587a2ed2f5b467539914904b99e6543d7fc794952244f189fe85d78fbfefd93e14bbe9c39da099ba90208bbb01860f50c1b00d6c604804852b151cba70914050924c94021ba00a896db865ac4d2eeeab3ebef663dbf7fc3b0925a5cb32d5335d219c1689cb16582294f4ae465599341c599ddc07c3cd0a2f7b499817733393199764a49bcc34b85a951515932cb0c4d20b975a73ebb8b91b6e98e39e6605eb2010ead5d509c0d80c765c8bd58a0196580761515cd0024192808399dfffd68fc30a38ee587de4850ba880308986af69d74b79a477f0e246629482d530720c5d3f8eb3b3048c5bc566e78e510a9e6e168834d2c130af61bed662a9709bfc1232ef1050c03c095fc99e2cd04be9eedd7d174cce52bc412494d2a8075fd37c6b75f98177ad32a11ea5f8306a152294a488c0bb1a780b4fad87a0da9065d238db387b9dad54f3fa0ddff3ee93a3edf1548f8fb7dbe36b9b6998069faa5dabc67f49def18e77f0b3f9daaffd5a7e36ef7ce73bf9cff1f6b7bf9d5f50d1b92491610a535a0699744c1061694810a8e04142768b702d43c982bba7812040d06151b6cc2eeda4527878b0072b5b7ac18bbc9b1292de214105ba8b041286c2839ffdb6f2da8feaeffb09fba44f79f6cf7cf9bfbc382fd8a97992c087944bd133d19ecb7ead7a18e15c71afe3ab5e6db8958148c003934ae69c1cbb5f233bb4c8665dd94160e0ca58436456548188707e46400652880e3d2033c954469226528059acc95976b9aeb9ce1f7bef6cd9c54c2b65b0d2a46849294e08939372cd8a469bd99813e3a8f14ce3401971c74cee3287b45a6c4aabaa23e2653fdfd4c1913ce5c290831bff898161251d333a8e2c5522bdf7099bdcc6f401ccb96490a43a124dacc1bdd5deecc32d6c1b4cc50d8af88812041411ca1101d5ec818d9f3c7bf1c8dffef257ffbedff3f897ff917ff8dcee438a9b66d154460bf1f8dc853e307737d5e452e123b29671633ed6eb37cb73cf0b06c038c15fc8dc60c75ebb328a0e8a4c71c92969964ee67db5025bac414d018e55174e090a3fc3850712062e4c1431884cd6a0889b6e6b9725835068f3d64f3af9ceef1ea32372092bba944913ad67efb9b4cca6f429eb49d623f31d3240b8e46460c6d82975dc9451e2653fef0ccce4c85d988c3457adb176bcaaf4c0c3acbb8391dd0d082bb6752ba57ae152c331249a6c71b5645126dc3b8ef70db578a5125895852132a951b8125c3261cead81cfb971e3a96ffcc61bc3f8f4d7ffebaf796effc19ed5ac3b1be31ed50f46df617792455cb702ce8b0c482a771deb68d0f56d148fc4463213a7c31dd7c6a84e698602e7920a014bb511f60b1795098fc2a2743073e74a945c82455aaca479375f8c6a34735906bc71da3ebbae3396c54e86e122b59a8356b3e10bbf78fcaeefc15d5d867aca4829838cec9174694eb21e34ed35eea95b5164255593222173369d41db64345ef6f34c221305996427c3b20b1720911d25c9954c30a2595bac2d2339ba974c078a4322925c21494967caa1daeb278e8a4ae9cea5da4d099dde4580200103632a7ce6bdc7479ff12b6e7ffbbfdd1c5ffb9a477efadd5d411abe4fbb55f236fdf1e8c7c53eb0ae383e909629c00dcca8f5e33ecdc60dd394d133e458815f3ed47f71982f22adb8659694bab0c695018fdefb0dac13cf251519082a544f997129d521c9105236454a324020c0c89ddaa21ce0c47586b09400a9cd90b2489320319348b5cc66bef4b8c8d622fa616a87439b2e729ce4c849f3f492ea72696edae4b134c878d9cf2f73949672e4c2248f342f4001f3629482499672e89e69d94d391993a88502a330aef424338159f4cebda33d9ce5a4d836a8a516ae143088a08060101ff1c9d3f6e1dff5e77ee4af7de53dd5ffd5e34f7def210e492721bdd6ebcefb0eedd8ecc7d7750eaeb9954e3a2f4a0783ea37aedbc97da56c2a3548a0906fbf79f4af0fb389d31e6e26cc24074426d509d95dc6160e3d4fab1f83038682b170a9cbaa941d9c80925c32310813262c7130b88e15312f6149158bb2fff0f75dc7c64421a0381822111682ecf85ad57ddfa75d960dbe258be4a2caaaa2239866a6a31b318dc6cb7e9e99436229230d4caaa652d25ce6324f33b9094bccd3089c98ccc7c1bcd4e20484798180c52df19e399366feca71dc0e030695c40061223b350b040606826a7cdc97ff8977ffd53f37b97fc79de55feefb597a5376a8e6d7f00787e12cd60f749e0c9d986d70c7495e6438d5a917fffa1f6f3ee93392c842331c5c7eadfa675ddbfedbf3e54299281c9973c9c091dbc1d88cc3d472dff37666af658335985c6bb18a77b2a5c9ad7b81e85e2253469a63c925b739aa88627e54a7d5554435baecfc9ddf7673188e7d35035dc2b1c4241092c92257cbbab2740e2b43c356bce2837c22c1dc8e0f1ce2104cc6cb7e9e09cb40a044dd72159602912464a234ba203bd12c9bf5652c39c887ece65e0c44c0422e3d058bb4eb79a3da2b8d62dd0ae0980392929471499554f600fc64607ef291eed9e109b5994872353a2a9e4755078bbde9347b9a3054b283f33354bc43bdf3e38f5cbf7d31deba8f4845043854f8e2a3edb79f2f25b5924b70253b570c6c9f6935ef81a65c3a0b4cc50503460a8214a2d13b9265273a917877299490e82c7b9038e3d6d77d6c4c8049b7fb7ad7e0274522c3304396c2d39022a5507629636db1f658d50ed6aa2d85e2d48a259e7671a1bbed2c358997fd7c93294d32e14a4b87e298830b64052b2a9e22e5d14b5b3668836fb182d76472376864260612884b2356c145096a499317ae1889c8a04287411c196fbdb679f4ebffd9bec7e36b7ef76e3d8b5ca42675b8d7cb43561e3bf4a75a7f7a8d0e75704b2013071c8c3c72eaae6bf8d073e36e29782153c2ace20f4c8618b1a0885c80808243226080ad31180d1c425428a9ea56601026082c306189250e35a82285672c5d26a664fb899fcc377fc76456a1c19d45afb8f7ae7bef5c202e49b809d2656ee6ea1e82ecfb838d87b041b6311ba1900603e14432dcd1f9f2ece1f886dbb73ddf1dae0ff6c068b72ab73b4f9e465df6a5edab538761a875ac65a85e9dea76e3e488ff2bbce31defe067f3b55ffbb5fce778e73bdfc9cfe61def78073f3f5286cc64a6cc34d24b969ac5134bf3ee35bc6464a679246a5eadda25c71db7308a2cb104e19ddc9343f1fbeb7873a86ed50a6e8085c010954bc540c006de388cafd95cff81fde94f2df95d87f976d2f0856c20e356295b2f3bc593a1261f8d110704852b8e4ff0eaa1d60b4869980f54ba1122505a3a7cdcb6fcfb430a644647058c3417766ebee237eab0983fdd6585626610aea0b83197549056d7e232ef94ee74b7281ee4ade28db277032f5eea27bd2dbfe55d83336093741e9cfcb63ff4c05ff9334e183240b87915811599653791196addd7bef4b425f10e5dbeca479971b6cb8b832ef2555bdf3542084e8aeeae0c66a7a2ce39ac6df01c82712052913e1653315ef6738b2e890ca2a314a64cf54e882b82240d020275e890e090c5d3ac02ddb42a1b74724feea49be677178daea4174870aa8ca42708c41583d794e1a3aed56777e7ef69cb77ceeb87d504cd58c90546b787c7f2a36d7dbcb7d3501998ccb094231018b853bd3c345a5da387b8beb0a9864417978c4b378d01ad227a16a1be60eed592bacf3e8f6ec4bdce50358b8a2a8c6978202c9522d4333d945d5d64e0209050782c1969190eaf79b8d1bdd4c1b5753ed4daf35ff7171e1c299eb32820c022cc3a2c196e6052648b033196f5c0306a35191a8ca5ca524e9c5db417e2e29eb2989d8722749cf690b87491b0e4302fa3e514362521457a5624e7653fa7cc544a2965a63c71244386904cf284c4038feeebeaad1d559b8c11267c12829e9780cc6495b27373b25bc6984c460d6ac1c902011d122c1054f825776d2fd6f8b1d3e51bcf0fa799065d446a0d023d307a6be1d2136b9a3489230c6142608641818f9dec86a8052aa5622eaf9109068e397cced1f67b9788160b24962040b83890418ed88a5e596a07c48b222061140e888f2ef57156034b0a0c410daa198d55aa62ec70766162031b3068d99f9ddb2b4b3912b33030401434991dc2aa542453c6b25296f4055b9485442273c835725dfbed3bebadf5d1fdf0c0c8ae09716d6b3d89d45953bb68e37e9e6cdd6c72dbd57bf4b146510ececb7e4e21f5cc1ed933434a29ad8697c031c7068ae3b8a2379c3e9abb5bb15adc8ad1b190562f0b023fa8ef712a2775702f50c081341c4224ee804185ceaf7fe5bd39cfdf76ba7ff7d2cf920d83d04a76b2c1dd83ffd2e3ed87d7f8e935f6b223b323b36a0e2ec0d2c8817ab3d8dba6cd7b7aab8b97305e40771951bdf70054bdc2c3c7e3e7f5edbf3c3d98cb65b5b316644a630fcfc2c37578bec71d311573284ec96ad0b91416c82b5e12efb8b030c31ccbc09bb152b0ecb5b076ac0ed8685e0a6ee35337eca37ed79fe74ffea1d265e05c4940208344445a667ad03b74b10616b2508dec2db2b7fdba2cda7596c29d4e87359108717be170119bddb2b1c3b6db92d662ec91bd6484f3b29f53bbb2b6b6f6d65a664ff558337a668f8cb00865442896924b59e7b132e2037d74371cb466b64c1cc19eeca29a36a65222dcd2e895342081c40569904c03c75ff46bffd6577fdd8faded27d67e521d62490e3df664adf6b6a371a63fa978341bd5063787342005d51370e7a3b7f59bdbfc29e354ef823b2d4e83491acc48097aeb66b6419f3ed6770ffe03b3456416e898ad3eb04fbdb0e69bb6798fdb73c4212541508d23b702410a4417ee6490e11978ba080956a9d1d348d068271ee9252c03d2324c2a84294c0105cc4c20b0214b5331c943d15b2cf219dba281e8ea9e6d4e1b62c976f6fcba3f7cd7739bfffa5503959dd98c1ab617efffd07e9afbe662d9da7ca461a5f6b4c8ec25228c97fd9c7a8bde7aefad476458f65497ba2cd228ae30696811bddbba6cb00926b12d3e40119d244920d9a7a2cbc458a9a20415b9259d52703e220113037cc9ef7ec757fff5aff9f72d3fd4fa7d4305f67965af3cef7ce2b6de83bd77c9c7f67d15d7aaa63477a144607852ddef825ba18f99a643cffae8da1facc3925ac3a65a2ad10149a8c08343f9bca3e9dd73538160c594a08cce69e41c3a713bb2a179ac9d73721f5aa4ad594d1b244b6aba830b4f704a328181094b3cf18e052415464c705d76e7e976fa37feec0dd9a90418980454a8498121f14863a14db11abe92058a5894aecd365cf1fcf3edb98b7938bafd60b96eec124424cf2ebc70d6a68b7973b63fe262496f611119517ae9b11a2ffb39cdbd2d6b5b5a9f7bce112bacca869abc9b751fd39bd84387365673b38dd7c1cdcd3a0af902894bacf4865be586976a8eb9bca4952898497c8401297ef3dffd9f9ffea3ffcd8c0b39d53071c9b92283132fabdc40b8938e3956c071330c0a54fc3eafb7d31ec06e0eb5febd79fe7337878bb017d058521022b16e94626ebce66833ded9cd2a56e49020c83a3c9df93474f32da40d75c8bb2843cda79acc0d24a5bce2053c7130cc70ef8a8a2784ec527ab1bbef2fb5547ca460dc3d0e8faceb534d0f0ec333b13601061408189d217df01cb185508665cb483c88c00b165a7a16e2e2b4dd3eab0fddfdbd67fa925be576d7165b829f3ee8f63e36bbd8ecd6558795a1ab84883e445d7a152ffb391d0ef3bcccf3b22eed457ded7d8d6841cfcc9e5dd9942b6d6ffd305436f8e0090484589250020b3452a84035c352a841232d50c1ccf908c3dd637f671ff11d6dbdc8bc6b1c3016c502cf643f85a1f2d064ef6f71865e28e96834dc48334807730a7e7fb5b76cede6500f196fd86eeaff76fb70ff8337ef9ccf736af13a625c4a056472e938b9bff8bec5400e10c14a52a6b36c1f5a7d5fe2c8d88b39f5964d054408130a043dbc9692cdb27936f3e04a7aaea899022d10ef7fb72ce4962530aea726e38327ebc307ffc9a64360a602c20486798d9a59a5ec5d43a435a3a70909a5c8b448795fe776fe5479eec1efbb39fda607ca83a3d5ca071bdf7e3b4fe7b61ce66599d7d8b732840f692552dde636c4d7ff9b6f39ae9ac671186a1d269b8eddec24f6a359e18a5d72b74beee6eea578295e6ba9b50e43adb55caaf5e4da357e3ebce31defe067f3b55ffbb5fc423abd38b488656d8779de1de68bfde162b73b3bbf383b3b3f1c96655997656d4b6b738fb5670b5a20b394af17d6968c5ec44676ec56c0924b02320d3a64aa231335c03161c213370c2c80040482871fbef1937ff4cbfedcf3bb9ebcd2ab4917a2273df2ac61d53fba70bae49cf9d3739738aa366105481cdc28c9a6fa5ba7f25c8f2ddc5deaba6ff53afea51f7cfe2fdd7d63475f9b8d830a268c4bc9a5017d542d1f6a91f8185ac1120a06061398f0c4c4532d6e7ab90e3d54922a9654ed4c49214b522a2555135017264650a87fc3bfb6c00b4398174ecc6ee0cf3e9bafa9c30d963b4a4440458081272519d0242dfdc0b266597dad691b58153dd7c871eb4bebcf7dd86fbdd687fa1f5e337eee353b5bf8aedbfa81f7afe3c5613d3f5fcf762d0f3d6bcf21d27b5bbaedd712cda3d59cc669a85ec6ad6de446f68b8d5901fb0837f34bc54af15a4bad5e6b1d862122862b42fc22d722d6d697b5cd6b3b2ceb7e592f0ecb6e5e2e0e87ddb25e2cedb0f6436f6bf4256d95ba95d59564020a883af868c50af2d2b8b242261f214be43228388e5ce693177081a07125c4a6da27eefd0f3d7f783ef355a508eb22504f3f55aec3e6f5d6dfb69d7eb4f59fee71219f4c1b28e018e6068331e09f36d4097b689ab6d8e7dd38f9034f3c5befd9941f5cda8d233f9fcb6de4d860c8e9461309264b2f69969015813a323beffe78e5543478b6c51dc5b5d5de3cf1d6617c2a231d29319317abb563826e867b5176f334f6b8175afaeeb10f2b8b63863bbeb1bcb7d85dae87067fb0940f75090c0a3fe3c84be253f6d1b4aead6eb2b7489325b22a3ca50c2cc3cfcffce2cc6e9f7cd387f2a157f9067dc7b3b9bbb3aee773db1dda6e69317786f039187aa7695ecbda6c993dc6713356afd3aa2d43db8bf5d8bd82db25cc2f15abc54a2db5966128e358c731228608654ae217b9656d4b6b8765d9cfcbee305fecf6bbddeee26277b1df9feff7e78779b79ff787797f38aceba1f5587a6a5db235d6995c6be449c12d8184c28b92f0ec41985668c80a9864969689c2e8100624d0c560fef6bbb6f3ad7bdeff81271e1a6a989ad48c59795bf91479cde6cfbe7ef481b9ff746bcf4b546ddc06c0e80818c0aabf7ab007b66584b4fccc7b4ffefb276fef2ad5324bcf8b25bc47385028905c11973abc66b09bd5f7bd3b72e11068513eddd7a7b1bdf26238eee5f88558cf97dd1b87a64b104828889af934e97818a252b4120b45a64c5ac9e7a3b51a0b763ca61b56d88a27d6f6897feacfbff24ffee91f5cd5cd8c8f5088002fd4c407592a744083a814c924a5d59ad90dacef6c776627377fead1f5ef8ce33d951f7dacd5f3a5cd87bedbf765e95a635e7b997bd934b1b4c3eccb81c396364eebe8f87460b161dd351d9afb00c5ddc04ba15c721fc6320c651ccb308e9ba9f5987a446464f28bdc6169f3b2eee7e57c7738db1dce2f761717fbf38bddf9c561b79b0ffbc3fe7058e6b9cd6b5f152d9549ca3224d1e562234661897345909908412629081918d880431134d61ad9103fe3bf3aa90fbcf68d7fe85d3ff8faa1061c928080f3351f6fd1a69bbf72737872ee2d78660d60631cc3e886007372846df2b1c348e451a9886f7be6ecdf9c1d7edd8d4dbdcbebcd9a5ff4c1e7def9ea7b1e59fb32c690a5400a4b92c8e48181d7157fb699400192f56ef869cb30cbe144e5d831d5a3dbe98f2ebb07aaed92224c94a43ade71a083ab72453d49b941f0dcd21452112b5e41b981b969fff7fee787bc204c2a5c31a830c092490a890e899a5445efb804c62519068bed0fec663b5d9f3cf336f872dafba1d5dd1cbb5dec773de688da19ba86b56a89b3830e071d36ccc3b81d3c7d98746275bd68b1ebb56cc0ed8a5faa577c187c1ceb380d9b695cb7636fbd6f5bf41e9d5fe476f37258d6dd7e3edbcf67fbc3e96e7776b13bdf1fce77fbd3fd7cb65f2ee6b65fd7b9c792b1a6f5b488cc48cb2ec554bd9803c2c38d4b4940830459a601ae4015cc315fcd6f57a37345028e8a89facbbeedfb1f1eeb09d6a4e44a4f3dded48fef3f5e9e25c683ec91d60cdf564ecc36382f32a8b029fea6b1dec770a358c05ba7e1f31f3dfdd8a3e99386b1d662f797e93df3fa9d6b7b75f53b09c5b6c552ac46937557cde1951beada570c133242aad66c4a9f5427243324cff1f8ddcbf98375c4d36598e1a550c00dc3392ef59081808a0550dc9f4edd30eb69f24b03c41069c6f34f3ef5d0301a870206060e890a4c5e26e358b6336aa6d4d608f56418b994c210a2afeccf385cd8c5fcfc7b78612c7eb1e4c54117e73acc797e27aba52f5197f0d63cd7be1c62b7e67e937b9fd651e9b5c6526b9f63bd4d2d276ec5cccdbdb8975a874a1d8669ba71b4b9278fae918369955ae61cc12f7217fb79bf2c17bbc3d9c5eef4e2e2f4fce27c777e7a71717ed89fedf6fbc361b73fdf1ff687753da45a44cb9e5a5023e7811890a04325333d416487ce258510086561023c67e59dc81784f3a224a0265f75aadf72e44be42974ae2cca673277d7ee1d2e9ef97537a6e7badedffba3914703d7cd26136407878a7be5deea9f7332eed022de7663fcfb1fba78e878fc9d771d9d29ab4937e041b77f72befb0b37ae5d645e64df500c10d1a3ebca2db8cb68529ac6ae1908a80e69b99029af944cca9394c56295c4258507a6f40ede416e404fb5d245a681e9996bf5ae5ddf23d5cc9a0979c972358d855299934b15c42543c22803d62824790806d4180c0bac88a01428d069e7ac175a0f8cd83c685dd45696bd7215a6ecd9225b44cb6e6abd0f6b2c394fcbbe4c1ad4aa937d94d40e77acd670ab6656bc162fa5da504b1d6f1e6f3fe668b83bd6ddc10677334b637af0417e913bdfcfbbc37cb13f9cedf6a767171767bbb3f3dd6e77d8ed0efbfd61deefd6c3da96682da39121eb69ade7b25a8b0d147921313720532021a85c322193e832a05a76ddce7e072f4e058343e64e7aff70f2dbfcfcb4718080024be6b32d1eb3329c3ffd25d736cf373ddefae36b70a9433587e445024beb4cae9e6130997bd7598feb60a9b5f73a62c043c3f0d3f37a72b3cca959a9a8d535242b570c36c6ddb52e6b3f172b4ad10079894e0a5908c3ccad95a3167b17bb962ee8545113e38a751c080810972ce8320b04bdcb08832ac6f46797f609af7dede6e93b4b2208a85c293048636784299869a5b71861991936b8b8d41c039276c6e18cc31e812dcc8bf667797881f90e7dc6200ff2216d08b7d696ba5caced625dcf59fb68e96ad95c756a6777c6ea5eca58acb8975a86527c18bc8e7767db6ebc3cf0861b376fd961cd7967aeba5cf08bdcd97ed91d96f38bfdd9c5e17c379feef7e7f3723e2f17cbe1705876733bb47e485ba9ab4590419072cf62867b4262c225ba39a2839315040958a419b0c2299c27031451a089673ae7f77ccc67ee7ffa19d9cc95912b4ff574cc2810867149803976abd8643e40231d1f8cc1b8e6fee99bcd0b8d8747fb8407eff1d3dd77b4f8a3771f6fcc8e4badab836c8033f189bff3b77ff7ffeb1fdee97d5738c25548a7f7584db27aadc6c470e8e14611197403843a363891e97855dd9cfa61932607a5dcc0c0c1b9e4a520228dea04508b3ff3fcfe93a6ed922c69d7bc389ccf3199ed82a3dff47b6efcc73fbccf4c2e0928063283d56d9b4c45de56ca6188be6627841b294a4272690dd660eeb008889565d6d2724d1a784a91dd73896ed6965e5aac4bf4656fcd6757ed875c2da7ebedece2b8b2190619d5dd4be9a5d461d0308a387eddebebd135ddbe93fbd9dccc5c8f3fbefe87efb1ed11a5c6b2b4e36b87c3fe05bc97e25e865a865ac7619886a1d66ab55a29d7ae5de33fc73bdef10efe739cee969ed9235be4daa245f6c89e19a9dea347b6d6d61ecbba2eeb7a98e7d38bddc56e7fb1bb383b3f3f3b3f3bbfd89def2e2ef687c3c57e3f1f0ef37ce8b186d6ae1e913d32b3a82b9a7924121698931846cab83440c51bb9a0a68c42060a6630cc4a223508df5cbcee57fcd6e7bfe76953333a020a5764fa808d7dbaf585c7b767e9d1b53dd613e3c1818db94140874aba7354ea6b462f955714bb6f3bdefa835ff69a2ffdbd5f74f3e8bec15798cc2a120838263fefaf7ef55fbe757d0717ad79ad052c0329d5436cd1b169210f4828a1f715e1a644560c034a7ae9643878124a8f6eea9e0e5e088f00b93a999e60783e2f6e9dd807f7ed14aee30ef234e79c3cfb9ffedcc980932db954b0048a945467481fc811cdea990b1694c08fb08641752e1518617006b18ab5295afaea950c8790659299e1567ae23dd6d6fbb2580e665efba2d67b6ee725b7eb725c9bcc6af12bb58e7565e81f46edf6ede1e187fafbdee7af7a851fdd883ba7cbfec0f98e712cd35837db091bd6f5d9ae0b372f751c2ed51c47454ce3304826f10bac45b6c8b5c7da62e9b1b66c91ad478be811adf5b5b5b5f5655d97659d97797f9877fbfd6eb73bbfb838bbd8efcecf77fbc3e130cff372a9b5e8ab5a127985ae92a9ec1e41e792158161924ce050615b9ca4894c297091d0b96403224004b4e3237c73a2783ad8110e0314f7dbbd3fa6a37e74f7f5dd63e3663c138f2f6170ab720d8724e9468501b6f8eb8bfdcacd90b0a45eff4bdefa86dffe8e5f763c3decd4a4c28fccadba3010bcba0cefbe587ec9effed26ffaa7ff4f8295b8e66548062830c98fb11369715f52821599847048449817650f2777961b9c0e824e159e382fea141802535a2254c37ae855bff70f3df757feea1931bb0fd03a2412f392b7b0279325b914c80c0b4c38d4cc293586963e97618e368b824fa420916346042be0346359341fac1db41c528bc52a4b49b9cc99322bbeeebd378ba66551970ddbb2ce7668dd4e5ac4b2ee4e878297d1ac142fa5f6a196d63e1ceba3ef7fef9b5f798f1d0de5a187f2a9670e2f3cd7a729c7c9c6719a261df66577eec3f8c6a323db6e7ff4cef959a9c338b6d68e22f28a06895f606bcfa5c7d262e97958fad26269b1f668116beb6d5dd7de97d6d6659dd7659997c361bfdbef7757f6e7bbf9b0acbbb5ed972b73cfa5b3505757606a32645c2a694363f66a2eaa994475af787546e7520001064574ae48325badaad4281b6def6a8c5ff8a16ff989d49a5928ee54b7b39e8fc9dbf1bdc7a78ffefaeb474ff77cdfba9af95dc5ee72774320c360b41cf1d78de5f38fb64fb47875b5d71ed5ffe59bbfef4dd3f07ce71e2bcf87de73683fd65a0d7703413abd9ab69b704be8436d6e11648654c3c9e20472b0049b8ad6a01a065d80cc84dccc2e283731734c292fdd8457309ceea58097c0aa5934702ba3e2037feb6fdeb719df7f6817ae6db155262820fc6eafd7881905578aa8068689e6656b6c0aadebd0dbb0b6b524696090d80401955a282343a1af808461ea494820649a5318c5966e2d6c495f85efc9ea2b250e6b3db4f0b3c372b4dab656dcab7b9446ab0c7dedf1f4d9f99b9fbfed374e6c38e2d96797d3d3db65b071aac3386c06afc3304ee3344ce7e7751c3eba0ee5e4da7e997f74595abf12115326bfc00e6bccadcf6b3facb15fda61edf3da97b5ad116b6bebbaacad2feba57959d6659e0ff3ee7038ecf7bbfdee7cbfdfef0ebbf930cff3b2b436b7bea6af28a4cc14cd4853ba049164765a61c0dc4c042460e68884c522b8a43240d73294b451c314c351bfebb5dc7ccb17bfef1f3d965d49711f4b1463163f95edf6d103372f1ef94d378f1f6bfdbdad3dabbc77f06dc1418e3adda89e857a54ed6dc79b27d11bb6f568280f9d6cbee6d1e71fda8c0d7debbc3eb2c66b87f247efbb5197cc0d576e38c7a15ffb37bfeacb6e9c3cabe64d47c3502c2c9524e44856cb2d1c8c50625649072f78902075670e793852ca935423429124eed5082f09966a25650a088fe2fcf8bc7ec11ff9c34ffc8f7feb39740c17f4bd4b40a50cd09d889e5c124a37874c2ed9406978256959571c4a410146310c8a334d6c47bcd02aa5528a7cc09d324008cc1c302f980c032f1184a25a11b5c51c1dca458b43785398276e962533a75009fdf0e9c55b7ee807efff825fabb39ddffb40fcf4237b1f369b65338de33294712cc3813accc3e8431d371b96659aa6b7dd7bff3317fb27227bc45104bfc0764b3facfdb0f6ddd27673db2fedb0b47959e7b5afad2dcbbcb6b6ae6d59f6ebbaaccbb2ccbb793eccfbdd3cef0e17877939accbbab6b68622bca7a559060a43984c2f3281b854020a48c57c7236b8072d49d2c5982ad82e72cf90f544658abaed0f7ceceffcf0b73ef2f47ff840245061821a5c7aaac5ededc3532cbfe164fbe8d27799cfb5bc56fdba1909a49248cc98f013e7e307b3dedf300c673ddf7aefadbfffe853d52d220e99a3fb07e7f60f5e77ef5b7eedafa987ccebee2b1478cd581eddf83d66e7597b74b93bb8a862822ddcc090ba3bb0465628e0410841eb529565861553b7049189124f0a57d4c2cc6a404f4b010a6ada0fede74f7ed7777fd48d931f7ef6f66cb6485d1c3b953c129bccece23f4999615045ede95209b975ef1d9f1966aca0c0172448ee7b23db2db5d056ca05889889aed62949084ba2ab2cac07622562cdac3947df8482682ce76d38da65dcd67add074bcb6a6ec5f1548eeaef3feffb93a17ff027eb3d77d9ddb7a6f9620d531bca32d571f069501d18061b06c6b1ad8798a6ba39b25ab6a1575e3b7976bfdf65f20bec62e9fbb5ef977e31f78b43dbcd6d3f2f87b5cfebbaac6d99e7b5afebd2d6f5d096b5ad87653eaccb6199e7f930af6d997b5f7b36694dbabc5b4d214b79217a98bb0b6b2aa1ba5963054623b1c97cf4924eebd141f22eb09ca5f3ba89e9baeaf5b6bda1fb3ef115cf7cdf8f1c34e34e0e7835467c86e75a7f62b85ed43e4da74f375be0fd2dee2ee52ef78a432620dc28c64d2f9f32d4d74ef541f70be9f5d3d477cbd7dcd907d6cd1f59e2b36e8ccffcde2fe5a9670edff08df54ee45db5021d5d1f86f79daeeb8d61bbe473e2e075340192a27849df0cb9a44e22227daf2c1680192eb283c08cb42c05b2402513efb843a1989366153fcb845a2c10988f6e6719dff5bffde0e7dd7bfdbe3a3e1feaea1bb37b4a290c1b62a28d485c12e05885c2958dd7ad7a2b5a7a8fb6d6baf684622408308689eb378edf7ce3936e9577fd80b1740e330ca84021129092bed261edc46ceae0746c3e08cf7096457e7ce87e1e6bc3548ac9e8b252b210a99afacb4f3cff95fadf5ffda99f33ff7fbefec6affa4dc33fff7bcb5ccb70a8c3c4a6328c3e0c3e0e368c1a474d9bbe345a9b8e8e8efbeacb6141fc023b9fdb6e6ebbb95dcced7cbf5c1c96fdb2ece7362ff3b2f6653eac6d5d97a5ad87d696be1cdab26f6d5ee7a5cdbb3596b5b516d13b5db5bb4528f5223ad5acf7042a4e21a450430d063c2c175249130d85b4c2edae364c7d7b571fb679d7ebb8f6aa4f7ae29b2ef6a77bebbcc83cddfd9c7cb6c7b3c351609f66a7f79b3d91f1780f73ae17073a29528e92828f854f38aa378b8fce85e9de4ded4614d24d104e5628e4e854a2941a1973e6161a4cf0007ccc5ffacb3ffa27fed8e9caae352be68944893ea10d2914ae103bcb0bd4c4254356b04034280bb86790995a88ee99a41c8c46c1e3603a5857c9962ca8bb55e73faef3b553bd659a829e803114cb823c4a2da6ec293004463a0e4aaad9e03eb434642ce986075e70a30614a62d0f5dffc31f33de3ff22b1fbcf995ffab139d678ed10a0bc18b0c44348ac32075ca1443478179d611c2b1986e1c9aced091b963c52c448482ace635e2cf3e79fb6f7de027278678e6d16badcd6b9b973a8c4d6bd538d4611c86cab4f1312cc27a44a447f6271ebf3e6d85f805767ae8fb392ee67ebe5fcff7ed626efb7ddf2febbcf679d9aff3b2b6b5ad4b5b0e7d9da31ffa7a88bef67917f3da5a8b50c77b7ab867bae42048a8c62501ae620ae450a546c78b326d153dd5208db97351bcd54d8cc7ede87eddf5c6bb774fdcf3e837f7f3a7104283f960549cce136bbfb3b96b1d4f3e3f9edb28cf83c77bafe2867b4d3e2281a4e209066362a4e1323c78d32bcb5ffcf1e722e385cebd135ff7d0f52f78fbafcef73db27bf78ff7c87a0dbbe879a3bab8f2e1a63ff87b7eff97dfbab6a39da5b650cc1c2a4cd8b5742305c558dd774d3bd2640a1252b4963e4486d542498a20643d1d9c1719084474116c44726584dba1f72dedd7fc95bf76fdcffea967961c9d7b6e99b6f7e9850f8c199e5993ce150913971c0631255bb109cdcbc1eb2eeb9e0a14b2e11df88c370dfffcf1f6c18bfc036f18fef1afbef65bbfe93e1e3d667e8e0c08026a01a308060862ee2ec76adf5107b293ca3e67ddecd772da0f373c472f98b94c4ae1202c4cf1eddffa4d9f7be37abefbdfdfff199f32ffbb773ddf14ad4e433959c6711ac661dc642bd15c93673352aeae20ba65bbfd2ddf54a7cd73e63e0ca7e66329c50b46428ac695339fb8ebd5489861c6ff4148484880a45446666bd922969687b59fce6d77681773bf98fbf9da2e0eb19bdb61edf3dce7b9ad6b5f97b5b7e8cb1a3da265ac2d7a8f3533bddb10ae86859594c9aa2a1252105d98d502964c9e4a9fbcca5a001d9b71896e71e8b462bd0ccbe6661f4ffac92bb8ef133ef683dfb01e4e87f56cc68a51ad8c46854c4e33ef1cdfd7195e3dbfb019d4658f47bb6675e3eea4e390bc28f1825fab7ce1f1d4c5ab6b39b27a52ecf5c7e358ef7fcd70f11baffb6fbb79fcfa37bcbabcf66396efff9ec3c5a19340fd0d775dfbfab35df722117032d80fcefd811bc74fbfb03b6febc6d84031a70e43a70cb1a528d28a66d99df4595d6026131620305b29b5808c64c6a903a9c247182f52968958b812f85d58169e98e35d5ffe159ffccae9ad9ff1855a0ef5977dc1a35ff1fb536c285b324c26c415178321106cf1eeb92d9cb7b5f639d4948143800f60cfedf4de1f9b89fc6b8fb75ffbb6ed777dd1cd5ffed3afe5e2363a27b8528e188e704850e7e299ba7bde6cf0c4965918862bb08a8d2df73dc1a0cb0c8754a608c92ddff9de27efb979fb63af1d6f3eee535ffdbad7d9bb7ff2e95ca2161b16ad930f8dde6c6cf4d57aa3a765780f45e4ba2e759c37ebf55aeb383ed9558a0feec50c10085621295f78faecfaeb38ba0102c38cff444902525e8988d6a3452eadcfadef97b69fdbc561bd98dbf96edecdcb7e990f87755ee7653eacbdb5a5f5768858a2f56c4b3665cf484b45f69ea61029899a1eb282418009243aa6f4c0d39c4cacb292dd4c64e261a50fa5978dc6a3f5d61bb9f5465ef8c0bd4f7e33e78f49ac608e63ee69d09367339f9b6e44ec3eb9ea3673b7a1c38246c32be01d482005e67eecf68a6267e4c76c87d1edbcf7371c4fd39b5e9fd7eb3b7edf5f6fdff92da0f5077f7879e2dbe6ec5949c9a0fedf1fbef54f7fec7cce18cc81bb8c27d7fef8c5eec4d5e917e9eec5107483c930816b48d6a29b62d7b417157513970cb4761f318505c44a91457a8655c152004dc69d1a889e2cceea69a51c89b5fab7cefb279f583ef59bfed5b119dffece0f29ef783c534240a054970332702e596a741bb28eca718c968d1e944e9940d84029ef7d2a28c630d0f21b7e6479f4e336bcf12decce599ec7162e0d5bae3fc8cd5790c90b1fe6f4c3bd1e555da40d858f488fe89b1bb9d5d9ee62875fc7460c496686452a911b52fc83e7ceff1ff8ebffe5bf3af9f4cf78c5d1d1e90b77f6ad5b4b75d918c7c8844ba42c21b190f5b0a95f1b7bb4f529fc6818df320d67c107330777e3670492e8e0b77f6815dade38bbe7e3310361cecf10a05466c4e9d33cfd6335bab7362ceb38cfed7018f7fbcd7ecf7e5ff787cde1d0d7a5b7b62e6befadf7bef6be46a6b4642c914b6a49da70b48e77f5ed8d649442a4c27124c0a17249ddb279c7d3c1b12a6c41321325cd55a7186ef4e39b5c7bf0939efb91a776cfe5fe996bf3f32b54c360480643c92589b5ab4f83b5f96ed7c76f860f743db2b4c9d816e899e05c49bcc011f9ba5a3efb68dab88fc9dcf586a3e118771b99ad7df3bfcd471f3d7fecb105bad4a14bc0c6ac1e97ea018939974619d2b2ea766f35a064552962c0ab10981228c909b64103664ab0821006746439ba95a0cae6544932299e010198dd306e2f3100a92e5670d716bcf3e1881f6a71bee6bdd5af593948e73d89aca1122ad09540882a2e390c622227c5869cfbaeb4f35e0b5e4981f1d62fe0d9855b03cf37cc38eb3ff243bbf7fc8ebbdff2d73e9aa7be97100a080ca60d240fbd91becf38eb17bba1a0e8a883c32ca78d9bdd3cde8ec3f55252be7573022c45641a645abafda3d3177e6b1cbdeadf7ffbcd071fba76bb9fb5d8abc154e84b4df7a89e3e274a294577ad564ed4174a7db00efbf5f013a73cb019ee4b9e8dd883810021e8a82582f5ce9df8d023937b3fbef5ec836f233a5eb864289552d47bfabdbfb43df923f585f7d2d617e6e53ca6ddc1e7d976fb9c0f39cfb6749f635cc25b6e3b3dac63b3f5d5fb32748514c29847dda11d96baeddb7be4c738c2c1b8e4331d48ac6735285e8a14995cf19ac3143e6abccebd1fef4f7def43a73fe5e74fdd5046a6a08041b56260e030673edff5c2d17d9bb6fed6e3fa42f4673b8f2fed869723f39e5c7230ae8ccec6ed6eb3cf3bdefec7b97fd6d1b064dce5f5d8aa89f69ef7080ebd3558536b10c91e0571ec651aac66adf78df51978d82dc4761c52eb5fbe7df165775f33632f4603f36e50b1c0cd27315622f33e6287edd766b0e0c510a8701f3994b12416cc69837b24500a7403ca89f368cf570e2e6531c0a397a39a38272a0b792784b2b98708794d55b21a292526ae543010249af0d118930a2dc24359b8224821e3ffac882b511004a4e1239b1bb863851b0ff3fc7bb978dac0120b54f09089b441f5f8b0df2f858d63a16298914248660b32d9c52effcd72f117bfe2cf3cf9557fe9a3ffd89f18bfeaaf7cf0b0ee5bb0d693cc61eda5856d9a5aa3355b166d277a2f37eff1656e671753f18fafe5d9f3fcbeb97fc26678f354bffd7c9edc122412420ae822e0546acf3c931f780fdb1bcf3ef84bd95ed7ba506b8ab824f5e337afd31bd716cb633f7eebe96f9f0ecbe96e7fa171d7725d5b5b96b5ad2db387b58c4c993ad13d720de4e9a9a1af53ec9a5c47f7ab5695110bc48b44170e2287822cbd18938a63050a5e994e68334737b8f5903f7afbfec3132f480e3815ccccc1c9524958ba3e84ed8eae9776f67947f6a150181f6cede6540cd6cc04071c8c2236e6f7143ee16878f7da3febfa74d1631acb68b6963c3517d97aac5213bbd02e6349041be7fae0c3586a3f3ffb23f75e7bc733b71f763798600cfdd4b2dcdadc3c59d7e7d44d55c8d505144a500c8c13e31ecf7deac3ffbfb6e004eab6f4aeebfcf7ff7f9ebdf719dee18e55b7e64aa55249650e2484144380000631280401d7c256160a74b017026da30b10b0b17158b636b388200a0a6940211d904080042a40420209996a9e6fddf99dcf397befe7f9fffabcb70a845efdf9b88a7094926a45b034b9d7a0627104a7dd0f3d7030aafb409d346955553c8a6980926270cbe69ec8297af9b3115783199a5aaa167d6321a74411aa14e39893b82ecc45d77853a289bad24a04c70c730cb2d3262e3ecd72c1a993a4335ff047f189bf77e7bd1fbb99fda7610441e6d419ba0e0c4ff487312e35ecd7087743022977a4691107c3c15e2d33e8dd0c92cca115152b6859d5c233115ff08ddffa6bdffa9d17fec5bfb8fb0bbf74f52bbfb05bea483aec4b2392a7767bcbc26adf13b208f3cc64e5b3b95fbb50a5c8de14dd39d6c3232e643f5b2acde4d9d5022841450183acc0288d6250d476d8193f59da2da7d68d5ba29dc5c1e51a2a79a388b1d43e6687f98ed9e107978b7e617555340ec3d8f7b5965a5445ac69cd3c92224358588db1a932a37aaa79433ec5122410042a8411060e0d885405d804cf7822b5f89c17bd992b0fbff4bddfd98b3dd462e638e6604136cca070103a3fc6303db931aefec6cc2e8db11771a5c686390581739d9382049dfb6d66afeef28df8e6c4a3d42cb5a5e269d157a851595057c151e848ea2901137caab4051bb7df96bbe9ec4dfffc07e24bbf3c20410bf3cce118de8f736ca71244c23bf2508bf1bc0c8de124124f63cf861a6c55e5c24602bce2c151d586e2644e978335734a01974a506b19534415ae914852ae601b2145ec4aab60f0bab468a00252825c554516051484e1868b243c222b1ac9c6651a0e4aeeb0441507bbcca73cbe20a09b70f922d72e3d515ff4951b735ef47a3eb6cbd155ca01fd2512dc36d99cf8012758dccdeee375e74fbcba57198518a1274fc3e7fd72eb4a7f698a5773f0c6e44e0081448511ccb92bd957fcc0fffe63b79e79fc5d6fbff7abbef4e95ff86f4fc5b05f4aa59d648d3b97f289b38ad0b8540a1f1a86a5657cd2d48383553f36f8cbb04716fd83b5dede3629e7c9c9adf73ff6a443400d0246a850614435f666979e161e4d73fed4cb87f94d71b4534ba9675f5e944ad471727abce9b387339fde973aec5e1c1eff831b77fea08b28753c1a6b1f65ac1ad09a410b0d082e35b3ddcd5bcac917d16d8390b1665047145020b316056f312737544886b5749bdcf0699ff6db6fdb7dfc1d80b0a9e32403e3580233308a582a2ed30cf3ad9794ddd74ef3f95125e8836dcb10c173bc0103839973c2ed5326ed999476aacea4b4526d584b01ab4a81a1d643a997061091c8093ab31b9be6e4a7bedaf77673fad44f3df8f66ff9ecd9ec7c8d390464cbab5cc79c66b20e2db00dac40498d58938141834de1b435b7542ef4838427b74a02cc9c644e6331e237a4f4283579ca1c4b62949f49b9171e8e1b18609192d33a336c082d3d141477a0612d0255c018c59a818b0c0666147c61dea3c361a9bc88b18f764e299c7f9ab337b31cb8f9464e375c18b87c850b573ef2617bdfb7bdeabe7fb2e263efa21c727485c5f0f2d3cd179df31f596e1cee9fe5f4cbfcb17799d728632e25e56ae3a8249aad323db3bfbab6578a055df62cb2582b20b156e1a850d069b7b73cf8eceffea3ef583ef247b3dbefd87aecc9fda196a825978aa7f9e8dd54fdd28aa82363612cb6b5d10c2b5dda3d1ccb20bb23f90d551fdadf4f3b3bafbbefbe8f7ef8e3d76ac5348a222a14100c50a50a35a8c4ecd2bb3ba9351e78c9dfaee71fa9e75e5a1ffa8dfcc4ef1eddf997c7f92d63c4685db9f5bec76f7a6d196bad25863ea24aa322a44a54089ee73878662d848091b504e69481b2606d36a3d902c7326bdb2fffec3ff807cfd6cac7ffdd1e64072c83b1160689eb1c05bdd41b3ba277bf9dc55d6d5aa2a571e8c83d4010c15ae398b1d69a6d3a77b669abf16754ef9ca4a5d7a168743265190c30c088060b1921c79cebaaa10cb369f337bf2efb3df7e8fedff9ee531b5f75feca24e70a49b59470a94573d8d358c9321265e0580b3237c8d0264e262689a3aa64c24014231254856b54ac3c7a8fa9a72a99d143a19e6cedb121fa14134b39a9cf34840c8cc02104d55c509c60cd0b6ba150242bc15a8240ceb1942ca5dc120d752c2b6715699bdaf3ec0778c367b04a2ffdd48d732df545dd7b7e3ff1d8c33c3afc8327377fe7db3ffdb3bea3f2d03b280387bb1fbd78ee1fde9dfffe4b27dffbec496e7ce1383bd11c0e78471a805c86a199d16d46bdb1acf6ae2ecf1374619eccc00d03930c0c041506d9b6f9d30f3fda7ce08327feca5bba672f3c72388c250ec7ea1ad2e52bdded7732dfa249e4a9db9a5b9ee8e4e9e6d2b56671b4ac751736927f96d9270e173ff78e5f7d45d73e71b4ec8c0a8318a040850a8a081803b1164847e2a6dfff3763c81535d4a6fa87fd58cede50c3cac77efccc337fd0a29dbe1c6cdeb8bae9b59a9c55de901cc4f3c45aad108c472c2eb1b89497577d5c946e1edb2f60f33626a799dcc49a96dcf81a3efa5f5ef9ecefac84c165d3d41c7020488671ac40e279b512e250dac757708feb2eca44ec0d2c08c00241702c8113d93dc18dc61d29bd38373b63b921e7cde0a04411aa4cdd2406698442a93c2710cf39d3b4b76c7afb8297f0d4e339ddfc82eef617dc72e7a71cfcd80f6d7b2470706c76fa647df6ea0cdbab90706195c431074f9138962bb7b8dfe2fef0581d9aaa00c7a8912b296c540c554de0a1064260445567566ab0e6aa9888c0c9201a6a267295a2564895d149d0822023aa240a5430c0586ba559c44a7552a32ffb6535a3d906b1fb1051983427b23e78b1ec5d2af7bd61f22777dd7bf0bb8fdeff0707fff6be8df77cc71bdef875bfceb8cf331fe3cc99df7fcdb9bf7cd26e7ec9e4fceea666a7cbb8db688c0055ab47d47d98d036c3c6c9c3d5ce862d47afa3a516703c24634d586f5ac10a6e9ba46ffee5b77fe3a9ed7b1ffc44dbeae67befb8f0e893bb632944986cb193b7b66dd290227c24459a756a8d8d2eae1ed5210e83a5b1e5fea286a797c37fbc72f857e7edbb0ffbcd644be8830a231a43152a20931484a4808820b4088d1151cb2d1ffde9f8f04f594448d1eae39ffa9d71ed71759b71f21e25c78da1302ee8f7595d838086f929f28494a82f8128b530aed87b9c332f67eb8c7de25df73cfef3820406ee84371305e03c2f018671cca0319e338aa2389276c8adf96b5bbfd5e9b08b2546d6dc00c78204d9c9d0ba35d8dc79c9a499c296d94571d23c812303c12224a287a8145c1c3398240c0c5e339f6cfdcd6fae9bc6d5fd1c930977de397cf203c9112e0c8854abe548ae6a902b8e41ca89eb2ac63137c86c8a4d0fb3481849aab819e6e6c25c60a404669624c0b84ede7a1a421513548191b04c2e51baf002ee31040609121874e0d868423cc710b2c69069ea3e8fd8483654d56155cba8dc30162eeebef8b3ce95d0de432b0e8fde77a939fdf2ad4ffbfc17bdffe7ffe0a7cb2b4e7dfec6b9bbeebbf089dfe4e2033c76cb0fbe67fea56fd9fa3bb7a77ff29e91932fd5e28a562b5352ad84289522d440c29afd7139574d99ec9e830c0e0642ae18820297f05399ef7ef6eacf7dfd673ff2ef3efaca2ff9cce689fffcd87258d4268d9a9cbf648b65dad8b49367b0441358321235b45852a28c7529c6946ec8f6996e8d0f6559efa35e58e9b15204a358411f31460488630249804012212990bc469190c6a852dcf53bdf0952c88519e239525010c70ce3392ed6dcc030e021634d6064288673cc29663c27397f461c13cf2bb0081d4a2b7851e737bb6d255571a9d69553a01a1218e6386b2ea31a0d4a89cdc6efce7e698c1bba6c8903389415d3484430988f22126b4e2470a33577b8a56dd2e9534fffccbfbaf96bbf991b4e67237c3619ae5ec8e85a2db3c67bab55d17dc597f63ff4a39d5128bdd190a1548e59a21a6b0e4e9e37e51ef963031743666189300f0f379985d07643ae2a26998d6234ccd9b1b8b9b30707add011968c9469dd03e48e6a8808aa219053a1e5ba0461150415921060861b157283aa59c583354be4c4d1dea5e1a6ad0dc79db5a87bcbfa744a6c6eb3e83f7cb8f1a257dd76e189d39425434f1985819112a9850c19ccf0548a8f63d4a0dba0d9aedd76aff148cb69f80433b78c9c632396f18a0aec854af029d3c95bbfe79f7dfd99cd1b7efa676e9834673d76eab08a664ce46b07ec1fa41a6c9d485de3ed84a6756bd330fa58f24855c83d5a9f99bd24fcfb77f6bee586cd676a3c3d8c554a30a8ae82b14608705101e3980c4980aef350170a64924081cc0461520d613c4f19338eb93866b8719d15c939e680c07068c55ae298018601c1ff8740629456b05b02b8ab49f718a79c8b4547a20f0c14e03cc7c1a1754c6ca36db373a417991f96b83c969b9a7ca808d1534a65252a04218e19c7dce8c093dfd2f96b4e9f78f4998b2ffea237da6c8e6f642e5c48b7bc209ddeb80dff648831c651099cd4625368e494f054325825208125323464c0f09b3dee6ef2c5551f154186a83aaa91038415b6c47e8decde4388247a74267b2b1611c57d21b9343366b91aa4a08908c983ea101c13c631838caaa8504582401e74308109319396e35119f64b8231f8f02fecdcfacdf6fa1965e4da550e2e94cba7cfdf792bf7dec6fb3ffc9e8fbcea3d6f7df11befff28cf7c808b7fc453a77f62efd4e74c8d5b37b8fc32ed3f58c66b3e26b7082dbd5e8b3a254de936cbc696d35f3b5c581a1c2f789837900053652d2a3e50faf0a76afdb479fed5fdc55bfefa973cf1ce5fbde7df7cfff41fffa327f617bb54052dde5cbe98c6818dd6b7e714c5892d45895a9132b416262ff28f2f17cb3a1ef4e5b161b5aae32886a0570ca22f5104e6c6b14418c8040e480214022444d29a214220843b38d719c17512cf3382638e678e1918602430c058338e19ffffc49a5718293d1af09349f7b64dc061256340f2b48c8ae3b8418604d9ad810de746cf37357e479312ec94307c5919a0c24a39881110c29391215918d1c12ce55b93bff6333eefe1fbdf73f7c979f7996fc6ecf09f7c478e9d2b76f74bd3ad2fb877e3f13f3a5884384c96b0e1fc791a4fb54943ac929b23a0623ccf5833a0216da5746fe6131e976b759878724b19b9633596e2b4f92e643c214106614bb945380e3688b11a19c2dc69421d546c040bb2e39050324ba28273cc4545ac89061a2870643e9a06692ccba873ea10971fa4f45933d68e0e79f47eb6ef007dd957bffa17f75ec5873ff20bafff8cdffbdeb7bee16b3ec2e1153efedefffc5b77edbd7693a6e3c4394ebd9a8b9f9437516b52517f146937dab3e409697bec465f1d1c0c475d8a70223175efc04403c2bd84a0449cafb152be23db67fce07ff8919b4f4dbff97fb9f1f59f76f7873ef84c5ffb14293c5965b84c63f960619b5be9869b1b4b5d0ca0046d58941883a37e9cd4aa526eca5965d9c0184ac118b1aa31128665ac81309c63ee382e89b50820207bad48204020645482ebc49f32fe8cf19c4880b3661c338e19ce75ce5f10ac853816c10807c42151c4676cb4f74d9a8f0f23d8c5c0600f41e0ac25c320993590d1dc39d9e49b1bbfddd3a926ef96b16454d849c15a0573f04ab06690488079c2139c68db977fedd77cf4e77fe1d9a82ffac66f8e49577ee73dd714b93c73be7dc5abfdf4cd6f3b3dffa5fdc541ad016d865413e128e5a84210a08ca02acc1c90b943822cce4dfd85c597d42a3529c2ab121048bfbf5a7ddabced972572ae95113aa338ab1424031530e84dbb99c01b2372549c30992a08dc3122dc0993cb026a00a5f21c4f9621054d4337d2d4b07140054b9018af5d5d9e62d2f1d19fe5e869761e65f1e42ffe3f377dd95b6efac5c9ebbeff370fca176ebff8d59ff7c087dec5de453ef9d03b97773369996f72ebcbe2899b351e5948212b258fcba1f6749b742714d2e468b5acfb75e0ba06925b03091a58e05cd7473cdb9755e437cfe7df73e1e83fdc75faf2ef7fe0c4467b467931f62ae6ada5b6b5bd158f3ce42f7f0d3941b426ab72c8862a8fac863f5ef6afed9a9337dc709be2d7afee0bc62aa41863502d22991cc3c922bb67b07007c34460060c80100654702780e0cf08029cff21785ee2ba604d1c33e7cf13041038c7020402894568455dd6b8b1499f3e6facea93cbb135bb1c72d88f70084890217918de498d31314ee13761b7e3a7cc3c6a0e664244a93c675408106b89682b19da44834fcc5ffd973effc3bff66b8f5cbe74dfd9899f3eab55e9dfff81bdd598fdea15aeeea41b6fbbf57bfff99bfece37fcd2e10a31c5dbd337d54a174ce1a0049904b5b266905238b83c8183c336bc2ae7413cd28f73dc2badc8e1392a8e851478258be7552daab6b1558de29e61251663358b297478262a50c573c49a4724a80152098a94440541840087165a9858e4ba5bc649999e25f6b9ff3f3ce07fffec2b4e5cae0779791576ebc53d3dfac15ffce557bce52fdff68e9ffef00ffff68b7ef3dbdff8797fef599efd631efa2d543873138849c3f6b9b27ab2d1c8b0720d2a078c3bd80926136c63d096b4da3fba524c03aac41c9f79328e790e220a0c5285651dcf62afd8b0d73fb6f7cedb37c6c5b071e3b97af142c9449baccdd6a5eac1fe55b63726af7a457ae0d1ba3caca5ae223e7134feecc1f2a62edd36c9a7ffc6577fcb777df7764a2bb48838940e8d05c8ac330c9f38e6de1959b696c04058706c228a19d7550408488458135404a40037ae2b88eb2cc08deb842c788e789e2041704ce044911728110be4e66fdddeb823fb1faf8699f99164b2556800c30d1ae8dc0c33e820a1893171b6cd4f9a4fcd5a4f09368dd66cdb7c9045d5084b6280d148c260023931c393f182d61ff8e09f7cf889273ef786c90bbfebfb2d42e79fadbbd75ab31c0787da3bb073370fbff8f6b79ddc7ef76a74b49d9b6663bba66ca9b625395e210109ab3808dc00e739925bba75ea0fd5d8f0d4910c7330dc2d4ea5bc49863ac1801e3218c7eec869af6a08a66e05c6b0de71f329e62450eb31066b0912646839d69be1aa61920c0404185318044e954d4b44bf883650c4fe0ecde475a7f2af7467bd3c60566b110ffd06c3f88e4eb337bd7af1db1ffddf1eda7ce247beea8eaf73cebf9f07dfcbe16b986e5147f266345beafb0873c2faa5af76627523dd1679437ea2a423cf8bc57824530e97474a34e0ee041e785045188efa5a0b6922ae8d31334ebcf5adfccc7ff2c303dfda4a67cf11359e7a5257afd8c61693a9df7ccbe2c1079e3e5afce1d1f06b8bf19e26bfb96ddeb7187ef6dbfff189e48bb1aca495d81fc7a3d0684ae608b770bc235a3c991a5382c4ff500c504088b5ca3141186be258011c4c802001460812581520d6aaf33c634d1050c55a10010a16a84071bdb46d3f63da3c30944f149bb55c1da31a3baa24aef30c0e06667230a733db7466ee273d6d36a96db21281e5940cbc92a87db22a218748021c302763c9b86bd2b4c63b9f782ce31b1b595d4b19a25f148864b91eeea4ddf3e9f63be3e0ea3d5ffb0d2ff867dffb74d80d19fbe807542b849bc8a5f0a71261ac15f3cc3183300c32dc3d4d87ae1a90a00a0fe0e6a9e358864c968eaa95c45a8155e666d943a5b6e66e76e4c22c3cb2fb942422c2c358934782e4a98041020b5aab3d4854b30a82ce69aada941a7c4a59d4a5c758dace762fa84dbf72ff3ef77cfe78e1038dc6544a3dbaa0277f9fb6fb9ccfbff3bd9ff9aa3ffced9d7fd89d79fa07bff2d6af7e94e5359ef943ba9358a62cb169a44d4b2b8b3e115e6a0cbb74dba439d3538a2162c09bd57074582be6277007c31c1c0c1c0ba9c2a37df5d6dfd4d6b73db3ffad27bbed1ffee1737ff76d3b3ff1a31cad9a7bcfc685cbe5998b12b1eaf7f776af95fa1b87cb5f3f1afb88fff5ece6518d771d0e3baaa7921d854609b854ca321408d188d6e86006537c0b3a30ac037782eb8202e258988a10c72acfab50c49a00b156a1024220400e54101810218e5510083c080828a248c9389bd24bbbb4897d6c396e273bac2a952118230003838ee8dc0d12329160029b6edbf81cdb2226722f35020383041692504884d5489004164a24e1e48c6d655b8d7158ebdf3d3dbbe57ffe368b51bb3bbaf42c75dc36b2ad063b58d8307a9ed872f1cab6a9ab7a877b3e7fd1218b4e582581f13c4fac6585e15c67468689380337067b12d5b270f0a0a94aa126a092c1242a060647516f49e991a80b62db7d08b2c9920d112d6178260a92a022202a901d410755744840a840810c1d14d152e6d252c338ee9b6f41e24f3e74faafbefe6a7faf3e7436769f8c66a01eb27c1a8b5ff9ef4f7cc917dffecb1fddfd2fbf055f78ea8d9ff705ef79d7dbe92fd35f666d5862b5b646495693d792c6ddba6c353b41b785cdb4241ccb445050f13884066f4c38018241080ab6923e3e8eaf9f76f7cdf8beddc3976d4feb4ffee8a9edcd71b5a8a55f5d387ff9ea95ab45576af98dc3e5a3635c0bbeedf4d60b3bffe4727cfb617f3ab18221c02d6147c1120f479025374b969bccc46d0213b79cbc85e496785e850c044215ba08a056e45e41acd51284901950218b8a24d6aa9920788eaaa8ee84554710a108820818950d3a8b1b1b3fe1ee024b9d5182411ac5100cf8045ab7cee83043028364d6c1c47dd3eca4fbdcd94cdee24622c0598b20544dcab080842702c370872d79367bfdd6fc237b473f7bb0fcc6339b77beed9becd4cd8cd56a91a769caf3d3dbb90c435a1cd9ce654e9e29bbe7ef6ada27ea7853d3d8ceae4898dc1c327f8e71cc8c8c9970c8e0d0999d49cd5d5d7ea28c2d386af0c65862e6e9b4e70c1966c8b004097ab120b66017462c43153990ab9a7530c5a5a8012e87041d9ec23264e41660a09519c2204b4086064fd40c1661c19a9687fd0096c97317142223413f3294e5a2e299210e076dcf3be82823cfa9204cc905110404082ad44c2da4cddacca960b118f6956b5b35b5a841c20504521d2b825e8ca6cb4d9c34ee6b9abff6c4d187ef98c7743a397d6679ffef4d5ff6b27cf5f2fe383ed18f2d7cf966736f6ecfcdfcc72eed3f326adbd929924846132a50834c348ac01c35d8d4cb0c9fe373b759a2235ac8e1ac39cf118487a0004e4071c243214140312406132889e058041220e358e5980c29aa1310e672c24311e01db199fc54ca2f6c7c6a7671acbb5e135c93c6d0119444031bc936cc5a2740950ac9c8d066a6c614ef328d81518dd1a96e09011556a11e4633f0c681c431399692cdce4ede79fef0bd8b55d3a57bbef66bb9e725ca99568a4d4d673a7122bff973b3a2d7ea80d699a6585cfafcdb6e9c5dba78fb34fb6a5129d565a69ca20707834460acb9b970371a518c0c068d7382b84cd40003a7c2a9363d310ea71b13c86d52390a3ac76084a7a53bbabc3fc6bee984d921748e9be12e07cc22952422702a5edd0c972145845785c2022a2490919c2e989026eeb3287bc3a236d3c81bfcf14f1dbef20dedcbcf0c8ffdadf8cdefc1938734ae74ed212e9efef5f74d365e73dbe1fb1e79c7efa6fff695aff8e54f5ee3c3ef848a0a0424e5c67c4206791e575aee0eb37d6667489b8c556511d13a2ef3d5707448556622ef0ce1066612140854c4a3fdf8caaecdf0129677efdcf230174e6e6d6c7cf6672eef7fdf2d9ffa9ab37ff2b14fabb15bca7b178b7ed4b73eb5b765b4705024c8460b59067490209b9560e23e33b6c89b589612b441eb24684140b06620a810601c1378108144850a0e113ca78a02192a483ca7f2e7047f2a221021983a27dd5f96fdb626fdee72ec929d363b3f04b014471140e33e8353300782411a830cd9c9d0042d4c3c722581257797d79a02a1a5e8a55e081ca646c60c7a09e88c8de0759ff5153ff6e33f3233fbbab3f3e6a5af40b05aaa1f6d3aa31febee352b966d809d439b6ee41327cbee951b67dde7cea6d30dcb1b37d8d5bd5c69a1254a652d81434aac2585e1098cffc1c4ac7202df0d5a8a11a9468cf513cbf1be69bb533511047ba1241a8e55316bd2398bf335c23d432fb261aab3482d0a62250135a804c784d342406f0a67088d50a14086042d7439a6a3d2b09f72ae9e4da1dff8bee1ce7fc2cb5e513efaca7cf98fc33301078f71619359fbd7ffcacd3f39dcc11f3efc5d8f6f7ffcbbdff8d2bffd218e9e04838cb51ac6b1eb7cac8992c6decbbeaf2ec67096c926f3096c85d73195b092dcf6c6dd8a4654b00cc5bd88921945a990b852f540a977b7f964d7befce0d1bf55a6ff87e2950f3f524e9c79f8837fbc1f5cedc7cfbafb163df8d40f1c2ebb6cfb41018c04722a06142881dca3868cb01c8e927566f39436dc36f13691f0c60ce43c2f3084a8050204d5011f894a08062885e4aae02306a66a200359859635090a241c1038b8b3e9e98cf139b309f09161fcf8c81d6db353eb952af05d318432deb99d71bb31a5930e4e2d1c986a62ad83844d8259f6b9334f3e33db306b2d051caaf4a1c2b10e6b8cce6c622941a136618dd1a57477d77deb4ffedb99f9676c7477bcf82ecf0daa2c970c8339d68faae8a927b35213ab9e8d0d4e9de3fcc5e9377f4df7e8c37eebddfbffe73f95b92ccc9b1c461250505bc371878c010e06190c1c03e6399f18bd503aac2335782f77bc958b9ab1e434c19a4303665cac716f6e8acab5d096639021430b2d56a18531689c6ca4a0c15a27210361a08a49aa60902a66e6680e153b895ded0fe4b3d2c1b527dbc65efbbaadfb1ffd7bfecb7f8b9c895a96bbec3ece33d39ffca53bbef68bcffdfbfd177ef8b7aefee0c60d5ff0e62ffaf55ff829ca126b71c18065ac1595583ad11c5debdb8b904813f226590aaa02327538188ec872bc40a58aa885029853ada08bc3382736dd4f3a1fcc377cc113cffcd4d1235ff4b7bff2ee655f1e7cf8c967af7ccb071f3ad21a4721fe8c4100e239628c182460ea6533f996f9c9c42cc7063eb7688d942283831bd73910622da072ac540aa5e083089445cdd1e3056a1384c49a6a852482c2b102884898318109dcd0f8a74c5203f72f96869dcbf94a94c3c08c1e5d3455e8b26dba9d4c764f6eb6b31bf4d037a41a957031b1dc263ae384d924d9cc93c3185cabe50804b8196ab179b289a79c683060a88902ce66ebef5f2c0ee1d337bbcfb9eddcd6177ea99a86088da30e76ad0c316b16e6e9e987b334d6c59ef676d8d860362bef7bb7df715779ffef2c0f772a920bd1582462004424460b07cc9de78d06221b8609354d1862ad881457a9af9be70c7b55db8901a6b00806b78414146799ddab8581b1122d6bb6ccc9c0608c1ac6007ecc0c4f46324f16d9532252111e25405a189d5b72ebaa7729a62a53d53a1c323961878bfee9b8ffa33b2f7df35d9f7847d7a8446a6d5c69b5c3ee135cbdf2efff7bf7159f73eaed0f3ef3c3ef9dbefdcbeffdf547bf928fbd83c52ebe494ba8a0ecb5d6669acb2a8f0b1d5e1ef2948d9bc89b4c0c908475085973d4efa5ac161346750703a51604f465bc1c3a93d34ea977ed3df6d8fcb6afe2c497fdf07ffcf4a6d98d78a82f9b4ee62f10b8c8902119218e6a0c55c0d439e3f9249c723f8bcfb1a931cf9e21e32dc79c638e01d5048c80108c0911438ddea8580fbd7c120c4185052451c22af24a85242ab41c9b181b6e7735f9c6865af9e04159c10bba7c5862672c8212da0b8e08c3e7704be2d626dde476b6492d8c6240012579c21da66e2dd61806253828e320d6cc684162cd8c89d1428aead058ea854a6de1ced3a71fbb7ce5edfb8be4bc69deddf4e637db2d7750462274b0aba79f0ae7f0bfbf731887d5d56bd9c37dff8883039f6fa68dcdfaf86371e14a9c7f9a0ac22a4dd44ed694e03a879468f02c0c0c0ccc4860c291505234b25ce984078745036054412581852c900418ac8a9e8de105c92ef7750f36dd5722a152c626bb074d68a8ac89e098cccd8916844a44018b484220d6d419d5681393602ef575afd4933577fcf8d7f0cd3ff1f18f9ce7755f13efff21cc51d05fe5b072f141e0ed7f68dc729a0b97befee3933ff8ce57bdfe5f4ef9bd9f80021d75128c41c6a738695c5ab96c7da3f9169393e40d4c582d63aa8c2991298b7a544d06256b10e15d903010deda5ef4bde3d9630cb9c9f200bd3138c5397014b6c2cc784e428202e626380cf661f4c8d025dfcc7e22f976b293394f9d896ce2d690dc9904ee1818386620a8ac49104185414df53a48057aa9afac8c9258d5302243310aea44058119536c2b7387e7ad644f8dfad0a25fc20bba6c7065ac0324ec72d11213cc499bc6a99c5e3b6d6e74df48a9c51c2a047fc118ea558f828a1ccb86836102210cc766666dc24919eb2049aba083bbbff0cdcffec1efbdf77040f6595d7be79bded4bdf2b578c3da38dad5bd78e6e9d8bdd61a198f55e4f004458b43bfe156df3c53eba3ba72a55ed98994bc5433aa379dc73403924890209b3b1818240418b865c0551bbc818c19645c580948ac225a720f9b6e49eac15006c1517015ce7aba506a720a54016ec5369c43125e2368e516e1d0382d1824b3702f117338822232a44a329314e200afa810437f14de322cf5c3dfca57fd73eefb6b65e77cfbe07f759aa29516bb7ae61328d136b7bcf185cfec0f3b7fb278f38af77ce38bdef8c41b78e2b73083169aa0c3c049b14cfd51d2a5d29c20cfa1c127e41932d5522b9ec761380aa9318508116d82602dc0145535641133f39b0e1e7f3877efe8ee7ef7ce833732bea26b52a51786108963066618388a60151c9511e8dcce263f633a056733278c89d119d34ca22623a564e01c73c475c1b1002582da891214e8832668325965846c346244c509cc213b27924f9d4d1c7864883feaeb409c6bd21dee97a2f65093f7113bd2c2a9a8831b1abfc9d31d9ddf3d69e746322115590d70c6d0a09a2c0b55a704909c9a49c6b1c231c35a4f8d61d08b84b5c91ae3405463a3cd5727ed7f7ef6f2b38a97cdf27db79d6cbef08bd44d494e291a5751fae897e5da3548ca5e21878d06312ebd094d2cd2a0ba0a4651ab295c0ac90baa5c17e0508d35c30cc958334854c00ce4f2a0a18c9039326d4ef2a343ed8965a204829cad483dc65a50e122bab9b30be64b986247b0e10cee8d913c082b3024ccd30883e56c74895c99c0328753a921540c83694a0de41a5da60473d9ce78a0665a9a86e555bdfb87f89c6fe08bdf36a86b1ffb658f1463d5e1535cea6836f7861771e7091ebcbab39abff1b7fb377de9e7bcfbdf3fcce133b4731c95d1728636ba310d8b6e386271b9cc6ea43b419e1242994098f57b8639181818b819d6b0e66141c59725369d3e62cb7cbef3e0d199d7e0dda6ca048a48609881b3262043861c368a65a9a3e8dcb6dc4f19674867929dc4b7b189c8c926911c8c63e29871cc3996785eb09604851a611d546384857285315129153368f00e6fcc8476a23c3cd6674b54e986944ea474285d1dc6c2b1bd120b31420333e344b27b53baabc9679be6b46130040a2445502ba212f48c02832c1aabe6224a110109dc68dd883a86162137bbb1b12df25054a39e4a792cfab19ff9b9ddaa6cbc28e733a7376c366758e11de3c0f2b03ef960b9f0ccb8736de36ddf34fdc17f5daab2d730dc7677adc2ee9ed3465fad6215131e349549d861780302830c2e8e990c1006090c01422e5a45aa6a248b182366d91f1dc653f8e5214e980d286319421214680c89c5c81dc6e3436c642fc6aad61531719f063d0ca6216ac21ccc0546254336265247ed5da5122011aa0e9dab1305444084575164092b58a5c92445aae111ad61052ba4512968a1099ae030520709b250a516e5602c91236a750ba04cb630f00a99640804d586e9266511b12caa0261d16499232c027377ed5237922b589b5257e3be0d87dbf3a69a8d06221bd71918509061c97d19718087c724f93ca58d94b6da7623732ae7d6ad31252cb0004145218408e46690c08c35838cb958cb78388e22d4864d1a142aac396b2248fb512e153d54ca32047167eeb69c2371506320f064b018d58bb506664e48136c469e98b558c68016965284551401a4040db8b3a6405003511b2393cc316c15daa96555458a5bbc3b931dd951d4967432db4f5e3e88502fddd6faa7cfbb939ff3263b3ca2692d4cfb077ae8b1f8c423dadb91a2bcf3bf9efaaabfb9fcafff2547ca24ab470b5ff59c38c5e61697afe109c23996dc12b6a99225ae7330cc4020d60418c6f3ac4113bc23b5d4ced32258e037a7e646b34f963897ad977a34336bcc0a14a98a160e42b765db702e95b8a5f152552d25b74d270a210252f5c67027410319321ec49c34441d908481070e19927098e3d3b18fc3abb1bd61fd2a9efc63c2d85bf096af2fdfff6b6d7f5482d02e571f23a5a3f7bffcc5f79d7ba03a9fd87bcbe79e61d6f2cab7f2be1fa5f6f8043a9964397cb324e571d11e5c186811749b904833ca409ac957354f6c0c2b0b40292bbc7a02123282a05247c78951a408faa3cd145390c49a30302310d73938aa6854eda306b83341538f691a67788ba5c09c80310828a141ac050236dd0d0212cf4981c2788e40105eab135051704c40305206539f22a282806231246a8dd1096a8182578f8a0ac7aab39dec644ae73adf6cf234a344855219c26a221c05018251ac09cc698cc6cdc90e0405f66b39afd8adac9d759f779e9a74795523f94b5ffdb2fb3ff8c74fb91fd638dda5376c7427eebaddee796d3896b3b0d8b9327ce263abc3bd70177ef5d1274ff6bf35fb673f984508b43c6038a26be84c130b5364d5a27045c813c99904e298b12640502002b126fe942472a04818a1c8ec506f6e6de63e96a88d47e53058b9e6468b65125015397828b491531fba0067cc0fe0b47b97bc351ae9a08083dbd47d4c3e815a514272e52299821032c31d483055ad29d5f08d4c445f6a8d6ee66389fbdfc11bdfcafe2e7fed5f9777fcc33c1e444f258b097b3b0f7c728b1bb678faca3b3eb8ffa6176e7ce49b5ef0ca075fc785dfc13a6c66a95089763341405e1d44ba583c631ddd0665206f20a8bde7b9020546c5129eddb281b911607594c688060486a5a85bf85c181864c890c45ae558820c166439aa0e5dd024e6f8263e25a5c0a106d9b1c0c0840971cce07008c30cccc860946ce660900067cd2007151c1ba55e2ca4c35a2e1576a316c8cecd9eb6dc42b13faa0f14080216b5ae24443632ccb18de0ae8e2ce52ad644e2d8d4453006e298818c5aa9305247884a0483b40cedd7f26c619f3a713febf682a63deb5c5b8e096e78cb67bfebe7dffde17e2c633d97ec159d7df6e6a4fb922fa7065534a171ac0f7e7c78e0637da9c1b165a8d9bdcabbde91bd04d56df78083239b6ca4c98c34e94b78250987a6228ed530ae338e55108c52852282e78d086195b690434dc84bece25da644dce0d488142274181cc21c6dbb5a0840aa62c3ed5284c3e8ec298e9c4d058808248e1912356ac2330eadd1a8bac990a0a2c1d44285ce5444f1982946b4e8af869768e63cf6abb42bdef8d5edcb4e0ed3ff6bf8c56fcafd9e8de8e871769ee2d49c5b6e669ad83b7a7c7be3e70ef5195f7adffd3ffe7ba8309d68b9c047d10d46b2681757d270b5aeb236cf61034d2237584bccc6b64b56948ad7909b720e4bc8bd6259519a65f44bf739ae88de04314bc9b38f21816435219e1748606129b908dc0222794d264f612ecb720b103a0a7a31aa566c242a04648161c800590283249261e0242aa24212b517235a4807631c955841814cda70bfad73605563291a100cac19a8120926c65ac25a30fcb064cfaa2af36a1b4de3c820c22a5ad6ba9056d25e8da51814e258879bb1b63fc6213a5404cccd6fcae9ae36ddd34c76a33461d3c69a8f5d7e6c2c7d7067ca2f9ee67b9b76eb2d5f966ebf4b172fd8c60696acf45cba2c514540820c3bd70e17bff48e2ccbe65617ab7cb4f09bcfd8c60d9cb8e6293958092368aca9182e070434814030420ef52a6e8c32ae3318518bb768464ca0c11770ced20a7b61f6cb354eb815715435102ba8a40da3339b99259420712c4386040edb58093f8c1a40a08c2055ba84016203ef8995c49a48558635ac1948eef3f01a7170b403698cac841ef86d969787bff4f739739acffbdef2c1ffc4fe130c3d7b57d93be44ef009477b477be59f7e72fcea5b4fdd7feae55cfc1032aca38e5095127481a7d532e96a995c6676926e46150292ac818c921c4104911c032309885a6284704a442d61d6b709af21719dbcf2679ceb4c4820106b0a0fc72a84ccaa5b0d8db01f1a28458c101c73c8803030e32f100e019803ab28aaac6080554445caac6d5a3add30377ac54a0c892a822013414585004c3ca7a285594f5d561a912063f44381404358417d5008898a580b72b28c4fbd1a54e2b0aa3a09369ab4e9e965f3c96d937c6928053b334f9b5df3df3ef9274bbc6be2255db3416e5be7d6dba35fa18a67926b350e4f3db532df5714d41aadfb2a74b52acb8bccb538d4c135b5b7ebe4c43667344e1d640ad644268181a124c806543011e0d56a484170aca0106110168e57c057c651e684b127ceafe2449b676380aadca09a8d89640e54d56b95174ff303bd0e0dccf6b1539633440e9c1a0cce481a6048de196e78435b68732446aa840d4e359f0b11b5d2c2d49ba23acf35867d591a67331b473df9d037dc977ff47e78eddddcf46d3cf504cf3cc0d61968e88d69c7225ff8d8ea27feeaa93f89e0eefb387c96a38b3473a29a0a289a0969860ef3d8d7f19afa0409cbd404466ac99da950ab41f216b253cd13119025ab90c08cc05c7503cf98a1040e99bfa00222075331970d522d11d963c43316aa23a3e8a5652da3183966606086818173ac724c1cab200808c5082146544101418226b369762247a3bc2aa51723c73a8ed52010850e104b2841614d452ad0538263e27985e75521a8208e19e450b238842a0406594ccceec05ed5a61764eb871255d9c88a83beafaa9998c216dcd1d9e91bcff8e9d37af2114c6c9fb2b1d7954bfdfeeee118d7c652a081534d4acea5e598bd8205ab9576f60cf7c916f3139e5aabbd83d7481c338e99933103872a2af28a221175941c10090b94458b72a5a94a1163401b234e043554c324145128c46598549f24bf39d9147a74b1d78dc6851a27b2ef572d9d2d670a4dd45ed4a010d53d6ad484931b6292998db571b5553d1ac115a319903251d4262630813e068d3b459bd1ccd0e18f7efd37cebefd47160f1fd0c0a7dfcb933733ace81a6ac12a0d501f19eae3266e3bc75377d15fc23235ab8e809a5cba49f262e390963bc513c9e836492382940b5d503c55109eabe54a4e4a18893a0cb672abee111e690cb7ea56cd8415d49a55c0798e9085157048c9e66db3378e0bfcc07c1f3b2077e6610cd29171402e30128db9432bfe8c25d632d44a820a896383a8e02070c2a13ac9e9cce7c646a2c50614648143039d618031117d1363b565b0896aa24085aa088e89e709826335081850855e0c10e050a0084140822dc350e77683e5936e080b129c9a4f53df7f64d177705b93cf25bbab6b4edf79c7f40d6fe0c10739d8b51bce3a70b4e0e187fa51cba2fd122b918dced3dcc88a8c651c15cc31cbb413eb669edb9472aa25b947b0661ccbc8b08419186bcaa6ec8c911a08e3986a458e27a2c113323c1107a39e8e724f93e7f8e3bd5edca41368f488a017b5c62a62a27cca39615c93cd61ea7ead44977d59b4d5d8a631271181ab060a68307091f019a5976d840584a44a40180e09265085601604a2efcb72bfc8d54c34ac16dff70dddb7fe407f3e78e812db27984c7158057d6580547ef2f1f299b7a5eff9828deffaf80b38ff21b4849638a40ad5203bad31a6e51ea244a5143062242a158511ac0586038aa8ae4a54140a0f020535b0311b425ca735832043e198248c0a193b6d3a8483a8fb233ba6a3c2bcf1908f56fa60290ad7295af392c3f00418d5789e47c8252a54430588009987421c33bccda5735cb9a0d12830b21682e4de609d710244121e61a3519020580bc005e640113df48a4b635d062b42412f86a00744c65833fe94029ba774a6499fb23d39d3e4dd712c4ed7349bb7ddf6f0830f5993cf44de6cecdcd6fcccbd2fef5efe4a4e9d1dffe87d36df4cb3699451179e5d3cf0d15de34a7081632636c25a37f79c231520caaa2e779c9ecd994e6cd8b4e1b080409800198e018e3c9b739d24ace93534a65a2a08140853282c5b53b004a5ba5f835d48399d834f96f240adb7751ea33d5b50b0508410b1249d4bb691b854991b97222db11d678e6f984f731cc108355bc57b9891648035e4a9d3651a3428fa20819cc01d5244035df2b6d2c8baace5d8e7dc8fcd0664c8e0ac5902a7cd20860ace75571636c35eb39168e79021e119b22103a7c57a3767ad465445709d0196cc22791014dccd808c936a58dd37ac2ab29283615e685b3298c8908d2c9c63060203c45a0eb6cd4e273f1ceba1622fd8196dc3f014a328853a8aeb3c034121591824b08443f09cf08af1a78460245a5150805b50888c08f0a4922bad28506061d14293b2190dd699356e0ec90d08507840450182117a69492c0a4b05084425c4730a1298c890a1334e24bb33db2bda7426736de86ba54d76cb0b6e66ebcc9c071bb3c9c9e9e62db7ce4f6eb79ffb05f5c37f181ff83ddbdcb053a7c999fd6be5818ff4e71f3f28b157c7fd52f643118495e2cdbcb16c95631ab9b6e0f0c84f9c66f3449a6fa70b1772250782802433c0c8665e641c6b3117c555468600a90022435574445b6a5b6535080eb3bfbaf15aea0671a7f164a9d748b7b865f74bc46165a1d81b3558b44d3e97ec844b30491ca84e47df24e63975d0790ca1216cf0eaa4917030b2136d8e8d41bd475fb542052c481e60e652588564e1c8108c41a1ae70186bffeffee5fb7ee6bbee7bbbd83fe2b067d6b15606ac8766d81992a6b7cdc5d993ccb7393a00233af94a0a99456ed1c4cbc2ea810f1ed9b00c099065da6e6c8263926794ac0c63134d69a45ca9919c206515f3e214a786106626278381029030ae1b21bb6f66db0c16c17ea41dfca47207050ac86320cc3d1909c738962c20990273145c972d49aaac558e3904242283e1d96820836146ae50795e0207c71a485886444ae080e361e1b2008a43702c60c413d1e01171244621d6c47519cbd042324e25ee6e9b4f9f4eee9ee54b7d7159c0b9b69ddcf7b9f1b147cfb4ad41f7c23bdbbffe3fe9c107c7fffb67626fcfb636d2cdb7fa7c9b6b87c3bb7fe5e8996776fbb8da979db15c19eb8154038f94dbf185b4999401c9d4f7ac06e5ce4edde037ddea8f3e9a1893591546189e4c060dc9c1714f44c5ad0837578904d54086898a4ff1193ef171e62950092e143d55cb6776cd99448b3d59ea91fbcdd94e93f6aa3f3294ddd021baa4326ff2b6dbaeb425567885fdaa9b125be67d68a94a156134a44a4a64487882253184ef473521ae0bd61264692e0edd672542ecf747605e63e4aca272f589fbbef81bf88a7f7cf2f6133b5746aeec30f4202426468da7ae846e349a8ebc4d791a25c8c828421019cfacd531f57b10e19d3cc91b30f1a752225853720205c2478d4424222b7a1421d6c475b2e0cfab481cab10c4d4ed6ce64a898388f355338fce92272a0c6820a0badc2c0c6a622d83cc810001228cb59aa91c2b850019a34206448f2f2b0d4c32d930a7812c46315616b00b0855aa0806e14018e23a9120e15d66dbc138925ff2ba2056e86a508d3501a2c3b26180d399bd62da7dc146b7d136cf0e4349f4e2a4bb271b3ffa91f48ad76c7cdaab746daf7ef2a347ffeafb62d55b93f3a9d376fb9d9a4ecb538f1dbcf7fe8352f68a2e573d2d3d8b5f40fbb516ac17497e8af4ff02fe9a5ebf6dd88bff0000000049454e44ae426082	2025-04-06 10:53:59.795119+00	2025-04-06 10:53:59.795119+00
1	1	Наушники Marshall V	Очень крутые наушники	12000.00	20	\\x524946467a5a000057454250565038206e5a0000b04a019d012a7f01c2013e190a8441a1044a1f560400612d2ddc2ed618b5d4aa3ecf7aee919e55f2ddf77acced8f3b2e9bffbbeb1bd32798efec7f50fff8de93bcdc7cdb3d47bf9c75527a3b79b7fad9ff73f36ec1fde627de3f1c7f797d71f35bed3f603fc27fd6ff09f2f195bedd7517f93fe1ffc0ff92fd8afef1ff67fd2fdd6ff2fc1bef8df01df8f7f38fedbfdd3f623fb3ffd6ff57f685136d4bf41af6ffec7fe3bfc7fedb7f82fdb8fa6bee77a67fbffeeb7daafd817f3ffea9fdfffc17ed87f7bfffff647835fa97fceff55f005fce3fad7fa9ff1bfbbbfe43ffffd2a7f97fecffd67fdaff29ffffe1cfd3bfefbfcffeec7f8fffffffc7f423f93ff45ff21fddffcc7fc6fefffffffe5fde9fb23fdb7f631fd60ff9ff9fe44457860b2aaf45e8e8c7066fbf7fef7f6efff6d0a874d4344d8c039ff881da28c2943d429387d3dfebb7ad6add5fa1c40ae3153d4d8e3af782eabc3059744d0a7f7ffef99f0ba9f962de0579789006cfff81ac01549fca1b4939b3a2b5dfd412f53f79eebf26150e9a7c6d2dc79a53e586615ea1ec03955abb5c834ad2d2199c64fad335ac863a276ffc85cdf5cb528708245fdb597fb4f0793fa6a33401621d2ab4acfe92db08146727c536e1e0ec1ab9e6d357cfe0d745102a7d0cc0ce0ff53da65fda707c225fe504008947b2150586c324cf71dfc6bc9d3fd9aad5d345317cbffff98d955fa9aa9bde49caa950fb736f00dc9aa38295a1b3c1ab04479cd2fef90c8db92f72ca5878e23107cb0767abd303e8c1bda35bcde348f517cd104fa6547bfcbffb3c75a4e8134baf3c1b58f573140b970aacf654cda306807b065da9ed38e630c3abd83b76aa66f58e9f7c59756ed676b4d2f26494f5a3a9a52baf54b1df388667189af5f823d653d6b123dbaa3d8ed2a25a5c0be41d3be5e2ee808fedc96f06777cdbfa87199026c337d4d825d77b4a0de8015a58990aba915ae8d8e4c4574ee78380641424cfa53d5ea19b0dfdda9cff24212c6713ccf7068e5c42a5520ebdcaa204597f3dba662b2653c207df13cfb3b522be508f3e14f969515e182cba30f6bd53355f96efeb3eecf68443a740140e9b0da9449e4657a113c482a356da3255b51188af31190ebfb9371b986361bfd823a89d90c59e5d57860b2e8d0ca5c25d29613a5cc81c7795c7b43ed4caf01bb90605a272618f9945bf0b950f4651dfbb6a570081b809567ab5a5690ee3ef0ea44ce327d79e0cc6885fced88ab9c7dcf19e290d454bea0d4c9a9e2a92925531e6a6e46a24c792658b9b9266f405dc3175259c80c75e6a08247b158a74a080130b17816f0221bca1f74af78308eccfd21f24c57b062962aa45762fc884a70ed97bc16723ee260aacb429366b3554da23d9787ae08e8e7fd6bbcf0c165d5754e6e55e2069279e536a335f1382e0d1a7e054be31f2490a6a28216e8a1d19689eae3d9256c79f4658f74fb25b63893bea261647205dedcb9311552fc1dd7a8ceddc9521831495bb1b4e9a8de3ae3ffe2aed6b4572b51b23bf6ce8d01b4aee4a36b80216f1d0a8ad724c375a15c22fe0df548ad4211f2ae02d8d72a09859755e1786c1bc5c1c4a6f5ca4b8baf67d9ad1f155f8dc2a62abab1c51a29ba92d8b0409d2eb353d815768d7bfd98758c7e7fe83b0eaccdf5ae56b311f1580b273d747d58cee8a75df4776223a64faf3c30586df64df89e8b74300625a48eaf19ba57ee24aa13f4d2dbe0eb69c9cd5b047f4713cdf72b3cd0b36e142b317b21f482b7282ede2fcee8496ef72b789b43809bb3dbcdd88b408d42dfb68567193ebce8d456c1aa3844fba6f815eb34a630b2fb439ee0a57a2dee1f61664d2cbccff7ce5eed45b4120de4a16a8fd270b28518f0b41a568c92b2e02d40961c11347b303a2849640c9efe365c13f6718e3b4df58fcf4495c63e21e6c5c957d969e0b812e9b9a699ec5d849f4c9e1b04a3054c534c5dd36769755869bf27876ff419b55023b61fa009f431b88ba26951962e21687ce72a8fea9d51e9767a3d5c5e489c60d85d7f0a34c66a1b6152a6a26afa9021b9e52a10e9861178ae7d540f8940e8f33a513ce4916b138c9bf080f85409004bc7572659bf1c2936178cba507dc1d7417cbd16c11b671522bbbda5de5d48161328496c5634c51aa6bfc6dc1c2434dec94c90141e5e54dbb27d7f7a920e3f07267a9e4a66aa44b09aa823f574e7a3ad8e35c4db0008eb50b386fb8283e6f0a1a6ac09509224244574e8657b9c0064ea9401cd59c3cd901e59b578775d06525955c29cac93cf760a914b55f447826463fe5731b0a6865d1c59a9928f7d2b079b3e8b44cad6cd762f51887eb8b824788cf1a83421af13bfd3d7cead790a364fe64d345f7a58f0b95669df24734fdc4711d214844915f9f30f2bce2dbec0b1f52b435eff2f0a5c79592953fca905da1ad208f535e1e4079597bae95157ea169ddb75bad9990363e68403404dd0539c6472ebd82dcd6495518e3e97b1823ea6b31118b77740a5e0fe62754d2c4add09fcab1069cc091603a4c57d75e6a7d31d9752b3724ad66f7befe07222b36acced8905b38e2c1ea34c4e6d26a977b9154ab4869a663c83ba1913d90cd32615838a896cd6164017590a10567f2fc215fefd15889ef7d6c362c9adf3693bae0f7f8da1c55e6ce98b10cfeed1c9a9154909b9e2b0f4d4c2a12504ee8e6ede015783203c5ae41acc26ad9ac9c0ee5155f6cbd5ed0ae575cc5191084375cd4f2b3fcbe8e9e906295f743d407ad1a5b2770550f86ea0d95368c2780c023a32b147faa56d5c128dce35f07dc674dcdf096f150e9e8cb27c06e39cc8d74b51ed37a6b69f5002ae5cb0c56d16fdd960f131c2d0aa23b0cf9483bed980fa5e42b5f464d0bcb28d96f2b72a7b13b161c10627cf9940f763a12d19e92fa84c8668aacdec44d5e03375a1f1090e0a02e80c6680a9dedad5ce64c7e272524f8ea50b2776b0297e5a9cc34d7958573383a1467e74cfc6124cceb228fc3c0ce2c0928ffd9968d3f339fa0b2b49437ab1cbb6e87b643bbf557ef6d7b9bb60991e3732b7c2002ed027b4c7a666c26e364be4a59adedf17a2a7166eb20f59b30b2b273d6bfd31ad40ba1991d4606ce613ab5a7a3e5b15cadde77ac1ae2b90751a5c55ef68bb8076a144f4fb6196b259f8000a77aa4eec41fc146a33a8457c1dc35cd7105e3a725d519cd96e3c401cfc3a1cc3dbcb0df8aaf5e74e4ba4d836945d5edb37f25d816c4de4d997d516e638a2db528109ab85b28cd9e9aa880b13735b399e41a46c564ce0fcb3dec4e3f6381bb1857a3da579ec86a72ce7cc3dfeca00a98a55d5fd6ab670c3cffc91a62a2c35f684074d98275e5a556d0ac4742f48bf25d3f25ffa863098e16b3884fdc2038db627d010025bc5bce5a7449369aabfbe8d62984dc134b202528955c996462828365ff1dbd33d755779b27e75e98aa4c72bba60944eef8f77758e6d797ad20883049201e6554fe16c24e145656266e3d0f9eeb30cb394d12258969bf0be87448bd105d5785efd0a13a4a6567f8554e55b3c50b5d0f44c5f6a9cbeffb54c7a86238d44a24e6a6b20ef9ea5508460bfbfd01dbc7b3bdcef2d35eb070bbbc7ca5497d80445ba02a48aeffc5689c300e4c457860b2e8b4dbfec12a10b55795bf1b5c5244c280b4f6ab9c1a42b0a49faa6ec8de543c98a1884009859755e182cb68fa8bb426cf9a79e66f3ffe210026100000fefffafe400097dae0751619491fbd35be7e4eb260747c68a9b71557eb19a2d5d2a9ed2c0f1382c0165c97b917a439d0b6bffecc089051896b6861a78b943c6d9918d8ef51b291c8386c391658b0a7c7456b576256d7386cc5c50aa94af0b3c5ecfe2549d972959edf977bfb8a13c6d63b78b2c1a2b6e000278226d4030348835f928a3a43cfdc8dba1c0f264a75eb9d57ff075c94f9f0af3241cba883e734a993e58ace4e718c3e0918752f6f457ae4d128ccf436d84b38754ea1c6d0444bcf64fb7929426e8337b28d9fd9b7ebc3c7af0f9f69fcca88e3f3d2902eabd4c5da8f282c110374113f7063735147d8b6dd0a6d6ce5af8c439716383874ba5b13636bd6e5e8f4a957221570bd0eada0d1072743dd0ed8e0cbe1faff7b3d6f4228aa5e1ef665eaf48a13a2898047287363cc10aa720130d9ef76e0da90445f26a407b7f05842542b8f45ae372efd9a8b8352c6ef61ab5684614be4c6fbfebc6045d428a333704d6e75c5999dbbf5a4f8ec470eda2388b57e77cf0a94a1990916b046afa06af160c3d508619d30137c3bb97fd4a85c14e34f13e8806e91286a3acc5f67c95ad2dbb501d484114ddee0e72683dee43700c5349542a0bdb1a2b89d18856d00985baae836e0fe7b536f4cfe929f0fe826997b93b25c9c6153bda1eb55de1227aeebeba6c77a83dda49453f032de04656573ce1e1352ce3ba554abd9d75a8cdadc5733fe741bf28e2e6d8bc29c01d190bb83a9cd53b782b20fe0de7fafe9ce4f178c4a4ef82368af77b1d9944fb023bc10f946434df925a48020a14090c55fda914d7ecfdd2fe51ba69d30a0b69410f0a5000003951c5b7e7910f78ed7a5d7869ddf1bbd710b6a3986317a9a9527e6b96fd0e7e9988be79fd726760583545882898f321960981fbccae891ba01b68661612238c137976b544998b275bf97f7e2fc4153485aaf121976375ce4018a8f9f779312a10941dc246042cb2c7518cd1fc18a96bba39d8242ec923cad47232f8f29cb6081663db336a3438d61c373e907ac4b6d18ef1317eda67d727265db524dbb301c75161dca9e7f09b77892ee8fe824ec1130bcaf48d601e9b883b1cb430c90f1eb282131576679f866a823bfa34dc95ee5e371eb8144e9652da640551dd8536bd261e6fcd52528c079096ef78c595e30aa65293e2e2556adab323c660b1368916128b99e5c28f654894d90c991cda77b749317d0dde470a34bce9315668a01a0b12b543816130c0e21af9960bbd8184189661c8f9f908c99555572b2810a3c98224060a457f1fc3916010273698da65a0485fd0ef7a119af4f8778d918e235726f5c6930b894e0aecb12c87478bfdf9747f2fc95890a387b503e9b8236ba9ace4f24636620f59a615161ee036e427cb3413f98f7841c6af640cbda3fd165319a6e4f578e810b4be5297744b578f8206601703ee156abbbbc50d2c7e9560b3b21bc50e3a47120a5ed8d064b966ba5438c16d23686a196721620ee8ff7abd7e53261a04c3bb9b9c8fd5071fca43740d18f9bcae823b2b4efb62833251a38cd5e9627896415882f8081e0f48cd2429f00e6822298e8d6284884ec7567b828128afc000bf6a40897ad8d9b371c2626ef41c433fb64ad164a3942b434dc169b48ebfc54a2fdedc2d4afb5ed4877e1f8f328c59d1888dfc49dd7ab45bb2986947d2a3143acbdfa5e3f0d1aae390a7259e10a017d91a6932c31d2b6c0b6b472b7cadf1f732a6ee46521c1f424c7b8195b565e6861b1a7259a87c2690604db4a28243de59f04e9777a59f91116c1d158fe77d0c7ba0dad03311e7a6257162ef49cb488b6aa5401d9d8537fbd8540c0cdf4f105284d37d0755978f54e97aba6225855ad548ab792ec000ca255b7cbd2792ba5fddb0ff055a595af3961ce8d5746aec414d9044270f4cca7c77b2c3238d59e5a2c3abb62eb14a81847ac3e9b07382316cde1ea325819ee6e85c1ea72a5d82ff5c4cca0ae283471048d16f6f784f3ff8ca853db1d5db10682f7c531f62e169087dcc410466e5d56d8b45c679230f11fbcfcb8ff1a91caf367c7f82a54fc84b431d3bc239f4c4955c0c40e139e0747494dd00f876023c570ef2da38d8445cbd0487ae226a388e012d3ed62a1d89691ec57776baab5f62722955f5a1fa2787d660df23626d8dd239999c32f95e5f995fc0fc8c436d5b55e27533667347d987a6826097f9772b3b9fc1de5c50cf2999994fb689679a938cd3d8b61d06f53fe6a92575e09188fc554b9e2bf987ba81b6ca107043c083fd1381803eab8c62977cd3c456019c9e17bc5dc620456f996303a1d7ebfd67ddcaf36154f6eee8d744a5f8b1f378bc2d19ae27983b958238e5be45564329b45e89ea56e2620dc1cedeb3b12b7780d8f45ca3c87641edab00d84c3ebcffb78bc11cbdbfc4ea9a5f83368a600e278685bb23d7fe3d604879b8e79c5c9f25c5498a647320932ea92f0d054edad3e3630ec4aa8ce99e21644e018087b6764f5042f002ade4f16363357e051235a9a62256c72595a7bb3d64869920ec6fd2b29e364c9393c1b40a676001d99067cc2da3a0c0002b9c062a582d03cc2548289ae2a777924f547aadff8dc2ef99903fdc2049aa8236dc0b2261fd8eec53c79394647ffff4e57b46776f8b71b5ffd8fe83f638c2fa74742991df154ee2804474a03b66544f726b8225b2d5738cfc6e64305a1a3469fc4d2508c6b38d8046bde150c37219bbe3623ce7f5ee28d9bc43d14b627d224d772c584e9b96d47db08b7824106a9e0ac278ca9c6a238e188d57dfa28b4716ffe7744e8a2972b5de5e736770b21ba725f40c1dd1edac294e40ef30258aaf2382723f6bc1d2fd47b78c2f88cf0a3a92634be324d882e329a0c158e2ed44d6f66e139ef43fb21a6288e635732a9d76a2c0c6487cad30a544b233e6f67b19d0e78c48481c5b434cf7242592b624b9b49a65b8e15c585e117b3c49a0c639d16dcba8bdcc1a4f64125f6566918938f05942a5783bfe023b6082b14ccd4d16a3af8ace2ed17e5ebb30e8f164954d6af3b7594a14d37209a6373c8b369a8b6cfc356d01e6d0421ce3f1d1b5aa6b5d2a70cf7a4cdcc930f73397d7a96af8ee0d4beca0c546c76b45394949c59f61a0e8fd74528c2cefb8893c4097a2dae003868463e1ba66f1fde20b97956330243d0d3b98b24190c13444f2230e301573c8ee9543ef798ad3ab018d30638aa0bef7cfc09fd90dc90eda0384dfe2beed4fd4add56a481c36a249abe6f30e3c9535fe4eb05dacdbd9971a66be946de01a9a298645e0e246b1644f5d53232f4a96ecacd42d782ec4307d3ee4caae3bc10b3213119b5a9de0d6158eb6aa9e65ac3ce6e054d74100077b7c94874114f803fe8685ac19ce6a3f73a5e73e3f6f1e30a7e1220887536cb3c29f7c688af050a01b1caaf106199096433845ed6b216e5f0a277a3e5004fc53f3524c855fca2275f14cf58f5ba84ab004c6a51d4f64ab17c08bcf992612a0a3650846ccefb36556f0ec0810c6af5850b55909efd4460c92800416f3cd5cc8971467e8001ec86e7b32db353748f3e6017a10882433916cd5d7e6f483f2808a3268ac6b951e2b1c325b9c51330871c11674a348c8c8238735be4354fcd06006463dc13f1866b5c85b33fc8215a8a6fd3c321640a966f4019fd28b87cf24075dcc5b6cc1d880ac58f71efc010005c3fcd370285b756c6601aefd88944aa530dfe8050d89b1de7270a96cf09f9db32ebd74da6e4f5bb9a601ef6098959f2f9493c2da23fd440c5bef6e000059366d1eb1dd1d193335298f033e8b758cb02260feeb5a742d243c371808e22f55536113408f57ed0db46d6ef484fb69502cb3b1215ca27099117bea237e7176a87a685084ab3c01659f9a5094405fa3c6e499691085d09ba8ce2ee9f04451e0b639b21656670fd7cfb9c3191f48b33b0f1fdfa08d83f5e1bd3d32e2834932f7bda7e9a683e193670801b031dfa816ce0dd0a8b564f56557240b2fa59e987aeabd0de99370e9cdee94e44458df4105e060d6c8bb21135dccd2761a96eaccad2f01307f5ca0befdcabed578024654a6f3af1ea22c5bda00df7a2fd6722bf5860d486641384f4ede7f41cb3a7062338565e8a2dd3492d2ad09366308d75eb153802ef5611c5bf80dc7c701df202bf44d68bcf445399ede5a06c1d23b246c4d62c9b33f85cf7a12358b629751e070d4181d94ea6424b2df87697f3db7dc7f34249cf3e59165ee76252d5e8173da0399df998fd43a585ee30a30427fffe058e50fab81ecdace0e65b81fec7ac472ff4fc193601ae1ed990465f0e10678f929712e19b0a3d74b34350714fb631ead100ef2a6c61df141206e3388f2fc9731fbf8ccff31a66daf43868ab7a5306d7430a3755f53b16997f4812901c54b6cf1de1c09f3bab4ccba0df9b596c447f86fe1a7fb198e261056661d000aa3c5ed3bed87463cdff92cecbc7d32681ebd037cb5fe99c124313ce18ca8e84a57a2c572dddf4dde224599cf9dbe70fd7fad579a53ed8f76da4825bc0036fb10446072e06e1cde66677748c04c4a6b6541cd86cbb88abbf3d81f8285fcebe0bc90f3f9fad02938cc3ca8abe5c3c9bb91ddd0f5e1fd80906550a6a5b90750152b8fc0c47366ed0110fbef8cf0ff49924f66ca6397abfe35337f2c45022ece5ae157e1e05fd14c60d58226b20fff232e0b21a8398bf88dafa14696ddf3ac6db53c7135ad70976b9bb371c1bb8fc29cf31185dbf2dfdad69f408250091c7aa13b7cc1aa6041d429a0e277d51b003a4acb89bc232bcf22d7b00657e529ee6fb8a5be6a0810ee0f381424f72923e6dea8a88bf5f13b7dc0261b6c1425d8651f6b8aad8391edb8e9ff3b2bc5908f0b0f2d2bf0693cbfea2764af090ffb772ec3a599b84abdd6b38ee7b86949fd0fcff90a48683ff913d71a7e9210e99071bbc64aa6b7a7b46728998f42e45f13a994990caf45ac453a10d6e28d14d09b2c3b0dbd8b52ffb150b85fe44d4f846d34c5aeb0fbefb88861e0e753f04f70ca84f4dea2c018ce330e06b88a00984bd4f7ad5970939d7282b0040aad692927027d83495e58442fac5d10d0e0815d72634ffacb676eadc7e2c83a7b005f51d94ee9a8a455de86c38ecc4a82ea93ad26c2099961dae1577e522d2c1acda2a39a4a8f9f67944465f6a9efdf52688074867c3021d401b29f2657163b8f87ed36f16804071eb17772d425f600000009524d1044e5df287c327163697dcd3d968db1a1696fbf7e56f8948f458a1c6ea5af6793505709f205d5cbba966145f929bd6c644882bb50c57d45190ce8c1a0470a511077d5782cebd1a23c7f44708047b7164a11fabdffe996cac2d289169b443857ac9da9358b82248ecf1856165734459daa40b0456802bf4012e684a045f9d90d357dc05ee668204b60b8167e54f352cfa22e38b20a2572ac38afcd02e2110e9c0819af9c2b35974207cab2b3b6ee207191006a89098f6749cbf8b5507254d4ad420e955947285bc129a96e91e8d5e639999143d1e0af5a37e9b8106a16e788f6d8cdceedc7f0e56a55daec7d5361303fba58ac19680e975fcb65d7e6362fb9e83958dd5b5ef4c5ac25f233c0c5a9d06d6fba18931f23fe1b47768e18fdeba09c3023923d9c25d4919936cedbd77a6214c147ab9516b2fbf7e36f40d6369bb366def1d2b867d6094af59d065b59e1dc3823a7a77aa41616923d3b7e5b98d1cbba31403dba1fc3e6e4f54f8c7d60820393fbe5c3a9745387a268d673aac3fe79d2325721a06f022e5be62561cbbfd6402ade0a06aec342b87903d60b9aaa200275b74e5aec5305aa43af5193279ab8e87c73c54dc7ffa6a9e24283e6e3cfac7dcc7e64000117238aee76b73878b622db2dfbda27062da7a3b48bba31052a025fc65672427c95116e63d3117964224e0dbffb574a09d5c26e1b84621fd0eb3b80f8c43f37dd968e21ed52ea4cc66be0ec790986e9a1f952b17c861e4af9ba7ffce22cf455fbe989222c9498d70040392003bfdd63361eab1f19a58e5ffa085a5e7887e66b6a59f8e895cd640cf155a6f05fc24d32a8e1cbfafca3ec4aa8ba542c6d6cdf186cf08f0f790d8509d38da86d9efffdfeb64d0eba7bc3c6548c096f5b6ddc57594fe1074d6149688fa1081ccfd1fc31459452a2ee79d4fb037b625a08bb3166b0da57396a24472cbb16de9e85e754d43d002074e80d961b4467625f8a25351baee1b625d739adbeab621fac0a6dcfbd3177b2819d0588b6aac38a0831b86647734e108629787be17c8d7b5c8f72ec7948e086d610274cfc818904a1029fcfc76341f146053cd22e6a3cc72ab1527644aca4776b7eb4cd0ad561ec3ce73e0024a391b3ab7f03e700741e25b0e1e04da81b4ffd84933eb22533a5903934b30db64b027259838fea2fbafb8b18ea56694fcecc380e9ccb0c1bbd57bfaad53542575707c134e973273baa34a571f30074984250b9c4d05c691897307ccbdb4cb09523e000d282d23b8d87a56dbd748deefd76d997103cf578e5b807b5b76feaf76da58e10d9b4687ef3d1d45576d9f4529c72c3eb853979ef5b34083a976737ec6a2c2547a4595e617f725151d8e8ad2325642dd40d3ee50009fa61b943210999bffb9e02648f16b65782d7ab09f29a32effd71f05e56170cbb8090d0242f2ec4fff3788d82549e6accd315413daa3d4bf84fcddb93a6274caa2e74b7a7cd4ac8d44252756fb7671b561842784774990e001480ce3eed7ee49cfb246885d06e76eff67b66378830651f13eeebfd2e084f589080934de56f3cdceeae8bb3f8031960faef091658c65c243ea48069483a33d8b184aee77341fb46b2fd6b603bf20ab46a1f19f14762bac2f43675b6128fde7cb22ceab048e02a0eef20d7122374774fa76a59f23a3c396ca3b34187df701bcbb7f081fa80cd4278a0f2bee592479e32e45ecc463e03c731f51a3bdc8e8fde18fd8a784aa696e30fe6775229251a16649d9cb39c10d8d9160a2a9b3997a5d681fa9fbb931e1af5c6e09322b7dc32b9df0e5da36cb692dcfa6ed1f74a4ac5721e23f1571fe8d31846434e0facb87e1a064c97e187040689a7627e3a27db8d44d8620127a400012b41db367f6ef78e07d7b70e16a3f34d23d063773c891a1e5001a848a0ee913afdd6a0cdec30098487901677f36dbc8264e8d98b4390f982225cd145324685c02dd4fb4ba83db055725c7f1bfd0964fff68e98bcdc27f19b9a1b9aa4603cc966da5323f565b7a4e64849940fe7964ceb903cfd03a52cdb12cc97d9d4d934a54464a7a7e6c7592c877b59c545dd6766b32a5f9e7e3d1b1710d86bf2314acc316377a0552aa175a521df0fcdc4c267ff5f641580b50a9f5c0b52c6f19827f1e23704545650d796622f554f1713340b6b24aae249b4fed48c46e7a232d841f5278a652a4feca3b4e32af7cff2f9d943deefcd0be268f569b61704f39499621c6e2f4bf888885210f92528013b8dfbe476aca374e4290ab087b262fe1025dc614d326ea2636f4205d5122dbf68b0d7e64b6660edc3bbf52eb003cea8e947a94ac50e7445851d1a10c0953c89afe9f802a71cebba19ca268ee3a40b734e0f4891bb6ddd133d2eaf536bec6818ce4727bac965593a2f03e669e5d073d47c78def5d9fb175be0ef30f1e389fbc7dd8a33ef64471c78c4aa538d84fd9cbfa6f931f15a942541e3cc41378d7ae2766fdca69b581f90d55c39aa813a79412827d17708ae0c817233a80bf5d8726cf9f2db5f428a24ff0c296400209d11da73f28e29600acde9f88e2b295bc60c2c61cc96e196289659bd8e3d1c90e8a037d4c51dc447146b4e144a18b6be02b95c77ab54c83db6f52cc82855dd4253fa2d3c3fa9855ee27f4f8f6bca4257df71d65b674cd3264a1c011eaf8ec1c4e1f9cf7d83a09ddbfce118020342399e5318f4dc1019219b412dc398f3e960d57c5f9ba6ca033495fe2c4db0417abf528e8cb56d881e524fa2a98bce4031295ebb844b1ba7ee980da8bbecf45eafcf78b331c25354ac1814c0a81d06b9579ff8ce8f8a386162b3941dcb39adadf314b1f62d4d255bebcf0ead6ac71138d72f3320f47c6348dc381960a1276fa536e6e69acd1abe1651be06656d94a404c868d9e0ac9525b72dfc892bfc0ec3bf28b7bdd686cff8eb89389f0f2c055f6c2cc4d39c79c8154ec084b87547015822e7dbf5226df6643cf7d53d4753f0e22ee5ead0d59c9ed709b7ddfbb4d9b51ac0d1bdf761d2cde70f031aa9318ede11044769b2cc7e407cfc652c7c0a578bee1faac896230faadd0b63c8af6b0a7d3228df3cf24dddc0731de7432d1b1f6ca73cd5ba814d807167af256d6f872a496958303464fff34dbd5f6f714b123fd055cebb54d231e8ef46cefa863b7f35b3e42a0c185a8ad5807f74085c821ecfe4464d4e33ce1fbc5fb80000000b2032e8ffa37234d69d6d9b7fff9960e937cf03861b58c3c389c0b7784e8832427ab7f243c727e3fadf0fd7127958bc6bcca5f06fac91ed5945513884f0f7a5f3dfcfbdf7cd4101f546fd50709b38ab6caa07e9ad590a447beef43a335bd2e60e4ca5d7624e37dd8c7ce9cb87039d5fc082d3d8bd892ed4cddf047cf2d68d1a7c188a680bc6c7b03d79c72d14b0bb9c67641c5afc06141157ceb5837be472a5cc242eb32b3bd6d915810d4681257a29c744d965117302f74651aa93b464851e38b005d65d814b434c441fe8d97cb2ad4c9d8df7e2b206b9fefa06a8de4b78b3296b7ca89091b1f225b6ebc52fd648ed4289e80f9a4ba4fe2da5b049519e6a097b8f0e0f4c6d37adbb122e8b237fa1d0bb7c72f8ba586e437747dcaf88eaf2ee1c5c3baef1d8d79f2c65a2c375fda8aa36d12c8dfee7a6c0238e6622fe12d6820f420a2bf9acb2d5a5a78ce4e3a6516058af4406be7712a9f6a068721741700750916ed2cf3e6378b19655c84d2dc68de73b7aec2d1cae8a318a93b8842deb28bc4cbed28adf9db4bbc5d867759e529f5526064b0ccb75856daa2a991580364ccb6b62b8d6b2864a42048c870f877d88b0d4b8e6e89b7a08a8b8c06c18128b6198eeb9b42407cd7c43c4bf5dc20a254f6f898cb0d5e7f4a254514a67cb0727912b0ab9576307272b8b53dbe317a2612cf5f76515cccc811af00483674beec0ab2e064469f2ee9fe218885b9988ae7f016c26f7faa1279156c1b647000006c124e70eb8a0d6fc8a6b1389864ab683cd01f85a33c1460f77d46eb488cb1ace7599b0bfbb31f9926dd543eb56778cba92145732e7262f3eba9b1ce1e9c852132498c8877cfa2f23a9573c7080211c77f7f66d284879b88773949f5bd6c40fe0e17711034086fdce0af46b7e5be141e7bdb43e101faa09ba8275be69a40ab7924a4f1f4fd6f89c16a65455ce9f2627bcf93c74564d2de8305ec2f8271f098255e475cd5c14a69e381e840ace3456c5fa0c816963c6d607eea0da6de520ea941e3b0bd5a83c0b505331c9907e2a2b6bba782ac8bcd7bc1cc358ad891eb962f4518f9262a72fad7ab41599a1611a94a47fd75996157a638a4d11cdc4b6ea3c7e9a619d7d428e270dc9bfed78af7aafd014694d74f6811ad280f9d7ba21c1b5428bbb1f3284868438dc03b1b05c11314639c437a66c691703449fff7c255a0a0780a41ffbaddf7ffbf292cadff36044524eb2ba0442419ab01efd64d12e93a728eb62472bfda6576695af94b44fccfdfcd7513895434f2881e58ea378204a06bb4a9a3e23af514f05b15701e0ee1e168778b413c5a92dd5698f26ad765c1902573536e56e8d4079077cc22e97c9db675e91885613789db0a48e941513678639ce7bda4c2200dc603c534c91a5dfb00b4c0ef93d68c396628e51582c5859db265facf603ba3f5b5f5d61f72f717857b754ae112e032372f58fa5f8089fbec626eb34256478f117a0baf7383c9d9717a1f011a4626a11913755ad4f5c6776cb10b3470579415d43b0496658a3ca2965ce2a9326eb33acda2f7140a5c82a25c65e19b15f3b1e87e20d9157db411f4547e7e35698239d6cf77e79fe76c7213c7d0e003f5faba64274fefc810badc4b6a90900545a7f25c90a1d3d3b13e5e4e93b065e90e709376d382cab14a95270d016c03de3651abc813e912aae6f2482019bfc063a50b0d9154276683a2fc48e710b9d0b0a4788d9aedf186f360599ea864cc7f2803f41d8573f611475ffd4039ed5af5db665e7d67d68b343d94507fe16d8c131a95a0b1b1bd74a0e7a9754797ebdb3285366e1d48e0b9286cd779f464309969868d8d9955bd3a969d88f0daca7beee5578128be2fec83aab593a5c3423d04fb7480bbe2ae8e65cbc085b7b3984718f7633d352dfc57713fbab190123900353b6c2363f8664d3fdd6e7f9fd1fe711e587792ffe8de2f5bc37243739ba7ca22aefae4319d60934fcabe3f0fed1419ab7aff74f42aed8829e915405f5d62893f1b060b8084444d228f931e65749651a1ad5ac83ca83078799eade47d9cee2f14a48a6f7439c46a3f789b04991ec2711d8580ebc3a03b729e5c7314b7b60f08c1ef4721e46f527744e077acd20f54990e8942b228fe530e1d9105b388cbce3cc34972a47583012e5b561b62b5a9ae3a17593afa119e093f537de96d58d1752609b9d4f4a2b895291ebf16242acf197a85e2692a3f56fc00daebf5ba1ca7ad7330f4c6910dbeab3cc89ec5fc85959b987f958b518b389d345919b94cc1994ce4f9c28953dc41aab9a1c8f963f2cab8b41e036b003fc95f647c7f2140ff016d6b3d0e2abbab6b21f78ff0eef14e432c19cfdab0601572d5017ff4a71b7af8744367929be90424da51e0b069f84349256c7564f6af77d7ab33a1bc12999155138067ad38341e5723b68f0e3447926f4683d4948ff8e30be3e18c9368a31235cd484a67801095bb2498ee51303ae5ffdc1dcb32d364ff915df1fc44d01542e221a5c3aa81d106bdb0cb62b202d5bebae935bf08489f08ed394573d017c2172ddfe1b85894c1b7fb44d27c27632eb5206a9f2ffa17e56aaca8ae253c45283667832d6c8c1581461a165ad661ace2b1dcab5e6d86bf76e8ee8b463bc9162a30ceb4a6647094d0159c6b9a4f42e41c4ea2513edd3e10d8625b9361a8ef31c6fb915c175c1663295b44f5506d5745d7a50cabaa7a3635805c32f430de1b48e986a387b04475bcb8ddb719f93b384866e24b3aa45cbe392ea8f3f50c300727de002b957121e51b2de24d6a5f5d9231de957c6f35e5557a871170ee9ba72e6222dd5f1bf0f690c68fecf5c4e199dec2755f4c650122259b63a76de4c623f31418999b9e172ed9d62dcfe18ea8675cd072e66d571e463c0527f11f8e8899e5aa6292f097dd324fb7cba3eecd56c0f0a35ac7e672ff78c6be9dee9ffd9846c4f75ade40a50114d2b6df3a224ffb54376aa374be2536bd8d82d738c53a670d51b8e738beb5bca402d1805c52a3c50d84ffb672a9fa582fc3df9495437d6b1661dce166fdcd3d9ee4697d4c31e09fdf114456b68473101beffa3b3970e605e5fe057f419e6e3e4126ca925bc8c8d689dac7d912373120e560dd8d45bf60ad875acffc3e5e2d703eb7cc78a85cb292361ab33cb37bf695fef54908ff592aa66893158dd60d77d0d6a9f89b257b3be23c4d373fbd85f5808aededcbdecca06e73750efe1004699cc739e2f173328d5fb60f98af314e97817dfe65c1c327f0d29fd0466217668eba49346947fec088050e319aabfd375c9fc761dc592fe8b7282c35b16dbf95e399846eee798d9f8bbc570ffea92f5ec14843fe7307561a3a898da4fb76175e868b687b8df598cc133dba1eb873130a2931d5de775d7439610f13549c1eeb5823150e4342f3e718d18e61dbe0bc01ae1db5d49d64c5a420373b8141a175f705489c3964e6d5e63b0fb030b03b2535fefc325c3b1d8f4ac586f9c8d22cec27da7f705e0abfb2053e39eb0c42346a56b56e2e4c6dec0bab31be74b084809252767edb2924efd1d4ccce6b1fea22d9dfff2ccf3b09e722d14306101d9a11178b8cd1f36c51dad08c3e5ecbf9dfab25fb83c6457c1137db656d0ecfeb366d7cd0ea2e1164191d0b146f0ca729b6ebee1b9a0c89fdd7acd0c20bd0f90feb2f7429aa1c3ebe57ee7b5c860a5c09c7b4ebfa849e5b0ce86c78af97fc1219f734dc7f6a17d8c17fd1ed5556031e6d623e2732c3034eb1addcc81cdf10f7f338906d326b8ce5ea8fb54c84deebb0fa9d794cf0eb2b1490cd07c75eed0452d074cb4aba2cdbe5719a21a53879a748b54e6e7e71fce60b9ab42d153aec50ee3e992d0d3d4928cd18b3cd9026788273cfe2e7650e6bf2c95e473e1d8a3058f3f1a3ba5d76ca73a1dac3eb09274f76975d76d0f42f8760f7c2854b37d0141feb9ac9672b84e142e4537d7e64df1be9fdc185e4fc1309d1b4e8525779582acd28a452673e6d9795f810da6843a77cb16212434c5452bc1f2dff7aaffa8da249c1e4f331c4288c2193c3c77c61eba8ece2c84bc8d2d4619788c417576ff26403be7873107947279935a403b4f6b70d17714f660ec82e4d629486e176d1df67cde0738ff06c70ef7cb034063498cac6c174f611f696e576acbc07a81be43ef6cb5aecb341596b72c11e0c95344d62d6e30aa5d8a1a9fa8caca6a16da0d4313ee8b9980b0efbbb53fd6230fdda45e7b881675bb7522d3492c36cd888d770fe0570c2f7d8b22afd85e48b7dc1646300de022da28470ce62d657e77541f8068f1528a4fb78daa479b2e5d4a6f0988fd9ee10c776a5f7db7d84d9b516f5b6ce9cd4f74d3ef6e945ad63a06904009cb8593521304417eb8c8cc1c3396f9fed1ff255418f8023834bb1323257904c15a30a429b01ba8793045299ee027ab7acc8bcadb7c81b02c102db30fd6482bce88ea886d0c357ca02fe96d95513603aa7f97e7089302e719771d14563378cb0786ffc2728f88accc1ac0ba544aaf35612cdd663a928ffd44ac25a865046f196b43ae095ed916489e3e1e78e88751e32e57676f2d7461846f1d07fec6189d241a79ba58636ae629f758a55e11d5a726f2fa8ee4826c0154fa3e9c8eb548fbaf238e18a10bb174147b7afb5b49ab98fd7e645bd50b5fad45f306fccd2b1340f91a3b2b7aad9ef6d615cd917710dd94d59d7bb0149bcb5cc55f103e9626870a031d4f8d0d74312834a97baef9dcd17e95d006790569cc6566257410bec34529694572c480a97f025952b3daa07f8b78e57233739bd73d7aa43df177c3f4fe889af16260f9e8ee41eaaec03b876e09342b6add705be484861cf5e176f55ba7f0063c4f8519b6cc544bed5a86e4cb4faad2195e61fbeb99fcb3b78a7cf4656ae8801bf6f7778c15312455526745100422c801d6b0828c2f6535a5a1946fb29676c02b33bef6e5002fb53a27b2316d2d3a9f2a516b6f5f294035a1fe71249908734b566cf4a0aade4cc1ea0036e102be3bf8c254767b0293cd6c0e330b12a2a50ad47d973f33f04f1628dbb27f55e1840f338ddb9f7a7df816dd8f72bac15fc4be74c2fdc0ec92d3a021adb292386cbf124977e7c65389fbf74bfb945d1251eadb3cb53719dded54f757a1ece41ec0621e47bd15d05db93342d71a17207a7d7fd1d279d628769b4d7a39eea55d6e8ba1ea0b7f087dd8db5a578dab8f6c2b71803c8159fcce1c4a89d7ffc2e8f91a900ceb72d6ae35f5b622e5bbede7c8a2bf03a7daeb4966b41a61c84d09d61ffb3e39428f1b336f18489672c7bea1f13f05e4c7bdb60e21ffde65fccefe4044028a7d0e33e31329ae9fa5d10642dc5153e22bedc1381d1be16443b2b77840fb634f8727da22418730f0ebf9ffc604d36725c5959e34119a012e75501b2e7ed232efd3d14e1c57c264215502e5f87a955c79eb73b4e1b11af3a657268a47fed1c6dfdff98a9485d1d1c01752a836e87a3e6be12b7891670fccb0a0dbc71b884e7b5226766754594d9d5b9337f8b0ed1f846d07739a393819d7e35ec13c99ea9eeaec363911d3bc96bb37ef84faac7261fc566aa3ab710b41858f89721ffdd736c16037b552090a9cf49e327252fba50b70c653a880a80edee1d4839499d9268e2d39083f39ba9abfd95c043159deb0a3cb39f1c9a675306e6e170d78dd35e8dd3dc2b7ed6371ad3c2eb38b7f3790dfa5577837ef1acb33cf2be1368846300cdfd12a079a74de1aed2ebf7ae415744408b3997e4ac66b5c2eb0b8266b4423698e696f0b671b2542536e1def515a820eda36f480c9729ae82572c47bf3e8919649e28c1a38064ea6ead0b21110552cd5155233cfb5a6433444f22cb7da097928c8126920a4f33edf18d9582e56bf93322e4d0069902d903656eb339eb5c507fe6f94977e84c1b2ba5579d3b054150150c73ba870777473c400f241feb1323b91cfa5694e1327f4431195e728c22ed8bc1431ecd8cc498f684c74c0eca1303734143eae0c8c5d22697c672ac2b68dae60012792c7eaa7ab508ec84d99ea6032d1f9b17200215406040751883e547ffc5432bc80cac2bcf3c7a394cb6cf1584fd19f2928d8ad20e8ec8085cfedbae31aead69d37efa89d9b818d70a03f8cec13f09b5b8100a1e60fb87addd0e3753e3883634edf548521f002f4cb0f3c4a1b56872ea95d341c1a06c6d80d7f80ae93c012e86fc1c22e8a7a9906a5cef192085d048d1a7094a25389b3cfac2476c26bf073d164fcb187589fd52466b7c5b8db9c630c3f3edcd386a18b97c5651a7e9d95ff6f04ef917afa58656c4b9c5ad37225a115fa27cb0e356c3580c03dd760837eb5991e299fe788f799428bebd36d6521c82c2953279135129fbfabb0b7b4ba36d7aec0541731d115832965c1fa519f993c88548ca2062a1fcf3137f056d83f75e22a9bc7ccaa9c3f3363e99074aa5fb2502708090dc9dc969e80ad07e0320e9a134ba4137567b4f8a9b8eaca2f3778bc85e3db5f87046d36eb0b0f4e5468e71dd958e94133e9051a2d31f387124ad9193906023a09b12c80c5f67648238c4c4fad20bb1deb939e6672aa7420b47f496b3659197b2df9bcd749ca12b0bbc512ccf052d951e48a21f49dbf875cc2a50a478797286b6472e1931c0f50850212dc15d6b859d55a58781050258ab02bec89dfcec6a755cae41f241e587319b6c703dde920a2ebd9523a4321d6bebb053a39b7ac26bf6e3e2fd2411cfd66529c57a1a1eb44d1b46202e1ec5438fd925305b8d3c6deba21334cd90589484f89b8d44074f448d2cb8a90e2b3f0f2a3ed15fc60e36baa5cf7824465b904429a16813bf27511489431884c3c888f644f812d4bbbb79187a5e0e71b7cea0d115b40553deebaea685ead1d1e8b5d745008138c9cdcdb965f807fb38ce300a3731d55041cf7db707ff5394d037872d3260f6e2ebf274f45472c6040bc598411e647f6f4347b23b084d2819b9683027d98dfbcb2921d347275abaa01c062aefe4ea47e7cadfad481ae48e2b815af5ab2cbdb592010361878f2386d05507ac58677ded71cde1f812a07635e0732da8a4cf37f6ce3037aca89d87221b6baf3749de549f1f7d6acf181eccc98bfd503622228f312a9c848388a1f959e7dc8bc049b005d79bb6d54f82cfbc22473e00c25911fa1c076badb3c3053b4d82fae4608623dd2d7f3e6b6be7c9144fab4a67a0ba270febf004011bf154cb51e232ed7142d85673414854b553ddd2bfede0b73f2cd0efc1f74764ef878a2f5cbb570347be039c8322efb8d3c6598d6342685cdcf97f36b1c512a9508a9065eb0b5f74a9460cb7314621d4dd408acdefbf5025abec412d7bce35553e86e6f7ae20772a3de22f6e51bd77776658242f006b8715df3a73dfb6a8910832352f547486dae6cd00b771eb3f7a9c1cd8b2ebceb9c1a2b7b1cd79032a525f9b6d5fa32eccc7bd9c0f5a73de8a3a4c6a348f2c190f366be9abc8fcc121e93bd996d7d24d33153949b8758e959e5ed5188f54f32b3b524c2b9e0949e5ab44fbae0fdadbdbe0cc44be4453f0dd0dcff11c5d256a64bf9d6569132be437e6cc02ca495f062a1f66cb34109b8a077c0544477a87645d14b0a5bd03a89d3bda6ed3ca837716291aedd05754f672d97e4f6be2100ddec3c3c1bebcc53851aac1ad12beac01c24f81e48246d5113dcb9bfffa157acb25fa016bd9537917533088008a9126e98a075588e0c5bdd937c607ac44a069deb1d50c24bf0b26c0c5134564094b234d08c0b22a571d01ea2bad65fa2b6252b442142c9806b063bf90e872a842f53f5ca1532df8901a09b5e8f6ab4fb0580e078db46e35657f7f7ade410e993c852472ad8baec5ea9397b87be333f5c9352071cdce22307a0d4d2fd00c81460fe8110be8d8497d3d84d32637bef709b795557de41e8962181361542c108408ae5f19609fcc76b0884e4e10c005e40c6fe73e680d6599313e58529148b04f9b72197d2dd4f148c56081d095053f48812ec60bd7b1201250472397018c3fffcc7d3be4fa3d539867e3b75e7549337d0bd1e9efff01f6a7ab7f6fb2656e6d49fc62eac095eec0509a0286d7a3cd8bf349e6334bde7db1219e579ae5cec9164b49cf949f55b5a2bf1a873472322c4bb3f20bc2a5ab40f42f9f6b2f8dcd7db66146d4f5044a4a8d5dc28e0eef6cec36b96ac1b0ad9fd6295eeb1c781ba3d5dca7b8a48f9bd1ffb16caa53c0bde99ef5d69a79677e9fab725ad758966ac016f255475fc84beab1c5e53a7e6a3c863e40eff3785c00087628d9f8b7e0ad3a598fd5bd4629305ed3b4dff77b9d0103d7d66e2e67412b62004c8559d2e69b7650beda1ed76a98b02628dc013a1b2c674c18bb23102e72bea9aa1aff5d59a7a2423be98f1641bb9049373ded3cc61961af78627bc06a655f50ed2272d702d4761a300fff39badb352bbc7964d219ddcb556c282cdd93fe34f979a5175362686875164518cd8a63eafc8cb01607d8b90132b88d33d6bb115262bca4926c0534be92c310151bdea9eac9d70b5cc71e5df37d8a64859a4199ad5199ea599836ef4399e121711be7e123e406534234b0f0a782920b47b106823abdc4421661233eb2ffea1bcd66d97c01c217b398a6fbad5d0b6ae8aa16f978cffbcdb0bfcdbf8c9f1a98901e94fec509237ad6a5c13f12af93693f416d4a007e3ee484a73c917b8b5656d8e2650b4d82bfc19b6d66eb7dac2bff81195b58b7c6e129bc3ac0e836709f55ceab5186589d96f875b06e4ac60c370297d58a2964e71b57690f5f86649a8b9fe30749b614353630085698289008ae788ff978c3263a8d7fb13276575fada9f47fbb25e127bfd921928adbaf1b27427cae5d6235a78d976d787768c34849d72934c830b11cd252bb054e39bcd32cd6f88846c92f3460f3fb08415ac0ed6f4406211dca94ff502d10e0142fd95b891cb847e44fa6b26364f80e97cda2a560ad82daab889f8a57fff3d1fdf48e224c097f2c772f85d53b873d76094f9a4524b9058e0e1b75d04387e656bf495281afb40e9f4d2bbb610cf8747094c14b1e06d6a8a24a9a6cde09f942485ef9944535501ee412c462ea47cba9ca35a0a86fbb09db940b54c6658f279078239de275f709574e4e36b6fe947ff3be6bdf2125129ec248a6c83f82b0e9809d8e8367c873349b29993427513b9628903a8ff2ac48a72997296d050bd3d99e19a057cb0040a3f1e239ba01fd72e9ad4e0ab3cb9a8e6098d2d4a30de5ca822da1e25a401ce7d54841efcb44eb80d2a6dd61fd5294a320390f6857499dad9f9e0231358c57a0d16ca40e865d5f5bc31a58791c6d6e11b9118d008f84009cc79eadb317c2a4a275efc900f6ffa1cdcc9a7a6e7db89d7df86d22de0f06a978f07abbdfa2c874b6bd7d9fd40652db3769c5ed0fdb92fa13666e7fcf43154094607dc2a24547ae6734c195dd5f095d28c9633c988fca040d396cd30d8c4fbef6ffd5cfed389bc4c9712822ffd38d86fc9641eea8e105a3a8230b2f65402e11a58556eaeec3784f55d5287298ae2221f883a800b1047b02424c4051dddcbb0228b59382ae08c178a916f3d1ebcb8404246430bd815197b06a240883cf9f7a9d8a6050a0bded414d66af664f2cc3c2adac814c156476615667325f7609c3b3d013454465a1fb4704ee844c879726d786576f3d6277e03c54c4f49ddad32ca77dc2f71cbcd948e5cab42297f7674fc981486d5b4644c1f53fb3760f5a83a3c67c86b4f4fd91e92dea82a3f6ab659d6c7a6ff4f7d9a8ded6ed1261573008f37c6d40044e96acd3a4e5ee9043718983fb80e8859505f8801dd04ffc66b6067e631638eb50fc01cd7bbb3b969d251790089413dc4872ea2422793f206b909acca0c09400535856c0d2f8408dd82f2d02718f39bfaf149cdadddf2ae18781183c2299c79174dda4ee40b0097581f26dfd14f4749053c3815fe5c1fbc35b180535751943c021f473727157d617ad489dd6ef72f6fa6178610755c83042659ec7bab5219f878cb6ae14f1f95143d1f386a5130b030d77857a87521b6a38ca65f7cc1a58e99ac4023d83fd4242b8cb5354cd9df2bf65d9695e4ef09bd7b0eb2dde2056914fc679beb14e5762754a6b83d96fc428b583c046f77f3382fd8397fdee0dd134486f17a78d85ed816366024fcc8a2b658f045b4005b84eb901d9a98ce1f74664211d4626e44fd744960461264d9cce8b703a8b7c7162c57c4673993008aa0d5b91860e721b5683b81134aff1fb7f502aff09674044eb02a73d42a46533ef5bf7fe9c5b2e675fe5af3aa051c7f5e04ff93211a0b51768a855736ceb6d01ed40c56423a502d408a0f7455d3249c1b16a26417dd0a5359c730a2c6066cf59a479299d509e46f7f633fa7f56e8364f708ee9eb44e70a02b5362bd64ad701688c9c657b6a05cad0c2ff79caf7b4c7cea70be73611940e2c81018379ec23c493249a0f2dd0a0315f1a227353dd70c65a6296b8c8c983ef9eba41d1f673afcfdd7ad8fff95aa47f7b0425320db4304a7a9358686f7ab7999dbc7ff2c9dbce459523fe647c28e763aaa5597e6f95488a06659ad7202d68cdb6f2670a3d09dc64bae6db37093a541d99b0d3e3f5e428f7272e6ed40464ba00a943b520a502c3135ea0a344fd779ab6d913b51f518a61649feca8da94380c08e855609781c8afd613bc0d4cdcc03ea871c75dbbe40589a83dd0868a4cf414dcd62aa132108304a8267d95234448ba6ed7812cb26e073ce64cdc4a4d07c7ec8a2b7f06c263ce7781fd2a691e2e1da5cb7ff87627c5cbec234f3efccc98f5937d0170a123a64cacc9e7cc1cc7ce75aa19b1129fb9d85e07e5462013a714f1d73a7c08569ba4cc1d40013d978fb2f26f846348fde45b549747347c9033239a87f89e53875aaf20eb7bbdd76cb50af97d123f0b70a1c34df7cf573874b925173aa601bbea1dc7d8d27800727ff53e0de0b25e765e0219c7864ebf9bacf77c921b5d0b208df575b6779c9590d28e24b641e400899d886f9f3558683130bb11fab00cfbf8919acd332e55b05b8490179a11265050c87ce8ef2d1c7eb36c35133c4b15c08632db65f15ad41809c348200948e65cd640277dcabd5becb1a6f7cef590c4e9ed331914a2f3d22be494d1a0ec99405a07d97cd59154930f4855abdd83482799d64841ea3f5aee805eaa52262c93533d32ef98ae575b8def38d95e4b8950d41512e24258b3fba4ed69a337ee1129c3fc13ef9596646a97e06a878952ac3e22b2fc25b5b0073ebae366fcfc7f9ceec11c0d6ce1ffc6809530e1660a255450bfd6fb787a6b88f55b21fc8e4fb41466a6d6ec124a82f958aeec1dd2216eb452968f63107fff5b07bf7779705e89ed79b542d04f1b380c1c971ca435f8edd142ffc57c8e124235b115ca446a2580e2c93160d4d0482d11872b22b45efde933997dc8f8c5034bc33e30404e8d2d817fada5bd5b01839f0f0e9b5a5fc6c09542bf1ec4b5bef1dbbaba5883fc6fa657e48542691bd60cd6b0343014af9b4fe488082995c63b05b558674aac9a82fa0bb943e17c7ff6d1a271db32648f4fbf25ef263a48e2c5e75509f6d3f0839a9b2e6b92bd6f1f2b0cae33f2dbc31fceaa5e5d3629d8dc81bf0f34f0608e968c0ddc5796f5f9fecb807c1c794face3b65ec29634706c81e64eeb9e35978957f7d0afccaca13162f157d2d250daac1304deb9ae9ccc0507781f9e2e14247d6316860047fd56fdcf9e7a154d3dbbfd4027f8f4c00bac63ceb3306d330b592d4ac0ae6f17a3d44c5374ad4662259a1fd9df75fdda5eae67c64d3f229d9f44698a7de08e1e1b47a94c2bf366da5de63f9308f3b35072e08f8c39e375dccc85f43eae4b3f284d2c1ca0308aee9f7b85bb633a80cfad665074b4b5f9726adbcd55ec8fce226037a4005d39f374bb03fbfa74cbb07750346e7803480dd8dedcfd78c1639395e6694186f16beb2589c463dea14894ad68781258786ff180fcf57dc83cc57835f4c5cf5fdaca86495e51c9f7a704bd836f6537f1c2f8eda8409c2aaa8552519e45c0f07ccb124b03dacab4d956c561b5c2a53fedd1d3ef4b65c0ef65cfe037391af68b2bcfddc04411bbb69e707540d90c1bc00c0376ded932fc9d4355421277dc41c79f22561c4081dc0133dac49be07247106d4b76707b6b4ca76c0a52acc34e8252e36b17b1e800d4ddfcde7f2ec9a350b4fec7b6a4ccfb74f372dec059aabf6373a1ed47bc8c03f3ff9a6e25a7a13594a77b82425c6dd0b3d0cb5165e4cf85d5c369129982f25db752a0f0a6307a4cb2416430080619d194ba190c1de7890415ff3f5a942c4d7f0947efaa9bc9026a85fdfdb29c4eec209ef137d0c928d9482898e8b50d0f3dc7502cfafeec39ebcf42302f0fc54721c2626a72b3ec3336f86143211ad1c59abcedd257012812a993af6552215f72cfb9f138a837c7356bc519d21191518376ca034fa9818a049e65d48f10d157f37672ae70cc31b82404240e6b03b0dbc74b8a1d7f9dda7304a46b690147ea2ceceb6148818bb380ec62b977ce597b13a72ec202757389f1389a696c78e8e32aeab224cd774fc50a540437c28baf3dd11aaee6f6a9bbb1074963cf886ebf67c641436dada8104e0053e28d24515f387711164b3f18f9524de31edcfdd67dbed0434b985aea6f4b7b15596797c0090d5cc8e8d9bbb8617581807961a5199922afea41343598458aef91d8004e54ae5d603780c1e7604b779117081dc4eab03c7ae83f61c1aaa740e45a89a226b27761a0622f1bc2c5d70922f1ce064c03690dc42f0889f9524d8fce2140b58fa10aee255b5f552811883094855ca0df8de903d941ee6bb508a7c87decc7723d9435dd8aa24263e3565d7bdca603727b566d683770b794eb8069270d1e1c73dbed792c004ba4bd3fde410dfd9557fb0cfa3e31bae7cf4263fcbf9b9507679f8a9eaeb985f75091dd6d2d7f80cf1a15f62f327fcb67ac828835a6281229351e5fed99d3e5be7a163fcd510df0af00928eb0bfcb9c30aa913825b137cbc2675cd52ce614a9f368b8c9e8be7d9f5e1ecfe10fd4e306fda9b06f1a98d027c9bace16e44fde169ec714e8b63e447c03983e6b860a937082221a48520fc89cd0e3423b93d21deb0d89c82d024f01e29db4fd14e3c7d1d5d3eb33be22e7cbf5eef1db75e0e84321cce68316018953a9057729188372aca4830e107e5759e2d56b107c84c59ea65c69896f41484773376b85ccf7782ec40ffc4442b2043ad4f092557db47067f774947d85cacde4632f12b6f61ca50062fbfe8abef4e20ad0dec11d49d22f3c3b2cafeda4b8f44fd8dad80efcf0a9d4022b0b9a1d7d0919b1d9eccd7eb07dfb19793b23cc7923a3b22076b4671298291f8e4461c98e9de85f6655900c6a6d0dc958aff66133de9be871c242f9d24ce1fc267802aec0a579058f6c8fac0bd79b98204095f47ec2ed9d5f25671868b0095608878167f06dfb185faa75264390329ce95e3a6fcecc8a031acc5071474aaa3aef5aff1c89baccdcd7de64b395cf659efe13f2e9540367a55be0a1a14d53133d16193e5e9f842c22532dbc914e7b83b16b932fd13bb233620f2af893b5739f1fb7c551acebd5184ac8d3b49b4971bf14ce18fa16d401cf82c61e0240bab5f2730a0c16a5cdad3d430a3752e2de24c1b1a93257f2ae5ed7f5954d3e0b33e403a89eac72b7c206aad877a3aab52a2388f00af120f48af802c340d2d0a4e879350fa861b69e73dcfffdb6b67bb23e196bb63c48ec6e58e19b5922c4a589a7488e57d35ef0de3c91df28f8c77d2b54006e1c3d91f181f07feb93b63531aea0e740bdf1d50788e0134b714e0d8c3f89cb0fc4e3534e21104259c2c02b85615852ea64ae113223083fa3bec48a3fc66739ae1bc8dfb4d974ffa544be39fff73a7b8978d0194c8fbb95086a3091a939a3ddff84be289216e23d215307986c8d2742794737027a22ec4695569ea0d79f93c71e9ff0a671f4c28943469a78ba4957949cd4fe6d726a2597026e8c7fcd1a96f11ef89bdb6c0679a2871740479a0ac4c397c4799cae261bf362a7b0c3ce479391078bd5286fd362058c52c62c23c06895c3f475e08e44bd60ceb26120ac86e0d16560a450d5a915526d0182bd79073c4782d5d93bc5d021f4b5cadae579e71c0d99507107b52caa20b5d6c081f0d7d5ba566747e8908ffe86d00d5e3d9c38c4f84518b66a4ab105915b53a2d4f708efaa03c9b1030ad21fb2a074ff75e360fcb6d2c1a863107a3fb8fe1c4e4d2bd6a0e59bd13a6373ae0ce29cab191b61512de0e4a8322a5443817b01485500ccd2b8639fe101c636cd81aa6055cff627dfc79069102e45479e618e2205ab5c9639175a8212cb133932ef15a4ee39ca98186db02660a20899d3006928eb83f3d7c01a88fefcd69827e67147a6e313b293524dd2fe0cf81f4c6b985e77dc614bdd19027b82746707bd2a06bfb8a266eadfa9d1cbfa2b1295a1f4e976db3a5d32bf6b4cbfc13ee10c2db4f4f43a5ec3f2db3a0ed9f71b85be3dd1fd4f099ebe81754fd729705ed2182129820097a73e8b0074f54d1c852d0fe74f5395cf61c52dd7b8c83d422c2ea4f57c50bc521f2c576b084c9933ef38d1402bc931ff534d66ee87ae9bef1b09bf114b441d07664d9055c971cf8df28d2de5f09f16a37165796acb51100ae8d32741e96cfc451ded2bb655545847a05fbff8f5247264d6a1de970ea156e66c54803a9dc921247199579c3f5e89cd53d0374493b3527dab48224592979c348f694e43ed03d57048b2629257ba2738345af5c7a33b407f0f8d676ba7a07a113c80039789024f7170d2968da7e64a7924213287e65766f80a1d8dbd0c50ec6467ced6a7360f81b98389c85c35098cdf181a7b49612b2556d7c1bf446a12d1e30b7434fadef6c022e4ebf12e059c1b02e88a6170cb6e158c120a6e4a93c09dce17fad311af9df79443fdf39e79242d2d56331515bdda7099c0bd27691ad948873d2b6006c0b01fde7048142799adbfe2077b268c550c797261b3fd377a9382668cc01c67d2db82ea9f7b776aaa0703725f1e13d5484536253efece4c81b89ce9e4313a67ee59c89ed58988905cdeea992dc13151baa5eacf2ccab398c918331f56a9dd25ee8a281f7e92bd63ecd2bd33ffca60d6c10dc8b626b4b309e43da95e293133c3f353ca354c33900c932869102178aa8a3454663fd5bf38d3eda2d7893545015f7f1d0bbf96994f0f88687a6f01f97062fa0e38c8a7ca986fbe5708e46789fc0c6934693d611caf3dc8ee1c531a6608e558fb12856d5ed0b24cc9ee47dc745c74c34cc4e148171999a14756eabf35edf24feff80bdc3cf6759bc1c204a360729c8044e560a658656f812118dea1cb27e3a0952c921d900a3f6d50178fa5ff345aac440b1738c6ba8f703e8676a2ff9138bd9fe67f15b8220d3e719085b558ca9c4a0a930ea40389e0e10ff7689e7e78b4a86296024ad5bcda23c3c9fd3efd249fef2cdeec936583ecbbd283141ff2d56593e14c526741dc983dc383d7ed20cefad96039c101db552dacdfd4b82638000c79f3c3ccc7a2dcf9989d6d2667d2d0127b3e1a242acfc4b8874c26086567ffc15096db9437f68f535c2850a1de8fe174133706646f234bbbbf029907319e34b51f5bd46040041808a81abb95130e5b3f6ef556025a4455f1fc32a62fbb05a6299f3ba171bcd5df2d94676e70bd27d035a0cef78d0a668d7235687202c31b31a04f194b6843657f5898e6a9078aac3e296568278069228872074df90a66de5c5053770521ef27de0a22bccb1e1a461f038609ca77563a607e693c7be2cda562d9c04a671823869bfbbc87eab11f31529197930c6abcad61170fd402a46127808f95be421f91cee9bd8f4523e16db237946d1b56df18de7b9898999767e165bd2ce5fd78f94e9c46d0a1962e98c5121b8701950d52c30fc2f6e91f7e7e799a643fe5e4ea41c23109d593bf895d40a9c43c98a33c52178ef45c863d0d9f0e7bfbc0969120f4e361e4cb236fa1cfc6c73a5fbc3550473ce71b2f1f3e2b6ab20d5bbd9de37f810782700a04e1d1b5d178a828f7f8723dffc7dfbd7f15ffcd80dd01fcfb5ebfc00528be1d7ce6970eadac6c2c6378de46f14c0c90076abb2d1658e5a69b5bfed8ba11c9092e090f9ddb20a35c3cad8365748ed5bf67844e361e13e0df9da3ff888bd4a5bfe186fac43164177cda653ccc46835a3c1e13aea32e5777607294ad30467f38f895ebd99cd8b1508f12d9b7ebf8a308ff9fb9c608fe96b99c3dbb60d8a060b6f386de5e16202ed2c8ee2f5137abee5e20c1c633201e5dec6aa29cd209f2e873622d5711d8b35206a208eb393a2d7d3cad0e26f235dec9a7fd6a2a1c721298456b310b4b9586d941d0279d60fdab20dd528e4f1695a833976c342d84c6ba84103ed87cde05bac46b07fecf361e3fe476a8b2706c9c46ab5b70864ee8c32f043edd4eec00faf2f7b7cf4192383c45b416b328bb2e3f83ee7c4dae0751008b8157f1e49c7af62460a74af124cb64071b2a1084bf208c184d1ed83f6d23088b14df649485f7002c0025eafeb608d769df6b1aff523a1fbc084254464bd8df12c75ec389936c97d4ce7025ba1268fb8749d0fdda260a7d697741cb0164a68f3487924fb7e8f3aa80ec300dea239c73732321a24fbe374d3dc3d26b672cb0ad622d4f6002dba39079e5a162efb9a82bbca7ec6bb149da41095b7e5715aab52369a2eef747682d9ba50461779d7a0e6cb0a95914b7100dd1e948003c9d0b7bd82d071d430c379b68746309e57cd9f53a91224657733c05f28475e14a61c7af416623f283d3f5a71bb139a0c22838be7900839642b1992d21947553695ae09059817a8bd618c25a89114c54564a01488abb98faec6392045c19038e37d5ba0320b210e56f23661d052b3c19001ac9ae4d2f9e48e5ee0db571b73041921dd79b62ee341e1aef732dab8e2717e955005e9b1b53a959380cb59ef73c4d9839a6adfeaaa50a73396a25fe67e1b24c309b611c465b4bfa065db6b49f8e04203ae33342ba604ef99f2c6a2d24c2ae562bc80217fca95b3370ce2d1e95eccef6e6f2b2bcb0cea45127e14b16e47082c4d8911270be210f47430440ef34445498ec4ff999c4b8fc4f451023fa01c6be7cf7be5d5acbe4c3cd920a6188337675896d3eacc4e9ab9f8ba3a23a6085efdd1ef789b585f1dadee8278c7da3eab181ede4a1351c62d87b4c4ed0793a0584e0deb1700432ed2e40b5532529f5dd14bace8463c20358fae2e2dd1697f73730ef16b96a108a0f7590d634897c7f360cb491c9a524a1b0c10ea5dfaa20e89aaee5115e01fbd78aa03b86f00a08242c09fefb66f35d8821969269058fd76a09dfb5e52a751b3b4960a4ee1d654aa2a68121993bfb704dc8016404cbdd15ac948995b393f3325817f890082a6b402a865066efae0d6e471494ec0a14138a8066aa066a97128d8f50552116bfea69be196564e133bfa866e07b3c463cdec073b39bd099f8a129bbf517ce6057655e82ed61e4ca37ac469a2213ffc1c78ac4ddface73dde68c3dd8e5b6ad845222de497a274c7a18ee9d54282ed3f0d465ad83acf48fb6ec9c071c8d6b5b0a302bc17dbe650c1a8ab81e07fa08ef363a492bcc917eb0cc872ec7177a62eca1452595df6ca47c95d1b7f384a22e72f2cb4978444c3fbb1dc297647ffe3e825942021e3ed3b8d17bafb0bb2fe105e88f54a01b31709e636899f517f86be6c7586b44c9736b314a44ab57fde78623c2d6183c99087f23aedaa316cbeb75065b23475acf3eec739997a301e28693ce1b39d0b198cd5db835bc34f7b5e9f16bce15d73c2b1b4a6d013e0185462dea9ed1cc23d24966572275067a1205ab488e84a16627ac13be024d6f5dc30027d412931cd6240b228aab6f9f4b0da03b5669bda6d3ce2f88cf823df92b6c220a8bfe8eb587fd0a4082c1d2953b6983d5ca3b888cce33a88604897f25156c7677df8e2bc0efc636e3bf8cfd5412051e709fd03464716b2f81896dad7ef84bc01005173415404e24360bc5de602e097d3a3f7755af2831bd0d112eefc3e30e92a8169af1c2876baf87e027161a76bee2fe57061f20ee6dbb7f367ed56b14effce3c3b795a624a09fe3fc9a053aa033b2885c7f6e694fee632a8bc8c45d0b4d7ce3fa2b685c62e83cb346fe1a59755067a2031b247a2663f64fdcaa8f3f762f74305faf94097a71978f0a6757b2f62ff9c7f33dcc3856c4a5e356eaf59fd38c81946190ba639f8be623d41403759fd952da9df27257d28e16a8c48daa5a456c703bab9de7676ba938d9077343c809fb6aa2a940f478986cf2233800ca960d2c8850c5353e277d7acb8f610ff5ee9b05f0b2935ca7a1f459bac4c85579776cb5ec4c90abbed8488851f30b788f06bd6121f95ea8a7a07b10c6795800f7f7dd942c553902f5f7be67baa40fb0ef6aa02650f0880c6836d5bade1ea7d8979156787e9d229a357e26c84da66f1a3f1c69de996930d5c48ac2dd4049ef3d563548a8126a7b4cd2febe2d48bf472465a77f9a005469eb0b00a6c84f99f9447a73205c1f8759b24a96f6a1ac023c621ec8134e20c97ac25366592e33d2487e3b7b2358997b81427e560df7c204022c64a2aefbcc3ee6e31f78102320803869060d51a38e7cb4980c267b25c066b895998a6c0a03ef52c2d86c1b649106109cddcc1c626bb787185499ccf944ae95797b88ae42f805b47e27f7a0f797a272fff4462e19427af920d377602a513aa04b422e458af8d834791c267d1615d99045360e855809da4482d625b1dfd92a3f0672896a5744b5ba044d7ddfc8ff4375e8548ce4989a5a10a87258d0182af8de065ab7faa385c6d706e5ba548784787951be6f0653bc0afd6e18bf4fd0cc0618321fa6dfa726791748bbb888ba873c4790737fce8d6bc4ebfd99759c58f3fc23a386c4f5182bee7b124b4c91e2e8111cc804b445544da5741aefd4912b755ea7478011b4aeefb5ba329b62963f6f1b39639cf55d7c7891f8f3e4193f479e163e9286bf82118eae8f07ef493401cf962a5815954e22fb0ccc509132e6e20d1ce753f488bb5f41a5b19e0fb58ebf77e750af614019b052d2091c91022387fe489a685f5a2697b95f30ac0cafa877b86c8ecc7e0452d09483150509a2071e4edde325bea354806df196160ae3dca459b7322bf98c9e11b421d371eafcc96c543df4090826504e708d82d062583f34892d55edd2a1e1c4a0bbbc269ba41b95b0754b41c5c731d8670630e8d99d42ed4af6de701ee264fa55203f0160ca1eb98ebfbd11cef9ffe7c0c3146773a1d321f5c3222a1ccca47814f688e08b084377ac78b1a5cd387336a2e40ac32dbab43931fc56fd67428c0ff288eaf5d1da645c7cf216dad45dfce8d59538cbb277f5e09a871910fad14af4fc3db92f5c682e3fd7578025dcf85a8a33582c106cb21e802de3434896a82990d3d8282e11b095e65c806fb744e906dda92e4e6576e9a5eb6e2ea67d779539bacd55eec332a19c809d3fcb62badd5a1a13cb66b37cad3f848ac346b054d6e4af14583ed2c12a0f3ffaa59de07cd5d4c86978616270fef07566e0d917e47d7efb338f156b2c0dff5c866277d70122fd3b3b28a28691ca5311b8f9bba5338180c3e96e5073e47bf708e82e2a7f8a7549a70408b0f3fb8005764c92ec84f829ece303abde4589b9192ae3d2b8cd1eae8bcb51b8d469bdb75360e9959030b9b330aa267b7dcefb56e100dcec5f39e60dfa1bd86a414cce3c4cd72e4a6d83b9bcaf13e83d5672d063d3a289c95a853fbb915b85e03be94415e517e2f69ce7ccfd7e109503cb9d5c31193bc87623178cf903e5253df9104b2f42cf1d95a2cdeb313985f59e0f8ebd1eb51c7ab4d9a85e7f237ee9a119390872c4bd6954468fb34fd237f5ad4becdae0175436a30082cdf25541d229b99a556ad3c32e6d21c80e2296337c0af0961189d38d5bcc321d031dd948faa0bb0da88c0b379681ef3683e0500996b073bcf5e7b29827cb9ac85e12822edabd79f01e27a74240d9903f3a1188db97377b8e29a20aa8190b5cb987b6f2317db145a14d838c1ea23da96fca59c0438dc55c821049ce2619b8b4560caf26e59312190a444bf1d19b870590afdfdd22c4720ec97983ddb43c0ac7dfa1bc9beba574f17d2bc2d9c3aa9bc1667c85de999ce4a8e6ecfc04cade218225efe4b3a847e4218d04e3b9c3b30b98bd4a2f9b29f2f6fbf465abd3384ff9fdbf075b2279437d334ac0180577cc91f580000000004713cc4a532a678176713908115632453930af98cc3d3facb0ec6c59cf88a76c7d84a967defbb75a628e23e50e21b7d0e4527736cf78b63274a3221362f91ee07009fb2ec582f71f5756bbebcfa08baeb0d547a000000000	2025-04-06 10:19:01.98321+00	2025-04-06 11:07:25.005127+00
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.promotions (id, name, description, discount_percentage, start_date, end_date, is_active) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.reviews (id, user_id, product_id, rating, comment, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.schema_migrations (version, dirty) FROM stdin;
1	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (id, username, email, fullname, password, role, phone, is_banned, bonus_points, created_at, updated_at) FROM stdin;
1	admin	admin@example.com	admin	$2a$10$luUfFfBovdA1lSZSFFfg0eii9cazVDbZDV1hVpTMEXd9P3kdAQ8hW	admin	79999999999	f	0	2025-04-06 10:18:02.700273+00	2025-04-06 10:18:02.700273+00
2	user	client@example.com	client	$2a$10$fouz6J46Y7amyHjlEm3cmO.NLcVbvcrJQCYixPbhAi8vlkkpVg/dK	user	78888888899	f	0	2025-04-06 10:18:02.764592+00	2025-04-06 11:08:30.0632+00
13	hiss	hiss@gmail.com	hiss	$2a$10$AfZHfP8TyzXqR6cI2Hr6culDQCe1qzDsCPPZoCtxc3APR5p7rdWxa	user	89088376322	f	0	2025-04-06 11:10:09.731488+00	2025-04-06 11:10:09.731488+00
\.


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 4, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.categories_id_seq', 3, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.favorites_id_seq', 7, true);


--
-- Name: help_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.help_id_seq', 1, false);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.logs_id_seq', 41, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.order_items_id_seq', 2, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.orders_id_seq', 2, true);


--
-- Name: product_promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.product_promotions_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.products_id_seq', 3, true);


--
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.users_id_seq', 17, true);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- Name: help help_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.help
    ADD CONSTRAINT help_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: product_promotions product_promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product_promotions
    ADD CONSTRAINT product_promotions_pkey PRIMARY KEY (id);


--
-- Name: product_promotions product_promotions_product_id_promotion_id_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product_promotions
    ADD CONSTRAINT product_promotions_product_id_promotion_id_key UNIQUE (product_id, promotion_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: reviews unique_user_product_review; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT unique_user_product_review UNIQUE (user_id, product_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: cart_items_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX cart_items_created_at_idx ON public.cart_items USING btree (created_at);


--
-- Name: cart_items_product_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX cart_items_product_id_idx ON public.cart_items USING btree (product_id);


--
-- Name: cart_items_user_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX cart_items_user_id_idx ON public.cart_items USING btree (user_id);


--
-- Name: favorites_product_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX favorites_product_id_idx ON public.favorites USING btree (product_id);


--
-- Name: favorites_user_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX favorites_user_id_idx ON public.favorites USING btree (user_id);


--
-- Name: logs_action_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX logs_action_idx ON public.logs USING btree (action);


--
-- Name: logs_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX logs_created_at_idx ON public.logs USING btree (created_at);


--
-- Name: logs_user_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX logs_user_id_idx ON public.logs USING btree (user_id);


--
-- Name: order_items_order_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX order_items_order_id_idx ON public.order_items USING btree (order_id);


--
-- Name: order_items_product_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX order_items_product_id_idx ON public.order_items USING btree (product_id);


--
-- Name: orders_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX orders_created_at_idx ON public.orders USING btree (created_at);


--
-- Name: orders_delivery_status_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX orders_delivery_status_idx ON public.orders USING btree (delivery_status);


--
-- Name: orders_status_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX orders_status_idx ON public.orders USING btree (status);


--
-- Name: orders_user_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX orders_user_id_idx ON public.orders USING btree (user_id);


--
-- Name: product_promotions_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX product_promotions_created_at_idx ON public.product_promotions USING btree (created_at);


--
-- Name: product_promotions_product_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX product_promotions_product_id_idx ON public.product_promotions USING btree (product_id);


--
-- Name: product_promotions_promotion_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX product_promotions_promotion_id_idx ON public.product_promotions USING btree (promotion_id);


--
-- Name: products_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX products_category_id_idx ON public.products USING btree (category_id);


--
-- Name: products_name_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX products_name_idx ON public.products USING btree (name);


--
-- Name: products_price_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX products_price_idx ON public.products USING btree (price);


--
-- Name: promotions_discount_percentage_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX promotions_discount_percentage_idx ON public.promotions USING btree (discount_percentage);


--
-- Name: promotions_end_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX promotions_end_date_idx ON public.promotions USING btree (end_date);


--
-- Name: promotions_is_active_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX promotions_is_active_idx ON public.promotions USING btree (is_active);


--
-- Name: promotions_start_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX promotions_start_date_idx ON public.promotions USING btree (start_date);


--
-- Name: reviews_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX reviews_created_at_idx ON public.reviews USING btree (created_at);


--
-- Name: reviews_product_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX reviews_product_id_idx ON public.reviews USING btree (product_id);


--
-- Name: reviews_rating_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX reviews_rating_idx ON public.reviews USING btree (rating);


--
-- Name: reviews_user_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX reviews_user_id_idx ON public.reviews USING btree (user_id);


--
-- Name: unique_user_product_cart; Type: INDEX; Schema: public; Owner: root
--

CREATE UNIQUE INDEX unique_user_product_cart ON public.cart_items USING btree (user_id, product_id);


--
-- Name: users_created_at_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX users_created_at_idx ON public.users USING btree (created_at);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_is_banned_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX users_is_banned_idx ON public.users USING btree (is_banned);


--
-- Name: users_username_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX users_username_idx ON public.users USING btree (username);


--
-- Name: cart_items cart_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_products_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: cart_items cart_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_users_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_orders_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_products_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: products product_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT product_categories_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: favorites product_favorites_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT product_favorites_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_promotions product_promotions_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product_promotions
    ADD CONSTRAINT product_promotions_products_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_promotions product_promotions_promotions_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product_promotions
    ADD CONSTRAINT product_promotions_promotions_fk FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: reviews product_reviews_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT product_reviews_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: favorites user_favorites_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT user_favorites_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: logs user_logs_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT user_logs_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders user_orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT user_orders_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: reviews user_reviews_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT user_reviews_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

