# Arquitetura

| | |
|---|---|
| User Story | US_A014 ([issue #14](https://github.com/escobar0304/ProjInter-2-1/issues/14)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

Esta pasta reúne as decisões de arquitetura da Plataforma de Literacia em Saúde para Jovens (ADR) e a visão de alto nível do sistema ([modelo C4](c4.md)).

## Registo de decisões (ADR)

Cada decisão técnica importante tem um ADR (*Architecture Decision Record*), no formato curto de Michael Nygard:

- **Estado:** proposta, aceite ou substituída (com o ADR que a substitui);
- **Contexto:** o problema e as restrições que levaram à decisão;
- **Decisão:** o que a equipa escolheu;
- **Alternativas consideradas:** as outras opções e porque não foram escolhidas;
- **Consequências:** o que a decisão implica, de bom e de mau.

Regras:

- Os ADR são numerados (`ADR-0001-...`) e nunca se apagam. Quando uma decisão muda, cria-se um ADR novo que substitui o anterior, e o anterior passa ao estado «substituída».
- Uma decisão fica «aceite» depois de aprovada pela equipa num Pull Request. Até lá, fica «proposta».
- Cada ADR indica os requisitos do [levantamento de requisitos](../requisitos/furps.md) que afeta.

## Índice

| ADR | Decisão | Estado | Requisitos |
|---|---|---|---|
| [ADR-0001](ADR-0001-sgbd-postgresql.md) | PostgreSQL como sistema de gestão de base de dados | Aceite | RNF20 |
| [ADR-0002](ADR-0002-contentores-docker.md) | Execução em contentores Docker, com Docker Compose | Aceite | RNF21 |
| [ADR-0003](ADR-0003-autenticacao-sessao-cookie.md) | Autenticação com sessão em cookie no backend Flask | Proposta | RF05, RNF23, RNF24, RNF25 |
| [ADR-0004](ADR-0004-armazenamento-ficheiros.md) | Ficheiros multimédia num volume, servidos com verificação de acesso | Proposta | RF12, RF16, RNF22 |
| [ADR-0005](ADR-0005-spa-react-api-rest.md) | Frontend SPA em React e API REST em Flask, na mesma origem | Proposta | RNF17, RNF18, RNF19 |

## Modelo C4

O [modelo C4](c4.md) descreve o sistema em dois níveis:

- **Nível 1 (contexto):** o sistema, os atores e os sistemas externos;
- **Nível 2 (contentores):** as aplicações e os dados que compõem o sistema e como comunicam.
