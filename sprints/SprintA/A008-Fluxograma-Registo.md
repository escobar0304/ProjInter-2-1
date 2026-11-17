# A008 — Fluxograma do UC «Register User» (com consentimento parental)

| | |
|---|---|
| User Story | US_A008 ([issue #8](https://github.com/escobar0304/ProjInter-2-1/issues/8)) |
| Branch | `feature/A008-Fluxograma-Registo` |
| Responsável | João Crasto |

## Objetivo

Estruturar num fluxograma o processo completo do UC01 Register User, incluindo o pedido de Parental Consent quando o User é Minor. O fluxograma cobre todos os caminhos, incluindo os de erro e os que não terminam com sucesso.

## O que foi feito

- Fluxograma BPMN 2.0 em [`docs/bpmn/registo-utilizador.drawio`](../../docs/bpmn/registo-utilizador.drawio), com a [imagem exportada](../../docs/bpmn/registo-utilizador.png) (PNG, escala 2, fundo branco, margem 10):
  - pool «Plataforma — Registration», com as raias Guest, Sistema e Guardian;
  - pool separada para o Email Service (sistema externo), ligada por fluxos de mensagem;
  - caminho principal, caminho do Minor e nove situações de erro ou sem sucesso.
- Documento [`docs/bpmn/registo-utilizador.md`](../../docs/bpmn/registo-utilizador.md), com:
  - a notação usada e a descrição de cada participante;
  - os caminhos (principal, Minor, erros), cada um com o evento de fim;
  - a ligação aos UC01 a UC06 e aos requisitos RF01 a RF04, RF45, RNF06, RNF22, RNF23 e RNF26;
  - os estados de conta e de consentimento e os dados usados;
  - os pressupostos D02 e D11 e os pressupostos da equipa P1 a P8.

## Decisões

- **BPMN 2.0**, com raias por interveniente, como pede a issue. O Email Service fica numa pool própria, sem detalhe interno, porque é um sistema externo: comunica com a plataforma só por mensagens (RNF26).
- **Gateway inclusivo depois da criação da conta.** O ramo da verificação do email segue sempre e o ramo do consentimento só para um Minor. O gateway de junção espera pelos ramos ativados, por isso a Account Activation de um Minor exige o email verificado **e** o consentimento aceite. Evita desenhar a verificação do email duas vezes.
- **Fins *terminate* para os caminhos sem sucesso.** Quando um ramo falha (ex.: o consentimento é recusado), o processo termina por inteiro e o outro ramo deixa de esperar.
- **Prazos com eventos temporizados** e eliminação dos registos não concluídos ao fim de 30 dias, contados a partir de `users.status_changed_at`.
- **Coerência com o [modelo relacional v1.1](../../docs/base-de-dados/modelo-relacional.md) (US_A003).** O fluxograma usa `account_statuses`, `user_tokens` e `parental_consents`. Levou também a três colunas novas no modelo: `users.privacy_accepted_at`, `users.status_changed_at` e `parental_consents.revocation_token_hash`.

## Pressupostos

Os pressupostos estão na secção 8 de [`docs/bpmn/registo-utilizador.md`](../../docs/bpmn/registo-utilizador.md). Em resumo:

- prazos: 24 horas para o link de verificação, 7 dias para o pedido de consentimento e 30 dias para a eliminação dos registos não concluídos;
- email já registado: mensagem explícita, com links para iniciar sessão e recuperar a palavra-passe;
- consentimento recusado: a conta passa a `deactivated` e os dados são eliminados ao fim de 30 dias;
- consentimento expirado: até 2 reenvios pelo Guest; depois, eliminação ao fim de 30 dias;
- falha no envio de um email: até 3 novas tentativas, e o Guest pode pedir o reenvio;
- validações extra (email do Guardian, data de nascimento e política de privacidade) e sem idade mínima.

## Como verificar

- Abrir o `.drawio` em [app.diagrams.net](https://app.diagrams.net) ou no draw.io desktop.
- Todos os caminhos terminam num evento de fim ou voltam a um ponto anterior do processo (formulário ou espera), sem pontas soltas.
- Todos os gateways de decisão têm as saídas identificadas.
- O consentimento parental é pedido e registado antes da Account Activation.
- Os nomes dos use cases, dos estados e das colunas coincidem com o [diagrama de use cases](../../docs/uml/casos-de-uso.md), o [glossário](../../docs/uml/glossario.md) e o [modelo relacional v1.1](../../docs/base-de-dados/modelo-relacional.md).
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Atualizar os pressupostos se o cliente responder às dúvidas D02 e D11, ou se não concordar com os pressupostos P1 a P8.
- Descrever o UC06 Revoke Parental Consent, se a equipa decidir detalhá-lo.
