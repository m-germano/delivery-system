# Histórias de Usuário — Sistema de Delivery

# Epic 1 — Autenticação e perfis

## US01 — Cadastro de usuário

**Como** visitante,
**quero** criar uma conta informando nome, e-mail, senha e tipo de perfil,
**para** acessar as funcionalidades do sistema conforme meu papel.

### Critérios de aceite

- **Dado** que estou na tela de cadastro,
- **Quando** informo dados válidos e escolho uma role permitida,
- **Então** o sistema deve criar meu usuário com senha criptografada.

- **Dado** que informei um e-mail já cadastrado,
- **Quando** tento finalizar o cadastro,
- **Então** o sistema deve impedir o cadastro e retornar mensagem de erro.

---

## US02 — Login

**Como** usuário cadastrado,
**quero** fazer login com e-mail e senha,
**para** receber um token de acesso e utilizar o sistema.

### Critérios de aceite

- **Dado** que tenho uma conta ativa,
- **Quando** informo e-mail e senha corretos,
- **Então** o sistema deve retornar um token JWT e os dados básicos do usuário.

- **Dado** que informo credenciais inválidas,
- **Quando** tento acessar,
- **Então** o sistema deve negar o login.

---

## US03 — Controle de acesso por role

**Como** sistema,
**quero** validar a role do usuário autenticado,
**para** impedir acesso indevido a funcionalidades de outros perfis.

### Critérios de aceite

- **Dado** que sou cliente,
- **Quando** tento cadastrar produto,
- **Então** o sistema deve negar a operação.

- **Dado** que sou empresa,
- **Quando** tento cadastrar produto da minha empresa,
- **Então** o sistema deve permitir a operação.

---

# Epic 2 — Empresa e produtos

## US04 — Cadastro da empresa

**Como** empresa,
**quero** cadastrar os dados do meu restaurante,
**para** disponibilizar meus produtos aos clientes.

### Critérios de aceite

- **Dado** que estou autenticado com role Empresa,
- **Quando** informo nome, telefone, documento e descrição,
- **Então** o sistema deve cadastrar a empresa vinculada ao meu usuário.

---

## US05 — Cadastro de endereço da empresa

**Como** empresa,
**quero** cadastrar o endereço do meu restaurante com latitude e longitude,
**para** permitir cálculo de distância e taxa de entrega.

### Critérios de aceite

- **Dado** que possuo uma empresa cadastrada,
- **Quando** informo endereço e coordenadas válidas,
- **Então** o sistema deve salvar o endereço da empresa.

---

## US06 — Cadastro de produto

**Como** empresa,
**quero** cadastrar produtos no meu cardápio,
**para** permitir que clientes façam pedidos.

### Critérios de aceite

- **Dado** que estou autenticado como Empresa,
- **Quando** informo nome, descrição e preço do produto,
- **Então** o sistema deve cadastrar o produto como ativo.

---

## US07 — Manutenção de produto

**Como** empresa,
**quero** editar ou desativar produtos,
**para** manter meu cardápio atualizado.

### Critérios de aceite

- **Dado** que possuo produto cadastrado,
- **Quando** altero seus dados,
- **Então** o sistema deve atualizar o produto.

- **Dado** que um produto não está mais disponível,
- **Quando** desativo o produto,
- **Então** ele não deve aparecer para o cliente como disponível.

---

# Epic 3 — Cliente e pedido

## US08 — Visualização de empresas e produtos

**Como** cliente,
**quero** visualizar empresas e produtos disponíveis,
**para** escolher onde e o que comprar.

### Critérios de aceite

- **Dado** que existem empresas ativas com produtos ativos,
- **Quando** acesso a tela de produtos,
- **Então** o sistema deve listar empresas e produtos disponíveis.

---

## US09 — Cadastro de endereço do cliente

**Como** cliente,
**quero** cadastrar meu endereço de entrega,
**para** usá-lo na criação de pedidos.

### Critérios de aceite

- **Dado** que estou autenticado como Cliente,
- **Quando** informo endereço e coordenadas,
- **Então** o sistema deve salvar meu endereço.

---

## US10 — Criação de pedido

**Como** cliente,
**quero** criar um pedido com um ou mais produtos,
**para** receber minha compra no endereço escolhido.

### Critérios de aceite

