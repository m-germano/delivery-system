# Requisitos — Sistema de Delivery

## 1. Requisitos Funcionais

| Código | Requisito | Ator principal | Prioridade |
|---|---|---|---|
| RF01 | O sistema deve permitir cadastro de usuários. | Cliente, Empresa, Entregador | Must |
| RF02 | O sistema deve permitir login de usuários. | Cliente, Empresa, Entregador, Admin | Must |
| RF03 | O sistema deve autenticar usuários por token JWT. | Sistema | Must |
| RF04 | O sistema deve diferenciar usuários por role: Admin, Empresa, Entregador e Cliente. | Sistema | Must |
| RF05 | O sistema deve permitir que a empresa cadastre seus dados comerciais. | Empresa | Must |
| RF06 | O sistema deve permitir que a empresa cadastre seu endereço com latitude e longitude. | Empresa | Must |
| RF07 | O sistema deve permitir que a empresa cadastre produtos. | Empresa | Must |
| RF08 | O sistema deve permitir que a empresa edite e desative produtos. | Empresa | Must |
| RF09 | O sistema deve permitir que o cliente visualize empresas ativas. | Cliente | Must |
| RF10 | O sistema deve permitir que o cliente visualize produtos disponíveis de uma empresa. | Cliente | Must |
| RF11 | O sistema deve permitir que o cliente cadastre ou informe endereço de entrega. | Cliente | Must |
| RF12 | O sistema deve permitir que o cliente crie pedido com um ou mais produtos. | Cliente | Must |
| RF13 | O sistema deve calcular subtotal, taxa de entrega e total do pedido. | Sistema | Must |
| RF14 | O sistema deve calcular a taxa de entrega com base na distância do endereço da empresa até o endereço do cliente. | Sistema | Must |
| RF15 | O sistema deve permitir que a empresa visualize pedidos recebidos. | Empresa | Must |
| RF16 | O sistema deve permitir que a empresa aceite ou recuse pedidos. | Empresa | Must |
| RF17 | O sistema deve permitir atualização controlada do status do pedido. | Empresa, Entregador | Must |
| RF18 | O sistema deve permitir que entregadores fiquem disponíveis ou indisponíveis. | Entregador | Should |
| RF19 | O sistema deve permitir que entregadores visualizem entregas disponíveis. | Entregador | Must |
| RF20 | O sistema deve permitir que entregadores aceitem entregas. | Entregador | Must |
| RF21 | O sistema deve permitir que entregadores atualizem status da entrega. | Entregador | Must |
| RF22 | O sistema deve permitir que entregadores atualizem sua localização atual. | Entregador | Should |
| RF23 | O sistema deve permitir que o cliente acompanhe o status do pedido. | Cliente | Must |
| RF24 | O sistema deve permitir que o cliente consulte a localização atual do entregador durante a entrega. | Cliente | Should |
| RF25 | O sistema deve registrar histórico de alterações de status do pedido. | Sistema | Must |
| RF26 | O sistema deve registrar histórico de alterações de status da entrega. | Sistema | Should |

---

## 2. Requisitos Não Funcionais

| Código | Requisito | Prioridade |
|---|---|---|
| RNF01 | O backend deve ser desenvolvido em Python com FastAPI. | Must |
| RNF02 | O frontend deve ser desenvolvido em React com Vite. | Must |
| RNF03 | O banco de dados relacional deve ser PostgreSQL. | Must |
| RNF04 | A API deve ser organizada em camadas lógicas: Controller, Service, Repository, Model/Entity e Schema. | Must |
| RNF05 | Senhas devem ser armazenadas usando hash, nunca texto puro. | Must |
| RNF06 | Rotas sensíveis devem exigir autenticação JWT. | Must |
| RNF07 | Rotas administrativas ou operacionais devem validar a role do usuário. | Must |
| RNF08 | O projeto deve possuir README com setup, execução local e guia de rotas. | Must |
| RNF09 | O projeto deve conter diagramas UML de casos de uso e classes. | Must |
| RNF10 | O backend deve possuir testes automatizados com Pytest. | Must |
| RNF11 | O projeto deve implementar pelo menos um Design Pattern comprovável. | Must |
| RNF12 | A aplicação deve ser simples de executar localmente via ambiente de desenvolvimento. | Must |
| RNF13 | O frontend deve consumir a API por uma URL configurável em variável de ambiente. | Should |
| RNF14 | O banco deve preservar histórico de pedido mesmo após alteração de produto. | Must |
| RNF15 | A documentação deve ficar no repositório principal. | Must |

---

## 3. Priorização MoSCoW

### Must Have

- Cadastro e login.
- Roles básicas.
- Cadastro de empresa.
- Cadastro de produto.
- Visualização de empresas e produtos.
- Criação de pedido.
- Cálculo de taxa de entrega.
- Atualização de status.
- Aceite de pedido.
- Aceite de entrega.
- Histórico de status.

### Should Have

- Disponibilidade do entregador.
- Localização atual do entregador.
- Regras de taxa por faixa de distância.
- Histórico detalhado da entrega.

### Could Have

- Horário de funcionamento da empresa.
- Categorias de produtos.
- Imagem do produto.
- Mapa com Leaflet.

### Won't Have no MVP

- Pagamento online.
- Cupons.
- Chat.
- Avaliações.
- Notificação push.
- Otimização avançada de rotas.
