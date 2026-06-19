# Requisitos — Sistema de Delivery

## Requisitos Funcionais

| Código | Requisito | Prioridade |
|---|---|---|
| RF01 | O sistema deve permitir cadastro e login de usuários. | Must |
| RF02 | O sistema deve diferenciar usuários por perfil: Cliente, Empresa e Entregador. | Must |
| RF03 | A empresa deve poder cadastrar, editar, desativar e listar produtos. | Must |
| RF04 | O cliente deve poder visualizar empresas e produtos disponíveis. | Must |
| RF05 | O cliente deve poder criar um pedido com um ou mais produtos. | Must |
| RF06 | O sistema deve calcular a taxa de entrega com base na distância informada ou simulada. | Must |
| RF07 | O cliente deve poder acompanhar o status do pedido. | Must |
| RF08 | O entregador deve poder visualizar pedidos disponíveis para entrega. | Should |
| RF09 | O entregador deve poder aceitar uma entrega. | Should |
| RF10 | A empresa e o entregador devem poder atualizar o status do pedido. | Must |

## Requisitos Não Funcionais

| Código | Requisito | Prioridade |
|---|---|---|
| RNF01 | A API deve ser organizada em camadas: Controller, Service, Repository e Model. | Must |
| RNF02 | O backend deve utilizar PostgreSQL como banco de dados relacional. | Must |
| RNF03 | O sistema deve possuir documentação de setup e rotas no README. | Must |
| RNF04 | O projeto deve conter diagramas UML de casos de uso e classes. | Must |
| RNF05 | O backend deve possuir testes automatizados com Pytest. | Must |
| RNF06 | Senhas devem ser armazenadas usando hash, nunca em texto puro. | Must |
| RNF07 | A aplicação deve ser simples de executar localmente. | Must |
