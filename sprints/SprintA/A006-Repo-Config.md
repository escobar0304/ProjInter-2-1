# A006 — Configuração do repositório

| | |
|---|---|
| User Story | US_A006 ([issue #6](https://github.com/escobar0304/ProjInter-2-1/issues/6)) |
| Branch | `feature/A006-Repo-Config` |
| Responsável | Diogo Escobar |

## Objetivo

Preparar o repositório GitHub do projeto para o trabalho em equipa: estrutura inicial, README, `.gitignore` e regras de branches e Pull Requests.

## O que foi feito

- Criação do `main`, com o README e o `.gitignore` iniciais.
- Ruleset de proteção do `main`.
- Ruleset de nomes de branches: só são aceites `main` e `feature/**`.
- README com a descrição do projeto, stack, equipa, orientação, sprints, estrutura do repositório, regras de trabalho e uso de IA generativa.
- `.gitignore` para Python/Flask, Node/React, ficheiros de ambiente, sistema operativo, IDE e cópias de segurança do draw.io.
- Estrutura de pastas inicial: `docs/` (por tipo de artefacto), `sprints/`, `frontend/`, `backend/`, `database/` e `.github/`.
- Template de Pull Request.

## Decisões

- **`docs/` organizada por tipo de artefacto, e não por sprint.** Os diagramas evoluem de sprint para sprint; assim, cada um tem um só sítio com a versão atual e o histórico fica no git. O que foi entregue em cada sprint é identificado pelas tags (`sprint-a`, `sprint-b`, `sprint-c`).
- **`frontend/` e `backend/` ficam vazias nesta sprint.** A organização interna do código é decidida na Sprint B e registada num ADR.
- **Branches só com o prefixo `feature/`**, imposto por ruleset.

## Como verificar

- Criar uma branch com outro prefixo (ex.: `teste/x`) é recusado pelo GitHub.
- Um push direto para o `main` é recusado.
- `git check-ignore -v .env` confirma que os ficheiros `.env` são ignorados.

## Pendente

- Confirmar que o Pedro Vale (`QuakeXIV`) tem acesso ao repositório.
- Revisão e merge do Pull Request por outro elemento da equipa.
