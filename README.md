# ProjInter-2-1 — Plataforma de Literacia em Saúde para Jovens

Projeto interdisciplinar do 1.º semestre do 2.º ano da Licenciatura em Engenharia Informática do **ISTEC Porto**, no ano letivo 2026/2027.

## Sobre o projeto

Aplicação web que disponibiliza *webinars* e *workshops* sobre várias áreas da saúde, pensada para jovens do 3.º ciclo e do ensino secundário. As atividades são dinamizadas por professores e profissionais de saúde.

Cada recurso formativo é acompanhado por um questionário de diagnóstico, respondido antes, e por um questionário final, respondido depois. A comparação entre os dois mede o progresso de aprendizagem de cada utilizador. A plataforma inclui ainda:

- gamificação, com *badges* e certificados pela conclusão dos recursos;
- uma biblioteca virtual com publicações, notícias, agenda de atividades e destaques da semana;
- uma área de administração (backoffice) para gerir conteúdos, questionários e utilizadores, e para consultar indicadores de utilização e de aprendizagem.

## Stack

| Camada | Tecnologia |
|---|---|
| Frontend | React |
| Backend | Python com Flask |
| Base de dados | PostgreSQL |
| Contentores | Docker e Docker Compose (a partir da Sprint B) |

## Equipa

| Nome | GitHub | Papel |
|---|---|---|
| Diogo Escobar | [escobar0304](https://github.com/escobar0304) | Team leader |
| João Crasto | [crastoo](https://github.com/crastoo) | Membro da equipa |
| Pedro Vale | [QuakeXIV](https://github.com/QuakeXIV) | Membro da equipa |

## Orientação

| Nome | GitHub | Papel |
|---|---|---|
| Helder Rodrigo Pinto | [helderspinto](https://github.com/helderspinto) | Docente |

## Sprints

| Sprint | Período | Peso | Objetivos |
|---|---|---|---|
| [A](sprints/SprintA/README.md) | 31/10/2026 – 21/11/2026 | 25% | Engenharia de requisitos, modelos UML e planeamento do projeto |
| B | 21/11/2026 – 19/12/2026 | 25% | Estudo de UI/UX, estrutura base do frontend e implementação da base de dados |
| C | 19/12/2026 – 16/01/2027 | 50% | Funcionalidades gerais da plataforma, validação e testes |

O planeamento e o estado de cada User Story estão no [quadro do GitHub Projects](https://github.com/users/escobar0304/projects/2/views/1). Cada User Story é uma issue, com prioridade (P1 a P4), estimativa (S, M, L), sprint e área.

## Estrutura do repositório

```
docs/                  # ficheiros dos artefactos (.drawio, imagens, Gantt, PDFs), por tipo
  requisitos/          #   levantamento de requisitos (FURPS+)
  uml/                 #   use cases e modelo de domínio
  bpmn/                #   fluxogramas
  base-de-dados/       #   modelo relacional e dicionário de dados
  metricas/            #   métricas de aprendizagem
  arquitetura/         #   decisões de arquitetura (ADR) e modelo C4
  seguranca/           #   privacidade, permissões e ameaças
  planeamento/         #   mapas de Gantt
  entregas/            #   relatórios e apresentações de cada sprint
sprints/               # um README por sprint e um .md por feature
frontend/              # aplicação React
backend/               # API em Python/Flask
database/              # scripts SQL (PostgreSQL) e dados de teste
.github/               # template de Pull Request e workflows
```
