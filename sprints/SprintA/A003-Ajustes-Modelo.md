# A003 — Ajustes ao modelo relacional depois do modelo de domínio

| | |
|---|---|
| User Stories | US_A003 ([issue #3](https://github.com/escobar0304/ProjInter-2-1/issues/3)) e US_A007 ([issue #7](https://github.com/escobar0304/ProjInter-2-1/issues/7)) |
| Branch | `feature/A003-Ajustes-Modelo` |
| Responsável | Diogo Escobar |

## Objetivo

Alinhar o modelo relacional v1.1 com o [modelo de domínio](../../docs/uml/modelo-dominio.md) (US_A004) e corrigir as lacunas encontradas na revisão das métricas (US_A009) e da descrição do UC27 (US_A005).

## O que foi feito

- **Acesso ao conteúdo de um recurso sem Levels.** Nova coluna `enrollments.content_accessed_at`. O Final só pode ser respondido depois de o User ver o conteúdo (RF20); nos recursos com Levels isso já se sabia por `level_progress`, nos recursos sem Levels não havia registo.
- **Attempt do mesmo recurso da Enrollment.** Nova coluna `attempts.training_resource_id` e duas chaves estrangeiras compostas, para enrollments e para questionnaires. A base de dados recusa uma Attempt com um Questionnaire de outro recurso.
- **Regras do Questionnaire no backend.** Pelo menos 2 opções por pergunta, exatamente uma correta, e sem alterações às perguntas e às opções depois da primeira Attempt.
- Atualizados:
  - o [`schema.sql`](../../database/schema.sql);
  - o [modelo relacional](../../docs/base-de-dados/modelo-relacional.md): alterações face à v1.0, decisões de modelação e regras de negócio;
  - o diagrama, página «Formação e questionários» (`.drawio` e SVG);
  - o [dicionário de dados](../../docs/base-de-dados/dicionario-dados.md): `enrollments`, `questionnaires` e `attempts`;
  - a secção 8 do modelo de domínio.

## Decisões

- **Chaves compostas em vez de um trigger.** A coluna `attempts.training_resource_id` repete um valor, o que é uma exceção à 3.ª forma normal. É aceite porque as duas chaves compostas garantem que o valor é sempre o mesmo da Enrollment e do Questionnaire, e a regra fica visível no modelo.
- **As regras das perguntas ficam no backend.** Contar as opções de cada pergunta e bloquear alterações depois da primeira Attempt exige ler várias linhas, o que um `CHECK` não faz.
- **A versão continua a ser a v1.1.** As alterações acrescentam colunas e restrições antes da entrega da Sprint A e não mudam as tabelas.

## Como verificar

- O job «Schema PostgreSQL» do CI passa no Pull Request.
- Numa base de dados criada a partir do `schema.sql`, inserir uma Attempt com um Questionnaire de outro recurso dá erro de chave estrangeira.
- As consultas das métricas (US_A009) continuam a correr sem alterações.
