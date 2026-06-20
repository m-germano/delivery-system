# Arquitetura Inicial — Sistema de Delivery

## 1. Visão geral

O sistema será desenvolvido com uma arquitetura cliente-servidor.

O frontend React será responsável pela interface dos usuários. O backend FastAPI será responsável por expor rotas REST, validar dados, aplicar regras de negócio, autenticar usuários e acessar o banco de dados PostgreSQL.

Todos os módulos do sistema consomem a mesma API:

1. Área do Admin.
2. Área da Empresa.
3. Site/área do Cliente.
4. Portal do Entregador.

---

## 2. Backend

O backend será dividido em camadas:

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

Recebem requisições HTTP, validam autenticação/autorização e chamam os services.

### Services

Concentram regras de negócio, como cálculo de taxa, validação de status, criação de pedido e aceite de entrega.

### Repositories

Isolam o acesso ao PostgreSQL. Mesmo que a implementação use SQL puro, a camada Repository evita que regras de negócio fiquem misturadas com comandos de banco.

### Models/Entities

Representam as entidades do domínio e as tabelas principais do banco. Caso o projeto não utilize ORM, esta camada pode representar estruturas de domínio e documentação das entidades.

### Schemas

Validam entrada e saída da API usando Pydantic.

---

## 3. Frontend

O frontend será organizado em:

```text
src/
├── components/
├── pages/
├── services/
├── hooks/
├── routes/
├── contexts/
├── assets/
└── styles/
```

### Pages

Telas principais, como Login, Cadastro, Produtos, Meus Pedidos, Pedidos da Empresa e Entregas Disponíveis.

### Services

Comunicação com a API.

### Contexts

Estado global de autenticação e usuário logado.

### Routes

Rotas públicas e privadas por perfil.

---

## 4. Banco de Dados

O banco utilizado será PostgreSQL.

A modelagem principal será composta por:

- roles
- users
- companies
- company_addresses
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

A modelagem foi simplificada em relação a uma solução comercial completa, removendo permissões por ação e vínculo N:N entre usuários e roles. Para o MVP, cada usuário possui apenas uma role principal em `users.role_id`.

---

## 5. Autenticação e autorização

A autenticação será baseada em login com e-mail e senha.

Após login, a API retorna um token JWT. O frontend armazena o token e envia nas próximas requisições no header:

```text
Authorization: Bearer <token>
```

A autorização será baseada em `role_id`:

| role_id | Perfil |
|---|---|
| 1 | Admin |
| 2 | Empresa |
| 3 | Entregador |
| 4 | Cliente |

---

## 6. Design Patterns

### Repository Pattern

Usado para isolar acesso ao banco.

### Strategy Pattern

Usado para cálculo da taxa de entrega.

### State Pattern ou validação de estado

Usado para controlar transições de status do pedido e da entrega.

---

## 7. Rotas previstas

### Auth

- POST /api/auth/register
- POST /api/auth/login
- GET /api/auth/me

### Companies

- POST /api/companies
- GET /api/companies
- GET /api/companies/me
- PUT /api/companies/me

### Products

- POST /api/products
- GET /api/products
- GET /api/products/{id}
- PUT /api/products/{id}
- DELETE /api/products/{id}

### Customer Addresses

- POST /api/customer-addresses
- GET /api/customer-addresses/me

### Orders

- POST /api/orders
- GET /api/orders/my
- GET /api/orders/company
- GET /api/orders/{id}
- PATCH /api/orders/{id}/accept
- PATCH /api/orders/{id}/reject
- PATCH /api/orders/{id}/status

### Deliveries

- GET /api/deliveries/available
- PATCH /api/deliveries/{id}/accept
- PATCH /api/deliveries/{id}/status
- PATCH /api/deliveries/{id}/location
- GET /api/deliveries/{id}/tracking
