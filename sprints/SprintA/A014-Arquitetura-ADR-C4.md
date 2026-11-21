# A014 — Decisões de arquitetura (ADR) e modelo C4

| | |
|---|---|
| User Story | US_A014 ([issue #14](https://github.com/escobar0304/ProjInter-2-1/issues/14)) |
| Branch | `feature/A014-Arquitetura-ADR-C4` |
| Responsável | Diogo Escobar |

## Objetivo

Documentar as decisões técnicas mais importantes do projeto, cada uma justificada, e uma visão de alto nível da arquitetura.

## O que foi feito

- [`docs/arquitetura/README.md`](../../docs/arquitetura/README.md): formato dos ADR, regras de numeração e índice.
- Cinco ADR, cada um com contexto, decisão, alternativas consideradas e consequências:
  - [ADR-0001](../../docs/arquitetura/ADR-0001-sgbd-postgresql.md): PostgreSQL como SGBD, com a validação do orientador;
  - [ADR-0002](../../docs/arquitetura/ADR-0002-contentores-docker.md): execução em contentores Docker, a partir da Sprint B;
  - [ADR-0003](../../docs/arquitetura/ADR-0003-autenticacao-sessao-cookie.md): autenticação com sessão em cookie;
  - [ADR-0004](../../docs/arquitetura/ADR-0004-armazenamento-ficheiros.md): ficheiros multimédia num volume, com verificação de acesso;
  - [ADR-0005](../../docs/arquitetura/ADR-0005-spa-react-api-rest.md): SPA em React e API REST em Flask, na mesma origem.
- [`docs/arquitetura/c4.md`](../../docs/arquitetura/c4.md): modelo C4 de nível 1 (contexto) e de nível 2 (contentores), com a fonte [`c4.drawio`](../../docs/arquitetura/c4.drawio) e as imagens em SVG.

## Decisões

- **ADR-0001 e ADR-0002 aceites**, porque correspondem a decisões já tomadas pela equipa (RNF20, RNF21). **ADR-0003 a ADR-0005 propostos**: passam a aceites com a aprovação do Pull Request.
- **Um ADR por decisão, nunca apagado.** Quando uma decisão muda, um ADR novo substitui o anterior.
- **Imagens em SVG**, como no modelo relacional.

## Como verificar

- Os ADR têm contexto, alternativas e consequências, e o ADR-0001 refere a validação do orientador.
- Os atores do C4 de nível 1 são os do diagrama de use cases (US_A002).
- As tecnologias do C4 de nível 2 coincidem com o FURPS+ (RNF17 a RNF21).
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Na Sprint B: ADR da organização interna do backend e aplicação do ADR-0002 (`docker-compose.yml`).
