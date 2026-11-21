# A005 — Descrição estruturada do questionário final

| | |
|---|---|
| User Story | US_A005 ([#5](https://github.com/escobar0304/ProjInter-2-1/issues/5)) |
| Branch | `feature/A005-Questionario-Final` |
| Responsável | Pedro Vale (`QuakeXIV`) |
| Estado | Proposta para revisão em PR |

## O que foi feito

- [Descrição fully dressed de UC27 Answer Final Questionnaire](../../docs/uml/uc-responder-questionario-final.md), coerente com o diagrama v1.1 e o glossário.
- Ator e interessados, pré-condições, garantias mínimas e de sucesso, cenário principal de dez passos, extensões, RNF, frequência e exemplos de validação.
- Distinção entre conclusão e recompensa, preservação das primeiras tentativas e referência à extensão UC28.
- Questões abertas de acesso prévio ao conteúdo, idempotência, concorrência e preservação histórica das perguntas, sem inventar capacidades no schema atual.

## Dependências verificadas

Em 21/11/2026, #5 está em In progress e atribuída a QuakeXIV. #2 e #4 estão fechadas. Existem o diagrama de use cases e o glossário, mas o diagrama de domínio e a tabela de agregados de #4 ainda não aparecem no `main`. O alinhamento com esse artefacto fica explicitamente pendente.

## Como verificar

- Comparar nome, ator e relação com UC28 no diagrama de use cases.
- Rever cada passo: pertence apenas ao User ou ao Sistema.
- Conferir os exemplos de 80%, 85%, repetição, concorrência, rollback e conta suspensa contra os requisitos e o modelo.
- Correr lint e validação de links conforme o CI.

## Pendente

- Revisão em PR por outro membro da equipa e validação das propostas de interação.
- Alinhamento com o modelo de domínio completo quando estiver disponível.
- Validação dos pressupostos com o cliente e definição dos mecanismos técnicos na Sprint B.

## Uso de IA

Codex (OpenAI): apoio à redação e revisão de coerência. A equipa confirma a classificação no sistema de semáforos e valida o resultado.
