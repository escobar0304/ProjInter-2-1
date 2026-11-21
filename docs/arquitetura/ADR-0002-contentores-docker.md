# ADR-0002: Execução em contentores Docker, com Docker Compose

| | |
|---|---|
| Estado | Aceite |
| Data | Sprint A (novembro de 2026) |
| Requisitos | RNF21 (e RNF15, RNF28) |

## Contexto

A equipa trabalha em computadores diferentes (Windows, macOS e Linux) e o sistema tem várias peças: o frontend React, o backend Flask, o PostgreSQL e os ficheiros multimédia. Instalar e configurar tudo à mão em cada computador gera diferenças de versões («na minha máquina funciona») e atrasa quem entra no projeto.

O CI (US_A012) já usa um contentor PostgreSQL para validar o `schema.sql`.

## Decisão

A partir da Sprint B, a aplicação corre em **contentores Docker**, definidos num `docker-compose.yml` na raiz do repositório, com um serviço por contentor do [modelo C4](c4.md):

- `web`: servidor web (Nginx) com o frontend React compilado, que encaminha os pedidos `/api` para o backend;
- `api`: backend Flask;
- `db`: PostgreSQL 18, com os dados num volume;
- os ficheiros multimédia ficam num volume partilhado entre `web` e `api` ([ADR-0004](ADR-0004-armazenamento-ficheiros.md)).

As configurações sensíveis (palavras-passe da base de dados, credenciais SMTP) ficam num ficheiro `.env` local, que nunca é commitado; o repositório tem um `.env.example` sem valores reais.

## Alternativas consideradas

| Alternativa | Vantagens | Porque não foi escolhida |
|---|---|---|
| Instalação local em cada computador | Sem ferramentas extra | Versões diferentes do Python, do Node e do PostgreSQL em cada computador; configuração repetida três vezes. |
| Máquina virtual partilhada | Ambiente igual para todos | Pesada, lenta a arrancar e difícil de manter atualizada. |
| Serviços geridos na cloud (ex.: base de dados alojada) | Sem instalação local | Custos, dependência de rede e dados de menores fora do controlo da equipa (RNF22). |

## Consequências

- O mesmo `docker compose up` arranca o sistema inteiro em qualquer computador da equipa e no servidor de demonstração.
- As versões ficam fixadas nas imagens; o PostgreSQL do Docker é o mesmo do CI (18).
- A equipa tem de instalar o Docker Desktop (ou o Docker Engine no Linux) e aprender o básico de Docker Compose.
- Os dados da base de dados e os ficheiros vivem em volumes: as cópias de segurança (RNF09) têm de incluir os dois.
- Na Sprint A não há código, por isso a decisão só é aplicada na Sprint B.
