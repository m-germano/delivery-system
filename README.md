# Delivery System

Sistema de Delivery criado para a disciplina **Laboratório de Engenharia de Software**.

## Objetivo

Construir um MVP de delivery com três perfis principais:

- **Cliente**: visualiza produtos, cria pedidos e acompanha o status.
- **Empresa/Restaurante**: gerencia produtos e acompanha pedidos recebidos.
- **Entregador**: visualiza corridas disponíveis, aceita entregas e atualiza o status.

## Repositórios

- Repositório principal/documentação: `delivery-system`
- Backend FastAPI: `delivery-system-backend`
- Frontend React/Vite: `delivery-system-frontend`

## Estrutura do repositório principal

```txt
delivery-system/
├── backend/                  # submodule: delivery-system-backend
├── frontend/                 # submodule: delivery-system-frontend
├── docs/
│   ├── fase-1/
│   │   ├── planejamento-inicial.md
│   │   ├── requisitos.md
│   │   └── historias-usuario.md
│   └── fase-2/
│       ├── arquitetura.md
│       ├── diagrama-casos-uso.puml
│       └── diagrama-classes.puml
├── docker-compose.yml
├── .gitmodules.example
└── README.md
```

## Como clonar com submodules

```bash
git clone --recurse-submodules https://github.com/m-germano/delivery-system.git
cd delivery-system
```

Caso tenha clonado sem submodules:

```bash
git submodule update --init --recursive
```

## Como rodar localmente com Docker

Depois de adicionar os submodules reais em `backend/` e `frontend/`:

```bash
docker compose up --build
```

Serviços esperados:

- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Swagger/OpenAPI: http://localhost:8000/docs
- PostgreSQL: localhost:5432

## Rotas iniciais da API

| Método | Rota | Descrição |
|---|---|---|
| GET | `/health` | Verifica se a API está online |
| GET | `/api/products` | Lista produtos disponíveis |
| POST | `/api/orders` | Cria pedido inicial |

## Fases do laboratório

### Fase 1 — Concepção

- Elicitação de requisitos.
- Histórias de usuário.
- Requisitos funcionais e não funcionais.
- Backlog inicial.

### Fase 2 — Modelagem

- Diagrama de Casos de Uso.
- Diagrama de Classes de domínio.
- Planejamento da arquitetura.

### Fase 3 — Arquitetura

- Backend FastAPI estruturado em Controller, Service, Repository e Model.
- Integração com PostgreSQL.
- Testes unitários com Pytest.

### Fase Final — MVP

- Frontend React consumindo a API.
- Fluxo principal do pedido funcionando.
- Aplicação local demonstrável.
- Pelo menos 1 Design Pattern implementado.
```
