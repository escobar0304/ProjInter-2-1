# A004 — Modelo de domínio (DDD)

| | |
|---|---|
| User Story | US_A004 ([issue #4](https://github.com/escobar0304/ProjInter-2-1/issues/4)), 2.ª parte |
| Branch | `feature/A004-Modelo-Dominio` |
| Responsável | João Crasto |

## Objetivo

Desenhar o modelo de domínio em DDD: os agregados, com a raiz e a fronteira justificada, as entidades, os value objects e os seus atributos. É a 2.ª parte da US_A004. A 1.ª parte, o [glossário](A004-Glossario.md), foi entregue antes, para a equipa poder usar a linguagem ubíqua nos use cases (US_A002) e no modelo relacional (US_A003).

## O que foi feito

- Diagrama [`docs/uml/modelo-dominio.drawio`](../../docs/uml/modelo-dominio.drawio), com quatro páginas e as imagens em SVG:
  - Visão geral: os 11 agregados, as entidades de cada um e as referências por ID ([imagem](../../docs/uml/modelo-dominio-visao-geral.svg));
  - Conta e acesso: agregados User e Role ([imagem](../../docs/uml/modelo-dominio-conta.svg));
  - Formação e questionários: agregados HealthArea, TrainingResource, Questionnaire e Enrollment ([imagem](../../docs/uml/modelo-dominio-formacao.svg));
  - Biblioteca virtual: agregados Category, Publication, NewsItem, Activity e WeeklyHighlight ([imagem](../../docs/uml/modelo-dominio-biblioteca.svg)).
- Documento [`docs/uml/modelo-dominio.md`](../../docs/uml/modelo-dominio.md), com:
  - as convenções da notação;
  - a tabela `| Agregado | Raiz | Entidades | Value objects |` e o motivo de cada caso menos óbvio de entidade ou value object;
  - as regras de negócio que cada agregado protege e o motivo de cada fronteira;
  - as referências entre agregados, com as multiplicidades;
  - os serviços de domínio e os eventos de domínio;
  - a validação com os use cases UC01 a UC48;
  - a correspondência com as 40 tabelas do modelo relacional v1.1 e as diferenças de representação;
  - os pressupostos sobre as dúvidas D01 a D11.
- [Glossário](../../docs/uml/glossario.md) v1.1: novos termos Token e Level Progress, usados no modelo, e ligação ao modelo de domínio.

## Decisões

- **Um só bounded context**, organizado em três módulos (as páginas do diagrama). A equipa, o glossário, a base de dados e a API são os mesmos para todo o sistema.
- **ParentalConsent e UserToken dentro do agregado User.** A decisão do Guardian e a ativação ou a suspensão da conta ficam na mesma transação (RF04, RF45).
- **Attempt, Badge e Certificate dentro do agregado Enrollment.** O limite de tentativas, a ordem Diagnostic → Final e a atribuição única do Badge dependem do conjunto de Attempts do User no recurso (RF19, RF20, RF23).
- **Questionnaire separado do TrainingResource.** Tem estado e edição próprios (UC39) e é grande; liga-se ao recurso pelo ID.
- **Badge como value object e Certificate como entidade.** O Badge é um facto imutável; o Certificate tem identidade própria (código de verificação) e é verificado depois de emitido.
- **Enumerações e Translation como value objects partilhados**, repetidos nas páginas onde são usados.
- **Atributos com os nomes das colunas** do `schema.sql` em `camelCase`, para a comparação com o modelo relacional ser direta.
- **Diagrama em draw.io sem compressão** e imagens em SVG, como no modelo relacional (US_A003): o `.drawio` e as imagens têm diferenças legíveis no Git.

## Pressupostos

Seguem os pressupostos do glossário para as dúvidas D01 a D11. Os efeitos no modelo estão na secção 9 do [documento](../../docs/uml/modelo-dominio.md).

## Como verificar

- Abrir o `.drawio` em [app.diagrams.net](https://app.diagrams.net) ou no draw.io desktop: quatro páginas.
- Todos os agregados têm a raiz identificada («aggregate root») e a fronteira desenhada; a justificação está na secção 4 do documento.
- Entidades e value objects têm estereótipos e cores diferentes.
- Todas as entidades e value objects têm atributos, e todas as associações têm multiplicidade nos dois extremos.
- Cada use case de UC01 a UC48 tem um agregado (secção 7), exceto as páginas estáticas UC18 e UC19.
- Cada tabela do modelo relacional v1.1 tem um elemento correspondente (secção 8).
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Atualizar o modelo quando o cliente responder às dúvidas D01 a D11.
