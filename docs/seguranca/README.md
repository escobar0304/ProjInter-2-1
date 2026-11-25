# Privacidade e segurança

Análise de privacidade e segurança da plataforma (US_A015, [issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)). O público-alvo são jovens do 3.º ciclo e do ensino secundário, quase todos menores, e a especificação (§C) pede atenção especial aos seus dados.

| Documento | Conteúdo |
|---|---|
| [Inventário de dados pessoais](inventario-dados-pessoais.md) | Cada dado pessoal, com a finalidade, a base legal, o prazo de conservação e quem lhe acede; dados de menores assinalados. |
| [Consentimento parental e direitos do titular](consentimento-direitos.md) | Como o consentimento fica provado e pode ser revogado, o que acontece à conta e aos dados, e como se exercem os direitos de acesso, retificação, apagamento e portabilidade. |
| [Matriz de permissões](matriz-permissoes.md) | O que cada perfil (Guest, Registered User, Manager, Administrator) pode fazer em cada use case, e a permissão verificada no backend. |
| [Modelação de ameaças (STRIDE)](ameacas-stride.md) | Ameaças ao registo, ao início de sessão, ao consentimento e ao acesso aos dados, com a mitigação e o requisito de cada uma. |

## Requisitos de segurança

A análise deu origem a requisitos novos no [levantamento de requisitos](../requisitos/furps.md) (US_A001):

| Requisitos | Tema |
|---|---|
| RF47 | Autoproteção das contas de Administrator. |
| RF48 | Correção da data de nascimento e novo pedido de consentimento. |
| RF49 | Dados do menor depois da revogação do consentimento. |
| RNF29, RNF30, RNF32 | Início de sessão: bloqueio por tentativas, palavras-passe e mensagens que não revelam contas. |
| RNF31, RNF33 | Tokens dos links e gestão da sessão. |
| RNF34, RNF35 | Registo de auditoria e prova do consentimento. |
| RNF36, RNF37 | Autorização por objeto e campos da API. |
| RNF38 a RNF41 | Ficheiros, XSS, injeção de SQL e limite de pedidos. |
| RNF42, RNF44 | Segredos e cópias de segurança. |
| RNF43, RNF45, RNF46 | Prazos de conservação, exportação pseudonimizada e conteúdo dos emails. |

Também foi acrescentada a dúvida D12, sobre os dados de um menor depois da revogação e da maioridade.
