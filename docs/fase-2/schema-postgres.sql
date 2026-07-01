-- ============================================================
-- Script de criação do banco e estrutura
-- Banco sugerido: delivery_system
--
-- COMO USAR NO psql:
--   psql -U postgres -f criar_banco_delivery_system.sql
--
-- Se estiver usando pgAdmin/DBeaver:
--   1) Rode apenas o CREATE DATABASE abaixo conectado no banco postgres;
--   2) Conecte no banco delivery_system;
--   3) Rode a parte do schema a partir de "-- INÍCIO DO SCHEMA".
-- ============================================================

CREATE DATABASE delivery_system
    WITH
    ENCODING = 'UTF8'
    TEMPLATE = template0;

\connect delivery_system

-- INÍCIO DO SCHEMA

--
-- PostgreSQL database dump
--

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
-- SET transaction_timeout = 0; -- removido para compatibilidade com versões anteriores do PostgreSQL
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    owner_user_id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    phone character varying(30),
    document character varying(30),
    image_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_addresses (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    street character varying(150) NOT NULL,
    number character varying(20) NOT NULL,
    complement character varying(100),
    neighborhood character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(2) NOT NULL,
    zip_code character varying(20) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    longitude numeric(10,7) NOT NULL
);



--
-- Name: company_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: company_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_addresses_id_seq OWNED BY public.company_addresses.id;


--
-- Name: company_order_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_order_settings (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    accepts_delivery boolean DEFAULT true NOT NULL,
    accepts_pickup boolean DEFAULT false NOT NULL,
    pickup_discount_percent numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    minimum_order_value numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_company_order_settings_at_least_one_mode CHECK ((accepts_delivery OR accepts_pickup)),
    CONSTRAINT ck_company_order_settings_minimum_order_non_negative CHECK ((minimum_order_value >= (0)::numeric)),
    CONSTRAINT ck_company_order_settings_pickup_discount_range CHECK (((pickup_discount_percent >= (0)::numeric) AND (pickup_discount_percent <= (100)::numeric)))
);



--
-- Name: company_order_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_order_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: company_order_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_order_settings_id_seq OWNED BY public.company_order_settings.id;


--
-- Name: company_payment_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_payment_accounts (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    provider character varying(30) DEFAULT 'mercado_pago'::character varying NOT NULL,
    provider_user_id character varying(120),
    public_key text,
    access_token_encrypted text NOT NULL,
    refresh_token_encrypted text,
    token_expires_at timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    connected_at timestamp without time zone DEFAULT now() NOT NULL,
    disconnected_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_company_payment_accounts_provider CHECK (((provider)::text = 'mercado_pago'::text))
);



--
-- Name: company_payment_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_payment_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: company_payment_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_payment_accounts_id_seq OWNED BY public.company_payment_accounts.id;


--
-- Name: company_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_reviews (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    customer_user_id bigint NOT NULL,
    order_id bigint NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_company_reviews_rating_range CHECK (((rating >= 1) AND (rating <= 5)))
);



--
-- Name: company_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: company_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_reviews_id_seq OWNED BY public.company_reviews.id;


