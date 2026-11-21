# ADR-0001: PostgreSQL como sistema de gestão de base de dados

| | |
|---|---|
| Estado | Aceite |
| Data | Sprint A (novembro de 2026) |
| Requisitos | RNF20 (e RNF13, RNF14, RNF22) |

## Contexto

A especificação (Parte 02, §E) indica MySQL ou SQL Server como SGBD. A equipa não frequenta a unidade curricular de bases de dados que impõe essa escolha, e o orientador confirmou que, nesse caso, as regras dessa unidade curricular não têm de ser aplicadas.

O modelo de dados (US_A003) precisa de:

- regras que a própria base de dados garanta, para não dependerem só do código: uma só opção correta por pergunta, um só pedido de consentimento aberto por menor, um destaque que aponta para exatamente um conteúdo;
- datas e horas sem ambiguidade de fuso horário (prazos de consentimento, tokens, utilizadores ativos);
- um SGBD gratuito, que corra da mesma forma no Windows, no macOS, no Linux, no CI e em Docker.

## Decisão

Usar **PostgreSQL**, na versão 18 em Docker e no CI. O `database/schema.sql` é compatível com o PostgreSQL 16 ou superior.

Esta decisão foi **validada pelo orientador**.

## Alternativas consideradas

| Alternativa | Vantagens | Porque não foi escolhida |
|---|---|---|
| MySQL 8 | Indicado na especificação; muito usado | Não tem índices únicos parciais (`... WHERE ...`), que o modelo usa em `answer_options_one_correct` e em `parental_consents_one_open`. As datas com fuso horário (`TIMESTAMP`) têm um intervalo limitado (até 2038). |
| SQL Server | Indicado na especificação; tem índices filtrados | A edição gratuita (Express) tem limites de tamanho; a imagem Docker é pesada e exige mais memória nos computadores da equipa. |
| SQLite | Sem servidor; simples para começar | Serializa as escritas, o que limita vários utilizadores em simultâneo (RNF12), e não tem um servidor separado como o de produção, o que esconde diferenças até tarde. |

## Consequências

- O modelo usa funcionalidades do PostgreSQL que garantem regras de negócio na base de dados: índices únicos parciais, `CHECK` com várias colunas, `num_nonnulls(...)`, chaves geradas (`GENERATED ALWAYS AS IDENTITY`) e `timestamptz`.
- O CI cria a base de dados a partir do `schema.sql` num contentor PostgreSQL em cada Pull Request (US_A012).
- Mudar de SGBD mais tarde obriga a rever essas funcionalidades. A forma como o backend acede à base de dados fica para o ADR da organização interna do backend (Sprint B).
