# DishDash — Delivery System

DishDash é um sistema de delivery de comida desenvolvido com backend em **FastAPI**, frontend em **React + Vite**, banco de dados **PostgreSQL**, eventos em tempo real com **Redis Pub/Sub**, mapas com **OpenStreetMap/Leaflet**, cálculo de rota com **OSRM** e pagamento online com **Mercado Pago Checkout Pro**.

O sistema trabalha com quatro perfis:

- Cliente;
- Empresa/restaurante;
- Entregador;
- Administrador.

---

## Sumário

- [Escopo do MVP](#escopo-do-mvp)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Pré-requisitos](#pré-requisitos)
- [Clonando o projeto](#clonando-o-projeto)
- [Configuração de ambiente](#configuração-de-ambiente)
- [Rodar tudo com Docker Compose](#rodar-tudo-com-docker-compose)
- [URLs da aplicação](#urls-da-aplicação)
- [Mercado Pago com ngrok](#mercado-pago-com-ngrok)
- [Rodar em modo desenvolvimento](#rodar-em-modo-desenvolvimento)
- [Testes](#testes)
- [Comandos úteis](#comandos-úteis)
- [Fluxo para apresentação](#fluxo-para-apresentação)
- [Git e submodules](#git-e-submodules)
- [Troubleshooting](#troubleshooting)
- [Observações importantes](#observações-importantes)

---

## Escopo do MVP

O MVP contempla:

- cadastro e login;
- autenticação JWT;
- controle de acesso por perfil;
- cadastro de empresa/restaurante;
- cadastro de endereço da empresa;
- abertura e fechamento manual da loja;
- cadastro de categorias e produtos;
- cadastro de endereço do cliente;
- pedido para delivery ou retirada;
- cálculo de subtotal, desconto, taxa de entrega e total;
- cálculo de distância por rota com fallback;
- pedido mínimo por empresa;
- pagamento presencial;
- pagamento online com Mercado Pago Checkout Pro;
- conexão da empresa com Mercado Pago por OAuth;
- webhook de pagamento Mercado Pago;
- aceite, recusa e cancelamento de pedido pela empresa;
- cancelamento ou reembolso de pedido pago online quando aplicável;
- fluxo de entrega com entregador;
- rastreamento de entrega;
- código de confirmação para entrega;
- código de confirmação para retirada;
- avaliação da empresa pelo cliente;
- histórico de status;
- testes automatizados.

---

## Estrutura do repositório

Estrutura esperada do `main-repo`:

```text
main-repo/
├── .github/
│   └── workflows/
│       └── update-submodules.yml
├── backend/
├── docs/
│   ├── fase-1/
│   │   ├── historias-usuario.md
│   │   ├── planejamento-inicial.md
│   │   └── requisitos.md
│   └── fase-2/
│       ├── arquitetura.md
│       ├── diagrama-classes.puml
│       ├── diagrama-usecase-cliente-empresa.puml
│       ├── diagrama-usecase-entregador.puml
│       └── schema-postgres.sql
├── frontend/
├── .env.example
├── .gitignore
├── .gitmodules
├── docker-compose.yml
└── README.md
```

> `backend/` e `frontend/` podem estar configurados como submodules. Nesse caso, alterações dentro deles precisam ser commitadas nos próprios repositórios e depois o ponteiro do submodule precisa ser atualizado no `main-repo`.

---

## Pré-requisitos

Para rodar tudo via Docker:

- Docker Desktop;
- Docker Compose;
- Git;
- ngrok, apenas se for testar Mercado Pago Checkout Pro real.

Para rodar em modo desenvolvimento sem containerizar tudo:

- Python 3.11+;
- Node.js 20+;
- Docker Desktop;
- Git.

---

## Clonando o projeto

Clone com submodules:

```bash
git clone --recurse-submodules https://github.com/m-germano/delivery-system
cd delivery-system
```

Se você já clonou sem submodules:

```bash
git submodule update --init --recursive
```

Verifique o status:

```bash
git submodule status
```

---

## Configuração de ambiente

Na raiz do `delivery-system`, crie o arquivo `.env` a partir do exemplo:

```bash
cp .env.example .env
```

No Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

O arquivo `.env` da raiz é usado pelo `docker-compose.yml`.

### Variáveis essenciais

Preencha pelo menos:

```env
SECRET_KEY=
TOKEN_ENCRYPTION_KEY=

MERCADO_PAGO_CLIENT_ID=
MERCADO_PAGO_CLIENT_SECRET=
MERCADO_PAGO_WEBHOOK_SECRET=
```

### Gerar TOKEN_ENCRYPTION_KEY

A `TOKEN_ENCRYPTION_KEY` precisa ser uma chave Fernet válida. Ela é usada para criptografar tokens OAuth do Mercado Pago.

No Windows, Linux ou macOS:

```bash
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

Exemplo de formato:

```env
TOKEN_ENCRYPTION_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
```

Não use aspas ao colar a chave no `.env`.

---

## Exemplo de `.env` para Docker

Use este modelo na raiz do `main-repo`:

```env
# =============================================================================
# APP
# =============================================================================

APP_NAME=Delivery System API
APP_ENV=development
APP_VERSION=0.1.0
API_PREFIX=/api


# =============================================================================
# DATABASE - Docker
# =============================================================================

POSTGRES_DB=delivery_db
POSTGRES_USER=delivery_user
POSTGRES_PASSWORD=delivery_pass
DATABASE_URL=postgresql+asyncpg://delivery_user:delivery_pass@postgres:5432/delivery_db
DATABASE_ECHO=false

AUTO_CREATE_TABLES=true
VERIFY_TABLES_ON_STARTUP=true


# =============================================================================
# REDIS - Docker
# =============================================================================

REDIS_URL=redis://redis:6379/0


# =============================================================================
# CORS
# =============================================================================

CORS_ORIGINS=["http://localhost:5173","http://127.0.0.1:5173","http://localhost:4173","http://localhost:3000"]


# =============================================================================
# AUTH / JWT
# =============================================================================

SECRET_KEY=troque-esta-chave-local-com-mais-de-32-caracteres
ACCESS_TOKEN_EXPIRE_MINUTES=1440
JWT_ALGORITHM=HS256


# =============================================================================
# EXTERNAL APIS
# =============================================================================

VIACEP_BASE_URL=https://viacep.com.br/ws
NOMINATIM_BASE_URL=https://nominatim.openstreetmap.org
OSRM_BASE_URL=https://router.project-osrm.org
USE_REAL_ROUTE_DISTANCE=true
GEOCODING_USER_AGENT=DeliverySystemAPI/0.1.0
NOMINATIM_EMAIL=
EXTERNAL_API_TIMEOUT_SECONDS=8


# =============================================================================
# CRYPTO
# =============================================================================

TOKEN_ENCRYPTION_KEY=cole-aqui-uma-chave-fernet-valida


# =============================================================================
# FRONTEND
# =============================================================================

FRONTEND_BASE_URL=http://localhost:5173
FRONTEND_MERCADO_PAGO_SUCCESS_URL=http://localhost:5173/company/mercado-pago?connected=true
FRONTEND_MERCADO_PAGO_ERROR_URL=http://localhost:5173/company/mercado-pago?connected=false

VITE_APP_NAME=DishDash
VITE_API_URL=http://localhost:8000/api
VITE_WS_URL=ws://localhost:8000
VITE_OSRM_BASE_URL=https://router.project-osrm.org


# =============================================================================
# MERCADO PAGO / NGROK
# =============================================================================

BACKEND_PUBLIC_URL=https://seu-dominio-ngrok.ngrok-free.dev

MERCADO_PAGO_CLIENT_ID=
MERCADO_PAGO_CLIENT_SECRET=
MERCADO_PAGO_USE_PKCE=true

MERCADO_PAGO_REDIRECT_URI=https://seu-dominio-ngrok.ngrok-free.dev/api/payment-accounts/mercado-pago/callback
MERCADO_PAGO_WEBHOOK_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/webhook

MERCADO_PAGO_OAUTH_AUTHORIZE_URL=https://auth.mercadopago.com.br/authorization
MERCADO_PAGO_OAUTH_TOKEN_URL=https://api.mercadopago.com/oauth/token
MERCADO_PAGO_PAYMENTS_URL=https://api.mercadopago.com/v1/payments
MERCADO_PAGO_CHECKOUT_PREFERENCES_URL=https://api.mercadopago.com/checkout/preferences

MERCADO_PAGO_WEBHOOK_SECRET=
MERCADO_PAGO_WEBHOOK_TOLERANCE_SECONDS=600
MERCADO_PAGO_PIX_EXPIRATION_MINUTES=30

MERCADO_PAGO_CHECKOUT_SUCCESS_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=success
MERCADO_PAGO_CHECKOUT_FAILURE_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=failure
MERCADO_PAGO_CHECKOUT_PENDING_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=pending
```

---

## Rodar tudo com Docker Compose

Na raiz do `main-repo`:

```bash
docker compose up --build
```

Isso sobe:

- PostgreSQL;
- Redis;
- Backend FastAPI;
- Frontend React/Vite servido via Nginx.

Acesse:

```text
Frontend: http://localhost:5173
Backend:  http://localhost:8000
Swagger:  http://localhost:8000/docs
API base: http://localhost:8000/api
WebSocket: ws://localhost:8000
```

Para parar:

```bash
docker compose down
```

Para parar e apagar volumes do PostgreSQL e Redis:

```bash
docker compose down -v
```

> Use `docker compose down -v` apenas quando quiser zerar o banco local.

---

## URLs da aplicação

### No navegador

```text
Frontend: http://localhost:5173
Backend:  http://localhost:8000
Swagger:  http://localhost:8000/docs
```

### Dentro da rede Docker

O backend acessa os serviços por nome:

```text
PostgreSQL: postgres:5432
Redis:      redis:6379
```

Por isso, dentro do Docker, use:

```env
DATABASE_URL=postgresql+asyncpg://delivery_user:delivery_pass@postgres:5432/delivery_db
REDIS_URL=redis://redis:6379/0
```

Não use `localhost` para PostgreSQL ou Redis dentro do container do backend.

### Frontend

O frontend usa:

```env
VITE_API_URL=http://localhost:8000/api
VITE_WS_URL=ws://localhost:8000
```

Isso está correto porque quem acessa essas URLs é o navegador do usuário, fora da rede Docker.

---

## Mercado Pago com ngrok

Para testar Mercado Pago Checkout Pro real, o backend precisa estar acessível por uma URL HTTPS pública.

### Subir ngrok

Com domínio fixo:

```bash
ngrok http --url=seu-dominio-ngrok.ngrok-free.dev 8000
```

Exemplo:

```bash
ngrok http --url=fifty-eagle-unearned.ngrok-free.dev 8000
```

Em outro terminal, rode a aplicação:

```bash
docker compose up --build
```

### Configuração no painel Mercado Pago

Configure o Redirect URI OAuth:

```text
https://seu-dominio-ngrok.ngrok-free.dev/api/payment-accounts/mercado-pago/callback
```

Configure o webhook:

```text
https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/webhook
```

Eventos do webhook:

```text
[x] Pagamentos
[ ] Vinculação de aplicações
```

### URLs de retorno do Checkout Pro

As URLs de retorno do Checkout Pro devem apontar para o backend público via ngrok:

```env
MERCADO_PAGO_CHECKOUT_SUCCESS_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=success
MERCADO_PAGO_CHECKOUT_FAILURE_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=failure
MERCADO_PAGO_CHECKOUT_PENDING_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=pending
```

O backend recebe o retorno público do Mercado Pago e redireciona o usuário para o frontend local definido em:

```env
FRONTEND_BASE_URL=http://localhost:5173
```

### Fluxo Mercado Pago

1. Empresa acessa a tela de integração.
2. Backend gera URL OAuth do Mercado Pago.
3. Empresa autoriza a integração.
4. Mercado Pago retorna para `/api/payment-accounts/mercado-pago/callback`.
5. Backend salva os tokens criptografados.
6. Cliente escolhe pagamento online.
7. Backend cria preferência Checkout Pro.
8. Frontend redireciona cliente para Mercado Pago.
9. Mercado Pago envia webhook para o backend.
10. Backend consulta/valida pagamento.
11. Pedido é liberado para empresa após aprovação.

---

## Rodar em modo desenvolvimento

Este modo é útil quando você quer hot reload no backend e no frontend.

### 1. Subir apenas PostgreSQL e Redis

Na raiz:

```bash
docker compose up -d postgres redis
```

### 2. Rodar backend localmente

Entre na pasta do backend:

```bash
cd backend
```

Crie e ative o ambiente virtual:

```bash
python -m venv venv
source venv/Scripts/activate
```

No Linux/macOS:

```bash
source venv/bin/activate
```

Instale dependências:

```bash
pip install -r requirements.txt
```

Crie `backend/.env` com URLs locais:

```env
DATABASE_URL=postgresql+asyncpg://delivery_user:delivery_pass@localhost:5432/delivery_db
REDIS_URL=redis://localhost:6379/0
CORS_ORIGINS=["http://localhost:5173","http://localhost:4173","http://localhost:3000"]
```

Rode:

```bash
uvicorn app.main:create_app --factory --host 0.0.0.0 --port 8000 --reload
```

Se o seu backend estiver configurado sem factory, use:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### 3. Rodar frontend localmente

Em outro terminal:

```bash
cd frontend
npm install
npm run dev
```

Arquivo `frontend/.env`:

```env
VITE_APP_NAME=DishDash
VITE_API_URL=http://localhost:8000/api
VITE_WS_URL=ws://localhost:8000
VITE_OSRM_BASE_URL=https://router.project-osrm.org
```

Acesse:

```text
http://localhost:5173
```

---

## Testes

### Backend

Entre no backend:

```bash
cd backend
```

Rode todos os testes comuns:

```bash
pytest -q
```

Rodar testes específicos de pagamento:

```bash
pytest tests/test_mercado_pago_pix_payment_service.py tests/test_mercado_pago_webhook_signature.py -q
```

Rodar E2E real, quando aplicável:

```bash
RUN_LIVE_E2E=true pytest tests/e2e/test_full_delivery_lifecycle_live.py -q
```

No PowerShell:

```powershell
$env:RUN_LIVE_E2E="true"
pytest tests/e2e/test_full_delivery_lifecycle_live.py -q
```

O E2E real exige backend, PostgreSQL e Redis rodando.

### Frontend

Entre no frontend:

```bash
cd frontend
```

Instale dependências:

```bash
npm install
```

Build:

```bash
npm run build
```

---

## Comandos úteis

Subir tudo:

```bash
docker compose up --build
```

Subir em background:

```bash
docker compose up -d --build
```

Parar:

```bash
docker compose down
```

Parar e apagar volumes:

```bash
docker compose down -v
```

Ver logs do backend:

```bash
docker compose logs -f backend
```

Ver logs do frontend:

```bash
docker compose logs -f frontend
```

Ver logs do PostgreSQL:

```bash
docker compose logs -f postgres
```

Ver logs do Redis:

```bash
docker compose logs -f redis
```

Rebuildar apenas backend:

```bash
docker compose up -d --build backend
```

Rebuildar apenas frontend:

```bash
docker compose up -d --build frontend
```

Validar compose:

```bash
docker compose config
```

---

## Fluxo para apresentação

1. Subir ngrok para o backend, se for demonstrar Mercado Pago.
2. Subir a aplicação com Docker Compose.
3. Acessar o frontend.
4. Cadastrar usuário empresa.
5. Cadastrar empresa/restaurante.
6. Cadastrar endereço da empresa.
7. Cadastrar produtos.
8. Abrir a loja.
9. Conectar Mercado Pago na empresa, se for demonstrar pagamento online.
10. Cadastrar usuário cliente.
11. Cadastrar endereço do cliente.
12. Criar pedido delivery ou retirada.
13. Escolher pagamento presencial ou online.
14. Em pagamento online, finalizar no Checkout Pro.
15. Aguardar webhook/atualização do status.
16. Empresa aceitar pedido.
17. Empresa atualizar preparo.
18. Em delivery, liberar para entregador.
19. Entregador aceitar e finalizar com código.
20. Cliente avaliar a empresa.
21. Rodar testes ou mostrar Swagger.

---

## Git e submodules

Como `backend` e `frontend` podem ser submodules, o fluxo correto é:

### Commitar alteração no backend

```bash
cd backend
git add -A
git commit -m "fix(payment): corrigir fluxo Mercado Pago com Checkout Pro"
git push origin develop
```

Voltar para o main-repo e atualizar ponteiro:

```bash
cd ..
git add backend
git commit -m "chore: atualizar submodule backend"
git push origin main
```

### Commitar alteração no frontend

```bash
cd frontend
git add -A
git commit -m "fix(checkout): corrigir finalização com Checkout Pro"
git push origin develop
```

Voltar para o main-repo e atualizar ponteiro:

```bash
cd ..
git add frontend
git commit -m "chore: atualizar submodule frontend"
git push origin main
```

### Commitar ajustes do repositório principal

Para `docker-compose.yml`, `.env.example`, `.gitignore`, README ou docs:

```bash
git add docker-compose.yml .env.example .gitignore README.md docs
git commit -m "fix(repo): configurar Docker para Checkout Pro"
git push origin main
```

---

## Troubleshooting

### Porta 6379 ocupada

Erro:

```text
Bind for 0.0.0.0:6379 failed: port is already allocated
```

Solução recomendada: não expor Redis para a máquina local. O backend acessa Redis pela rede interna Docker usando:

```env
REDIS_URL=redis://redis:6379/0
```

Se precisar investigar:

```bash
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
```

No Windows:

```powershell
netstat -ano | findstr :6379
```

### Erro de CORS no frontend

Se o navegador mostrar CORS, verifique primeiro se o backend não gerou erro 500.

Logs:

```bash
docker compose logs backend --tail=150
```

CORS esperado no `.env`:

```env
CORS_ORIGINS=["http://localhost:5173","http://127.0.0.1:5173","http://localhost:4173","http://localhost:3000"]
```

### `/api/auth/me` retorna 401 após subir Docker

Limpe sessão antiga do navegador:

```js
localStorage.clear();
sessionStorage.clear();
location.href = '/login';
```

Isso costuma ocorrer quando o navegador mantém token antigo, mas o backend Docker está usando outro `SECRET_KEY` ou outro banco.

### `/api/companies/me` retorna 404

O usuário empresa está logado, mas ainda não tem empresa cadastrada no banco atual. Cadastre a empresa antes de tentar conectar Mercado Pago.

### Erro com TOKEN_ENCRYPTION_KEY

Teste dentro do container:

```bash
docker compose exec backend python -c "import os; from cryptography.fernet import Fernet; key=os.getenv('TOKEN_ENCRYPTION_KEY'); print(bool(key)); Fernet(key.encode()); print('FERNET_OK')"
```

Se não aparecer `FERNET_OK`, gere nova chave Fernet e atualize o `.env`.

Se já existiam tokens Mercado Pago salvos com outra chave, será necessário reconectar a conta Mercado Pago ou limpar o banco local.

### Mercado Pago não conecta

Verifique:

```env
MERCADO_PAGO_CLIENT_ID=
MERCADO_PAGO_CLIENT_SECRET=
MERCADO_PAGO_REDIRECT_URI=
MERCADO_PAGO_WEBHOOK_URL=
TOKEN_ENCRYPTION_KEY=
```

Verifique também se o ngrok está ativo:

```text
https://seu-dominio-ngrok.ngrok-free.dev/docs
```

### Mercado Pago retorna erro nas back_urls

Não use `localhost` nas URLs de retorno enviadas ao Mercado Pago. Use a URL pública do backend via ngrok:

```env
MERCADO_PAGO_CHECKOUT_SUCCESS_URL=https://seu-dominio-ngrok.ngrok-free.dev/api/payments/mercado-pago/checkout-return?order_id={order_id}&mp_result=success
```

---

## Observações importantes

- Não commitar `.env`.
- Commitar apenas `.env.example`.
- Trocar credenciais expostas em prints, logs ou conversas.
- `TOKEN_ENCRYPTION_KEY` precisa permanecer estável enquanto houver tokens criptografados no banco.
- Se trocar `TOKEN_ENCRYPTION_KEY`, tokens Mercado Pago antigos não poderão ser descriptografados.
- Dentro do Docker, PostgreSQL é `postgres:5432`.
- Dentro do Docker, Redis é `redis:6379`.
- No navegador, a API é `http://localhost:8000/api`.
- Para Checkout Pro real, o backend precisa estar exposto em HTTPS público.
- O PostgreSQL é a fonte oficial dos dados.
- Redis é usado apenas para eventos em tempo real.
- O código de confirmação de entrega/retirada é gerado e validado pelo backend.
