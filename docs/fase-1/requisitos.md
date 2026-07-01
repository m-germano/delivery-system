# Requisitos — DishDash

## 1. Requisitos Funcionais

| Código | Requisito | Ator principal | Prioridade |
|---|---|---|---|
| RF01 | Permitir cadastro de usuários. | Cliente, Empresa, Entregador | Must |
| RF02 | Permitir login de usuários. | Cliente, Empresa, Entregador | Must |
| RF03 | Autenticar usuários por token JWT. | Sistema | Must |
| RF04 | Diferenciar usuários por perfil: Cliente, Empresa e Entregador. | Sistema | Must |
| RF05 | Permitir que a empresa cadastre e edite seus dados comerciais. | Empresa | Must |
| RF06 | Permitir que a empresa cadastre endereço com preenchimento por CEP e coordenadas. | Empresa | Must |
| RF07 | Permitir que a empresa cadastre categorias e produtos. | Empresa | Must |
| RF08 | Permitir que a empresa edite e desative produtos. | Empresa | Must |
| RF09 | Permitir que a empresa configure delivery, retirada, desconto de retirada e pedido mínimo. | Empresa | Must |
| RF10 | Permitir que a empresa abra e feche a loja manualmente. | Empresa | Must |
| RF11 | Bloquear cálculo e criação de pedido quando a loja estiver fechada. | Sistema | Must |
| RF12 | Permitir que o cliente visualize empresas ativas e seus produtos. | Cliente | Must |
| RF13 | Exibir o status de funcionamento da loja para o cliente. | Cliente | Must |
| RF14 | Permitir que o cliente cadastre endereço de entrega. | Cliente | Must |
| RF15 | Permitir que o cliente crie pedido com um ou mais produtos. | Cliente | Must |
| RF16 | Calcular subtotal, desconto, taxa de entrega e total do pedido. | Sistema | Must |
| RF17 | Calcular distância entre empresa e cliente para pedidos delivery. | Sistema | Must |
| RF18 | Permitir pedido de retirada sem endereço do cliente e sem taxa de entrega. | Cliente | Must |
| RF19 | Permitir que a empresa visualize pedidos recebidos. | Empresa | Must |
| RF20 | Permitir que a empresa aceite, recuse ou cancele pedidos. | Empresa | Must |
| RF21 | Controlar as transições de status do pedido. | Sistema | Must |
| RF22 | Registrar histórico de alterações de status do pedido. | Sistema | Must |
| RF23 | Permitir que entregadores fiquem disponíveis ou indisponíveis. | Entregador | Should |
| RF24 | Permitir que entregadores visualizem entregas disponíveis. | Entregador | Must |
| RF25 | Permitir que entregadores aceitem entregas. | Entregador | Must |
| RF26 | Permitir que entregadores atualizem localização durante a entrega. | Entregador | Should |
| RF27 | Permitir que entregadores finalizem entrega com código de confirmação. | Entregador | Must |
| RF28 | Registrar histórico de alterações de status da entrega. | Sistema | Should |
| RF29 | Permitir que a empresa finalize pedido de retirada com código de confirmação. | Empresa | Must |
| RF30 | Permitir que o cliente acompanhe o status do pedido. | Cliente | Must |
| RF31 | Permitir que o cliente consulte localização do entregador durante a entrega. | Cliente | Should |
| RF32 | Permitir que a empresa conecte sua conta Mercado Pago por OAuth. | Empresa | Should |
| RF33 | Armazenar tokens do Mercado Pago de forma criptografada. | Sistema | Must |
| RF34 | Permitir pagamento online via Mercado Pago Checkout Pro. | Cliente | Should |
| RF35 | Criar pedido como aguardando pagamento quando o cliente escolher pagamento online. | Sistema | Must |
| RF36 | Criar preferência de pagamento e retornar o link do Checkout Pro. | Sistema | Must |
| RF37 | Receber webhook do Mercado Pago e atualizar o status do pagamento. | Sistema | Must |
| RF38 | Liberar o pedido para a empresa após aprovação do pagamento online. | Sistema | Must |
| RF39 | Solicitar cancelamento ou reembolso quando pedido pago online for recusado ou cancelado, quando aplicável. | Sistema | Should |
| RF40 | Permitir que o cliente avalie a empresa após pedido entregue ou retirado. | Cliente | Should |
| RF41 | Impedir mais de uma avaliação para o mesmo pedido. | Sistema | Must |
| RF42 | Exibir média e quantidade de avaliações da empresa. | Cliente, Empresa | Should |

## 2. Requisitos Não Funcionais

| Código | Requisito | Prioridade |
|---|---|---|
| RNF01 | O backend deve ser desenvolvido em Python com FastAPI. | Must |
| RNF02 | O frontend deve ser desenvolvido em React com Vite. | Must |
| RNF03 | O banco relacional deve ser PostgreSQL. | Must |
| RNF04 | A API deve ser organizada em Controller, Service, Repository, Model e Schema. | Must |
| RNF05 | Senhas devem ser armazenadas com hash, nunca em texto puro. | Must |
| RNF06 | Rotas sensíveis devem exigir JWT. | Must |
| RNF07 | Rotas operacionais devem validar o perfil do usuário. | Must |
| RNF08 | O projeto deve possuir README com setup, execução local e comandos de teste. | Must |
| RNF09 | O projeto deve conter diagramas UML de casos de uso e classes. | Must |
| RNF10 | O backend deve possuir testes automatizados com Pytest. | Must |
| RNF11 | O projeto deve implementar pelo menos um Design Pattern comprovável. | Must |
| RNF12 | A aplicação deve ser simples de executar localmente. | Must |
| RNF13 | O frontend deve consumir a API por URL configurável em variável de ambiente. | Should |
| RNF14 | O banco deve preservar histórico do pedido mesmo após alteração de produto. | Must |
| RNF15 | O PostgreSQL deve continuar como fonte oficial dos dados. | Must |
| RNF16 | Redis deve ser usado apenas para eventos em tempo real. | Should |
| RNF17 | Tokens sensíveis de gateway de pagamento devem ser criptografados. | Must |
| RNF18 | Webhooks de pagamento devem ser validados antes de alterar o pedido. | Must |
| RNF19 | A documentação principal deve ficar no repositório raiz. | Must |

## 3. Priorização MoSCoW

### Must Have

- Cadastro e login.
- Perfis Cliente, Empresa e Entregador.
- Cadastro de empresa e endereço.
- Cadastro e manutenção de produtos.
- Abertura e fechamento manual da loja.
- Visualização de lojas e produtos.
- Criação de pedido.
- Cálculo de pedido.
- Delivery e retirada.
- Aceite, recusa e atualização de status pela empresa.
- Aceite e finalização de entrega.
- Código de confirmação.
- Histórico de status.
- Testes automatizados.
- UML de classes e casos de uso.
- Repository Pattern, Strategy Pattern e controle de transição de estado.

### Should Have

- Localização do entregador.
- Redis/WebSocket para atualização em tempo real.
- Mercado Pago Checkout Pro.
- Webhook de pagamento.
- Avaliação da empresa.
- Reembolso ou cancelamento para pedidos pagos online.

### Could Have

- Categorias de produtos.
- Imagem do produto.
- Mapa com Leaflet.
- Filtros de busca.
- Relatório simples de avaliações.

### Won't Have no MVP

- Chat.
- Cupons.
- Notificação push.
- Aplicativo mobile.
- Painel administrativo dedicado.
- Otimização avançada de rotas.
