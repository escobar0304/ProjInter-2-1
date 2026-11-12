# A001 — Levantamento de requisitos (FURPS+)

| | |
|---|---|
| User Story | US_A001 ([issue #1](https://github.com/escobar0304/ProjInter-2-1/issues/1)) |
| Branch | `feature/A001-Requisitos-FURPS` |
| Responsável | Diogo Escobar |

## Objetivo

Analisar e atualizar o levantamento de requisitos fornecido pelo cliente (especificação, secção C) e organizá-lo pelo método FURPS+, acrescentando os requisitos que resultam da análise da equipa.

## O que foi feito

- Documento [`docs/requisitos/furps.md`](../../docs/requisitos/furps.md), com:
  - âmbito, fontes e convenções (IDs, prioridades MoSCoW e áreas funcionais);
  - atores e herança entre eles;
  - 46 requisitos funcionais, agrupados em 8 áreas;
  - 28 requisitos não funcionais (usabilidade, fiabilidade, desempenho, suportabilidade e restrições);
  - limites de âmbito, dúvidas para o cliente, alterações face à secção C e ligação às US extra.
- Cada requisito tem ID, prioridade e origem (secção da especificação, diagrama v1.0 ou equipa).

## Decisões

- **IDs estáveis.** Depois de publicados, os IDs não mudam e os requisitos novos recebem o número seguinte. Assim, as outras US (use cases, modelos e métricas) podem referenciá-los sem retrabalho.
- **Prioridades MoSCoW nos requisitos**, distintas das prioridades P1 a P4 das User Stories.
- **Decisões da equipa registadas como restrições:** PostgreSQL (validado pelo orientador) e Docker (a partir da Sprint B).
- **Valores de desempenho e de usabilidade propostos pela equipa**, a confirmar com o cliente.
- **Requisitos que só se aplicam com a plataforma publicada** (HTTPS e cópias de segurança) ficam marcados como "em produção".

## Como verificar

- Todos os requisitos da secção C e as funcionalidades da secção C.1 aparecem no documento (ver a secção 7 do documento).
- Cada requisito tem um ID único, uma prioridade e uma origem.
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Levar as dúvidas D01 a D11 ao docente e atualizar os requisitos afetados.
- Rastreabilidade com os use cases (US_A002), feita depois do merge.
