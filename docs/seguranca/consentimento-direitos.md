# Consentimento parental e direitos do titular

| | |
|---|---|
| User Story | US_A015 ([issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

Este documento analisa o Parental Consent: quando é pedido, como fica provado, como pode ser revogado e o que acontece à conta e aos dados em cada caso. Descreve também como o titular exerce os seus direitos sobre os dados pessoais: acesso, retificação, apagamento e portabilidade.

Completa o [fluxograma do registo](../bpmn/registo-utilizador.md) (US_A008), que detalha o pedido e a decisão, e usa os estados do [modelo relacional](../base-de-dados/modelo-relacional.md) e o agregado User do [modelo de domínio](../uml/modelo-dominio.md). Os dados envolvidos estão no [inventário de dados pessoais](inventario-dados-pessoais.md).

## 2. Quando é pedido

- O consentimento é pedido quando o User tem menos de 18 anos à data do registo (RF03, pressuposto D02). Não há idade mínima (P8 do fluxograma).
- A especificação (§C) pede o consentimento do encarregado de educação para todos os menores. A Lei n.º 58/2019 (artigo 16.º) só o exige abaixo dos 13 anos; a equipa segue a especificação, que é mais protetora.
- A conta de um Minor só passa a `active` depois de o email estar verificado **e** o consentimento estar `accepted` (RF04).
- Se a data de nascimento for corrigida pelo Administrator e o User passar a ser Minor, a conta volta a `pending_consent` e é feito um novo pedido (RF48).

## 3. Prova do consentimento

O RGPD obriga a demonstrar que o consentimento foi dado (artigo 7.º, n.º 1) e que foram feitos esforços razoáveis para confirmar que foi dado por quem tem a responsabilidade parental (artigo 8.º, n.º 2).

| Pergunta | Como fica provado | Onde fica guardado |
|---|---|---|
| **O quê?** Que decisão foi tomada e sobre que informação. | O estado do pedido (`accepted` ou `refused`) e a versão do texto informativo que o Guardian leu antes de decidir (RNF35). | `parental_consents.status` e a versão do texto (coluna a criar, RNF35) |
| **Quando?** | A data e a hora do pedido, do prazo, da decisão e da revogação. | `requested_at`, `expires_at`, `decided_at`, `revoked_at` |
| **Por quem?** | A decisão só pode ser tomada através do link único enviado para o email indicado. O link tem um token aleatório, guardado em hash, de uso único e com prazo de 7 dias (RNF31). | `guardian_email`, `token_hash` |
| **Registo independente** | Cada decisão e cada revogação ficam também no registo de auditoria, que só o Administrator lê (RNF34). | Registo de auditoria |

### Limites da prova

A plataforma não verifica a identidade do Guardian (D11): prova que a decisão foi tomada por quem controla o email indicado, não que essa pessoa é o encarregado de educação. Para reduzir o risco:

- o email do Guardian tem de ser diferente do email do Minor (P7 do fluxograma);
- o pedido explica, em linguagem simples, quem é o Minor, que dados são tratados e para quê (secção 6);
- o email de confirmação da decisão traz o link de revogação, por isso um encarregado que não autorizou pode anular a decisão a qualquer momento (RF45).

O risco que fica (um Minor que indica um segundo email que ele próprio controla) está na [tabela STRIDE](ameacas-stride.md) como ameaça T02 e foi aceite pela equipa, como em plataformas semelhantes sem verificação de identidade.

## 4. Estados e consequências

| Estado do consentimento | Quando | Conta do Minor | Dados |
|---|---|---|---|
| `pending` | O pedido é criado e enviado. | `pending_verification` ou `pending_consent` | Mantidos, à espera da decisão. |
| `accepted` | O Guardian aceita pelo link. | `active`, se o email já estiver verificado | Tratados para prestar o serviço. |
| `refused` | O Guardian recusa pelo link. | `deactivated` | Eliminados ao fim de 30 dias (P4 do fluxograma). |
| `expired` | Passam 7 dias sem resposta. | Mantém o estado | O Guest pode reenviar o pedido até 2 vezes; sem novo pedido, eliminados ao fim de 30 dias (P5). |
| `revoked` | O Guardian revoga um consentimento aceite. | `suspended` no pedido seguinte (ADR-0003) | Eliminados ao fim de 30 dias, se não houver um novo consentimento (S1); eliminação imediata a pedido do Guardian (RF49). |

## 5. Revogação

- **Como:** pelo link de revogação enviado ao Guardian no email de confirmação da decisão (UC06). O link não tem prazo, mas deixa de funcionar depois de ser usado (RNF31).
- **Efeito na conta:** a conta passa a `suspended`. Como o backend lê o estado da conta em cada pedido, o Minor perde o acesso no pedido seguinte, mesmo com a sessão iniciada ([ADR-0003](../arquitetura/ADR-0003-autenticacao-sessao-cookie.md)).
- **Efeito nos dados:** o tratamento baseado no consentimento para (artigo 7.º, n.º 3). Os dados ficam guardados 30 dias, sem acesso, para o caso de o Guardian mudar de ideias; depois são eliminados pela tarefa agendada (RNF43). Na página de revogação, o Guardian pode pedir a eliminação imediata (RF49).
- **Novo consentimento:** durante os 30 dias, o Minor pode pedir um novo consentimento, com as mesmas regras do registo (novo pedido, novo token).
- **O que não muda:** a revogação não afeta o tratamento já feito (artigo 7.º, n.º 3). Os indicadores agregados já calculados não são recalculados, mas as tentativas do Minor saem dos cálculos seguintes quando os dados são eliminados.
- **Maioridade:** quando o Minor faz 18 anos, o consentimento parental deixa de ser necessário e o link de revogação deixa de suspender a conta (S2). O User passa a exercer sozinho os direitos da secção 7.

## 6. Informação apresentada ao Guardian

O email do pedido e a página de decisão mostram só o necessário (RNF46):

- o nome próprio do Minor e o email com que se registou;
- o que é a plataforma, quem a gere e a finalidade do tratamento;
- os dados recolhidos (inventário, secção 3) e os prazos de conservação;
- que pode recusar, e revogar mais tarde, e o que acontece em cada caso;
- a ligação para a política de privacidade (UC19, RF11) e o contacto para exercer direitos.

Não mostram a data de nascimento, o ano de escolaridade nem resultados. Cada versão do texto tem um identificador, guardado com a decisão (RNF35).

## 7. Direitos do titular

O titular é o User. No caso de um Minor, o Guardian pode também exercer os direitos em seu nome (artigo 8.º e Lei n.º 58/2019). A plataforma responde no prazo de um mês (artigo 12.º, n.º 3).

| Direito | RGPD | Como se exerce na plataforma | UC e requisitos | Prazo |
|---|---|---|---|---|
| Informação | Artigos 13.º e 14.º | Política de privacidade pública e texto do pedido de consentimento. A versão aceite fica registada. | UC19; RF11, RNF22, RNF35 | Antes da recolha |
| Acesso | Artigo 15.º | O User vê os seus dados pessoais, inscrições, resultados, badges e certificados, e pode descarregá-los (ver portabilidade). | UC10, UC22, UC23, UC29, UC11; RF07, RF46 | Imediato |
| Retificação | Artigo 16.º | O User corrige os seus dados em Manage Personal Data. A data de nascimento só é corrigida pelo Administrator, porque decide se é preciso consentimento. | UC10, UC46; RF07, RF48 | Imediato; Administrator em 1 mês |
| Apagamento | Artigo 17.º | O User pede a eliminação da conta. O acesso é cortado logo e os dados são eliminados em 30 dias, incluindo os ficheiros (fotografia e certificados). O Guardian pode pedir a eliminação dos dados do Minor a partir do link de revogação. | UC12, UC06; RF46, RF49, RNF43 | Até 30 dias (S4) |
| Portabilidade | Artigo 20.º | O User descarrega um ficheiro JSON com os dados pessoais, as inscrições, as tentativas (com as respostas), os badges e os certificados. | UC11; RF46 | Imediato |
| Retirar o consentimento | Artigo 7.º, n.º 3 | O Guardian revoga pelo link. O User apaga os dados opcionais (género, fotografia) em Manage Personal Data. | UC06, UC10; RF45 | Imediato |
| Limitação e oposição | Artigos 18.º e 21.º | Pedido para o contacto indicado na política de privacidade, tratado pelo Administrator fora da plataforma. São raros neste tipo de serviço, por isso não têm um UC próprio. | — | 1 mês |

Os pedidos de exportação e de eliminação ficam no registo de auditoria (RNF34).

## 8. Pressupostos e dúvidas

Os pressupostos S1 a S6 estão no [inventário de dados pessoais](inventario-dados-pessoais.md#5-pressupostos). Os que afetam o consentimento dependem da dúvida D12, acrescentada ao [levantamento de requisitos](../requisitos/furps.md#6-dúvidas-para-esclarecer-com-o-cliente):

- D12: o que acontece aos dados de um Minor quando o consentimento é revogado (S1) e quando o Minor faz 18 anos (S2)?
