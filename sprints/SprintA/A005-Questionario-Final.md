# A005 — Descrição estruturada do questionário final

| | |
|---|---|
| User Story | US_A005 ([#5](https://github.com/escobar0304/ProjInter-2-1/issues/5)) |
| Branch | `feature/A005-Questionario-Final` |
| Responsável | Pedro Vale (`QuakeXIV`) |

## O que foi feito

- [Descrição fully dressed de UC27 Answer Final Questionnaire](../../docs/uml/uc-responder-questionario-final.md), coerente com o diagrama v1.1, o glossário e os agregados Enrollment e Questionnaire, coordenados por Questionnaire Submission.
- Ator e interessados, pré-condições, garantias mínimas e de sucesso, cenário principal de dez passos, extensões, RNF, frequência e exemplos de validação.
- Distinção entre conclusão e recompensa, preservação das primeiras tentativas e referência à extensão UC28.
- Registo de acesso sem Levels e bloqueio de alterações às perguntas alinhados com o modelo relacional; idempotência e concorrência de `max_attempts` permanecem por definir no backend.

## Dependências

Diagrama de use cases da US_A002, glossário e modelo de domínio da US_A004, modelo relacional da US_A003 e dicionário de dados da US_A007. O cenário respeita as fronteiras dos agregados e as responsabilidades do serviço Questionnaire Submission.

## Como verificar

- Comparar nome, ator e relação com UC28 no diagrama de use cases.
- Rever cada passo: pertence apenas ao User ou ao Sistema.
- Conferir os exemplos de 80%, 85%, repetição, concorrência, rollback e conta suspensa contra os requisitos e o modelo.
- Correr lint e validação de links conforme o CI.

## Pendente

- Revisão em PR por outro membro da equipa e validação das propostas de interação.
- Validação dos pressupostos com o cliente e definição dos mecanismos técnicos na Sprint B.
