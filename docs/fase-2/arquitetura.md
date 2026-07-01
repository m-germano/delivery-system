# Arquitetura — DishDash

## 1. Visão geral

O DishDash usa arquitetura cliente-servidor.

O frontend React entrega a interface dos perfis Cliente, Empresa e Entregador. O backend FastAPI expõe rotas REST e WebSocket, valida dados, aplica regras de negócio, autentica usuários e acessa o PostgreSQL. O Redis é usado para eventos em tempo real, sem substituir o banco principal.

```text
Frontend React/Vite
        |
        | HTTP REST / WebSocket
        v
Backend FastAPI
        |
        | SQLAlchemy Async
        v
PostgreSQL

Backend FastAPI
        |
        | Pub/Sub
        v
Redis
```

---

## 2. Backend

Estrutura principal:

```text
app/
├── controllers/
├── services/
├── repositories/
├── models/
├── schemas/
├── core/
├── db/
└── main.py
```

### Controllers

Recebem as requisições HTTP, aplicam autenticação/autorização e chamam os services.

### Services

Concentram as regras de negócio:

- criação e cálculo de pedido;
- abertura e fechamento da loja;
- fluxo de status do pedido;
- fluxo de entrega;
- código de confirmação;
- integração Mercado Pago;
- avaliações;
- regras de entrega e retirada.

### Repositories

Isolam consultas e comandos de banco. Essa camada aplica o Repository Pattern e evita que regras de negócio fiquem misturadas com acesso direto ao PostgreSQL.

### Models

Representam as tabelas principais do domínio.

### Schemas

Validam entrada e saída da API com Pydantic.

---

## 3. Frontend

Estrutura principal:

```text
src/
├── assets/
├── components/
├── config/
├── hooks/
├── pages/
├── routes/
├── services/
├── stores/
├── styles/
└── utils/
```

### Pages

Organizam as telas por perfil:

```text
pages/company
pages/customer
pages/courier
pages/auth
pages/shared
```

### Services

Centralizam chamadas HTTP para a API.

### Stores

Guardam estado global de autenticação, carrinho e UI.

### Routes

Definem rotas públicas, rotas autenticadas e rotas protegidas por perfil.

---

## 4. Banco de dados

O banco principal é PostgreSQL.

Tabelas principais:

- roles
- users
- companies
- company_addresses
- company_order_settings
- company_payment_accounts
- company_reviews
- product_categories
- products
- customer_addresses
- delivery_fee_rules
- orders
- order_items
- order_status_history
- couriers
- deliveries
- delivery_status_history
- payments
- payment_oauth_states

O PostgreSQL é a fonte oficial dos dados. O Redis é usado apenas para eventos em tempo real.

---

## 5. Autenticação e autorização

A autenticação usa e-mail, senha e JWT.

Após login, o frontend envia o token nas próximas requisições:

```text
Authorization: Bearer <token>
```

Perfis usados no MVP:

| role_id | Perfil |
|---|---|
| 2 | Empresa |
| 3 | Entregador |
| 4 | Cliente |

A role 1 pode existir no banco para compatibilidade, mas não faz parte das telas usadas na apresentação.

---

## 6. Integrações externas

### Mercado Pago Checkout Pro

A empresa conecta a conta Mercado Pago por OAuth. O backend salva os tokens criptografados. Quando o cliente escolhe pagamento online, o backend cria uma preferência de pagamento e retorna o link do Checkout Pro. Após o pagamento, o Mercado Pago envia webhook para atualizar o pedido.

### ViaCEP

Completa endereço a partir do CEP.

### Nominatim / OpenStreetMap

Converte endereço em latitude e longitude.

### OSRM

Calcula distância real por ruas. Caso falhe, o backend usa fallback aproximado.

### Redis

Publica eventos de pedidos, entregas e rastreamento.

---

## 7. Design Patterns

### Repository Pattern

Aplicado em repositories para separar acesso ao banco das regras de negócio.

### Strategy Pattern

Aplicado no cálculo de taxa de entrega. A regra padrão pode ser substituída por regras da empresa.

### State Pattern por validação de transições

Aplicado no controle de status do pedido e da entrega. O sistema permite apenas transições válidas.

---

## 8. Rotas principais

### Auth

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

### Companies

- `GET /api/companies`
- `GET /api/companies/nearby`
- `GET /api/companies/me`
- `POST /api/companies`
- `PUT /api/companies/me`
- `PATCH /api/companies/me/open-status`
- `GET /api/companies/me/order-settings`
- `PUT /api/companies/me/order-settings`
- `GET /api/companies/{company_id}/order-settings`

### Products

- `GET /api/products`
- `GET /api/products/{product_id}`
- `POST /api/products`
- `PUT /api/products/{product_id}`
- `DELETE /api/products/{product_id}`
- `GET /api/product-categories/me`
- `POST /api/product-categories`

### Customer Addresses

- `GET /api/customer-addresses/me`
- `GET /api/customer-addresses/location-status`
- `POST /api/customer-addresses`
- `PUT /api/customer-addresses/{address_id}`
- `PATCH /api/customer-addresses/{address_id}/default`
- `DELETE /api/customer-addresses/{address_id}`

### Orders

- `POST /api/orders/calculate`
- `POST /api/orders`
- `POST /api/orders/checkout-pro`
- `POST /api/orders/pix`
- `GET /api/orders/my`
- `GET /api/orders/company`
- `GET /api/orders/{order_id}`
- `PATCH /api/orders/{order_id}/accept`
- `PATCH /api/orders/{order_id}/reject`
- `PATCH /api/orders/{order_id}/cancel`
- `PATCH /api/orders/{order_id}/cancel-by-company`
- `PATCH /api/orders/{order_id}/status`
- `GET /api/orders/{order_id}/payment-status`

### Payment Accounts

- `GET /api/payment-accounts/mercado-pago/connect`
- `GET /api/payment-accounts/mercado-pago/callback`
- `GET /api/payment-accounts/me/mercado-pago`
- `DELETE /api/payment-accounts/me/mercado-pago`

### Payments

- `POST /api/payments/mercado-pago/webhook`

### Deliveries

- `GET /api/deliveries/available`
- `GET /api/deliveries/my`
- `GET /api/deliveries/{delivery_id}`
- `PATCH /api/deliveries/{delivery_id}/accept`
- `PATCH /api/deliveries/{delivery_id}/finish`
- `PATCH /api/deliveries/{delivery_id}/location`

### Reviews

- `POST /api/reviews`
- `GET /api/reviews/company/{company_id}`
- `GET /api/reviews/company/me`
