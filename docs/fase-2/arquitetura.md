# Arquitetura Inicial

## Backend

O backend será desenvolvido em FastAPI, dividido em camadas:

- **Controllers**: recebem as requisições HTTP e retornam respostas.
- **Services**: concentram regras de negócio.
- **Repositories**: isolam o acesso ao banco de dados.
- **Models**: representam as tabelas do banco via ORM.
- **Schemas**: validam entrada e saída da API com Pydantic.

## Frontend

O frontend será desenvolvido com React e Vite, dividido em:

- **components**: componentes reutilizáveis.
- **pages**: telas principais.
- **services**: comunicação com a API.
- **hooks**: lógica reutilizável de estado/requisições.
- **routes**: configuração de rotas.
- **styles**: estilos globais.

## Banco de Dados

Será utilizado PostgreSQL com entidades principais: User, Company, Product, Address, Order, OrderItem e Delivery.

## Design Pattern

O padrão Strategy será aplicado no cálculo da taxa de entrega, permitindo trocar a regra de cálculo sem alterar o serviço de pedidos.
