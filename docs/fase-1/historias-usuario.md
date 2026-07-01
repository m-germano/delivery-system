# Histórias de Usuário — DishDash

Este documento reúne as histórias de usuário do MVP. O escopo considera três perfis de uso: cliente, empresa e entregador.

## Epic 1 — Autenticação e perfis

### US01 — Cadastro de usuário

**Como** visitante,  
**quero** criar uma conta informando nome, e-mail, senha e perfil,  
**para** acessar as funcionalidades do sistema.

#### Critérios de aceite

- **Dado** que estou na tela de cadastro,  
  **quando** informo dados válidos e escolho um perfil permitido,  
  **então** o sistema cria minha conta com senha criptografada.

- **Dado** que informo um e-mail já cadastrado,  
  **quando** tento finalizar o cadastro,  
  **então** o sistema impede o cadastro e exibe uma mensagem de erro.

---

### US02 — Login

**Como** usuário cadastrado,  
**quero** fazer login com e-mail e senha,  
**para** acessar minha área no sistema.

#### Critérios de aceite

- **Dado** que tenho uma conta ativa,  
  **quando** informo e-mail e senha corretos,  
  **então** o sistema retorna um token JWT e meus dados básicos.

- **Dado** que informo credenciais inválidas,  
  **quando** tento entrar,  
  **então** o sistema nega o acesso.

---

### US03 — Controle de acesso por perfil

**Como** sistema,  
**quero** validar o perfil do usuário autenticado,  
**para** proteger as funcionalidades de cliente, empresa e entregador.

#### Critérios de aceite

- **Dado** que estou autenticado como cliente,  
  **quando** tento cadastrar produto,  
  **então** o sistema bloqueia a operação.

- **Dado** que estou autenticado como empresa,  
  **quando** tento cadastrar produto da minha empresa,  
  **então** o sistema permite a operação.

---

## Epic 2 — Empresa, funcionamento e catálogo

### US04 — Cadastro da empresa

**Como** empresa,  
**quero** cadastrar os dados do meu restaurante,  
**para** disponibilizar meu cardápio aos clientes.

#### Critérios de aceite

- **Dado** que estou autenticado como empresa,  
  **quando** informo nome, telefone, documento, descrição e imagem,  
  **então** o sistema salva a empresa vinculada à minha conta.

- **Dado** que já tenho uma empresa cadastrada,  
  **quando** tento cadastrar outra empresa na mesma conta,  
  **então** o sistema bloqueia a duplicidade.

---

### US05 — Cadastro de endereço da empresa

**Como** empresa,  
**quero** cadastrar o endereço do restaurante a partir de CEP e número,  
**para** permitir cálculo de distância, entrega e retirada.

#### Critérios de aceite

- **Dado** que informei CEP e número,  
  **quando** aciono o preenchimento automático,  
  **então** o sistema completa rua, bairro, cidade, UF e coordenadas.

- **Dado** que o endereço foi resolvido corretamente,  
  **quando** salvo o cadastro,  
  **então** o endereço fica vinculado à empresa.

---

### US06 — Abrir e fechar loja

**Como** empresa,  
**quero** abrir ou fechar manualmente minha loja,  
**para** controlar quando posso receber novos pedidos.

#### Critérios de aceite

- **Dado** que minha loja está fechada,  
  **quando** clico em abrir loja,  
  **então** o sistema marca a loja como aberta para pedidos.

- **Dado** que minha loja está aberta,  
  **quando** clico em fechar loja,  
  **então** o sistema marca a loja como fechada para novos pedidos.

- **Dado** que a loja está fechada,  
  **quando** um cliente tenta calcular ou criar um pedido,  
  **então** o sistema bloqueia a operação.

---

### US07 — Cadastro de produto

**Como** empresa,  
**quero** cadastrar produtos no cardápio,  
**para** permitir que clientes montem pedidos.

#### Critérios de aceite

- **Dado** que estou autenticado como empresa,  
  **quando** informo nome, descrição, preço, categoria e imagem,  
  **então** o sistema cadastra o produto como ativo.

---

### US08 — Manutenção de produto

**Como** empresa,  
**quero** editar ou desativar produtos,  
**para** manter o cardápio atualizado.

#### Critérios de aceite

- **Dado** que possuo um produto cadastrado,  
  **quando** altero seus dados,  
  **então** o sistema salva as alterações.

- **Dado** que um produto não está mais disponível,  
  **quando** desativo o produto,  
  **então** ele deixa de aparecer como disponível para o cliente.

---

### US09 — Configuração de entrega e retirada

**Como** empresa,  
**quero** configurar se aceito delivery, retirada ou ambos,  
**para** trabalhar com os tipos de atendimento disponíveis no restaurante.

#### Critérios de aceite

- **Dado** que estou na configuração da empresa,  
  **quando** marco delivery, retirada ou ambos,  
  **então** o sistema salva as opções de atendimento.

- **Dado** que configuro retirada,  
  **quando** informo um desconto percentual,  
  **então** o sistema aplica o desconto no cálculo do pedido de retirada.