--
-- Name: couriers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.couriers (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    vehicle_type character varying(50),
    vehicle_plate character varying(20),
    is_available boolean DEFAULT false NOT NULL,
    current_latitude numeric(10,7),
    current_longitude numeric(10,7),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: couriers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.couriers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: couriers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.couriers_id_seq OWNED BY public.couriers.id;


--
-- Name: customer_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_addresses (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    label character varying(60),
    street character varying(150) NOT NULL,
    number character varying(20) NOT NULL,
    complement character varying(100),
    neighborhood character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(2) NOT NULL,
    zip_code character varying(20) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    longitude numeric(10,7) NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: customer_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: customer_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_addresses_id_seq OWNED BY public.customer_addresses.id;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    courier_user_id bigint,
    status character varying(30) DEFAULT 'DISPONIVEL'::character varying NOT NULL,
    pickup_latitude numeric(10,7) NOT NULL,
    pickup_longitude numeric(10,7) NOT NULL,
    destination_latitude numeric(10,7) NOT NULL,
    destination_longitude numeric(10,7) NOT NULL,
    distance_km numeric(8,2) NOT NULL,
    delivery_fee numeric(10,2) NOT NULL,
    accepted_at timestamp without time zone,
    picked_up_at timestamp without time zone,
    delivered_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_deliveries_distance_non_negative CHECK ((distance_km >= (0)::numeric)),
    CONSTRAINT ck_deliveries_fee_non_negative CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT ck_deliveries_status CHECK (((status)::text = ANY ((ARRAY['DISPONIVEL'::character varying, 'ACEITA'::character varying, 'RETIRADA'::character varying, 'EM_ROTA'::character varying, 'FINALIZADA'::character varying, 'CANCELADA'::character varying])::text[])))
);



--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;


--
-- Name: delivery_fee_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_fee_rules (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    min_distance_km numeric(8,2) NOT NULL,
    max_distance_km numeric(8,2) NOT NULL,
    fee numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT ck_delivery_fee_rules_fee_non_negative CHECK ((fee >= (0)::numeric)),
    CONSTRAINT ck_delivery_fee_rules_min_distance_non_negative CHECK ((min_distance_km >= (0)::numeric)),
    CONSTRAINT ck_delivery_fee_rules_range_valid CHECK ((max_distance_km > min_distance_km))
);



--
-- Name: delivery_fee_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivery_fee_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: delivery_fee_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivery_fee_rules_id_seq OWNED BY public.delivery_fee_rules.id;


--
-- Name: delivery_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_status_history (
    id bigint NOT NULL,
    delivery_id bigint NOT NULL,
    old_status character varying(30),
    new_status character varying(30) NOT NULL,
    changed_by_user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: delivery_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivery_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: delivery_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivery_status_history_id_seq OWNED BY public.delivery_status_history.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    product_name character varying(120) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    total_price numeric(10,2) NOT NULL,
    notes text,
    CONSTRAINT ck_order_items_quantity_positive CHECK ((quantity > 0)),
    CONSTRAINT ck_order_items_total_price_non_negative CHECK ((total_price >= (0)::numeric)),
    CONSTRAINT ck_order_items_unit_price_non_negative CHECK ((unit_price >= (0)::numeric))
);



--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status_history (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    old_status character varying(30),
    new_status character varying(30) NOT NULL,
    changed_by_user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: order_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: order_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_status_history_id_seq OWNED BY public.order_status_history.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    customer_user_id bigint NOT NULL,
    company_id bigint NOT NULL,
    customer_address_id bigint,
    fulfillment_type character varying(20) DEFAULT 'DELIVERY'::character varying NOT NULL,
    status character varying(30) DEFAULT 'ABERTO'::character varying NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    pickup_discount_percent numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    delivery_fee numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL,
    distance_km numeric(8,2) NOT NULL,
    payment_method character varying(50) DEFAULT 'PIX'::character varying NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_orders_delivery_fee_non_negative CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT ck_orders_discount_non_negative CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT ck_orders_distance_non_negative CHECK ((distance_km >= (0)::numeric)),
    CONSTRAINT ck_orders_fulfillment_type CHECK (((fulfillment_type)::text = ANY ((ARRAY['DELIVERY'::character varying, 'PICKUP'::character varying])::text[]))),
    CONSTRAINT ck_orders_payment_method CHECK (((payment_method)::text = ANY ((ARRAY['CREDITO'::character varying, 'DEBITO'::character varying, 'PIX'::character varying, 'PIX_ONLINE'::character varying, 'DINHEIRO'::character varying])::text[]))),
    CONSTRAINT ck_orders_pickup_discount_range CHECK (((pickup_discount_percent >= (0)::numeric) AND (pickup_discount_percent <= (100)::numeric))),
    CONSTRAINT ck_orders_status CHECK (((status)::text = ANY ((ARRAY['AGUARDANDO_PAGAMENTO'::character varying, 'ABERTO'::character varying, 'ACEITO'::character varying, 'EM_PREPARO'::character varying, 'PRONTO_PARA_RETIRADA'::character varying, 'AGUARDANDO_ENTREGADOR'::character varying, 'EM_ENTREGA'::character varying, 'ENTREGUE'::character varying, 'RETIRADO'::character varying, 'CANCELADO'::character varying, 'RECUSADO'::character varying])::text[]))),
    CONSTRAINT ck_orders_subtotal_non_negative CHECK ((subtotal >= (0)::numeric)),
    CONSTRAINT ck_orders_total_non_negative CHECK ((total >= (0)::numeric))
);



--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: payment_oauth_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_oauth_states (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    user_id bigint NOT NULL,
    provider character varying(30) DEFAULT 'mercado_pago'::character varying NOT NULL,
    state character varying(160) NOT NULL,
    code_verifier_encrypted text,
    expires_at timestamp without time zone NOT NULL,
    consumed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: payment_oauth_states_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_oauth_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: payment_oauth_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_oauth_states_id_seq OWNED BY public.payment_oauth_states.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    company_id bigint NOT NULL,
    provider character varying(30) DEFAULT 'mercado_pago'::character varying NOT NULL,
    provider_payment_id character varying(120),
    provider_order_id character varying(120),
    idempotency_key character varying(160),
    payment_method character varying(30),
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    qr_code text,
    qr_code_base64 text,
    expires_at timestamp with time zone,
    paid_at timestamp without time zone,
    cancelled_at timestamp without time zone,
    refunded_at timestamp without time zone,
    failed_at timestamp without time zone,
    provider_status character varying(80),
    provider_status_detail text,
    raw_status character varying(80),
    raw_status_detail text,
    raw_response json,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_payments_amount_non_negative CHECK ((amount >= (0)::numeric)),
    CONSTRAINT ck_payments_method CHECK (((payment_method IS NULL) OR ((payment_method)::text = ANY ((ARRAY['pix'::character varying, 'credit_card'::character varying, 'debit_card'::character varying, 'cash'::character varying, 'simulated'::character varying])::text[])))),
    CONSTRAINT ck_payments_provider CHECK (((provider)::text = ANY ((ARRAY['mercado_pago'::character varying, 'manual'::character varying, 'simulated'::character varying])::text[]))),
    CONSTRAINT ck_payments_status CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'in_process'::character varying, 'approved'::character varying, 'rejected'::character varying, 'cancelled'::character varying, 'refunded'::character varying, 'failed'::character varying, 'expired'::character varying])::text[])))
);



