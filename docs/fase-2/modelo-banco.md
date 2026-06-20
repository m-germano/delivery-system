# Modelagem do Banco de Dados — Sistema de Delivery



## 1. Roles do sistema

| id | name | Descrição |
|---|---|---|
| 1 | ADMIN | Administrador do sistema |
| 2 | COMPANY | Empresa/restaurante |
| 3 | COURIER | Entregador |
| 4 | CUSTOMER | Cliente |

Observação: mesmo que o usuário tenha sugerido três roles iniciais, a role Cliente é necessária porque o sistema possui login e funcionalidades específicas para clientes.

---

## 2. Tabelas do MVP

### roles

| Campo | Tipo | Observação |
|---|---|---|
| id | smallint | PK |
| name | varchar(30) | único |
| description | varchar(255) | opcional |

---

### users

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| role_id | smallint | FK para roles |
| name | varchar(120) | obrigatório |
| email | varchar(180) | único |
| password_hash | varchar(255) | obrigatório |
| phone | varchar(30) | opcional |
| is_active | boolean | padrão true |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

Relacionamentos:

- roles 1:N users
- users 1:1 companies, quando role = COMPANY
- users 1:1 couriers, quando role = COURIER
- users 1:N customer_addresses, quando role = CUSTOMER
- users 1:N orders, quando role = CUSTOMER

---

### companies

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| owner_user_id | bigint | FK para users |
| name | varchar(150) | obrigatório |
| description | text | opcional |
| phone | varchar(30) | opcional |
| document | varchar(30) | opcional |
| image_url | text | opcional |
| is_active | boolean | padrão true |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

Relacionamentos:

- users 1:1 companies no MVP
- companies 1:1 company_addresses
- companies 1:N product_categories
- companies 1:N products
- companies 1:N delivery_fee_rules
- companies 1:N orders

---

### company_addresses

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| company_id | bigint | FK para companies, único |
| street | varchar(150) | obrigatório |
| number | varchar(20) | obrigatório |
| complement | varchar(100) | opcional |
| neighborhood | varchar(100) | obrigatório |
| city | varchar(100) | obrigatório |
| state | varchar(2) | obrigatório |
| zip_code | varchar(20) | obrigatório |
| latitude | numeric(10, 7) | obrigatório |
| longitude | numeric(10, 7) | obrigatório |

---

### product_categories

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| company_id | bigint | FK para companies |
| name | varchar(100) | obrigatório |
| description | text | opcional |
| display_order | integer | padrão 0 |
| is_active | boolean | padrão true |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

---

### products

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| company_id | bigint | FK para companies |
| category_id | bigint | FK para product_categories, opcional |
| name | varchar(120) | obrigatório |
| description | text | opcional |
| price | numeric(10,2) | obrigatório |
| image_url | text | opcional |
| is_active | boolean | padrão true |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

---

### customer_addresses

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| user_id | bigint | FK para users |
| label | varchar(60) | Casa, Trabalho etc. |
| street | varchar(150) | obrigatório |
| number | varchar(20) | obrigatório |
| complement | varchar(100) | opcional |
| neighborhood | varchar(100) | obrigatório |
| city | varchar(100) | obrigatório |
| state | varchar(2) | obrigatório |
| zip_code | varchar(20) | obrigatório |
| latitude | numeric(10,7) | obrigatório |
| longitude | numeric(10,7) | obrigatório |
| is_default | boolean | padrão false |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

---

### delivery_fee_rules

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| company_id | bigint | FK para companies |
| min_distance_km | numeric(8,2) | obrigatório |
| max_distance_km | numeric(8,2) | obrigatório |
| fee | numeric(10,2) | obrigatório |
| is_active | boolean | padrão true |

---

### orders

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| customer_user_id | bigint | FK para users |
| company_id | bigint | FK para companies |
| customer_address_id | bigint | FK para customer_addresses |
| status | varchar(30) | status atual |
| subtotal | numeric(10,2) | soma dos itens |
| delivery_fee | numeric(10,2) | taxa de entrega |
| total | numeric(10,2) | subtotal + taxa |
| distance_km | numeric(8,2) | distância calculada |
| payment_method | varchar(50) | simplificado |
| notes | text | opcional |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

Status de pedido:

- CRIADO
- ACEITO
- EM_PREPARO
- AGUARDANDO_ENTREGADOR
- EM_ENTREGA
- ENTREGUE
- CANCELADO
- RECUSADO

---

### order_items

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| order_id | bigint | FK para orders |
| product_id | bigint | FK para products |
| product_name | varchar(120) | snapshot |
| unit_price | numeric(10,2) | snapshot |
| quantity | integer | obrigatório |
| total_price | numeric(10,2) | obrigatório |
| notes | text | opcional |

---

### order_status_history

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| order_id | bigint | FK para orders |
| old_status | varchar(30) | opcional no primeiro registro |
| new_status | varchar(30) | obrigatório |
| changed_by_user_id | bigint | FK para users |
| created_at | timestamp | padrão now |

---

### couriers

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| user_id | bigint | FK para users, único |
| vehicle_type | varchar(50) | moto, bike, carro |
| vehicle_plate | varchar(20) | opcional |
| is_available | boolean | padrão false |
| current_latitude | numeric(10,7) | opcional |
| current_longitude | numeric(10,7) | opcional |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

---

### deliveries

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| order_id | bigint | FK para orders, único |
| courier_user_id | bigint | FK para users, opcional |
| status | varchar(30) | status atual |
| pickup_latitude | numeric(10,7) | origem |
| pickup_longitude | numeric(10,7) | origem |
| destination_latitude | numeric(10,7) | destino |
| destination_longitude | numeric(10,7) | destino |
| distance_km | numeric(8,2) | distância da entrega |
| delivery_fee | numeric(10,2) | taxa |
| accepted_at | timestamp | opcional |
| picked_up_at | timestamp | opcional |
| delivered_at | timestamp | opcional |
| created_at | timestamp | padrão now |
| updated_at | timestamp | padrão now |

Status de entrega:

- DISPONIVEL
- ACEITA
- RETIRADA
- EM_ROTA
- FINALIZADA
- CANCELADA

---

### delivery_status_history

| Campo | Tipo | Observação |
|---|---|---|
| id | bigserial | PK |
| delivery_id | bigint | FK para deliveries |
| old_status | varchar(30) | opcional no primeiro registro |
| new_status | varchar(30) | obrigatório |
| changed_by_user_id | bigint | FK para users |
| created_at | timestamp | padrão now |

---