- **Dado** que configuro pedido mínimo,  
  **quando** o subtotal do pedido fica abaixo do valor definido,  
  **então** o sistema impede a confirmação.

---

## Epic 3 — Cliente, pedido e pagamento

### US10 — Visualização de empresas e produtos

**Como** cliente,  
**quero** visualizar lojas e produtos disponíveis,  
**para** escolher onde comprar.

#### Critérios de aceite

- **Dado** que existem empresas ativas com produtos ativos,  
  **quando** acesso a área de exploração,  
  **então** o sistema lista lojas e produtos.

- **Dado** que uma loja está fechada,  
  **quando** visualizo a loja,  
  **então** o sistema mostra o status de funcionamento.

---

### US11 — Cadastro de endereço do cliente

**Como** cliente,  
**quero** cadastrar meu endereço de entrega,  
**para** usar esse endereço nos pedidos delivery.

#### Critérios de aceite

- **Dado** que estou autenticado como cliente,  
  **quando** informo CEP e número,  
  **então** o sistema completa o endereço e salva as coordenadas.

- **Dado** que marco um endereço como padrão,  
  **quando** faço um pedido delivery,  
  **então** o sistema usa esse endereço no cálculo da entrega.

---

### US12 — Cálculo do pedido

**Como** cliente,  
**quero** visualizar subtotal, desconto, entrega e total antes de confirmar,  
**para** saber o valor final do pedido.

#### Critérios de aceite

- **Dado** que selecionei produtos de uma empresa aberta,  
  **quando** calculo o pedido,  
  **então** o sistema retorna subtotal, taxa de entrega ou desconto de retirada e total.

- **Dado** que escolho delivery,  
  **quando** o sistema calcula a entrega,  
  **então** usa a distância entre a empresa e meu endereço.

- **Dado** que escolho retirada,  
  **quando** o sistema calcula o pedido,  
  **então** a taxa de entrega fica zerada.

---

### US13 — Criação de pedido

**Como** cliente,  
**quero** criar um pedido com um ou mais produtos,  
**para** comprar de uma loja aberta.

#### Critérios de aceite

- **Dado** que escolhi produtos válidos de uma empresa aberta,  
  **quando** confirmo o pedido,  
  **então** o sistema cria o pedido com status `ABERTO`.

- **Dado** que o produto possui preço atual,  
  **quando** o pedido é criado,  
  **então** o sistema salva o nome e o preço do produto no item do pedido.

- **Dado** que a loja está fechada,  
  **quando** tento criar o pedido,  
  **então** o sistema bloqueia a criação.

---

### US14 — Pagamento online com Mercado Pago Checkout Pro

**Como** cliente,  
**quero** pagar o pedido online pelo Mercado Pago,  
**para** concluir o pagamento em um ambiente seguro antes da loja preparar o pedido.

#### Critérios de aceite

- **Dado** que a empresa possui Mercado Pago conectado,  
  **quando** escolho pagamento online,  
  **então** o sistema cria o pedido como `AGUARDANDO_PAGAMENTO`.

- **Dado** que o pedido foi criado para pagamento online,  
  **quando** o backend cria a preferência de pagamento,  
  **então** o frontend recebe o link do Checkout Pro.

- **Dado** que o cliente acessa o Checkout Pro,  
  **quando** o pagamento é aprovado,  
  **então** o webhook atualiza o pagamento e libera o pedido para a empresa.

- **Dado** que a empresa recusa ou cancela um pedido pago online,  
  **quando** a operação é confirmada,  
  **então** o sistema solicita o cancelamento ou reembolso no Mercado Pago quando aplicável.

---

### US15 — Acompanhamento de pedido

**Como** cliente,  
**quero** acompanhar o status do meu pedido,  
**para** saber em qual etapa ele está.

#### Critérios de aceite

- **Dado** que tenho um pedido criado,  
  **quando** consulto meus pedidos,  
  **então** o sistema retorna o status atual.

- **Dado** que o pedido está em entrega,  
  **quando** acesso o acompanhamento,  
  **então** consigo ver as informações disponíveis da entrega.

---

### US16 — Código de confirmação de entrega ou retirada

**Como** cliente,  
**quero** visualizar um código de confirmação,  
**para** confirmar a entrega ou retirada do pedido.

#### Critérios de aceite

- **Dado** que meu pedido está em entrega,  
  **quando** consulto meus pedidos,  
  **então** o sistema mostra um código de quatro dígitos.

- **Dado** que meu pedido está pronto para retirada,  
  **quando** consulto meus pedidos,  
  **então** o sistema mostra o código de retirada.

- **Dado** que o código informado está incorreto,  
  **quando** o entregador ou a empresa tenta finalizar,  
  **então** o sistema bloqueia a finalização.

---

### US17 — Avaliação da empresa

**Como** cliente,  
**quero** avaliar a empresa após concluir um pedido,  
**para** registrar minha experiência de compra.

#### Critérios de aceite

- **Dado** que meu pedido foi entregue ou retirado,  
  **quando** envio uma nota de 1 a 5 e um comentário opcional,  
  **então** o sistema salva a avaliação.

- **Dado** que já avaliei um pedido,  
  **quando** tento avaliar o mesmo pedido novamente,  
  **então** o sistema impede uma nova avaliação.

