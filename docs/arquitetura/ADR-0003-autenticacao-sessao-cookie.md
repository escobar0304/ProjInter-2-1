# ADR-0003: Autenticação com sessão em cookie no backend Flask

| | |
|---|---|
| Estado | Proposta |
| Data | Sprint A (novembro de 2026) |
| Requisitos | RF05, RF35, RF45, RNF23, RNF24, RNF25 |

## Contexto

O utilizador inicia sessão com email e palavra-passe (RF05). O backend tem de verificar as permissões de cada perfil em todos os pedidos (RNF24), e uma conta que deixa de estar ativa tem de perder o acesso logo: suspensa pelo Administrator (RF35) ou pela revogação do consentimento parental (RF45).

O frontend React e a API Flask são servidos na mesma origem ([ADR-0005](ADR-0005-spa-react-api-rest.md)), por isso o browser envia os cookies da sessão sem configuração de CORS.

## Decisão

Usar **sessões com cookie**, geridas pelo Flask (com a extensão Flask-Login):

- depois do início de sessão, o backend guarda o identificador do User na sessão, num cookie assinado com as opções `HttpOnly`, `Secure` (em produção) e `SameSite=Lax`;
- em cada pedido, o backend carrega o User da base de dados e confirma que a conta está `active` e que o Role tem a permissão necessária. Uma conta suspensa perde o acesso no pedido seguinte;
- os pedidos que alteram dados exigem um token CSRF;
- as palavras-passe são guardadas com Argon2 (RNF23), na coluna `users.password_hash`;
- o fim de sessão (RF05) apaga o cookie da sessão.

## Alternativas consideradas

| Alternativa | Vantagens | Porque não foi escolhida |
|---|---|---|
| Token JWT guardado no browser (`localStorage`) | Sem estado no servidor; comum em SPA | O token fica acessível a JavaScript: um ataque XSS rouba-o. Revogar um token antes de expirar exige uma lista de tokens revogados, o que anula a vantagem de não ter estado. |
| Token JWT num cookie `HttpOnly` | Protegido de XSS | Continua difícil de revogar logo (RF35, RF45) e acrescenta complexidade sem ganho numa aplicação com uma só API na mesma origem. |
| Início de sessão com contas externas (ex.: Google) | Sem palavras-passe para gerir | Muitos utilizadores são menores sem conta própria nestes serviços; obriga a partilhar dados com terceiros (RNF22) e não substitui o registo com consentimento (RF03). |

## Consequências

- A revogação é imediata: como o estado da conta é lido em cada pedido, suspender uma conta corta o acesso sem esperar que um token expire.
- Cada pedido faz uma leitura da tabela `users`. Com o volume previsto (RNF12), o custo é baixo.
- O cookie `SameSite=Lax` e o token CSRF protegem contra pedidos forjados a partir de outros sites.
- Se no futuro houver uma aplicação móvel nativa (W02, fora de âmbito), esta decisão terá de ser revista com um novo ADR.
