# DishDash — Delivery System

DishDash é um sistema de delivery voltado para comida, com perfis de cliente, empresa/restaurante, entregador e administrador.

O projeto possui:

- backend em **FastAPI**;
- frontend em **React + Vite**;
- banco principal em **PostgreSQL**;
- eventos em tempo real com **Redis Pub/Sub**;
- WebSockets para pedidos, entregas e rastreamento;
- cálculo de entrega usando distância real por ruas via **OSRM**;
- mapas com **OpenStreetMap/Leaflet**;
- preenchimento de endereço com **ViaCEP** e geocodificação com **Nominatim**.

## Estrutura esperada do repositório

```text
delivery-system/
├── backend/
│   ├── app/
│   ├── requirements.txt
│   ├── Dockerfile
│   └── README.md
├── frontend/
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   ├── nginx.conf
│   └── README.md
├── docker-compose.yml
└── README.md
```

## Pré-requisitos

Para rodar localmente sem Docker total:

- Python 3.11
- Node.js 20 ou superior
- Docker Desktop

Para rodar tudo via Docker Compose:

- Docker Desktop
- Docker Compose

## Clonando o projeto

```bash
git clone --recurse-submodules <url-do-repositorio>
cd delivery-system
```

## Rodando tudo com Docker Compose

Na raiz do projeto, rode:

```bash
docker compose up --build
```

Isso sobe:

- PostgreSQL em `localhost:5432`;
- Redis em `localhost:6379`;
- backend em `localhost:8000`;
- frontend em `localhost:5173`.

Acesse:

```text
Frontend: http://localhost:5173
Backend:  http://localhost:8000
Swagger:  http://localhost:8000/docs
```

Para parar os containers:

```bash
docker compose down
```

Para parar e remover os volumes do banco/redis:

```bash
docker compose down -v
```

## Rodando localmente em modo desenvolvimento

Este modo é recomendado enquanto estiver programando, porque backend e frontend ficam com reload/hot reload.

### 1. Subir PostgreSQL e Redis

Na raiz do projeto:

```bash
docker compose up -d postgres redis
```

### 2. Configurar backend

Entre na pasta do backend:

```bash
cd backend
```

Crie o `.env`:

```env
APP_NAME=Delivery System API
APP_ENV=development
APP_VERSION=0.1.0
API_PREFIX=/api

DATABASE_URL=postgresql+asyncpg://delivery_user:delivery_pass@localhost:5432/delivery_db
REDIS_URL=redis://localhost:6379/0
DATABASE_ECHO=false

AUTO_CREATE_TABLES=true
VERIFY_TABLES_ON_STARTUP=true

CORS_ORIGINS=["http://localhost:5173","http://localhost:4173","http://localhost:3000"]

SECRET_KEY=change-me-in-development
ACCESS_TOKEN_EXPIRE_MINUTES=1440
JWT_ALGORITHM=HS256

VIACEP_BASE_URL=https://viacep.com.br/ws
NOMINATIM_BASE_URL=https://nominatim.openstreetmap.org
NOMINATIM_EMAIL=
GEOCODING_USER_AGENT=DeliverySystemAPI/0.1.0

OSRM_BASE_URL=https://router.project-osrm.org
ROUTE_DISTANCE_OSRM_ENABLED=true
ROUTE_DISTANCE_TIMEOUT_SECONDS=6
EXTERNAL_API_TIMEOUT_SECONDS=8
```

Crie e ative o ambiente virtual:

```bash
python -m venv venv
source venv/Scripts/activate
```

No Linux/macOS, use:

```bash
source venv/bin/activate
```

Instale as dependências:

```bash
pip install -r requirements.txt
```

Rode o backend:

```bash
uvicorn app.main:app --reload
```

### 3. Configurar frontend

Em outro terminal, entre na pasta do frontend:

```bash
cd frontend
```

Crie o `.env`:

```env
VITE_APP_NAME=DishDash
VITE_API_URL=http://localhost:8000/api
VITE_WS_URL=ws://localhost:8000
```

Instale as dependências:

```bash
npm install
```

Rode o frontend:

```bash
npm run dev
```

Acesse:

```text
http://localhost:5173
```

## Serviços externos usados

### ViaCEP

Usado para preencher endereço a partir do CEP.

### Nominatim / OpenStreetMap

Usado pelo backend para transformar endereço em coordenadas.

### OSRM

Usado pelo backend para calcular distância real por ruas entre o endereço da empresa e o endereço do cliente.

A taxa de entrega é calculada com base nessa distância real. Se o OSRM falhar, o backend usa cálculo aproximado por Haversine como fallback.

### Redis Pub/Sub

Usado para eventos em tempo real, como:

- pedido criado;
- pedido cancelado;
- pedido atualizado;
- entrega disponível;
- entrega aceita;
- entrega finalizada.

O PostgreSQL continua sendo a fonte oficial dos dados. O Redis não substitui o banco principal.

## Comandos úteis

Subir apenas banco e Redis:

```bash
docker compose up -d postgres redis
```

Ver logs do backend:

```bash
docker compose logs -f backend
```

Ver logs do frontend:

```bash
docker compose logs -f frontend
```

Ver logs do Redis:

```bash
docker compose logs -f redis
```

Rebuildar tudo:

```bash
docker compose up --build
```

Rodar testes do backend localmente:

```bash
cd backend
pytest -q
```

## Observações importantes

- Em desenvolvimento local, use `localhost` nas URLs do `.env`.
- Dentro do Docker Compose, o backend acessa o PostgreSQL pelo host `postgres` e o Redis pelo host `redis`.
- O frontend precisa ser buildado com `VITE_API_URL=http://localhost:8000/api`, porque quem acessa essa URL é o navegador do usuário.
- O código de confirmação de entrega não deve ser salvo no Redis; ele é gerado/validado pelo backend.
