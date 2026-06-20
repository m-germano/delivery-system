-- Schema PostgreSQL inicial — Sistema de Delivery

CREATE TABLE IF NOT EXISTS roles (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255)
);

INSERT INTO roles (id, name, description) VALUES
(1, 'ADMIN', 'Administrador do sistema'),
(2, 'COMPANY', 'Empresa/restaurante'),
(3, 'COURIER', 'Entregador'),
(4, 'CUSTOMER', 'Cliente')
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    role_id SMALLINT NOT NULL REFERENCES roles(id),
    name VARCHAR(120) NOT NULL,
    email VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(30),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS companies (
    id BIGSERIAL PRIMARY KEY,
    owner_user_id BIGINT NOT NULL UNIQUE REFERENCES users(id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    phone VARCHAR(30),
    document VARCHAR(30),
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS company_addresses (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL UNIQUE REFERENCES companies(id) ON DELETE CASCADE,
    street VARCHAR(150) NOT NULL,
    number VARCHAR(20) NOT NULL,
    complement VARCHAR(100),
    neighborhood VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    latitude NUMERIC(10,7) NOT NULL,
    longitude NUMERIC(10,7) NOT NULL
);

CREATE TABLE IF NOT EXISTS product_categories (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    category_id BIGINT REFERENCES product_categories(id) ON DELETE SET NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customer_addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(60),
    street VARCHAR(150) NOT NULL,
    number VARCHAR(20) NOT NULL,
    complement VARCHAR(100),
    neighborhood VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    latitude NUMERIC(10,7) NOT NULL,
    longitude NUMERIC(10,7) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS delivery_fee_rules (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    min_distance_km NUMERIC(8,2) NOT NULL CHECK (min_distance_km >= 0),
    max_distance_km NUMERIC(8,2) NOT NULL CHECK (max_distance_km > min_distance_km),
    fee NUMERIC(10,2) NOT NULL CHECK (fee >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    customer_user_id BIGINT NOT NULL REFERENCES users(id),
    company_id BIGINT NOT NULL REFERENCES companies(id),
    customer_address_id BIGINT NOT NULL REFERENCES customer_addresses(id),
    status VARCHAR(30) NOT NULL DEFAULT 'CRIADO',
    subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0),
    delivery_fee NUMERIC(10,2) NOT NULL CHECK (delivery_fee >= 0),
    total NUMERIC(10,2) NOT NULL CHECK (total >= 0),
    distance_km NUMERIC(8,2) NOT NULL CHECK (distance_km >= 0),
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_orders_status CHECK (
        status IN (
            'CRIADO',
            'ACEITO',
            'EM_PREPARO',
            'AGUARDANDO_ENTREGADOR',
            'EM_ENTREGA',
            'ENTREGUE',
            'CANCELADO',
            'RECUSADO'
        )
    )
);

CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id),
    product_name VARCHAR(120) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price >= 0),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS order_status_history (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by_user_id BIGINT NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS couriers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    vehicle_type VARCHAR(50),
    vehicle_plate VARCHAR(20),
    is_available BOOLEAN NOT NULL DEFAULT FALSE,
    current_latitude NUMERIC(10,7),
    current_longitude NUMERIC(10,7),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS deliveries (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders(id) ON DELETE CASCADE,
    courier_user_id BIGINT REFERENCES users(id),
    status VARCHAR(30) NOT NULL DEFAULT 'DISPONIVEL',
    pickup_latitude NUMERIC(10,7) NOT NULL,
    pickup_longitude NUMERIC(10,7) NOT NULL,
    destination_latitude NUMERIC(10,7) NOT NULL,
    destination_longitude NUMERIC(10,7) NOT NULL,
    distance_km NUMERIC(8,2) NOT NULL CHECK (distance_km >= 0),
    delivery_fee NUMERIC(10,2) NOT NULL CHECK (delivery_fee >= 0),
    accepted_at TIMESTAMP,
    picked_up_at TIMESTAMP,
    delivered_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_deliveries_status CHECK (
        status IN (
            'DISPONIVEL',
            'ACEITA',
            'RETIRADA',
            'EM_ROTA',
            'FINALIZADA',
            'CANCELADA'
        )
    )
);

CREATE TABLE IF NOT EXISTS delivery_status_history (
    id BIGSERIAL PRIMARY KEY,
    delivery_id BIGINT NOT NULL REFERENCES deliveries(id) ON DELETE CASCADE,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by_user_id BIGINT NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_products_company_id ON products(company_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_user_id ON orders(customer_user_id);
CREATE INDEX IF NOT EXISTS idx_orders_company_id ON orders(company_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_deliveries_status ON deliveries(status);
CREATE INDEX IF NOT EXISTS idx_deliveries_courier_user_id ON deliveries(courier_user_id);