- **Dado** que a empresa possui avaliações,  
  **quando** outros clientes visualizam a loja,  
  **então** o sistema mostra média e quantidade de avaliações.

---

## Epic 4 — Gestão operacional da empresa

### US18 — Visualização de pedidos recebidos

**Como** empresa,  
**quero** visualizar pedidos recebidos,  
**para** aceitar, recusar ou acompanhar a preparação.

#### Critérios de aceite

- **Dado** que existem pedidos vinculados à minha empresa,  
  **quando** acesso minha área de pedidos,  
  **então** o sistema lista os pedidos recebidos.

---

### US19 — Aceite ou recusa de pedido

**Como** empresa,  
**quero** aceitar ou recusar um pedido,  
**para** controlar o início do preparo.

#### Critérios de aceite

- **Dado** que o pedido está com status `ABERTO`,  
  **quando** aceito o pedido,  
  **então** o status muda para `ACEITO`.

- **Dado** que o pedido está com status `ABERTO`,  
  **quando** recuso o pedido,  
  **então** o status muda para `RECUSADO`.

---

### US20 — Atualização de status do pedido

**Como** empresa,  
**quero** atualizar o status do pedido durante o preparo,  
**para** informar o andamento ao cliente.

#### Critérios de aceite

- **Dado** que o pedido foi aceito,  
  **quando** inicio o preparo,  
  **então** o status muda para `EM_PREPARO`.

- **Dado** que um pedido delivery está pronto,  
  **quando** libero para entrega,  
  **então** o status muda para `AGUARDANDO_ENTREGADOR` e uma entrega fica disponível.

- **Dado** que um pedido de retirada está pronto,  
  **quando** marco como pronto para retirada,  
  **então** o status muda para `PRONTO_PARA_RETIRADA`.

---

### US21 — Consulta de avaliações recebidas

**Como** empresa,  
**quero** visualizar avaliações dos clientes,  
**para** acompanhar a percepção sobre meu atendimento.

#### Critérios de aceite

- **Dado** que minha empresa recebeu avaliações,  
  **quando** acesso a tela de avaliações,  
  **então** o sistema lista notas, comentários e pedidos relacionados.

---

### US22 — Conexão com Mercado Pago

**Como** empresa,  
**quero** conectar minha conta Mercado Pago,  
**para** receber pagamentos online dos pedidos.

#### Critérios de aceite

- **Dado** que estou autenticado como empresa,  
  **quando** inicio a conexão com Mercado Pago,  
  **então** o sistema redireciona para autorização OAuth.

- **Dado** que autorizo a integração,  
  **quando** o Mercado Pago retorna para o callback,  
  **então** o sistema armazena os tokens criptografados.

- **Dado** que a conexão está ativa,  
  **quando** o cliente escolhe pagamento online,  
  **então** a loja fica habilitada para receber pedido com Checkout Pro.

---

## Epic 5 — Entregador e entrega

### US23 — Disponibilidade do entregador

**Como** entregador,  
**quero** marcar meu status como disponível ou indisponível,  
**para** controlar quando posso receber entregas.

#### Critérios de aceite

- **Dado** que estou autenticado como entregador,  
  **quando** atualizo minha disponibilidade,  
  **então** o sistema atualiza meu registro de entregador.

---

### US24 — Visualização de entregas disponíveis

**Como** entregador,  
**quero** visualizar entregas disponíveis,  
**para** escolher uma corrida.

#### Critérios de aceite

- **Dado** que existem pedidos aguardando entregador,  
  **quando** acesso entregas disponíveis,  
  **então** o sistema lista entregas sem entregador vinculado.

- **Dado** que um pedido é de retirada,  
  **quando** consulto entregas disponíveis,  
  **então** esse pedido não aparece para entregadores.

---

### US25 — Aceite de entrega

**Como** entregador,  
**quero** aceitar uma entrega disponível,  
**para** ficar responsável pela corrida.

#### Critérios de aceite

- **Dado** que a entrega está disponível,  
  **quando** aceito a entrega,  
  **então** o sistema vincula meu usuário à entrega.

- **Dado** que aceito a entrega,  
  **quando** a operação é concluída,  
  **então** o pedido muda para `EM_ENTREGA`.

---

### US26 — Atualização de localização

**Como** entregador,  
**quero** atualizar minha localização durante a entrega,  
**para** permitir o acompanhamento pelo cliente.

#### Critérios de aceite

- **Dado** que estou vinculado a uma entrega em andamento,  
  **quando** envio latitude e longitude,  
  **então** o sistema atualiza minha localização.

---

### US27 — Finalização da entrega

**Como** entregador,  
**quero** finalizar a entrega com o código do cliente,  
**para** encerrar o pedido com segurança.

#### Critérios de aceite

- **Dado** que a entrega está em andamento,  
  **quando** informo o código correto,  
  **então** a entrega muda para `FINALIZADA` e o pedido para `ENTREGUE`.

- **Dado** que informo o código incorreto,  
  **quando** tento finalizar,  
  **então** o sistema bloqueia a operação.
