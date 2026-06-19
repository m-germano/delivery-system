# Planejamento Inicial — Sistema de Delivery

## 1. Visão geral

O projeto consiste em um sistema de delivery para conectar clientes, empresas/restaurantes e entregadores. O cliente poderá visualizar produtos, montar pedidos e acompanhar o andamento da entrega. A empresa poderá gerenciar seus produtos e pedidos recebidos. O entregador poderá ficar disponível para entregas, aceitar corridas e atualizar o status da entrega.

## 2. Problema de negócio

A operação de delivery depende da consistência das informações entre os três atores principais: cliente, empresa e entregador. O sistema precisa evitar divergências de status, permitir cálculo de taxa de entrega e organizar o fluxo do pedido desde a criação até a conclusão da entrega.

## 3. Escopo do MVP

O MVP terá autenticação simplificada por perfil, cadastro/listagem de produtos, criação de pedido, cálculo de taxa por distância simulada, atualização de status e listagem de pedidos por usuário.

## 4. Fora do escopo inicial

- Pagamento online real.
- Integração real com mapas.
- Chat em tempo real.
- Aplicativo mobile.
- Otimização avançada de rotas.

## 5. Tecnologias

- Backend: Python + FastAPI.
- Frontend: React + JavaScript + Vite.
- Banco de dados: PostgreSQL.
- Testes: Pytest no backend.
- Documentação: Markdown e PlantUML.

## 6. Design Pattern previsto

Será utilizado o padrão **Strategy** para o cálculo da taxa de entrega. Dessa forma, a regra de cálculo poderá ser alterada futuramente sem modificar o fluxo principal de criação do pedido.