--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.product_categories.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    category_id bigint,
    name character varying(120) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    image_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_products_price_non_negative CHECK ((price >= (0)::numeric))
);



--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id smallint NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(255)
);



--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    role_id smallint NOT NULL,
    name character varying(120) NOT NULL,
    email character varying(180) NOT NULL,
    password_hash character varying(255) NOT NULL,
    phone character varying(30),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);



--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_addresses ALTER COLUMN id SET DEFAULT nextval('public.company_addresses_id_seq'::regclass);


--
-- Name: company_order_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_order_settings ALTER COLUMN id SET DEFAULT nextval('public.company_order_settings_id_seq'::regclass);


--
-- Name: company_payment_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_payment_accounts ALTER COLUMN id SET DEFAULT nextval('public.company_payment_accounts_id_seq'::regclass);


--
-- Name: company_reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews ALTER COLUMN id SET DEFAULT nextval('public.company_reviews_id_seq'::regclass);


--
-- Name: couriers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.couriers ALTER COLUMN id SET DEFAULT nextval('public.couriers_id_seq'::regclass);


--
-- Name: customer_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_addresses ALTER COLUMN id SET DEFAULT nextval('public.customer_addresses_id_seq'::regclass);


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN id SET DEFAULT nextval('public.deliveries_id_seq'::regclass);


