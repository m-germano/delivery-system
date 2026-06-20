# Planejamento Inicial — Sistema de Delivery

## 1. Objetivo

Desenvolver um Sistema de Delivery para a disciplina de Laboratório de Engenharia de Software, utilizando uma API central em Python/FastAPI, frontend em React com Vite e banco de dados PostgreSQL.

O sistema tem como objetivo conectar quatro frentes principais:

1. Admin/Gestor do sistema.
2. Empresa/restaurante parceiro.
3. Cliente que realiza pedidos.
4. Entregador responsável pela corrida.

O escopo será mantido pequeno e compatível com um MVP acadêmico, mas estruturado o suficiente para demonstrar requisitos, arquitetura em camadas, modelagem de banco, autenticação por perfil, fluxo de pedido e entrega.

---

## 2. Problema de negócio

A operação de delivery depende da consistência das informações compartilhadas entre cliente, empresa e entregador. Durante o fluxo de um pedido, a empresa precisa receber e aceitar a solicitação, o cliente precisa acompanhar o andamento e o entregador precisa visualizar corridas disponíveis, aceitar uma entrega e atualizar sua localização/status.

O problema central é organizar esse fluxo em uma única API, garantindo que cada ator tenha acesso apenas às funcionalidades adequadas ao seu perfil e que os estados do pedido sejam atualizados de forma controlada.

---

## 3. Atores

### Admin

Usuário responsável por gestão geral do sistema, consulta de cadastros e apoio administrativo.

### Empresa

Usuário responsável por cadastrar sua empresa/restaurante, manter produtos disponíveis, receber pedidos e atualizar o andamento operacional.

### Cliente

Usuário responsável por visualizar empresas/produtos, cadastrar endereço, criar pedidos e acompanhar o status da entrega.

### Entregador

Usuário responsável por ficar disponível, visualizar entregas disponíveis, aceitar corridas, atualizar localização e concluir entregas.

---

## 4. Escopo do MVP

O MVP contempla:

- Cadastro e login de usuários.
- Controle de perfil por role numérica.
- Cadastro de empresa/restaurante.
- Cadastro de endereço da empresa.
- Cadastro e manutenção de produtos.
- Cadastro de endereço do cliente.
- Criação de pedido com um ou mais produtos.
- Cálculo simplificado da taxa de entrega por distância.
- Aceite/recusa de pedido pela empresa.
- Disponibilização de entrega para entregadores.
- Aceite de entrega pelo entregador.
- Atualização de status do pedido.
- Atualização de status/localização da entrega.
- Consulta do pedido pelo cliente.
- Consulta de corridas disponíveis pelo entregador.

---

## 5. Fora do escopo inicial

Não fazem parte do MVP:

- Pagamento online real.
- Integração com gateway de pagamento.
- Cupons de desconto.
- Chat em tempo real.
- Aplicativo mobile.
- Avaliações de empresa/entregador.
- Notificações push.
- Otimização avançada de rotas.
- Área de entrega por bairro.
- Sistema completo de permissões por ação.

Esses pontos podem ser tratados como evolução futura.

---

## 6. Fluxo principal do pedido

1. A empresa cria uma conta com perfil Empresa.
2. A empresa cadastra os dados do restaurante e seu endereço com latitude/longitude.
3. A empresa cadastra produtos disponíveis.
4. O cliente cria uma conta com perfil Cliente.
5. O cliente cadastra ou informa um endereço de entrega.
6. O cliente seleciona produtos e confirma o pedido.
7. A API calcula subtotal, distância, taxa de entrega e total.
8. O pedido é criado com status `CRIADO`.
9. A empresa visualiza o pedido e aceita ou recusa.
10. Ao aceitar, o pedido passa para `ACEITO` e depois `EM_PREPARO`.
11. Quando o pedido está pronto para entrega, passa para `AGUARDANDO_ENTREGADOR`.
12. A entrega fica disponível para entregadores ativos.
13. Um entregador aceita a entrega.
14. O pedido passa para `EM_ENTREGA`.
15. O entregador atualiza localização/status.
16. O pedido é finalizado como `ENTREGUE`.

---

## 7. Regras de negócio iniciais

- Um usuário possui apenas uma role principal.
- As roles serão armazenadas na tabela `roles`.
- A tabela `users` terá o campo `role_id` como chave estrangeira para `roles`.
- O cliente só pode criar pedidos para empresas ativas.
- Um pedido pertence a apenas uma empresa.
- O carrinho fica no frontend até a confirmação do pedido.
- O pedido só é salvo no banco quando o cliente confirma.
- O item do pedido deve salvar nome e preço do produto no momento da compra.
- A taxa de entrega será calculada por distância.
- A distância poderá ser calculada de forma simplificada no MVP.
- Uma entrega pode começar sem entregador definido.
- O entregador só é vinculado quando aceita a corrida.
- O histórico de status do pedido deve ser armazenado.
- O histórico de status da entrega deve ser armazenado.

---

## 8. Tecnologias

| Responsabilidade | Tecnologia |
|---|---|
| Backend | Python + FastAPI |
| Banco de dados | PostgreSQL |
| Acesso a dados | Repository com SQL/driver PostgreSQL ou ORM, conforme implementação |
| Validação de dados | Pydantic |
| Autenticação | JWT |
| Testes | Pytest |
| Frontend | React + JavaScript |
| Build frontend | Vite |
| Rotas frontend | React Router |
| Requisições HTTP | Axios ou Fetch |
| Mapas | Leaflet + OpenStreetMap |
| Documentação | Markdown |
| UML | PlantUML |
| Versionamento | Git + GitHub |

---

## 9. Design Patterns previstos

### Repository Pattern

Aplicado para separar acesso ao banco de dados da regra de negócio.

### Strategy Pattern

Aplicado no cálculo da taxa de entrega. A regra inicial pode ser simples, mas futuramente pode ser substituída por cálculo via faixas, API externa ou regra promocional.

### State Pattern ou validação de transição de estado

Aplicado no controle de status do pedido e da entrega, evitando mudanças inválidas como sair de `CRIADO` diretamente para `ENTREGUE`.

---

## 10. Critérios de sucesso do MVP

- API executando localmente.
- Banco PostgreSQL criado e populado com roles iniciais.
- Login e autenticação por JWT funcionando.
- Rotas protegidas por perfil.
- Empresa conseguindo cadastrar produtos.
- Cliente conseguindo criar pedido.
- Empresa conseguindo aceitar e atualizar pedido.
- Entregador conseguindo aceitar entrega.
- Cliente conseguindo acompanhar status.
- Testes automatizados cobrindo regra de taxa e transição de status.
