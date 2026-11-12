# Levantamento de requisitos (FURPS+)

| | |
|---|---|
| User Story | US_A001 ([issue #1](https://github.com/escobar0304/ProjInter-2-1/issues/1)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

Este documento organiza pelo método FURPS+ os requisitos da Plataforma de Literacia em Saúde para Jovens. Parte do levantamento fornecido pelo cliente (especificação, Parte 02, secção C), que o próprio documento trata como um primeiro *briefing*, e acrescenta o que resulta da análise da equipa.

### Fontes

| Referência | Fonte |
|---|---|
| §B, §C, §C.1, §D, §D.1, §D.2, §D.3, §E | Secções da especificação do sistema (Parte 02) |
| UC v1.0 | Diagrama de use cases fornecido (versão 1.0) |
| MR v1.0 | Modelo relacional fornecido (versão 1.0) |
| Equipa | Requisito acrescentado pela equipa, a validar com o cliente |

### Convenções

- `RFnn` identifica um requisito funcional e `RNFnn` um requisito não funcional. Os IDs não mudam depois de publicados: um requisito novo recebe o número seguinte e um requisito removido fica marcado como "removido".
- Prioridade (MoSCoW): **M** obrigatório, **S** importante, **C** desejável, **W** fora de âmbito nesta versão.
- Os requisitos funcionais estão agrupados por área:

| Área | Âmbito |
|---|---|
| AUT | Registo, autenticação e consentimento |
| PUB | Conteúdo público e biblioteca virtual |
| REC | Recursos formativos e inscrições |
| QST | Questionários e percurso de aprendizagem |
| GAM | Badges e certificados |
| GES | Gestão de conteúdos (backoffice) |
| ADM | Administração de utilizadores e permissões |
| EST | Estatísticas e exportação |

## 2. Atores

| Ator | Descrição | Herda de | Origem |
|---|---|---|---|
| Convidado | Visitante sem sessão iniciada | — | §C.1 |
| Utilizador Registado | Utilizador com conta ativa. O público-alvo principal são jovens do 3.º ciclo e do ensino secundário | Convidado | §C, §C.1 |
| Manager (Gestor de Conteúdos) | Utilizador registado com acesso à área de administração (backoffice) | Utilizador Registado | §C.1 |
| Administrador | Utilizador com acesso total ao sistema | Manager | §C.1 |
| Encarregado de educação (ator secundário) | Aceita ou recusa, a partir do email recebido, o registo de um menor. Não tem conta na plataforma | — | §C (proposta da equipa) |
| Serviço de email (sistema externo) | Envia os emails de confirmação, de consentimento e de recuperação da palavra-passe | — | UC v1.0 |
