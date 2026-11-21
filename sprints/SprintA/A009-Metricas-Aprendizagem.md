# A009 — Métricas de utilização e de aprendizagem

| | |
|---|---|
| User Story | US_A009 ([#9](https://github.com/escobar0304/ProjInter-2-1/issues/9)) |
| Branch | `feature/A009-Metricas-Aprendizagem` |
| Responsável | Pedro Vale (`QuakeXIV`) |
| Estado | Desenvolvida localmente; aguarda revisão em PR |

## Objetivo

Definir as métricas de D.2 e D.3 e mapear as variáveis para o schema v1.1, sem implementar já a API da Sprint B.

## O que foi feito

- [Catálogo das métricas](../../docs/metricas/metricas.md): objetivo, fórmula, variáveis, origem e agregação, unidades, permissões, casos-limite, pressupostos e limitações do modelo.
- [Consultas PostgreSQL de leitura](../../docs/metricas/consultas-metricas.sql) para os pares pré/pós, ganhos, distribuição dos Scores, proporção de acerto e indicadores atuais de utilização.
- Distinção entre conclusão do recurso e obtenção de recompensa, primeiras tentativas e repetições, facilidade e discriminação das perguntas.
- Proposta de bootstrap por User e teste bilateral por permutação, com seed e tratamento de amostras insuficientes.

## Dependências verificadas

Em 21/11/2026, a consulta MCP ao GitHub Projects confirmou #9 em **Ready**, atribuída a `QuakeXIV`. #1, #3 e #7 estão fechadas e os seus artefactos existem no `main`. #16 depende desta definição e continua fora do trabalho desta branch. Os pressupostos do glossário continuam sujeitos à resposta do cliente.

## Como verificar

- Conferir as referências `tabela.coluna` com `database/schema.sql`.
- Confirmar cobertura de RF21 a RF25 e RF36 a RF44 e dos casos-limite na secção 5 do catálogo.
- Executar as consultas numa BD criada com o schema v1.1 e os dados sintéticos de #16.
- Correr lint de Markdown e validação dos links conforme o CI.

## Validação local

- Lint com `markdownlint-cli2@0.24.0`: sem erros.
- As quatro consultas executaram sobre o schema original em PostgreSQL 18.7 embebido (PGlite 0.5.17), numa BD temporária em memória.
- Casos verificados: BD vazia, primeiras tentativas perante repetições, pré = 100, ganho negativo, ausência de Final e contagens por pergunta sem duplicação por repetição. O teste usa dados mínimos fictícios e não constitui o protótipo nem os entregáveis da #16.
- A validação no PostgreSQL do CI continua necessária; PGlite não valida a configuração Docker nem a aplicação futura.

## Pendente

- Revisão e aprovação por outro elemento da equipa.
- Confirmar pressupostos e convenções analíticas com o cliente.
- Discutir os limites registados na secção 6 com os responsáveis do modelo e do dicionário; não foram alterados entregáveis dessas US.

## Uso de IA

Codex (OpenAI): apoio à redação, consultas e revisão de coerência. A equipa deve validar e defender o conteúdo e confirmar a classificação de uso no sistema de semáforos do enunciado.
