# Planejamento Inicial — DishDash

## 1. Objetivo

Desenvolver um sistema de delivery para a disciplina de Laboratório de Engenharia de Software, com backend em FastAPI, frontend em React/Vite e banco de dados PostgreSQL.

O MVP cobre o fluxo principal entre três perfis:

1. Empresa/restaurante.
2. Cliente.
3. Entregador.

A entrega final demonstra requisitos, histórias de usuário, UML, arquitetura em camadas, banco relacional, autenticação por perfil, fluxo de pedido, entrega, pagamento online, avaliação e testes.

---

## 2. Problema de negócio

Um pedido de delivery depende de informações consistentes entre cliente, loja e entregador. A loja precisa controlar se está aberta, receber pedidos, aceitar ou recusar, preparar e liberar a entrega. O cliente precisa escolher produtos, pagar, acompanhar o pedido e avaliar a empresa. O entregador precisa ficar disponível, aceitar a entrega e finalizar com segurança.

O sistema organiza esse fluxo em uma API central, com regras de negócio no backend, persistência no PostgreSQL e interface separada por perfil no frontend.

---

## 3. Atores

### Empresa

Cadastra a loja, endereço, produtos, regras de atendimento, status de funcionamento, integração Mercado Pago, pedidos recebidos e avaliações.

### Cliente

Visualiza lojas e produtos, cadastra endereço, cria pedidos, escolhe delivery ou retirada, paga online ou na entrega, acompanha o pedido e avalia a empresa.

### Entregador

Marca disponibilidade, visualiza entregas disponíveis, aceita corridas, atualiza localização e finaliza entrega com código de confirmação.

---

## 4. Escopo do MVP

O MVP contempla:

- cadastro e login;
- controle de acesso por perfil;
- cadastro de empresa e endereço;
- abertura e fechamento manual da loja;
- cadastro de categorias e produtos;
- cadastro de endereço do cliente;
- pedido delivery e retirada;
- cálculo de subtotal, desconto, taxa e total;
- cálculo de distância por rota;
- pedido mínimo por empresa;
- aceite, recusa e cancelamento de pedido;
- status controlado de pedido e entrega;
- código de confirmação para entrega e retirada;
- disponibilidade do entregador;
- listagem e aceite de entregas;
- rastreamento de entrega;
- pagamento online com Mercado Pago Checkout Pro;
- conexão da empresa com Mercado Pago por OAuth;
- webhook de pagamento;
- avaliação da empresa pelo cliente;
- histórico de status;
- testes automatizados unitários, realtime e E2E.

---

## 5. Fora do escopo

Não fazem parte desta entrega:

- aplicativo mobile;
- chat;
- cupons;
- notificação push;
- painel administrativo dedicado;
- otimização avançada de rotas;
- área de entrega por bairro;
- sistema completo de permissões por ação.

---

## 6. Fluxo principal do pedido

1. A empresa cria uma conta.
2. A empresa cadastra loja, endereço e produtos.
3. A empresa define se aceita delivery, retirada ou ambos.
4. A empresa abre a loja manualmente.
5. O cliente cria uma conta.
6. O cliente cadastra endereço de entrega.
7. O cliente visualiza lojas abertas, escolhe produtos e seleciona delivery ou retirada.
8. O sistema calcula subtotal, desconto, taxa de entrega e total.
9. O cliente escolhe pagamento presencial ou pagamento online pelo Mercado Pago Checkout Pro.
10. Se for pagamento online, o backend cria o pedido como `AGUARDANDO_PAGAMENTO` e retorna o link do Checkout Pro.
11. Após aprovação no Mercado Pago, o webhook libera o pedido para a empresa.
12. Se for pagamento presencial, o pedido já entra como `ABERTO`.
13. A empresa aceita ou recusa o pedido.
14. Ao aceitar, o pedido passa para `ACEITO` e depois `EM_PREPARO`.
15. Em pedido delivery, a empresa libera para `AGUARDANDO_ENTREGADOR`.
16. Um entregador disponível aceita a entrega.
17. O pedido passa para `EM_ENTREGA`.
18. O cliente acompanha o pedido e visualiza o código de confirmação.
19. O entregador finaliza a entrega com o código correto.
20. O pedido fica `ENTREGUE`.
21. O cliente pode avaliar a empresa.

### Fluxo de retirada

1. O cliente escolhe retirada na loja.
2. O pedido não exige endereço do cliente.
3. O pedido não gera taxa de entrega.
4. O pedido não aparece para entregadores.
5. A empresa prepara e marca como `PRONTO_PARA_RETIRADA`.
6. O cliente informa o código de retirada.
7. A empresa confirma o código.
8. O pedido fica `RETIRADO`.

---

## 7. Regras de negócio

- Cada usuário possui uma role principal.
- A empresa só recebe novos pedidos quando `is_open = true`.
- Loja fechada pode ser visualizada, mas não aceita cálculo ou criação de pedido.
- Um usuário com perfil Empresa possui apenas uma empresa.
- Um pedido pertence a apenas uma empresa.
- Todos os itens do pedido devem pertencer à empresa escolhida.
- O item do pedido salva nome e preço do produto no momento da compra.
- Produtos desativados não aparecem como disponíveis para o cliente.
- Pedido delivery exige endereço do cliente.
- Pedido de retirada não exige endereço do cliente e não gera entrega.
- Pedido de retirada pode ter desconto configurado pela empresa.
- A taxa de entrega usa distância por rota, com fallback aproximado.
- O fluxo de status impede transições inválidas.
- O histórico de status do pedido deve ser preservado.
- O histórico de status da entrega deve ser preservado.
- Código de entrega ou retirada deve ser validado antes da finalização.
- O cliente só pode avaliar pedidos concluídos.
- Um pedido só pode receber uma avaliação.
- Pagamentos online só ficam disponíveis quando a empresa tem Mercado Pago conectado.
- Tokens do Mercado Pago devem ser criptografados.
- O webhook precisa consultar ou validar o pagamento antes de liberar o pedido.

---

## 8. Tecnologias

| Responsabilidade | Tecnologia |
|---|---|
| Backend | Python + FastAPI |
| Frontend | React + Vite |
| Banco de dados | PostgreSQL |
| ORM | SQLAlchemy Async |
| Validação | Pydantic |
| Autenticação | JWT |
| Hash de senha | Argon2 |
| Tempo real | Redis Pub/Sub + WebSocket |
| Mapas | Leaflet + OpenStreetMap |
| Endereço | ViaCEP + Nominatim |
| Rotas | OSRM |
| Pagamento online | Mercado Pago Checkout Pro |
| Testes | Pytest |
| UML | PlantUML |
| Versionamento | Git + GitHub |

---

## 9. Design Patterns usados

### Repository Pattern

Separa consultas e comandos de banco das regras de negócio.


---

## 10. Critérios de sucesso do MVP

- Backend executando localmente.
- Frontend executando localmente.
- PostgreSQL e Redis funcionando.
- Login e JWT funcionando.
- Rotas protegidas por perfil.
- Empresa cadastrando loja, endereço e produtos.
- Empresa abrindo e fechando a loja.
- Cliente criando pedido.
- Mercado Pago Checkout Pro funcionando no fluxo online.
- Empresa aceitando e atualizando pedido.
- Entregador aceitando e finalizando entrega.
- Cliente avaliando empresa.
- Testes unitários, realtime e E2E executáveis.
- README principal orientando a apresentação e execução.
- UML de classes e casos de uso atualizado.
