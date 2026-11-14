# A002 — Diagrama de use cases (v1.1)

| | |
|---|---|
| User Story | US_A002 ([issue #2](https://github.com/escobar0304/ProjInter-2-1/issues/2)) |
| Branch | `feature/A002-Use-Cases` |
| Responsável | João Crasto |

## Objetivo

Reformular o diagrama de use cases v1.0 fornecido (backoffice e frontoffice), para que fique claro, completo e coerente com o levantamento de requisitos (US_A001) e com o glossário (US_A004).

## O que foi feito

- Diagrama [`docs/uml/casos-de-uso.drawio`](../../docs/uml/casos-de-uso.drawio), com uma página por área:
  - Frontoffice: UC01 a UC30, com os atores Guest, Registered User, Guardian e Email Service ([imagem](../../docs/uml/casos-de-uso-frontoffice.png));
  - Backoffice: UC31 a UC48, com os atores Administrator, Manager e Registered User ([imagem](../../docs/uml/casos-de-uso-backoffice.png)).
- Documento [`docs/uml/casos-de-uso.md`](../../docs/uml/casos-de-uso.md), com:
  - os atores e a herança entre eles;
  - a tabela de rastreabilidade `| UC | Nome | Ator(es) | Requisitos |` e as relações entre use cases;
  - a cobertura dos requisitos funcionais RF01 a RF46;
  - as 16 alterações face à v1.0, com o motivo de cada uma;
  - os pressupostos sobre as dúvidas D01 a D04 e D08 a D11.
- Imagens exportadas em PNG (escala 2, fundo branco, margem 10).

## Decisões

- **Cadeia de herança completa:** Administrator → Manager → Registered User → Guest. A v1.0 não tinha a generalização Manager → Registered User e repetia o «Manage Personal Information» no backoffice.
- **Atores secundários à direita:** Guardian (decide e revoga o consentimento parental) e Email Service (sistema externo que envia os emails).
- **`«include»` só para o que acontece sempre** (o registo envia sempre o email de confirmação) e **`«extend»` para o que é opcional ou condicional**, com a condição indicada (ex.: o pedido de consentimento só para menores, o badge só com 85% ou mais).
- **Generalização de use cases no backoffice:** *Manage Content* é abstrato e os oito use cases de gestão herdam dele a associação ao Manager e as extensões Change Content Status e Translate Content. Evita repetir associações e setas.
- **Pacotes por área do levantamento de requisitos** (AUT, PUB, REC/QST, GAM, GES, EST, ADM), para facilitar a rastreabilidade.
- **IDs fixos** (UC01 a UC48), usados pelas outras US: a US_A005 descreve o **UC27 Answer Final Questionnaire** e a US_A008 detalha o **UC01 Register User**.

## Alterações face à v1.0

A lista completa, com o motivo de cada alteração, está na secção 5 de [`docs/uml/casos-de-uso.md`](../../docs/uml/casos-de-uso.md). Em resumo:

- nomes em inglês, iguais aos do glossário, e IDs UC01 a UC48;
- herança completa entre os quatro atores e dois atores secundários novos;
- notação UML corrigida (associações, `«include»`, `«extend»`, sentido das setas);
- novos use cases para os requisitos que a v1.0 não cobria (consentimento, RGPD, destaques, administração e estatística);
- use cases redundantes fundidos ou removidos.

## Pressupostos

Os pressupostos sobre as dúvidas D01 a D04 e D08 a D11 estão na secção 6 de [`docs/uml/casos-de-uso.md`](../../docs/uml/casos-de-uso.md).

## Como verificar

- Abrir o `.drawio` em [app.diagrams.net](https://app.diagrams.net) ou no draw.io desktop: duas páginas, «Frontoffice» e «Backoffice».
- Todos os requisitos RF01 a RF46 aparecem na tabela de cobertura.
- Os atores estão fora do limite do sistema e as setas de `«include»`, `«extend»` e generalização têm o sentido indicado nas convenções do documento.
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Atualizar os pressupostos quando o cliente responder às dúvidas.
- Rever os nomes quando o modelo relacional v1.1 (US_A003) for publicado.
