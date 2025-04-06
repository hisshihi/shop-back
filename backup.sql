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
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
1	Наушники		2025-04-06 10:18:30.482199+00	2025-04-06 10:18:30.482199+00
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.favorites (id, user_id, product_id, created_at) FROM stdin;
1	2	1	2025-04-06 10:29:15.916205+00
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
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.order_items (id, order_id, product_id, quantity, price, created_at, updated_at) FROM stdin;
1	1	1	1	12000.00	2025-04-06 10:29:29.224555+00	2025-04-06 10:29:29.224555+00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.orders (id, user_id, total_amount, status, payment_method, delivery_address, delivery_status, created_at, updated_at) FROM stdin;
1	2	12000.00	processed	card	Гоголя 12	\N	2025-04-06 10:29:29.224555+00	2025-04-06 10:29:29.224555+00
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
1	1	Наушники Marshall	Крутые наушники	12000.00	20	\\x524946467a5a000057454250565038206e5a0000b04a019d012a7f01c2013e190a8441a1044a1f560400612d2ddc2ed618b5d4aa3ecf7aee919e55f2ddf77acced8f3b2e9bffbbeb1bd32798efec7f50fff8de93bcdc7cdb3d47bf9c75527a3b79b7fad9ff73f36ec1fde627de3f1c7f797d71f35bed3f603fc27fd6ff09f2f195bedd7517f93fe1ffc0ff92fd8afef1ff67fd2fdd6ff2fc1bef8df01df8f7f38fedbfdd3f623fb3ffd6ff57f685136d4bf41af6ffec7fe3bfc7fedb7f82fdb8fa6bee77a67fbffeeb7daafd817f3ffea9fdfffc17ed87f7bfffff647835fa97fceff55f005fce3fad7fa9ff1bfbbbfe43ffffd2a7f97fecffd67fdaff29ffffe1cfd3bfefbfcffeec7f8fffffffc7f423f93ff45ff21fddffcc7fc6fefffffffe5fde9fb23fdb7f631fd60ff9ff9fe44457860b2aaf45e8e8c7066fbf7fef7f6efff6d0a874d4344d8c039ff881da28c2943d429387d3dfebb7ad6add5fa1c40ae3153d4d8e3af782eabc3059744d0a7f7ffef99f0ba9f962de0579789006cfff81ac01549fca1b4939b3a2b5dfd412f53f79eebf26150e9a7c6d2dc79a53e586615ea1ec03955abb5c834ad2d2199c64fad335ac863a276ffc85cdf5cb528708245fdb597fb4f0793fa6a33401621d2ab4acfe92db08146727c536e1e0ec1ab9e6d357cfe0d745102a7d0cc0ce0ff53da65fda707c225fe504008947b2150586c324cf71dfc6bc9d3fd9aad5d345317cbffff98d955fa9aa9bde49caa950fb736f00dc9aa38295a1b3c1ab04479cd2fef90c8db92f72ca5878e23107cb0767abd303e8c1bda35bcde348f517cd104fa6547bfcbffb3c75a4e8134baf3c1b58f573140b970aacf654cda306807b065da9ed38e630c3abd83b76aa66f58e9f7c59756ed676b4d2f26494f5a3a9a52baf54b1df388667189af5f823d653d6b123dbaa3d8ed2a25a5c0be41d3be5e2ee808fedc96f06777cdbfa87199026c337d4d825d77b4a0de8015a58990aba915ae8d8e4c4574ee78380641424cfa53d5ea19b0dfdda9cff24212c6713ccf7068e5c42a5520ebdcaa204597f3dba662b2653c207df13cfb3b522be508f3e14f969515e182cba30f6bd53355f96efeb3eecf68443a740140e9b0da9449e4657a113c482a356da3255b51188af31190ebfb9371b986361bfd823a89d90c59e5d57860b2e8d0ca5c25d29613a5cc81c7795c7b43ed4caf01bb90605a272618f9945bf0b950f4651dfbb6a570081b809567ab5a5690ee3ef0ea44ce327d79e0cc6885fced88ab9c7dcf19e290d454bea0d4c9a9e2a92925531e6a6e46a24c792658b9b9266f405dc3175259c80c75e6a08247b158a74a080130b17816f0221bca1f74af78308eccfd21f24c57b062962aa45762fc884a70ed97bc16723ee260aacb429366b3554da23d9787ae08e8e7fd6bbcf0c165d5754e6e55e2069279e536a335f1382e0d1a7e054be31f2490a6a28216e8a1d19689eae3d9256c79f4658f74fb25b63893bea261647205dedcb9311552fc1dd7a8ceddc9521831495bb1b4e9a8de3ae3ffe2aed6b4572b51b23bf6ce8d01b4aee4a36b80216f1d0a8ad724c375a15c22fe0df548ad4211f2ae02d8d72a09859755e1786c1bc5c1c4a6f5ca4b8baf67d9ad1f155f8dc2a62abab1c51a29ba92d8b0409d2eb353d815768d7bfd98758c7e7fe83b0eaccdf5ae56b311f1580b273d747d58cee8a75df4776223a64faf3c30586df64df89e8b74300625a48eaf19ba57ee24aa13f4d2dbe0eb69c9cd5b047f4713cdf72b3cd0b36e142b317b21f482b7282ede2fcee8496ef72b789b43809bb3dbcdd88b408d42dfb68567193ebce8d456c1aa3844fba6f815eb34a630b2fb439ee0a57a2dee1f61664d2cbccff7ce5eed45b4120de4a16a8fd270b28518f0b41a568c92b2e02d40961c11347b303a2849640c9efe365c13f6718e3b4df58fcf4495c63e21e6c5c957d969e0b812e9b9a699ec5d849f4c9e1b04a3054c534c5dd36769755869bf27876ff419b55023b61fa009f431b88ba26951962e21687ce72a8fea9d51e9767a3d5c5e489c60d85d7f0a34c66a1b6152a6a26afa9021b9e52a10e9861178ae7d540f8940e8f33a513ce4916b138c9bf080f85409004bc7572659bf1c2936178cba507dc1d7417cbd16c11b671522bbbda5de5d48161328496c5634c51aa6bfc6dc1c2434dec94c90141e5e54dbb27d7f7a920e3f07267a9e4a66aa44b09aa823f574e7a3ad8e35c4db0008eb50b386fb8283e6f0a1a6ac09509224244574e8657b9c0064ea9401cd59c3cd901e59b578775d06525955c29cac93cf760a914b55f447826463fe5731b0a6865d1c59a9928f7d2b079b3e8b44cad6cd762f51887eb8b824788cf1a83421af13bfd3d7cead790a364fe64d345f7a58f0b95669df24734fdc4711d214844915f9f30f2bce2dbec0b1f52b435eff2f0a5c79592953fca905da1ad208f535e1e4079597bae95157ea169ddb75bad9990363e68403404dd0539c6472ebd82dcd6495518e3e97b1823ea6b31118b77740a5e0fe62754d2c4add09fcab1069cc091603a4c57d75e6a7d31d9752b3724ad66f7befe07222b36acced8905b38e2c1ea34c4e6d26a977b9154ab4869a663c83ba1913d90cd32615838a896cd6164017590a10567f2fc215fefd15889ef7d6c362c9adf3693bae0f7f8da1c55e6ce98b10cfeed1c9a9154909b9e2b0f4d4c2a12504ee8e6ede015783203c5ae41acc26ad9ac9c0ee5155f6cbd5ed0ae575cc5191084375cd4f2b3fcbe8e9e906295f743d407ad1a5b2770550f86ea0d95368c2780c023a32b147faa56d5c128dce35f07dc674dcdf096f150e9e8cb27c06e39cc8d74b51ed37a6b69f5002ae5cb0c56d16fdd960f131c2d0aa23b0cf9483bed980fa5e42b5f464d0bcb28d96f2b72a7b13b161c10627cf9940f763a12d19e92fa84c8668aacdec44d5e03375a1f1090e0a02e80c6680a9dedad5ce64c7e272524f8ea50b2776b0297e5a9cc34d7958573383a1467e74cfc6124cceb228fc3c0ce2c0928ffd9968d3f339fa0b2b49437ab1cbb6e87b643bbf557ef6d7b9bb60991e3732b7c2002ed027b4c7a666c26e364be4a59adedf17a2a7166eb20f59b30b2b273d6bfd31ad40ba1991d4606ce613ab5a7a3e5b15cadde77ac1ae2b90751a5c55ef68bb8076a144f4fb6196b259f8000a77aa4eec41fc146a33a8457c1dc35cd7105e3a725d519cd96e3c401cfc3a1cc3dbcb0df8aaf5e74e4ba4d836945d5edb37f25d816c4de4d997d516e638a2db528109ab85b28cd9e9aa880b13735b399e41a46c564ce0fcb3dec4e3f6381bb1857a3da579ec86a72ce7cc3dfeca00a98a55d5fd6ab670c3cffc91a62a2c35f684074d98275e5a556d0ac4742f48bf25d3f25ffa863098e16b3884fdc2038db627d010025bc5bce5a7449369aabfbe8d62984dc134b202528955c996462828365ff1dbd33d755779b27e75e98aa4c72bba60944eef8f77758e6d797ad20883049201e6554fe16c24e145656266e3d0f9eeb30cb394d12258969bf0be87448bd105d5785efd0a13a4a6567f8554e55b3c50b5d0f44c5f6a9cbeffb54c7a86238d44a24e6a6b20ef9ea5508460bfbfd01dbc7b3bdcef2d35eb070bbbc7ca5497d80445ba02a48aeffc5689c300e4c457860b2e8b4dbfec12a10b55795bf1b5c5244c280b4f6ab9c1a42b0a49faa6ec8de543c98a1884009859755e182cb68fa8bb426cf9a79e66f3ffe210026100000fefffafe400097dae0751619491fbd35be7e4eb260747c68a9b71557eb19a2d5d2a9ed2c0f1382c0165c97b917a439d0b6bffecc089051896b6861a78b943c6d9918d8ef51b291c8386c391658b0a7c7456b576256d7386cc5c50aa94af0b3c5ecfe2549d972959edf977bfb8a13c6d63b78b2c1a2b6e000278226d4030348835f928a3a43cfdc8dba1c0f264a75eb9d57ff075c94f9f0af3241cba883e734a993e58ace4e718c3e0918752f6f457ae4d128ccf436d84b38754ea1c6d0444bcf64fb7929426e8337b28d9fd9b7ebc3c7af0f9f69fcca88e3f3d2902eabd4c5da8f282c110374113f7063735147d8b6dd0a6d6ce5af8c439716383874ba5b13636bd6e5e8f4a957221570bd0eada0d1072743dd0ed8e0cbe1faff7b3d6f4228aa5e1ef665eaf48a13a2898047287363cc10aa720130d9ef76e0da90445f26a407b7f05842542b8f45ae372efd9a8b8352c6ef61ab5684614be4c6fbfebc6045d428a333704d6e75c5999dbbf5a4f8ec470eda2388b57e77cf0a94a1990916b046afa06af160c3d508619d30137c3bb97fd4a85c14e34f13e8806e91286a3acc5f67c95ad2dbb501d484114ddee0e72683dee43700c5349542a0bdb1a2b89d18856d00985baae836e0fe7b536f4cfe929f0fe826997b93b25c9c6153bda1eb55de1227aeebeba6c77a83dda49453f032de04656573ce1e1352ce3ba554abd9d75a8cdadc5733fe741bf28e2e6d8bc29c01d190bb83a9cd53b782b20fe0de7fafe9ce4f178c4a4ef82368af77b1d9944fb023bc10f946434df925a48020a14090c55fda914d7ecfdd2fe51ba69d30a0b69410f0a5000003951c5b7e7910f78ed7a5d7869ddf1bbd710b6a3986317a9a9527e6b96fd0e7e9988be79fd726760583545882898f321960981fbccae891ba01b68661612238c137976b544998b275bf97f7e2fc4153485aaf121976375ce4018a8f9f779312a10941dc246042cb2c7518cd1fc18a96bba39d8242ec923cad47232f8f29cb6081663db336a3438d61c373e907ac4b6d18ef1317eda67d727265db524dbb301c75161dca9e7f09b77892ee8fe824ec1130bcaf48d601e9b883b1cb430c90f1eb282131576679f866a823bfa34dc95ee5e371eb8144e9652da640551dd8536bd261e6fcd52528c079096ef78c595e30aa65293e2e2556adab323c660b1368916128b99e5c28f654894d90c991cda77b749317d0dde470a34bce9315668a01a0b12b543816130c0e21af9960bbd8184189661c8f9f908c99555572b2810a3c98224060a457f1fc3916010273698da65a0485fd0ef7a119af4f8778d918e235726f5c6930b894e0aecb12c87478bfdf9747f2fc95890a387b503e9b8236ba9ace4f24636620f59a615161ee036e427cb3413f98f7841c6af640cbda3fd165319a6e4f578e810b4be5297744b578f8206601703ee156abbbbc50d2c7e9560b3b21bc50e3a47120a5ed8d064b966ba5438c16d23686a196721620ee8ff7abd7e53261a04c3bb9b9c8fd5071fca43740d18f9bcae823b2b4efb62833251a38cd5e9627896415882f8081e0f48cd2429f00e6822298e8d6284884ec7567b828128afc000bf6a40897ad8d9b371c2626ef41c433fb64ad164a3942b434dc169b48ebfc54a2fdedc2d4afb5ed4877e1f8f328c59d1888dfc49dd7ab45bb2986947d2a3143acbdfa5e3f0d1aae390a7259e10a017d91a6932c31d2b6c0b6b472b7cadf1f732a6ee46521c1f424c7b8195b565e6861b1a7259a87c2690604db4a28243de59f04e9777a59f91116c1d158fe77d0c7ba0dad03311e7a6257162ef49cb488b6aa5401d9d8537fbd8540c0cdf4f105284d37d0755978f54e97aba6225855ad548ab792ec000ca255b7cbd2792ba5fddb0ff055a595af3961ce8d5746aec414d9044270f4cca7c77b2c3238d59e5a2c3abb62eb14a81847ac3e9b07382316cde1ea325819ee6e85c1ea72a5d82ff5c4cca0ae283471048d16f6f784f3ff8ca853db1d5db10682f7c531f62e169087dcc410466e5d56d8b45c679230f11fbcfcb8ff1a91caf367c7f82a54fc84b431d3bc239f4c4955c0c40e139e0747494dd00f876023c570ef2da38d8445cbd0487ae226a388e012d3ed62a1d89691ec57776baab5f62722955f5a1fa2787d660df23626d8dd239999c32f95e5f995fc0fc8c436d5b55e27533667347d987a6826097f9772b3b9fc1de5c50cf2999994fb689679a938cd3d8b61d06f53fe6a92575e09188fc554b9e2bf987ba81b6ca107043c083fd1381803eab8c62977cd3c456019c9e17bc5dc620456f996303a1d7ebfd67ddcaf36154f6eee8d744a5f8b1f378bc2d19ae27983b958238e5be45564329b45e89ea56e2620dc1cedeb3b12b7780d8f45ca3c87641edab00d84c3ebcffb78bc11cbdbfc4ea9a5f83368a600e278685bb23d7fe3d604879b8e79c5c9f25c5498a647320932ea92f0d054edad3e3630ec4aa8ce99e21644e018087b6764f5042f002ade4f16363357e051235a9a62256c72595a7bb3d64869920ec6fd2b29e364c9393c1b40a676001d99067cc2da3a0c0002b9c062a582d03cc2548289ae2a777924f547aadff8dc2ef99903fdc2049aa8236dc0b2261fd8eec53c79394647ffff4e57b46776f8b71b5ffd8fe83f638c2fa74742991df154ee2804474a03b66544f726b8225b2d5738cfc6e64305a1a3469fc4d2508c6b38d8046bde150c37219bbe3623ce7f5ee28d9bc43d14b627d224d772c584e9b96d47db08b7824106a9e0ac278ca9c6a238e188d57dfa28b4716ffe7744e8a2972b5de5e736770b21ba725f40c1dd1edac294e40ef30258aaf2382723f6bc1d2fd47b78c2f88cf0a3a92634be324d882e329a0c158e2ed44d6f66e139ef43fb21a6288e635732a9d76a2c0c6487cad30a544b233e6f67b19d0e78c48481c5b434cf7242592b624b9b49a65b8e15c585e117b3c49a0c639d16dcba8bdcc1a4f64125f6566918938f05942a5783bfe023b6082b14ccd4d16a3af8ace2ed17e5ebb30e8f164954d6af3b7594a14d37209a6373c8b369a8b6cfc356d01e6d0421ce3f1d1b5aa6b5d2a70cf7a4cdcc930f73397d7a96af8ee0d4beca0c546c76b45394949c59f61a0e8fd74528c2cefb8893c4097a2dae003868463e1ba66f1fde20b97956330243d0d3b98b24190c13444f2230e301573c8ee9543ef798ad3ab018d30638aa0bef7cfc09fd90dc90eda0384dfe2beed4fd4add56a481c36a249abe6f30e3c9535fe4eb05dacdbd9971a66be946de01a9a298645e0e246b1644f5d53232f4a96ecacd42d782ec4307d3ee4caae3bc10b3213119b5a9de0d6158eb6aa9e65ac3ce6e054d74100077b7c94874114f803fe8685ac19ce6a3f73a5e73e3f6f1e30a7e1220887536cb3c29f7c688af050a01b1caaf106199096433845ed6b216e5f0a277a3e5004fc53f3524c855fca2275f14cf58f5ba84ab004c6a51d4f64ab17c08bcf992612a0a3650846ccefb36556f0ec0810c6af5850b55909efd4460c92800416f3cd5cc8971467e8001ec86e7b32db353748f3e6017a10882433916cd5d7e6f483f2808a3268ac6b951e2b1c325b9c51330871c11674a348c8c8238735be4354fcd06006463dc13f1866b5c85b33fc8215a8a6fd3c321640a966f4019fd28b87cf24075dcc5b6cc1d880ac58f71efc010005c3fcd370285b756c6601aefd88944aa530dfe8050d89b1de7270a96cf09f9db32ebd74da6e4f5bb9a601ef6098959f2f9493c2da23fd440c5bef6e000059366d1eb1dd1d193335298f033e8b758cb02260feeb5a742d243c371808e22f55536113408f57ed0db46d6ef484fb69502cb3b1215ca27099117bea237e7176a87a685084ab3c01659f9a5094405fa3c6e499691085d09ba8ce2ee9f04451e0b639b21656670fd7cfb9c3191f48b33b0f1fdfa08d83f5e1bd3d32e2834932f7bda7e9a683e193670801b031dfa816ce0dd0a8b564f56557240b2fa59e987aeabd0de99370e9cdee94e44458df4105e060d6c8bb21135dccd2761a96eaccad2f01307f5ca0befdcabed578024654a6f3af1ea22c5bda00df7a2fd6722bf5860d486641384f4ede7f41cb3a7062338565e8a2dd3492d2ad09366308d75eb153802ef5611c5bf80dc7c701df202bf44d68bcf445399ede5a06c1d23b246c4d62c9b33f85cf7a12358b629751e070d4181d94ea6424b2df87697f3db7dc7f34249cf3e59165ee76252d5e8173da0399df998fd43a585ee30a30427fffe058e50fab81ecdace0e65b81fec7ac472ff4fc193601ae1ed990465f0e10678f929712e19b0a3d74b34350714fb631ead100ef2a6c61df141206e3388f2fc9731fbf8ccff31a66daf43868ab7a5306d7430a3755f53b16997f4812901c54b6cf1de1c09f3bab4ccba0df9b596c447f86fe1a7fb198e261056661d000aa3c5ed3bed87463cdff92cecbc7d32681ebd037cb5fe99c124313ce18ca8e84a57a2c572dddf4dde224599cf9dbe70fd7fad579a53ed8f76da4825bc0036fb10446072e06e1cde66677748c04c4a6b6541cd86cbb88abbf3d81f8285fcebe0bc90f3f9fad02938cc3ca8abe5c3c9bb91ddd0f5e1fd80906550a6a5b90750152b8fc0c47366ed0110fbef8cf0ff49924f66ca6397abfe35337f2c45022ece5ae157e1e05fd14c60d58226b20fff232e0b21a8398bf88dafa14696ddf3ac6db53c7135ad70976b9bb371c1bb8fc29cf31185dbf2dfdad69f408250091c7aa13b7cc1aa6041d429a0e277d51b003a4acb89bc232bcf22d7b00657e529ee6fb8a5be6a0810ee0f381424f72923e6dea8a88bf5f13b7dc0261b6c1425d8651f6b8aad8391edb8e9ff3b2bc5908f0b0f2d2bf0693cbfea2764af090ffb772ec3a599b84abdd6b38ee7b86949fd0fcff90a48683ff913d71a7e9210e99071bbc64aa6b7a7b46728998f42e45f13a994990caf45ac453a10d6e28d14d09b2c3b0dbd8b52ffb150b85fe44d4f846d34c5aeb0fbefb88861e0e753f04f70ca84f4dea2c018ce330e06b88a00984bd4f7ad5970939d7282b0040aad692927027d83495e58442fac5d10d0e0815d72634ffacb676eadc7e2c83a7b005f51d94ee9a8a455de86c38ecc4a82ea93ad26c2099961dae1577e522d2c1acda2a39a4a8f9f67944465f6a9efdf52688074867c3021d401b29f2657163b8f87ed36f16804071eb17772d425f600000009524d1044e5df287c327163697dcd3d968db1a1696fbf7e56f8948f458a1c6ea5af6793505709f205d5cbba966145f929bd6c644882bb50c57d45190ce8c1a0470a511077d5782cebd1a23c7f44708047b7164a11fabdffe996cac2d289169b443857ac9da9358b82248ecf1856165734459daa40b0456802bf4012e684a045f9d90d357dc05ee668204b60b8167e54f352cfa22e38b20a2572ac38afcd02e2110e9c0819af9c2b35974207cab2b3b6ee207191006a89098f6749cbf8b5507254d4ad420e955947285bc129a96e91e8d5e639999143d1e0af5a37e9b8106a16e788f6d8cdceedc7f0e56a55daec7d5361303fba58ac19680e975fcb65d7e6362fb9e83958dd5b5ef4c5ac25f233c0c5a9d06d6fba18931f23fe1b47768e18fdeba09c3023923d9c25d4919936cedbd77a6214c147ab9516b2fbf7e36f40d6369bb366def1d2b867d6094af59d065b59e1dc3823a7a77aa41616923d3b7e5b98d1cbba31403dba1fc3e6e4f54f8c7d60820393fbe5c3a9745387a268d673aac3fe79d2325721a06f022e5be62561cbbfd6402ade0a06aec342b87903d60b9aaa200275b74e5aec5305aa43af5193279ab8e87c73c54dc7ffa6a9e24283e6e3cfac7dcc7e64000117238aee76b73878b622db2dfbda27062da7a3b48bba31052a025fc65672427c95116e63d3117964224e0dbffb574a09d5c26e1b84621fd0eb3b80f8c43f37dd968e21ed52ea4cc66be0ec790986e9a1f952b17c861e4af9ba7ffce22cf455fbe989222c9498d70040392003bfdd63361eab1f19a58e5ffa085a5e7887e66b6a59f8e895cd640cf155a6f05fc24d32a8e1cbfafca3ec4aa8ba542c6d6cdf186cf08f0f790d8509d38da86d9efffdfeb64d0eba7bc3c6548c096f5b6ddc57594fe1074d6149688fa1081ccfd1fc31459452a2ee79d4fb037b625a08bb3166b0da57396a24472cbb16de9e85e754d43d002074e80d961b4467625f8a25351baee1b625d739adbeab621fac0a6dcfbd3177b2819d0588b6aac38a0831b86647734e108629787be17c8d7b5c8f72ec7948e086d610274cfc818904a1029fcfc76341f146053cd22e6a3cc72ab1527644aca4776b7eb4cd0ad561ec3ce73e0024a391b3ab7f03e700741e25b0e1e04da81b4ffd84933eb22533a5903934b30db64b027259838fea2fbafb8b18ea56694fcecc380e9ccb0c1bbd57bfaad53542575707c134e973273baa34a571f30074984250b9c4d05c691897307ccbdb4cb09523e000d282d23b8d87a56dbd748deefd76d997103cf578e5b807b5b76feaf76da58e10d9b4687ef3d1d45576d9f4529c72c3eb853979ef5b34083a976737ec6a2c2547a4595e617f725151d8e8ad2325642dd40d3ee50009fa61b943210999bffb9e02648f16b65782d7ab09f29a32effd71f05e56170cbb8090d0242f2ec4fff3788d82549e6accd315413daa3d4bf84fcddb93a6274caa2e74b7a7cd4ac8d44252756fb7671b561842784774990e001480ce3eed7ee49cfb246885d06e76eff67b66378830651f13eeebfd2e084f589080934de56f3cdceeae8bb3f8031960faef091658c65c243ea48069483a33d8b184aee77341fb46b2fd6b603bf20ab46a1f19f14762bac2f43675b6128fde7cb22ceab048e02a0eef20d7122374774fa76a59f23a3c396ca3b34187df701bcbb7f081fa80cd4278a0f2bee592479e32e45ecc463e03c731f51a3bdc8e8fde18fd8a784aa696e30fe6775229251a16649d9cb39c10d8d9160a2a9b3997a5d681fa9fbb931e1af5c6e09322b7dc32b9df0e5da36cb692dcfa6ed1f74a4ac5721e23f1571fe8d31846434e0facb87e1a064c97e187040689a7627e3a27db8d44d8620127a400012b41db367f6ef78e07d7b70e16a3f34d23d063773c891a1e5001a848a0ee913afdd6a0cdec30098487901677f36dbc8264e8d98b4390f982225cd145324685c02dd4fb4ba83db055725c7f1bfd0964fff68e98bcdc27f19b9a1b9aa4603cc966da5323f565b7a4e64849940fe7964ceb903cfd03a52cdb12cc97d9d4d934a54464a7a7e6c7592c877b59c545dd6766b32a5f9e7e3d1b1710d86bf2314acc316377a0552aa175a521df0fcdc4c267ff5f641580b50a9f5c0b52c6f19827f1e23704545650d796622f554f1713340b6b24aae249b4fed48c46e7a232d841f5278a652a4feca3b4e32af7cff2f9d943deefcd0be268f569b61704f39499621c6e2f4bf888885210f92528013b8dfbe476aca374e4290ab087b262fe1025dc614d326ea2636f4205d5122dbf68b0d7e64b6660edc3bbf52eb003cea8e947a94ac50e7445851d1a10c0953c89afe9f802a71cebba19ca268ee3a40b734e0f4891bb6ddd133d2eaf536bec6818ce4727bac965593a2f03e669e5d073d47c78def5d9fb175be0ef30f1e389fbc7dd8a33ef64471c78c4aa538d84fd9cbfa6f931f15a942541e3cc41378d7ae2766fdca69b581f90d55c39aa813a79412827d17708ae0c817233a80bf5d8726cf9f2db5f428a24ff0c296400209d11da73f28e29600acde9f88e2b295bc60c2c61cc96e196289659bd8e3d1c90e8a037d4c51dc447146b4e144a18b6be02b95c77ab54c83db6f52cc82855dd4253fa2d3c3fa9855ee27f4f8f6bca4257df71d65b674cd3264a1c011eaf8ec1c4e1f9cf7d83a09ddbfce118020342399e5318f4dc1019219b412dc398f3e960d57c5f9ba6ca033495fe2c4db0417abf528e8cb56d881e524fa2a98bce4031295ebb844b1ba7ee980da8bbecf45eafcf78b331c25354ac1814c0a81d06b9579ff8ce8f8a386162b3941dcb39adadf314b1f62d4d255bebcf0ead6ac71138d72f3320f47c6348dc381960a1276fa536e6e69acd1abe1651be06656d94a404c868d9e0ac9525b72dfc892bfc0ec3bf28b7bdd686cff8eb89389f0f2c055f6c2cc4d39c79c8154ec084b87547015822e7dbf5226df6643cf7d53d4753f0e22ee5ead0d59c9ed709b7ddfbb4d9b51ac0d1bdf761d2cde70f031aa9318ede11044769b2cc7e407cfc652c7c0a578bee1faac896230faadd0b63c8af6b0a7d3228df3cf24dddc0731de7432d1b1f6ca73cd5ba814d807167af256d6f872a496958303464fff34dbd5f6f714b123fd055cebb54d231e8ef46cefa863b7f35b3e42a0c185a8ad5807f74085c821ecfe4464d4e33ce1fbc5fb80000000b2032e8ffa37234d69d6d9b7fff9960e937cf03861b58c3c389c0b7784e8832427ab7f243c727e3fadf0fd7127958bc6bcca5f06fac91ed5945513884f0f7a5f3dfcfbdf7cd4101f546fd50709b38ab6caa07e9ad590a447beef43a335bd2e60e4ca5d7624e37dd8c7ce9cb87039d5fc082d3d8bd892ed4cddf047cf2d68d1a7c188a680bc6c7b03d79c72d14b0bb9c67641c5afc06141157ceb5837be472a5cc242eb32b3bd6d915810d4681257a29c744d965117302f74651aa93b464851e38b005d65d814b434c441fe8d97cb2ad4c9d8df7e2b206b9fefa06a8de4b78b3296b7ca89091b1f225b6ebc52fd648ed4289e80f9a4ba4fe2da5b049519e6a097b8f0e0f4c6d37adbb122e8b237fa1d0bb7c72f8ba586e437747dcaf88eaf2ee1c5c3baef1d8d79f2c65a2c375fda8aa36d12c8dfee7a6c0238e6622fe12d6820f420a2bf9acb2d5a5a78ce4e3a6516058af4406be7712a9f6a068721741700750916ed2cf3e6378b19655c84d2dc68de73b7aec2d1cae8a318a93b8842deb28bc4cbed28adf9db4bbc5d867759e529f5526064b0ccb75856daa2a991580364ccb6b62b8d6b2864a42048c870f877d88b0d4b8e6e89b7a08a8b8c06c18128b6198eeb9b42407cd7c43c4bf5dc20a254f6f898cb0d5e7f4a254514a67cb0727912b0ab9576307272b8b53dbe317a2612cf5f76515cccc811af00483674beec0ab2e064469f2ee9fe218885b9988ae7f016c26f7faa1279156c1b647000006c124e70eb8a0d6fc8a6b1389864ab683cd01f85a33c1460f77d46eb488cb1ace7599b0bfbb31f9926dd543eb56778cba92145732e7262f3eba9b1ce1e9c852132498c8877cfa2f23a9573c7080211c77f7f66d284879b88773949f5bd6c40fe0e17711034086fdce0af46b7e5be141e7bdb43e101faa09ba8275be69a40ab7924a4f1f4fd6f89c16a65455ce9f2627bcf93c74564d2de8305ec2f8271f098255e475cd5c14a69e381e840ace3456c5fa0c816963c6d607eea0da6de520ea941e3b0bd5a83c0b505331c9907e2a2b6bba782ac8bcd7bc1cc358ad891eb962f4518f9262a72fad7ab41599a1611a94a47fd75996157a638a4d11cdc4b6ea3c7e9a619d7d428e270dc9bfed78af7aafd014694d74f6811ad280f9d7ba21c1b5428bbb1f3284868438dc03b1b05c11314639c437a66c691703449fff7c255a0a0780a41ffbaddf7ffbf292cadff36044524eb2ba0442419ab01efd64d12e93a728eb62472bfda6576695af94b44fccfdfcd7513895434f2881e58ea378204a06bb4a9a3e23af514f05b15701e0ee1e168778b413c5a92dd5698f26ad765c1902573536e56e8d4079077cc22e97c9db675e91885613789db0a48e941513678639ce7bda4c2200dc603c534c91a5dfb00b4c0ef93d68c396628e51582c5859db265facf603ba3f5b5f5d61f72f717857b754ae112e032372f58fa5f8089fbec626eb34256478f117a0baf7383c9d9717a1f011a4626a11913755ad4f5c6776cb10b3470579415d43b0496658a3ca2965ce2a9326eb33acda2f7140a5c82a25c65e19b15f3b1e87e20d9157db411f4547e7e35698239d6cf77e79fe76c7213c7d0e003f5faba64274fefc810badc4b6a90900545a7f25c90a1d3d3b13e5e4e93b065e90e709376d382cab14a95270d016c03de3651abc813e912aae6f2482019bfc063a50b0d9154276683a2fc48e710b9d0b0a4788d9aedf186f360599ea864cc7f2803f41d8573f611475ffd4039ed5af5db665e7d67d68b343d94507fe16d8c131a95a0b1b1bd74a0e7a9754797ebdb3285366e1d48e0b9286cd779f464309969868d8d9955bd3a969d88f0daca7beee5578128be2fec83aab593a5c3423d04fb7480bbe2ae8e65cbc085b7b3984718f7633d352dfc57713fbab190123900353b6c2363f8664d3fdd6e7f9fd1fe711e587792ffe8de2f5bc37243739ba7ca22aefae4319d60934fcabe3f0fed1419ab7aff74f42aed8829e915405f5d62893f1b060b8084444d228f931e65749651a1ad5ac83ca83078799eade47d9cee2f14a48a6f7439c46a3f789b04991ec2711d8580ebc3a03b729e5c7314b7b60f08c1ef4721e46f527744e077acd20f54990e8942b228fe530e1d9105b388cbce3cc34972a47583012e5b561b62b5a9ae3a17593afa119e093f537de96d58d1752609b9d4f4a2b895291ebf16242acf197a85e2692a3f56fc00daebf5ba1ca7ad7330f4c6910dbeab3cc89ec5fc85959b987f958b518b389d345919b94cc1994ce4f9c28953dc41aab9a1c8f963f2cab8b41e036b003fc95f647c7f2140ff016d6b3d0e2abbab6b21f78ff0eef14e432c19cfdab0601572d5017ff4a71b7af8744367929be90424da51e0b069f84349256c7564f6af77d7ab33a1bc12999155138067ad38341e5723b68f0e3447926f4683d4948ff8e30be3e18c9368a31235cd484a67801095bb2498ee51303ae5ffdc1dcb32d364ff915df1fc44d01542e221a5c3aa81d106bdb0cb62b202d5bebae935bf08489f08ed394573d017c2172ddfe1b85894c1b7fb44d27c27632eb5206a9f2ffa17e56aaca8ae253c45283667832d6c8c1581461a165ad661ace2b1dcab5e6d86bf76e8ee8b463bc9162a30ceb4a6647094d0159c6b9a4f42e41c4ea2513edd3e10d8625b9361a8ef31c6fb915c175c1663295b44f5506d5745d7a50cabaa7a3635805c32f430de1b48e986a387b04475bcb8ddb719f93b384866e24b3aa45cbe392ea8f3f50c300727de002b957121e51b2de24d6a5f5d9231de957c6f35e5557a871170ee9ba72e6222dd5f1bf0f690c68fecf5c4e199dec2755f4c650122259b63a76de4c623f31418999b9e172ed9d62dcfe18ea8675cd072e66d571e463c0527f11f8e8899e5aa6292f097dd324fb7cba3eecd56c0f0a35ac7e672ff78c6be9dee9ffd9846c4f75ade40a50114d2b6df3a224ffb54376aa374be2536bd8d82d738c53a670d51b8e738beb5bca402d1805c52a3c50d84ffb672a9fa582fc3df9495437d6b1661dce166fdcd3d9ee4697d4c31e09fdf114456b68473101beffa3b3970e605e5fe057f419e6e3e4126ca925bc8c8d689dac7d912373120e560dd8d45bf60ad875acffc3e5e2d703eb7cc78a85cb292361ab33cb37bf695fef54908ff592aa66893158dd60d77d0d6a9f89b257b3be23c4d373fbd85f5808aededcbdecca06e73750efe1004699cc739e2f173328d5fb60f98af314e97817dfe65c1c327f0d29fd0466217668eba49346947fec088050e319aabfd375c9fc761dc592fe8b7282c35b16dbf95e399846eee798d9f8bbc570ffea92f5ec14843fe7307561a3a898da4fb76175e868b687b8df598cc133dba1eb873130a2931d5de775d7439610f13549c1eeb5823150e4342f3e718d18e61dbe0bc01ae1db5d49d64c5a420373b8141a175f705489c3964e6d5e63b0fb030b03b2535fefc325c3b1d8f4ac586f9c8d22cec27da7f705e0abfb2053e39eb0c42346a56b56e2e4c6dec0bab31be74b084809252767edb2924efd1d4ccce6b1fea22d9dfff2ccf3b09e722d14306101d9a11178b8cd1f36c51dad08c3e5ecbf9dfab25fb83c6457c1137db656d0ecfeb366d7cd0ea2e1164191d0b146f0ca729b6ebee1b9a0c89fdd7acd0c20bd0f90feb2f7429aa1c3ebe57ee7b5c860a5c09c7b4ebfa849e5b0ce86c78af97fc1219f734dc7f6a17d8c17fd1ed5556031e6d623e2732c3034eb1addcc81cdf10f7f338906d326b8ce5ea8fb54c84deebb0fa9d794cf0eb2b1490cd07c75eed0452d074cb4aba2cdbe5719a21a53879a748b54e6e7e71fce60b9ab42d153aec50ee3e992d0d3d4928cd18b3cd9026788273cfe2e7650e6bf2c95e473e1d8a3058f3f1a3ba5d76ca73a1dac3eb09274f76975d76d0f42f8760f7c2854b37d0141feb9ac9672b84e142e4537d7e64df1be9fdc185e4fc1309d1b4e8525779582acd28a452673e6d9795f810da6843a77cb16212434c5452bc1f2dff7aaffa8da249c1e4f331c4288c2193c3c77c61eba8ece2c84bc8d2d4619788c417576ff26403be7873107947279935a403b4f6b70d17714f660ec82e4d629486e176d1df67cde0738ff06c70ef7cb034063498cac6c174f611f696e576acbc07a81be43ef6cb5aecb341596b72c11e0c95344d62d6e30aa5d8a1a9fa8caca6a16da0d4313ee8b9980b0efbbb53fd6230fdda45e7b881675bb7522d3492c36cd888d770fe0570c2f7d8b22afd85e48b7dc1646300de022da28470ce62d657e77541f8068f1528a4fb78daa479b2e5d4a6f0988fd9ee10c776a5f7db7d84d9b516f5b6ce9cd4f74d3ef6e945ad63a06904009cb8593521304417eb8c8cc1c3396f9fed1ff255418f8023834bb1323257904c15a30a429b01ba8793045299ee027ab7acc8bcadb7c81b02c102db30fd6482bce88ea886d0c357ca02fe96d95513603aa7f97e7089302e719771d14563378cb0786ffc2728f88accc1ac0ba544aaf35612cdd663a928ffd44ac25a865046f196b43ae095ed916489e3e1e78e88751e32e57676f2d7461846f1d07fec6189d241a79ba58636ae629f758a55e11d5a726f2fa8ee4826c0154fa3e9c8eb548fbaf238e18a10bb174147b7afb5b49ab98fd7e645bd50b5fad45f306fccd2b1340f91a3b2b7aad9ef6d615cd917710dd94d59d7bb0149bcb5cc55f103e9626870a031d4f8d0d74312834a97baef9dcd17e95d006790569cc6566257410bec34529694572c480a97f025952b3daa07f8b78e57233739bd73d7aa43df177c3f4fe889af16260f9e8ee41eaaec03b876e09342b6add705be484861cf5e176f55ba7f0063c4f8519b6cc544bed5a86e4cb4faad2195e61fbeb99fcb3b78a7cf4656ae8801bf6f7778c15312455526745100422c801d6b0828c2f6535a5a1946fb29676c02b33bef6e5002fb53a27b2316d2d3a9f2a516b6f5f294035a1fe71249908734b566cf4a0aade4cc1ea0036e102be3bf8c254767b0293cd6c0e330b12a2a50ad47d973f33f04f1628dbb27f55e1840f338ddb9f7a7df816dd8f72bac15fc4be74c2fdc0ec92d3a021adb292386cbf124977e7c65389fbf74bfb945d1251eadb3cb53719dded54f757a1ece41ec0621e47bd15d05db93342d71a17207a7d7fd1d279d628769b4d7a39eea55d6e8ba1ea0b7f087dd8db5a578dab8f6c2b71803c8159fcce1c4a89d7ffc2e8f91a900ceb72d6ae35f5b622e5bbede7c8a2bf03a7daeb4966b41a61c84d09d61ffb3e39428f1b336f18489672c7bea1f13f05e4c7bdb60e21ffde65fccefe4044028a7d0e33e31329ae9fa5d10642dc5153e22bedc1381d1be16443b2b77840fb634f8727da22418730f0ebf9ffc604d36725c5959e34119a012e75501b2e7ed232efd3d14e1c57c264215502e5f87a955c79eb73b4e1b11af3a657268a47fed1c6dfdff98a9485d1d1c01752a836e87a3e6be12b7891670fccb0a0dbc71b884e7b5226766754594d9d5b9337f8b0ed1f846d07739a393819d7e35ec13c99ea9eeaec363911d3bc96bb37ef84faac7261fc566aa3ab710b41858f89721ffdd736c16037b552090a9cf49e327252fba50b70c653a880a80edee1d4839499d9268e2d39083f39ba9abfd95c043159deb0a3cb39f1c9a675306e6e170d78dd35e8dd3dc2b7ed6371ad3c2eb38b7f3790dfa5577837ef1acb33cf2be1368846300cdfd12a079a74de1aed2ebf7ae415744408b3997e4ac66b5c2eb0b8266b4423698e696f0b671b2542536e1def515a820eda36f480c9729ae82572c47bf3e8919649e28c1a38064ea6ead0b21110552cd5155233cfb5a6433444f22cb7da097928c8126920a4f33edf18d9582e56bf93322e4d0069902d903656eb339eb5c507fe6f94977e84c1b2ba5579d3b054150150c73ba870777473c400f241feb1323b91cfa5694e1327f4431195e728c22ed8bc1431ecd8cc498f684c74c0eca1303734143eae0c8c5d22697c672ac2b68dae60012792c7eaa7ab508ec84d99ea6032d1f9b17200215406040751883e547ffc5432bc80cac2bcf3c7a394cb6cf1584fd19f2928d8ad20e8ec8085cfedbae31aead69d37efa89d9b818d70a03f8cec13f09b5b8100a1e60fb87addd0e3753e3883634edf548521f002f4cb0f3c4a1b56872ea95d341c1a06c6d80d7f80ae93c012e86fc1c22e8a7a9906a5cef192085d048d1a7094a25389b3cfac2476c26bf073d164fcb187589fd52466b7c5b8db9c630c3f3edcd386a18b97c5651a7e9d95ff6f04ef917afa58656c4b9c5ad37225a115fa27cb0e356c3580c03dd760837eb5991e299fe788f799428bebd36d6521c82c2953279135129fbfabb0b7b4ba36d7aec0541731d115832965c1fa519f993c88548ca2062a1fcf3137f056d83f75e22a9bc7ccaa9c3f3363e99074aa5fb2502708090dc9dc969e80ad07e0320e9a134ba4137567b4f8a9b8eaca2f3778bc85e3db5f87046d36eb0b0f4e5468e71dd958e94133e9051a2d31f387124ad9193906023a09b12c80c5f67648238c4c4fad20bb1deb939e6672aa7420b47f496b3659197b2df9bcd749ca12b0bbc512ccf052d951e48a21f49dbf875cc2a50a478797286b6472e1931c0f50850212dc15d6b859d55a58781050258ab02bec89dfcec6a755cae41f241e587319b6c703dde920a2ebd9523a4321d6bebb053a39b7ac26bf6e3e2fd2411cfd66529c57a1a1eb44d1b46202e1ec5438fd925305b8d3c6deba21334cd90589484f89b8d44074f448d2cb8a90e2b3f0f2a3ed15fc60e36baa5cf7824465b904429a16813bf27511489431884c3c888f644f812d4bbbb79187a5e0e71b7cea0d115b40553deebaea685ead1d1e8b5d745008138c9cdcdb965f807fb38ce300a3731d55041cf7db707ff5394d037872d3260f6e2ebf274f45472c6040bc598411e647f6f4347b23b084d2819b9683027d98dfbcb2921d347275abaa01c062aefe4ea47e7cadfad481ae48e2b815af5ab2cbdb592010361878f2386d05507ac58677ded71cde1f812a07635e0732da8a4cf37f6ce3037aca89d87221b6baf3749de549f1f7d6acf181eccc98bfd503622228f312a9c848388a1f959e7dc8bc049b005d79bb6d54f82cfbc22473e00c25911fa1c076badb3c3053b4d82fae4608623dd2d7f3e6b6be7c9144fab4a67a0ba270febf004011bf154cb51e232ed7142d85673414854b553ddd2bfede0b73f2cd0efc1f74764ef878a2f5cbb570347be039c8322efb8d3c6598d6342685cdcf97f36b1c512a9508a9065eb0b5f74a9460cb7314621d4dd408acdefbf5025abec412d7bce35553e86e6f7ae20772a3de22f6e51bd77776658242f006b8715df3a73dfb6a8910832352f547486dae6cd00b771eb3f7a9c1cd8b2ebceb9c1a2b7b1cd79032a525f9b6d5fa32eccc7bd9c0f5a73de8a3a4c6a348f2c190f366be9abc8fcc121e93bd996d7d24d33153949b8758e959e5ed5188f54f32b3b524c2b9e0949e5ab44fbae0fdadbdbe0cc44be4453f0dd0dcff11c5d256a64bf9d6569132be437e6cc02ca495f062a1f66cb34109b8a077c0544477a87645d14b0a5bd03a89d3bda6ed3ca837716291aedd05754f672d97e4f6be2100ddec3c3c1bebcc53851aac1ad12beac01c24f81e48246d5113dcb9bfffa157acb25fa016bd9537917533088008a9126e98a075588e0c5bdd937c607ac44a069deb1d50c24bf0b26c0c5134564094b234d08c0b22a571d01ea2bad65fa2b6252b442142c9806b063bf90e872a842f53f5ca1532df8901a09b5e8f6ab4fb0580e078db46e35657f7f7ade410e993c852472ad8baec5ea9397b87be333f5c9352071cdce22307a0d4d2fd00c81460fe8110be8d8497d3d84d32637bef709b795557de41e8962181361542c108408ae5f19609fcc76b0884e4e10c005e40c6fe73e680d6599313e58529148b04f9b72197d2dd4f148c56081d095053f48812ec60bd7b1201250472397018c3fffcc7d3be4fa3d539867e3b75e7549337d0bd1e9efff01f6a7ab7f6fb2656e6d49fc62eac095eec0509a0286d7a3cd8bf349e6334bde7db1219e579ae5cec9164b49cf949f55b5a2bf1a873472322c4bb3f20bc2a5ab40f42f9f6b2f8dcd7db66146d4f5044a4a8d5dc28e0eef6cec36b96ac1b0ad9fd6295eeb1c781ba3d5dca7b8a48f9bd1ffb16caa53c0bde99ef5d69a79677e9fab725ad758966ac016f255475fc84beab1c5e53a7e6a3c863e40eff3785c00087628d9f8b7e0ad3a598fd5bd4629305ed3b4dff77b9d0103d7d66e2e67412b62004c8559d2e69b7650beda1ed76a98b02628dc013a1b2c674c18bb23102e72bea9aa1aff5d59a7a2423be98f1641bb9049373ded3cc61961af78627bc06a655f50ed2272d702d4761a300fff39badb352bbc7964d219ddcb556c282cdd93fe34f979a5175362686875164518cd8a63eafc8cb01607d8b90132b88d33d6bb115262bca4926c0534be92c310151bdea9eac9d70b5cc71e5df37d8a64859a4199ad5199ea599836ef4399e121711be7e123e406534234b0f0a782920b47b106823abdc4421661233eb2ffea1bcd66d97c01c217b398a6fbad5d0b6ae8aa16f978cffbcdb0bfcdbf8c9f1a98901e94fec509237ad6a5c13f12af93693f416d4a007e3ee484a73c917b8b5656d8e2650b4d82bfc19b6d66eb7dac2bff81195b58b7c6e129bc3ac0e836709f55ceab5186589d96f875b06e4ac60c370297d58a2964e71b57690f5f86649a8b9fe30749b614353630085698289008ae788ff978c3263a8d7fb13276575fada9f47fbb25e127bfd921928adbaf1b27427cae5d6235a78d976d787768c34849d72934c830b11cd252bb054e39bcd32cd6f88846c92f3460f3fb08415ac0ed6f4406211dca94ff502d10e0142fd95b891cb847e44fa6b26364f80e97cda2a560ad82daab889f8a57fff3d1fdf48e224c097f2c772f85d53b873d76094f9a4524b9058e0e1b75d04387e656bf495281afb40e9f4d2bbb610cf8747094c14b1e06d6a8a24a9a6cde09f942485ef9944535501ee412c462ea47cba9ca35a0a86fbb09db940b54c6658f279078239de275f709574e4e36b6fe947ff3be6bdf2125129ec248a6c83f82b0e9809d8e8367c873349b29993427513b9628903a8ff2ac48a72997296d050bd3d99e19a057cb0040a3f1e239ba01fd72e9ad4e0ab3cb9a8e6098d2d4a30de5ca822da1e25a401ce7d54841efcb44eb80d2a6dd61fd5294a320390f6857499dad9f9e0231358c57a0d16ca40e865d5f5bc31a58791c6d6e11b9118d008f84009cc79eadb317c2a4a275efc900f6ffa1cdcc9a7a6e7db89d7df86d22de0f06a978f07abbdfa2c874b6bd7d9fd40652db3769c5ed0fdb92fa13666e7fcf43154094607dc2a24547ae6734c195dd5f095d28c9633c988fca040d396cd30d8c4fbef6ffd5cfed389bc4c9712822ffd38d86fc9641eea8e105a3a8230b2f65402e11a58556eaeec3784f55d5287298ae2221f883a800b1047b02424c4051dddcbb0228b59382ae08c178a916f3d1ebcb8404246430bd815197b06a240883cf9f7a9d8a6050a0bded414d66af664f2cc3c2adac814c156476615667325f7609c3b3d013454465a1fb4704ee844c879726d786576f3d6277e03c54c4f49ddad32ca77dc2f71cbcd948e5cab42297f7674fc981486d5b4644c1f53fb3760f5a83a3c67c86b4f4fd91e92dea82a3f6ab659d6c7a6ff4f7d9a8ded6ed1261573008f37c6d40044e96acd3a4e5ee9043718983fb80e8859505f8801dd04ffc66b6067e631638eb50fc01cd7bbb3b969d251790089413dc4872ea2422793f206b909acca0c09400535856c0d2f8408dd82f2d02718f39bfaf149cdadddf2ae18781183c2299c79174dda4ee40b0097581f26dfd14f4749053c3815fe5c1fbc35b180535751943c021f473727157d617ad489dd6ef72f6fa6178610755c83042659ec7bab5219f878cb6ae14f1f95143d1f386a5130b030d77857a87521b6a38ca65f7cc1a58e99ac4023d83fd4242b8cb5354cd9df2bf65d9695e4ef09bd7b0eb2dde2056914fc679beb14e5762754a6b83d96fc428b583c046f77f3382fd8397fdee0dd134486f17a78d85ed816366024fcc8a2b658f045b4005b84eb901d9a98ce1f74664211d4626e44fd744960461264d9cce8b703a8b7c7162c57c4673993008aa0d5b91860e721b5683b81134aff1fb7f502aff09674044eb02a73d42a46533ef5bf7fe9c5b2e675fe5af3aa051c7f5e04ff93211a0b51768a855736ceb6d01ed40c56423a502d408a0f7455d3249c1b16a26417dd0a5359c730a2c6066cf59a479299d509e46f7f633fa7f56e8364f708ee9eb44e70a02b5362bd64ad701688c9c657b6a05cad0c2ff79caf7b4c7cea70be73611940e2c81018379ec23c493249a0f2dd0a0315f1a227353dd70c65a6296b8c8c983ef9eba41d1f673afcfdd7ad8fff95aa47f7b0425320db4304a7a9358686f7ab7999dbc7ff2c9dbce459523fe647c28e763aaa5597e6f95488a06659ad7202d68cdb6f2670a3d09dc64bae6db37093a541d99b0d3e3f5e428f7272e6ed40464ba00a943b520a502c3135ea0a344fd779ab6d913b51f518a61649feca8da94380c08e855609781c8afd613bc0d4cdcc03ea871c75dbbe40589a83dd0868a4cf414dcd62aa132108304a8267d95234448ba6ed7812cb26e073ce64cdc4a4d07c7ec8a2b7f06c263ce7781fd2a691e2e1da5cb7ff87627c5cbec234f3efccc98f5937d0170a123a64cacc9e7cc1cc7ce75aa19b1129fb9d85e07e5462013a714f1d73a7c08569ba4cc1d40013d978fb2f26f846348fde45b549747347c9033239a87f89e53875aaf20eb7bbdd76cb50af97d123f0b70a1c34df7cf573874b925173aa601bbea1dc7d8d27800727ff53e0de0b25e765e0219c7864ebf9bacf77c921b5d0b208df575b6779c9590d28e24b641e400899d886f9f3558683130bb11fab00cfbf8919acd332e55b05b8490179a11265050c87ce8ef2d1c7eb36c35133c4b15c08632db65f15ad41809c348200948e65cd640277dcabd5becb1a6f7cef590c4e9ed331914a2f3d22be494d1a0ec99405a07d97cd59154930f4855abdd83482799d64841ea3f5aee805eaa52262c93533d32ef98ae575b8def38d95e4b8950d41512e24258b3fba4ed69a337ee1129c3fc13ef9596646a97e06a878952ac3e22b2fc25b5b0073ebae366fcfc7f9ceec11c0d6ce1ffc6809530e1660a255450bfd6fb787a6b88f55b21fc8e4fb41466a6d6ec124a82f958aeec1dd2216eb452968f63107fff5b07bf7779705e89ed79b542d04f1b380c1c971ca435f8edd142ffc57c8e124235b115ca446a2580e2c93160d4d0482d11872b22b45efde933997dc8f8c5034bc33e30404e8d2d817fada5bd5b01839f0f0e9b5a5fc6c09542bf1ec4b5bef1dbbaba5883fc6fa657e48542691bd60cd6b0343014af9b4fe488082995c63b05b558674aac9a82fa0bb943e17c7ff6d1a271db32648f4fbf25ef263a48e2c5e75509f6d3f0839a9b2e6b92bd6f1f2b0cae33f2dbc31fceaa5e5d3629d8dc81bf0f34f0608e968c0ddc5796f5f9fecb807c1c794face3b65ec29634706c81e64eeb9e35978957f7d0afccaca13162f157d2d250daac1304deb9ae9ccc0507781f9e2e14247d6316860047fd56fdcf9e7a154d3dbbfd4027f8f4c00bac63ceb3306d330b592d4ac0ae6f17a3d44c5374ad4662259a1fd9df75fdda5eae67c64d3f229d9f44698a7de08e1e1b47a94c2bf366da5de63f9308f3b35072e08f8c39e375dccc85f43eae4b3f284d2c1ca0308aee9f7b85bb633a80cfad665074b4b5f9726adbcd55ec8fce226037a4005d39f374bb03fbfa74cbb07750346e7803480dd8dedcfd78c1639395e6694186f16beb2589c463dea14894ad68781258786ff180fcf57dc83cc57835f4c5cf5fdaca86495e51c9f7a704bd836f6537f1c2f8eda8409c2aaa8552519e45c0f07ccb124b03dacab4d956c561b5c2a53fedd1d3ef4b65c0ef65cfe037391af68b2bcfddc04411bbb69e707540d90c1bc00c0376ded932fc9d4355421277dc41c79f22561c4081dc0133dac49be07247106d4b76707b6b4ca76c0a52acc34e8252e36b17b1e800d4ddfcde7f2ec9a350b4fec7b6a4ccfb74f372dec059aabf6373a1ed47bc8c03f3ff9a6e25a7a13594a77b82425c6dd0b3d0cb5165e4cf85d5c369129982f25db752a0f0a6307a4cb2416430080619d194ba190c1de7890415ff3f5a942c4d7f0947efaa9bc9026a85fdfdb29c4eec209ef137d0c928d9482898e8b50d0f3dc7502cfafeec39ebcf42302f0fc54721c2626a72b3ec3336f86143211ad1c59abcedd257012812a993af6552215f72cfb9f138a837c7356bc519d21191518376ca034fa9818a049e65d48f10d157f37672ae70cc31b82404240e6b03b0dbc74b8a1d7f9dda7304a46b690147ea2ceceb6148818bb380ec62b977ce597b13a72ec202757389f1389a696c78e8e32aeab224cd774fc50a540437c28baf3dd11aaee6f6a9bbb1074963cf886ebf67c641436dada8104e0053e28d24515f387711164b3f18f9524de31edcfdd67dbed0434b985aea6f4b7b15596797c0090d5cc8e8d9bbb8617581807961a5199922afea41343598458aef91d8004e54ae5d603780c1e7604b779117081dc4eab03c7ae83f61c1aaa740e45a89a226b27761a0622f1bc2c5d70922f1ce064c03690dc42f0889f9524d8fce2140b58fa10aee255b5f552811883094855ca0df8de903d941ee6bb508a7c87decc7723d9435dd8aa24263e3565d7bdca603727b566d683770b794eb8069270d1e1c73dbed792c004ba4bd3fde410dfd9557fb0cfa3e31bae7cf4263fcbf9b9507679f8a9eaeb985f75091dd6d2d7f80cf1a15f62f327fcb67ac828835a6281229351e5fed99d3e5be7a163fcd510df0af00928eb0bfcb9c30aa913825b137cbc2675cd52ce614a9f368b8c9e8be7d9f5e1ecfe10fd4e306fda9b06f1a98d027c9bace16e44fde169ec714e8b63e447c03983e6b860a937082221a48520fc89cd0e3423b93d21deb0d89c82d024f01e29db4fd14e3c7d1d5d3eb33be22e7cbf5eef1db75e0e84321cce68316018953a9057729188372aca4830e107e5759e2d56b107c84c59ea65c69896f41484773376b85ccf7782ec40ffc4442b2043ad4f092557db47067f774947d85cacde4632f12b6f61ca50062fbfe8abef4e20ad0dec11d49d22f3c3b2cafeda4b8f44fd8dad80efcf0a9d4022b0b9a1d7d0919b1d9eccd7eb07dfb19793b23cc7923a3b22076b4671298291f8e4461c98e9de85f6655900c6a6d0dc958aff66133de9be871c242f9d24ce1fc267802aec0a579058f6c8fac0bd79b98204095f47ec2ed9d5f25671868b0095608878167f06dfb185faa75264390329ce95e3a6fcecc8a031acc5071474aaa3aef5aff1c89baccdcd7de64b395cf659efe13f2e9540367a55be0a1a14d53133d16193e5e9f842c22532dbc914e7b83b16b932fd13bb233620f2af893b5739f1fb7c551acebd5184ac8d3b49b4971bf14ce18fa16d401cf82c61e0240bab5f2730a0c16a5cdad3d430a3752e2de24c1b1a93257f2ae5ed7f5954d3e0b33e403a89eac72b7c206aad877a3aab52a2388f00af120f48af802c340d2d0a4e879350fa861b69e73dcfffdb6b67bb23e196bb63c48ec6e58e19b5922c4a589a7488e57d35ef0de3c91df28f8c77d2b54006e1c3d91f181f07feb93b63531aea0e740bdf1d50788e0134b714e0d8c3f89cb0fc4e3534e21104259c2c02b85615852ea64ae113223083fa3bec48a3fc66739ae1bc8dfb4d974ffa544be39fff73a7b8978d0194c8fbb95086a3091a939a3ddff84be289216e23d215307986c8d2742794737027a22ec4695569ea0d79f93c71e9ff0a671f4c28943469a78ba4957949cd4fe6d726a2597026e8c7fcd1a96f11ef89bdb6c0679a2871740479a0ac4c397c4799cae261bf362a7b0c3ce479391078bd5286fd362058c52c62c23c06895c3f475e08e44bd60ceb26120ac86e0d16560a450d5a915526d0182bd79073c4782d5d93bc5d021f4b5cadae579e71c0d99507107b52caa20b5d6c081f0d7d5ba566747e8908ffe86d00d5e3d9c38c4f84518b66a4ab105915b53a2d4f708efaa03c9b1030ad21fb2a074ff75e360fcb6d2c1a863107a3fb8fe1c4e4d2bd6a0e59bd13a6373ae0ce29cab191b61512de0e4a8322a5443817b01485500ccd2b8639fe101c636cd81aa6055cff627dfc79069102e45479e618e2205ab5c9639175a8212cb133932ef15a4ee39ca98186db02660a20899d3006928eb83f3d7c01a88fefcd69827e67147a6e313b293524dd2fe0cf81f4c6b985e77dc614bdd19027b82746707bd2a06bfb8a266eadfa9d1cbfa2b1295a1f4e976db3a5d32bf6b4cbfc13ee10c2db4f4f43a5ec3f2db3a0ed9f71b85be3dd1fd4f099ebe81754fd729705ed2182129820097a73e8b0074f54d1c852d0fe74f5395cf61c52dd7b8c83d422c2ea4f57c50bc521f2c576b084c9933ef38d1402bc931ff534d66ee87ae9bef1b09bf114b441d07664d9055c971cf8df28d2de5f09f16a37165796acb51100ae8d32741e96cfc451ded2bb655545847a05fbff8f5247264d6a1de970ea156e66c54803a9dc921247199579c3f5e89cd53d0374493b3527dab48224592979c348f694e43ed03d57048b2629257ba2738345af5c7a33b407f0f8d676ba7a07a113c80039789024f7170d2968da7e64a7924213287e65766f80a1d8dbd0c50ec6467ced6a7360f81b98389c85c35098cdf181a7b49612b2556d7c1bf446a12d1e30b7434fadef6c022e4ebf12e059c1b02e88a6170cb6e158c120a6e4a93c09dce17fad311af9df79443fdf39e79242d2d56331515bdda7099c0bd27691ad948873d2b6006c0b01fde7048142799adbfe2077b268c550c797261b3fd377a9382668cc01c67d2db82ea9f7b776aaa0703725f1e13d5484536253efece4c81b89ce9e4313a67ee59c89ed58988905cdeea992dc13151baa5eacf2ccab398c918331f56a9dd25ee8a281f7e92bd63ecd2bd33ffca60d6c10dc8b626b4b309e43da95e293133c3f353ca354c33900c932869102178aa8a3454663fd5bf38d3eda2d7893545015f7f1d0bbf96994f0f88687a6f01f97062fa0e38c8a7ca986fbe5708e46789fc0c6934693d611caf3dc8ee1c531a6608e558fb12856d5ed0b24cc9ee47dc745c74c34cc4e148171999a14756eabf35edf24feff80bdc3cf6759bc1c204a360729c8044e560a658656f812118dea1cb27e3a0952c921d900a3f6d50178fa5ff345aac440b1738c6ba8f703e8676a2ff9138bd9fe67f15b8220d3e719085b558ca9c4a0a930ea40389e0e10ff7689e7e78b4a86296024ad5bcda23c3c9fd3efd249fef2cdeec936583ecbbd283141ff2d56593e14c526741dc983dc383d7ed20cefad96039c101db552dacdfd4b82638000c79f3c3ccc7a2dcf9989d6d2667d2d0127b3e1a242acfc4b8874c26086567ffc15096db9437f68f535c2850a1de8fe174133706646f234bbbbf029907319e34b51f5bd46040041808a81abb95130e5b3f6ef556025a4455f1fc32a62fbb05a6299f3ba171bcd5df2d94676e70bd27d035a0cef78d0a668d7235687202c31b31a04f194b6843657f5898e6a9078aac3e296568278069228872074df90a66de5c5053770521ef27de0a22bccb1e1a461f038609ca77563a607e693c7be2cda562d9c04a671823869bfbbc87eab11f31529197930c6abcad61170fd402a46127808f95be421f91cee9bd8f4523e16db237946d1b56df18de7b9898999767e165bd2ce5fd78f94e9c46d0a1962e98c5121b8701950d52c30fc2f6e91f7e7e799a643fe5e4ea41c23109d593bf895d40a9c43c98a33c52178ef45c863d0d9f0e7bfbc0969120f4e361e4cb236fa1cfc6c73a5fbc3550473ce71b2f1f3e2b6ab20d5bbd9de37f810782700a04e1d1b5d178a828f7f8723dffc7dfbd7f15ffcd80dd01fcfb5ebfc00528be1d7ce6970eadac6c2c6378de46f14c0c90076abb2d1658e5a69b5bfed8ba11c9092e090f9ddb20a35c3cad8365748ed5bf67844e361e13e0df9da3ff888bd4a5bfe186fac43164177cda653ccc46835a3c1e13aea32e5777607294ad30467f38f895ebd99cd8b1508f12d9b7ebf8a308ff9fb9c608fe96b99c3dbb60d8a060b6f386de5e16202ed2c8ee2f5137abee5e20c1c633201e5dec6aa29cd209f2e873622d5711d8b35206a208eb393a2d7d3cad0e26f235dec9a7fd6a2a1c721298456b310b4b9586d941d0279d60fdab20dd528e4f1695a833976c342d84c6ba84103ed87cde05bac46b07fecf361e3fe476a8b2706c9c46ab5b70864ee8c32f043edd4eec00faf2f7b7cf4192383c45b416b328bb2e3f83ee7c4dae0751008b8157f1e49c7af62460a74af124cb64071b2a1084bf208c184d1ed83f6d23088b14df649485f7002c0025eafeb608d769df6b1aff523a1fbc084254464bd8df12c75ec389936c97d4ce7025ba1268fb8749d0fdda260a7d697741cb0164a68f3487924fb7e8f3aa80ec300dea239c73732321a24fbe374d3dc3d26b672cb0ad622d4f6002dba39079e5a162efb9a82bbca7ec6bb149da41095b7e5715aab52369a2eef747682d9ba50461779d7a0e6cb0a95914b7100dd1e948003c9d0b7bd82d071d430c379b68746309e57cd9f53a91224657733c05f28475e14a61c7af416623f283d3f5a71bb139a0c22838be7900839642b1992d21947553695ae09059817a8bd618c25a89114c54564a01488abb98faec6392045c19038e37d5ba0320b210e56f23661d052b3c19001ac9ae4d2f9e48e5ee0db571b73041921dd79b62ee341e1aef732dab8e2717e955005e9b1b53a959380cb59ef73c4d9839a6adfeaaa50a73396a25fe67e1b24c309b611c465b4bfa065db6b49f8e04203ae33342ba604ef99f2c6a2d24c2ae562bc80217fca95b3370ce2d1e95eccef6e6f2b2bcb0cea45127e14b16e47082c4d8911270be210f47430440ef34445498ec4ff999c4b8fc4f451023fa01c6be7cf7be5d5acbe4c3cd920a6188337675896d3eacc4e9ab9f8ba3a23a6085efdd1ef789b585f1dadee8278c7da3eab181ede4a1351c62d87b4c4ed0793a0584e0deb1700432ed2e40b5532529f5dd14bace8463c20358fae2e2dd1697f73730ef16b96a108a0f7590d634897c7f360cb491c9a524a1b0c10ea5dfaa20e89aaee5115e01fbd78aa03b86f00a08242c09fefb66f35d8821969269058fd76a09dfb5e52a751b3b4960a4ee1d654aa2a68121993bfb704dc8016404cbdd15ac948995b393f3325817f890082a6b402a865066efae0d6e471494ec0a14138a8066aa066a97128d8f50552116bfea69be196564e133bfa866e07b3c463cdec073b39bd099f8a129bbf517ce6057655e82ed61e4ca37ac469a2213ffc1c78ac4ddface73dde68c3dd8e5b6ad845222de497a274c7a18ee9d54282ed3f0d465ad83acf48fb6ec9c071c8d6b5b0a302bc17dbe650c1a8ab81e07fa08ef363a492bcc917eb0cc872ec7177a62eca1452595df6ca47c95d1b7f384a22e72f2cb4978444c3fbb1dc297647ffe3e825942021e3ed3b8d17bafb0bb2fe105e88f54a01b31709e636899f517f86be6c7586b44c9736b314a44ab57fde78623c2d6183c99087f23aedaa316cbeb75065b23475acf3eec739997a301e28693ce1b39d0b198cd5db835bc34f7b5e9f16bce15d73c2b1b4a6d013e0185462dea9ed1cc23d24966572275067a1205ab488e84a16627ac13be024d6f5dc30027d412931cd6240b228aab6f9f4b0da03b5669bda6d3ce2f88cf823df92b6c220a8bfe8eb587fd0a4082c1d2953b6983d5ca3b888cce33a88604897f25156c7677df8e2bc0efc636e3bf8cfd5412051e709fd03464716b2f81896dad7ef84bc01005173415404e24360bc5de602e097d3a3f7755af2831bd0d112eefc3e30e92a8169af1c2876baf87e027161a76bee2fe57061f20ee6dbb7f367ed56b14effce3c3b795a624a09fe3fc9a053aa033b2885c7f6e694fee632a8bc8c45d0b4d7ce3fa2b685c62e83cb346fe1a59755067a2031b247a2663f64fdcaa8f3f762f74305faf94097a71978f0a6757b2f62ff9c7f33dcc3856c4a5e356eaf59fd38c81946190ba639f8be623d41403759fd952da9df27257d28e16a8c48daa5a456c703bab9de7676ba938d9077343c809fb6aa2a940f478986cf2233800ca960d2c8850c5353e277d7acb8f610ff5ee9b05f0b2935ca7a1f459bac4c85579776cb5ec4c90abbed8488851f30b788f06bd6121f95ea8a7a07b10c6795800f7f7dd942c553902f5f7be67baa40fb0ef6aa02650f0880c6836d5bade1ea7d8979156787e9d229a357e26c84da66f1a3f1c69de996930d5c48ac2dd4049ef3d563548a8126a7b4cd2febe2d48bf472465a77f9a005469eb0b00a6c84f99f9447a73205c1f8759b24a96f6a1ac023c621ec8134e20c97ac25366592e33d2487e3b7b2358997b81427e560df7c204022c64a2aefbcc3ee6e31f78102320803869060d51a38e7cb4980c267b25c066b895998a6c0a03ef52c2d86c1b649106109cddcc1c626bb787185499ccf944ae95797b88ae42f805b47e27f7a0f797a272fff4462e19427af920d377602a513aa04b422e458af8d834791c267d1615d99045360e855809da4482d625b1dfd92a3f0672896a5744b5ba044d7ddfc8ff4375e8548ce4989a5a10a87258d0182af8de065ab7faa385c6d706e5ba548784787951be6f0653bc0afd6e18bf4fd0cc0618321fa6dfa726791748bbb888ba873c4790737fce8d6bc4ebfd99759c58f3fc23a386c4f5182bee7b124b4c91e2e8111cc804b445544da5741aefd4912b755ea7478011b4aeefb5ba329b62963f6f1b39639cf55d7c7891f8f3e4193f479e163e9286bf82118eae8f07ef493401cf962a5815954e22fb0ccc509132e6e20d1ce753f488bb5f41a5b19e0fb58ebf77e750af614019b052d2091c91022387fe489a685f5a2697b95f30ac0cafa877b86c8ecc7e0452d09483150509a2071e4edde325bea354806df196160ae3dca459b7322bf98c9e11b421d371eafcc96c543df4090826504e708d82d062583f34892d55edd2a1e1c4a0bbbc269ba41b95b0754b41c5c731d8670630e8d99d42ed4af6de701ee264fa55203f0160ca1eb98ebfbd11cef9ffe7c0c3146773a1d321f5c3222a1ccca47814f688e08b084377ac78b1a5cd387336a2e40ac32dbab43931fc56fd67428c0ff288eaf5d1da645c7cf216dad45dfce8d59538cbb277f5e09a871910fad14af4fc3db92f5c682e3fd7578025dcf85a8a33582c106cb21e802de3434896a82990d3d8282e11b095e65c806fb744e906dda92e4e6576e9a5eb6e2ea67d779539bacd55eec332a19c809d3fcb62badd5a1a13cb66b37cad3f848ac346b054d6e4af14583ed2c12a0f3ffaa59de07cd5d4c86978616270fef07566e0d917e47d7efb338f156b2c0dff5c866277d70122fd3b3b28a28691ca5311b8f9bba5338180c3e96e5073e47bf708e82e2a7f8a7549a70408b0f3fb8005764c92ec84f829ece303abde4589b9192ae3d2b8cd1eae8bcb51b8d469bdb75360e9959030b9b330aa267b7dcefb56e100dcec5f39e60dfa1bd86a414cce3c4cd72e4a6d83b9bcaf13e83d5672d063d3a289c95a853fbb915b85e03be94415e517e2f69ce7ccfd7e109503cb9d5c31193bc87623178cf903e5253df9104b2f42cf1d95a2cdeb313985f59e0f8ebd1eb51c7ab4d9a85e7f237ee9a119390872c4bd6954468fb34fd237f5ad4becdae0175436a30082cdf25541d229b99a556ad3c32e6d21c80e2296337c0af0961189d38d5bcc321d031dd948faa0bb0da88c0b379681ef3683e0500996b073bcf5e7b29827cb9ac85e12822edabd79f01e27a74240d9903f3a1188db97377b8e29a20aa8190b5cb987b6f2317db145a14d838c1ea23da96fca59c0438dc55c821049ce2619b8b4560caf26e59312190a444bf1d19b870590afdfdd22c4720ec97983ddb43c0ac7dfa1bc9beba574f17d2bc2d9c3aa9bc1667c85de999ce4a8e6ecfc04cade218225efe4b3a847e4218d04e3b9c3b30b98bd4a2f9b29f2f6fbf465abd3384ff9fdbf075b2279437d334ac0180577cc91f580000000004713cc4a532a678176713908115632453930af98cc3d3facb0ec6c59cf88a76c7d84a967defbb75a628e23e50e21b7d0e4527736cf78b63274a3221362f91ee07009fb2ec582f71f5756bbebcfa08baeb0d547a000000000	2025-04-06 10:19:01.98321+00	2025-04-06 10:19:01.98321+00
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
2	user	client@example.com	client	$2a$10$fouz6J46Y7amyHjlEm3cmO.NLcVbvcrJQCYixPbhAi8vlkkpVg/dK	user	78888888888	f	0	2025-04-06 10:18:02.764592+00	2025-04-06 10:18:02.764592+00
\.


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 1, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.favorites_id_seq', 1, true);


--
-- Name: help_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.help_id_seq', 1, false);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.logs_id_seq', 7, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, true);


--
-- Name: product_promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.product_promotions_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.products_id_seq', 1, true);


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

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


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

