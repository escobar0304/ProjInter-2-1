# A007 — Dicionário de dados

| | |
|---|---|
| User Story | US_A007 ([issue #7](https://github.com/escobar0304/ProjInter-2-1/issues/7)) |
| Branch | `feature/A007-Dicionario-Dados` |
| Responsável | Diogo Escobar |

## Objetivo

Documentar cada tabela e cada coluna do modelo relacional v1.1 (US_A003), para que qualquer pessoa da equipa saiba o que significa cada dado e que regras tem.

## O que foi feito

- Documento [`docs/base-de-dados/dicionario-dados.md`](../../docs/base-de-dados/dicionario-dados.md), com:
  - as 40 tabelas, agrupadas por área, com a descrição e a chave primária;
  - para cada coluna: tipo do PostgreSQL, tamanho, se aceita nulos, valor por omissão, chaves, restrições, descrição e exemplo;
  - as restrições que envolvem várias colunas, por baixo de cada tabela;
  - os dados pessoais (**DP**) e os dados de menores (**DP-M**) assinalados, com um resumo por tabela;
  - os valores iniciais das tabelas de referência.

## Decisões

- **Gerado a partir da base de dados.** Os tipos, a obrigatoriedade, os valores por omissão, as chaves e as restrições foram extraídos do PostgreSQL depois de correr o `schema.sql`, para o dicionário coincidir com o script. As descrições e os exemplos foram escritos à mão.
- **Dois níveis de dados pessoais:** DP para qualquer dado pessoal e DP-M para os que identificam um menor ou descrevem o seu desempenho (§C, RNF22).
- **Eliminação em cascata verificada:** ao apagar um User, a base de dados apaga as inscrições, as tentativas, as respostas, os badges, os certificados, os tokens e os pedidos de consentimento (RF46).

## Como verificar

- Todas as tabelas e colunas do `schema.sql` aparecem no dicionário.
- Os tipos e as restrições coincidem com o `schema.sql`.
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Atualizar o dicionário sempre que o `schema.sql` mudar (ex.: respostas do cliente às dúvidas D01 a D11).
- Usar a secção de dados pessoais na análise de privacidade (US_A015).