--
-- Name: delivery_fee_rules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_fee_rules ALTER COLUMN id SET DEFAULT nextval('public.delivery_fee_rules_id_seq'::regclass);


--
-- Name: delivery_status_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_status_history ALTER COLUMN id SET DEFAULT nextval('public.delivery_status_history_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: order_status_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history ALTER COLUMN id SET DEFAULT nextval('public.order_status_history_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: payment_oauth_states id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_oauth_states ALTER COLUMN id SET DEFAULT nextval('public.payment_oauth_states_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: product_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: companies companies_owner_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_owner_user_id_key UNIQUE (owner_user_id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_addresses company_addresses_company_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_addresses
    ADD CONSTRAINT company_addresses_company_id_key UNIQUE (company_id);


--
-- Name: company_addresses company_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_addresses
    ADD CONSTRAINT company_addresses_pkey PRIMARY KEY (id);


--
-- Name: company_order_settings company_order_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_order_settings
    ADD CONSTRAINT company_order_settings_pkey PRIMARY KEY (id);


--
-- Name: company_payment_accounts company_payment_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_payment_accounts
    ADD CONSTRAINT company_payment_accounts_pkey PRIMARY KEY (id);


--
-- Name: company_reviews company_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_pkey PRIMARY KEY (id);


--
-- Name: couriers couriers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.couriers
    ADD CONSTRAINT couriers_pkey PRIMARY KEY (id);


--
-- Name: couriers couriers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.couriers
    ADD CONSTRAINT couriers_user_id_key UNIQUE (user_id);


--
-- Name: customer_addresses customer_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_order_id_key UNIQUE (order_id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: delivery_fee_rules delivery_fee_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_fee_rules
    ADD CONSTRAINT delivery_fee_rules_pkey PRIMARY KEY (id);


--
-- Name: delivery_status_history delivery_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_status_history
    ADD CONSTRAINT delivery_status_history_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payment_oauth_states payment_oauth_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_oauth_states
    ADD CONSTRAINT payment_oauth_states_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: company_reviews uq_company_reviews_order_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT uq_company_reviews_order_id UNIQUE (order_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_company_order_settings_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_company_order_settings_company_id ON public.company_order_settings USING btree (company_id);


--
-- Name: ix_company_payment_accounts_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_company_payment_accounts_company_id ON public.company_payment_accounts USING btree (company_id);


--
-- Name: ix_company_payment_accounts_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_company_payment_accounts_is_active ON public.company_payment_accounts USING btree (is_active);


--
-- Name: ix_company_reviews_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_company_reviews_company_id ON public.company_reviews USING btree (company_id);


--
-- Name: ix_company_reviews_customer_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_company_reviews_customer_user_id ON public.company_reviews USING btree (customer_user_id);


--
-- Name: ix_company_reviews_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_company_reviews_order_id ON public.company_reviews USING btree (order_id);


--
-- Name: ix_customer_addresses_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_customer_addresses_user_id ON public.customer_addresses USING btree (user_id);


--
-- Name: ix_deliveries_courier_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_deliveries_courier_user_id ON public.deliveries USING btree (courier_user_id);


--
-- Name: ix_deliveries_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_deliveries_status ON public.deliveries USING btree (status);


--
-- Name: ix_delivery_fee_rules_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fee_rules_company_id ON public.delivery_fee_rules USING btree (company_id);


--
-- Name: ix_delivery_status_history_delivery_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_status_history_delivery_id ON public.delivery_status_history USING btree (delivery_id);


--
-- Name: ix_order_items_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_order_items_order_id ON public.order_items USING btree (order_id);


--
-- Name: ix_order_status_history_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_order_status_history_order_id ON public.order_status_history USING btree (order_id);


--
-- Name: ix_orders_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_orders_company_id ON public.orders USING btree (company_id);


--
-- Name: ix_orders_customer_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_orders_customer_user_id ON public.orders USING btree (customer_user_id);


--
-- Name: ix_orders_fulfillment_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_orders_fulfillment_type ON public.orders USING btree (fulfillment_type);


--
-- Name: ix_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_orders_status ON public.orders USING btree (status);


--
-- Name: ix_payment_oauth_states_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payment_oauth_states_company_id ON public.payment_oauth_states USING btree (company_id);


--
-- Name: ix_payment_oauth_states_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_payment_oauth_states_state ON public.payment_oauth_states USING btree (state);


--
-- Name: ix_payment_oauth_states_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payment_oauth_states_user_id ON public.payment_oauth_states USING btree (user_id);


--
-- Name: ix_payments_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_company_id ON public.payments USING btree (company_id);


--
-- Name: ix_payments_idempotency_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_idempotency_key ON public.payments USING btree (idempotency_key);


--
-- Name: ix_payments_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_order_id ON public.payments USING btree (order_id);


--
-- Name: ix_payments_provider; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_provider ON public.payments USING btree (provider);


--
-- Name: ix_payments_provider_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_provider_order_id ON public.payments USING btree (provider_order_id);


--
-- Name: ix_payments_provider_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_provider_payment_id ON public.payments USING btree (provider_payment_id);


--
-- Name: ix_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_status ON public.payments USING btree (status);


--
-- Name: ix_product_categories_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_product_categories_company_id ON public.product_categories USING btree (company_id);


--
-- Name: ix_products_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_products_company_id ON public.products USING btree (company_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_role_id ON public.users USING btree (role_id);


--
-- Name: uq_company_payment_accounts_active_provider; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_company_payment_accounts_active_provider ON public.company_payment_accounts USING btree (company_id, provider) WHERE (is_active = true);


--
-- Name: companies companies_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.users(id);


--
-- Name: company_addresses company_addresses_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_addresses
    ADD CONSTRAINT company_addresses_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_order_settings company_order_settings_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_order_settings
    ADD CONSTRAINT company_order_settings_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_payment_accounts company_payment_accounts_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_payment_accounts
    ADD CONSTRAINT company_payment_accounts_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_reviews company_reviews_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_reviews company_reviews_customer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_customer_user_id_fkey FOREIGN KEY (customer_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: company_reviews company_reviews_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: couriers couriers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.couriers
    ADD CONSTRAINT couriers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: customer_addresses customer_addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: deliveries deliveries_courier_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_courier_user_id_fkey FOREIGN KEY (courier_user_id) REFERENCES public.users(id);


--
-- Name: deliveries deliveries_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: delivery_fee_rules delivery_fee_rules_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_fee_rules
    ADD CONSTRAINT delivery_fee_rules_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: delivery_status_history delivery_status_history_changed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_status_history
    ADD CONSTRAINT delivery_status_history_changed_by_user_id_fkey FOREIGN KEY (changed_by_user_id) REFERENCES public.users(id);


--
-- Name: delivery_status_history delivery_status_history_delivery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_status_history
    ADD CONSTRAINT delivery_status_history_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: order_status_history order_status_history_changed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_changed_by_user_id_fkey FOREIGN KEY (changed_by_user_id) REFERENCES public.users(id);


--
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: orders orders_customer_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_address_id_fkey FOREIGN KEY (customer_address_id) REFERENCES public.customer_addresses(id);


--
-- Name: orders orders_customer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_user_id_fkey FOREIGN KEY (customer_user_id) REFERENCES public.users(id);


--
-- Name: payment_oauth_states payment_oauth_states_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_oauth_states
    ADD CONSTRAINT payment_oauth_states_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: payment_oauth_states payment_oauth_states_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_oauth_states
    ADD CONSTRAINT payment_oauth_states_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: products products_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