- **Dado** que escolhi uma empresa, produtos e endereço,
- **Quando** confirmo o pedido,
- **Então** o sistema deve criar o pedido com status CRIADO.

- **Dado** que o produto possui preço atual,
- **Quando** o pedido é criado,
- **Então** o sistema deve salvar nome e preço do produto no item do pedido.

---

## US11 — Cálculo de taxa de entrega

**Como** cliente,
**quero** visualizar a taxa de entrega antes de confirmar o pedido,
**para** saber o valor total da compra.

### Critérios de aceite

- **Dado** que a empresa e o cliente possuem coordenadas,
- **Quando** o sistema calcula o pedido,
- **Então** deve calcular distância, subtotal, taxa e total.

---

## US12 — Acompanhamento de pedido

**Como** cliente,
**quero** acompanhar o status do meu pedido,
**para** saber em qual etapa ele está.

### Critérios de aceite

- **Dado** que tenho um pedido criado,
- **Quando** consulto meus pedidos,
- **Então** o sistema deve retornar o status atual.

---

# Epic 4 — Gestão operacional da empresa

## US13 — Visualização de pedidos recebidos

**Como** empresa,
**quero** visualizar pedidos recebidos,
**para** decidir quais aceitar e preparar.

### Critérios de aceite

- **Dado** que tenho pedidos vinculados à minha empresa,
- **Quando** acesso minha área de pedidos,
- **Então** o sistema deve listar os pedidos recebidos.

---

## US14 — Aceite ou recusa de pedido

**Como** empresa,
**quero** aceitar ou recusar um pedido recebido,
**para** controlar o início do preparo.

### Critérios de aceite

- **Dado** que o pedido está com status CRIADO,
- **Quando** aceito o pedido,
- **Então** o status deve mudar para ACEITO.

- **Dado** que o pedido está com status CRIADO,
- **Quando** recuso o pedido,
- **Então** o status deve mudar para RECUSADO.

---

## US15 — Atualização de status do pedido

**Como** empresa,
**quero** atualizar o status do pedido durante o preparo,
**para** informar o andamento ao cliente.

### Critérios de aceite

- **Dado** que o pedido foi aceito,
- **Quando** inicio o preparo,
- **Então** o status deve mudar para EM_PREPARO.

- **Dado** que o pedido está pronto para retirada,
- **Quando** disponibilizo para entrega,
- **Então** o status deve mudar para AGUARDANDO_ENTREGADOR.

---

# Epic 5 — Entregador e entrega

## US16 — Disponibilidade do entregador

**Como** entregador,
**quero** marcar meu status como disponível ou indisponível,
**para** controlar quando posso receber entregas.

### Critérios de aceite

- **Dado** que estou autenticado como Entregador,
- **Quando** marco disponibilidade,
- **Então** o sistema deve atualizar meu registro de entregador.

---

## US17 — Visualização de entregas disponíveis

**Como** entregador,
**quero** visualizar entregas disponíveis,
**para** escolher uma corrida.

### Critérios de aceite

- **Dado** que existem pedidos aguardando entregador,
- **Quando** acesso entregas disponíveis,
- **Então** o sistema deve listar entregas sem entregador vinculado.

---

## US18 — Aceite de entrega

**Como** entregador,
**quero** aceitar uma entrega disponível,
**para** ficar responsável por realizá-la.

### Critérios de aceite

- **Dado** que uma entrega está disponível,
- **Quando** aceito a entrega,
- **Então** o sistema deve vincular meu usuário à entrega.

- **Dado** que aceito a entrega,
- **Quando** a operação é concluída,
- **Então** o pedido deve mudar para EM_ENTREGA.

---

## US19 — Atualização de localização

**Como** entregador,
**quero** atualizar minha localização durante a entrega,
**para** permitir que o cliente acompanhe o andamento.

### Critérios de aceite

- **Dado** que estou vinculado a uma entrega,
- **Quando** envio latitude e longitude,
- **Então** o sistema deve atualizar minha localização atual.

---

## US20 — Finalização da entrega

**Como** entregador,
**quero** finalizar a entrega,
**para** encerrar o pedido após a entrega ao cliente.

### Critérios de aceite

- **Dado** que a entrega está em andamento,
- **Quando** finalizo a entrega,
- **Então** o status da entrega deve mudar para FINALIZADA e o pedido para ENTREGUE.
