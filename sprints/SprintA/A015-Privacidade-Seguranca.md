# A015 — Análise de privacidade e segurança

| | |
|---|---|
| User Story | US_A015 ([issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)), extra |
| Branch | `feature/A015-Privacidade-Seguranca` |
| Responsável | João Crasto |

## Objetivo

Saber que dados pessoais a plataforma trata, quem pode fazer o quê e que ameaças existem, com atenção especial aos dados de menores (§C), e transformar os riscos em requisitos de segurança verificáveis antes da implementação.

## O que foi feito

Pasta [`docs/seguranca/`](../../docs/seguranca/README.md), com:

- [inventário de dados pessoais](../../docs/seguranca/inventario-dados-pessoais.md): todas as colunas do modelo relacional que guardam dados pessoais, e os dados fora da base de dados (ficheiros, cookie da sessão, logs, emails, cópias de segurança e exportação CSV), cada um com a classe (DP ou DP-M), a finalidade, a base legal, o prazo de conservação e quem lhe acede;
- [consentimento parental e direitos do titular](../../docs/seguranca/consentimento-direitos.md): quando é pedido, como fica provado (o quê, quando e por quem), os limites da prova, os estados e as consequências para a conta e para os dados, a revogação e os direitos de informação, acesso, retificação, apagamento, portabilidade, retirada do consentimento, limitação e oposição;
- [matriz de permissões](../../docs/seguranca/matriz-permissoes.md): os UC01 a UC48 para os quatro perfis (e o Guardian, que só age com token), com a permissão verificada no backend e a verificação da coerência com a herança dos atores;
- [modelação de ameaças STRIDE](../../docs/seguranca/ameacas-stride.md): 33 ameaças aos fluxos de registo, início de sessão, consentimento e acesso aos dados, e aos ficheiros, ao backoffice e à infraestrutura, na tabela `| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |`, com a cobertura das seis categorias e os riscos aceites.

[Levantamento de requisitos](../../docs/requisitos/furps.md) v1.2, com IDs novos e sem renumerar os existentes:

- RF47 a RF49: autoproteção do Administrator, correção da data de nascimento e dados do menor depois da revogação;
- RNF29 a RNF46: requisitos de segurança e legais (início de sessão, tokens, sessão, auditoria, prova do consentimento, autorização por objeto, campos da API, ficheiros, XSS, SQL, limite de pedidos, segredos, conservação, cópias de segurança, exportação pseudonimizada e emails);
- dúvida D12, sobre os dados de um menor depois da revogação e da maioridade.

## Decisões

- **Seguir a especificação nos 18 anos.** A Lei n.º 58/2019 só exige o consentimento parental abaixo dos 13 anos; a especificação pede-o para todos os menores, e é mais protetora.
- **Prova do consentimento pelo controlo do email**, com a versão do texto lido e o registo de auditoria. Sem conta do Guardian (D11), a plataforma não verifica a identidade; o risco fica aceite e reduzido pelo link de revogação.
- **Revogação com suspensão imediata e eliminação ao fim de 30 dias**, o mesmo prazo dos registos não concluídos e recusados do fluxograma do registo. O Guardian pode pedir a eliminação imediata.
- **Data de nascimento corrigida só pelo Administrator**, porque decide se é preciso consentimento.
- **Indicadores e exportações pseudonimizados**, com os grupos de menos de 5 Users ocultos, para não identificar um menor pelos resultados.
- **Guardian numa coluna à parte na matriz**: não é um perfil, mas é um ator dos UC05 e UC06.
- **Pressupostos S1 a S6** para os prazos e as situações que a especificação não define, separados dos pressupostos P1 a P8 do fluxograma.

## Como verificar

- Todas as colunas marcadas como DP ou DP-M no dicionário de dados estão no inventário.
- A matriz tem uma linha por UC (48) e cada coluna tem pelo menos as autorizações da coluna à esquerda.
- As seis categorias STRIDE têm ameaças, e cada ameaça tem uma mitigação e um requisito.
- Os requisitos novos estão no FURPS+ com os números seguintes aos existentes (RF47, RNF29) e a origem «Equipa (US_A015)».
- O CI (lint de Markdown e links internos) passa no Pull Request.

## Pendente

- Propor ao responsável do modelo relacional (US_A003), para a Sprint B, o que os requisitos novos pedem à base de dados: a versão do texto de consentimento e da política de privacidade (RNF35), o registo de auditoria (RNF34) e a forma de terminar as outras sessões (RNF33).
- Alinhar com o responsável das métricas (US_A009) o formato da exportação CSV e o limite de 5 Users por grupo (RNF45).
- Atualizar a análise quando o cliente responder às dúvidas D02, D11 e D12.
