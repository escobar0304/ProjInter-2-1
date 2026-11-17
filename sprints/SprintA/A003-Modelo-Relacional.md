# A003 — Modelo relacional de dados (v1.1)

| | |
|---|---|
| User Story | US_A003 ([issue #3](https://github.com/escobar0304/ProjInter-2-1/issues/3)) |
| Branch | `feature/A003-Modelo-Relacional` |
| Responsável | Diogo Escobar |

## Objetivo

Reformular o modelo relacional v1.0 fornecido, para que suporte os requisitos (US_A001) e os use cases (US_A002), com os nomes do glossário (US_A004), e criar o script que gera a base de dados em PostgreSQL.

## O que foi feito

- Script [`database/schema.sql`](../../database/schema.sql), com 40 tabelas, as restrições de integridade, os índices e os dados de referência (idiomas, estados, Roles e permissões).
- Diagrama [`docs/base-de-dados/modelo-relacional.drawio`](../../docs/base-de-dados/modelo-relacional.drawio), com três páginas (Conta e acesso, Formação e questionários, Biblioteca virtual) e as imagens em SVG.
- Documento [`docs/base-de-dados/modelo-relacional.md`](../../docs/base-de-dados/modelo-relacional.md), com:
  - as tabelas por área e o termo do glossário correspondente;
  - as alterações face à v1.0, com o motivo de cada uma;
  - as decisões de modelação;
  - as regras de negócio garantidas pela base de dados e as que ficam para o backend;
  - os pressupostos e a forma de validar o script.

## Decisões

- **O `schema.sql` é a fonte de verdade.** O CI cria a base de dados a partir dele em cada Pull Request; o diagrama foi gerado a partir da mesma estrutura.
- **Traduções numa tabela por entidade** (`*_translations`), para suportar português e inglês nos conteúdos (D08) sem alterar o código para acrescentar idiomas (RNF13).
- **Novas tabelas para o que a v1.0 não guardava:** respostas a cada pergunta (`attempt_answers`), consentimento parental (`parental_consents`), tokens dos links por email (`user_tokens`), badges e certificados atribuídos, permissões e destaques da semana.
- **Um Role por User**, em vez da tabela `role_user` (RF33).
- **Imagens em SVG**, em vez de PNG: são texto, por isso têm diferenças legíveis no Git.
- **Colunas pedidas pelo fluxograma do registo (US_A008):** token de revogação do consentimento, data de aceitação da política de privacidade e data da última mudança de estado da conta.

## Como verificar

- O job «Schema PostgreSQL» do CI passa no Pull Request.
- Cada tabela da v1.0 aparece na tabela de alterações do documento, com o destino na v1.1.
- Os nomes das tabelas correspondem aos termos do glossário.

## Pendente

- Rever o modelo com o João Crasto, para alinhar com o modelo de domínio (US_A004).
- Dicionário de dados (US_A007), a partir do `schema.sql`.
- Atualizar o modelo quando o cliente responder às dúvidas D01 a D11.
