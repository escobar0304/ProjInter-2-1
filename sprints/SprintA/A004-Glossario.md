# A004 — Glossário (linguagem ubíqua)

| | |
|---|---|
| User Story | US_A004 ([issue #4](https://github.com/escobar0304/ProjInter-2-1/issues/4)), 1.ª parte |
| Branch | `feature/A004-Glossario` |
| Responsável | João Crasto |

## Objetivo

Definir a linguagem ubíqua do sistema: os termos do domínio, cada um com uma definição curta, os termos a evitar e a fonte. O glossário é a base dos nomes do diagrama de use cases (US_A002), do modelo de domínio (US_A004, 2.ª parte) e do modelo relacional (US_A003).

## O que foi feito

- Documento [`docs/uml/glossario.md`](../../docs/uml/glossario.md), com:
  - âmbito, fontes e convenções;
  - 52 termos, agrupados em 7 áreas: atores, conta e acesso, formação, questionários, gamificação, biblioteca e conteúdos, plataforma e estatística;
  - os pressupostos sobre as dúvidas D01, D02 e D04 a D11 e os pressupostos da equipa;
  - a correspondência entre os nomes da v1.0 (use cases e modelo relacional) e os termos do glossário.
- Cada termo tem o formato `| Termo | Definição | Evitar | Fonte |`, com a fonte na especificação ou no levantamento de requisitos.

## Decisões

- **Termos em inglês e definições em português**, por decisão da equipa. Os diagramas v1.0 já estão em inglês e os nomes passam diretamente para o código e para a base de dados. O termo português do levantamento de requisitos fica entre parênteses, para manter a rastreabilidade.
- **Um termo por conceito.** As ambiguidades das fontes foram resolvidas com termos distintos:
  - "perfil": Role (perfil de acesso) e User Profile (página de perfil);
  - "recurso": Training Resource (sempre com o qualificativo);
  - "registo" e "inscrição": Registration (na plataforma) e Enrollment (num recurso);
  - "resposta": Answer Option (alternativa da pergunta) e Answer (opção escolhida pelo utilizador).
- **Conceitos sem suporte no modelo relacional v1.0** ficam já no glossário, porque correspondem a requisitos: Attempt (RF19, RF21), Parental Consent (RF03, RF04, RF45), Badge e Certificate atribuídos (RF23, RF24), Permission (RF34), Weekly Highlight (RF10) e Translation (RF31).
- **Virtual Library sem os Training Resources**, ao contrário do diagrama de use cases v1.0, de acordo com a §C da especificação.

## Pressupostos

As definições que dependem de dúvidas ainda sem resposta (D01, D02, D04 a D11) estão marcadas no glossário e listadas na secção 3 do documento. Os pressupostos sem dúvida associada são: Category como tipo de Publication, Completion com a submissão do Final Questionnaire, School Year do 7.º ao 12.º ano e Score em percentagem.

## Como verificar

- Cada termo tem definição, termos a evitar e fonte.
- Os termos do domínio da especificação (§B a §D.3) e do levantamento de requisitos aparecem no glossário.
- Cada pressuposto indica a dúvida e os termos afetados.
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Alinhar os nomes com o modelo relacional v1.1 (US_A003) quando for publicado.
- Atualizar os pressupostos quando o cliente responder às dúvidas D01 a D11.
- Propor ao responsável do levantamento de requisitos uma dúvida sobre o significado de "categoria" (§C.1, RF27).
