# Matriz de permissões (RBAC)

| | |
|---|---|
| User Story | US_A015 ([issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

A matriz indica o que cada perfil pode fazer na plataforma. As linhas são os use cases UC01 a UC48 do [diagrama de use cases v1.1](../uml/casos-de-uso.md) (US_A002) e as colunas são os quatro perfis de acesso. A última coluna indica a permissão que o backend verifica, com os códigos da tabela `permissions` do [modelo relacional](../base-de-dados/modelo-relacional.md).

### Herança

A matriz segue a herança dos atores do diagrama de use cases:

```
Guest  ←  Registered User  ←  Manager  ←  Administrator
```

Cada perfil pode fazer tudo o que o perfil à sua esquerda faz. Por isso, cada coluna tem pelo menos as autorizações da coluna anterior. O Guardian não é um perfil: não tem conta (D11) e só age através dos links que recebe por email. Aparece numa coluna à parte, para a matriz cobrir todos os atores.

### Legenda

| Símbolo | Significado |
|---|---|
| ✓ | Permitido. |
| P | Permitido só sobre os dados do próprio User (verificação por objeto, RNF36). |
| ✓¹ | Herdado do Guest, mas só disponível sem sessão iniciada (ex.: registar-se ou iniciar sessão). |
| T | Permitido sem sessão, só com o token válido do link recebido por email (RNF31). |
| — | Não permitido. O backend recusa o pedido com o código 403, ou 401 se não houver sessão. |

### Como o backend decide

1. **Sessão:** um pedido sem sessão só chega aos UC públicos e aos links com token.
2. **Estado da conta:** só uma conta `active` passa daqui (ADR-0003). Uma conta suspensa perde o acesso no pedido seguinte.
3. **Permissão do Role:** os UC do backoffice exigem a permissão indicada na última coluna (RNF24). O Registered User não tem permissões na tabela `permissions`: as suas ações dependem só de ter sessão e de os dados serem seus.
4. **Objeto:** quando o pedido identifica dados de um User (inscrição, tentativa, certificado, dados pessoais), o backend confirma que pertencem ao User da sessão (RNF36).

## 2. Matriz

### Frontoffice: conta e acesso

| UC | Ação | Guest | Registered User | Manager | Administrator | Guardian | Permissão no backend |
|---|---|---|---|---|---|---|---|
| UC01 | Register User | ✓ | ✓¹ | ✓¹ | ✓¹ | — | Pública |
| UC02 | Send Confirmation Email | ✓ (por UC01) | ✓¹ | ✓¹ | ✓¹ | — | Sistema |
| UC03 | Request Parental Consent | ✓ (por UC01, Minor) | ✓¹ | ✓¹ | ✓¹ | — | Sistema |
| UC04 | Verify Email | T | T | T | T | — | Token `email_verification` |
| UC05 | Decide Parental Consent | — | — | — | — | T | Token do pedido de consentimento |
| UC06 | Revoke Parental Consent | — | — | — | — | T | Token de revogação |
| UC07 | Log In | ✓ | ✓¹ | ✓¹ | ✓¹ | — | Pública |
| UC08 | Recover Password | T | T | T | T | — | Token `password_reset` |
| UC09 | Log Out | — | ✓ | ✓ | ✓ | — | Sessão |
| UC10 | Manage Personal Data | — | P | P | P | — | Sessão + objeto |
| UC11 | Export Personal Data | — | P | P | P | — | Sessão + objeto |
| UC12 | Request Account Deletion | — | P | P | P² | — | Sessão + objeto |

² O último Administrator ativo não pode eliminar a própria conta (RF47).

### Frontoffice: conteúdo público

| UC | Ação | Guest | Registered User | Manager | Administrator | Guardian | Permissão no backend |
|---|---|---|---|---|---|---|---|
| UC13 | View Health Areas | ✓ | ✓ | ✓ | ✓ | — | Pública (só `published`) |
| UC14 | View News Items | ✓ | ✓ | ✓ | ✓ | — | Pública (só `published`) |
| UC15 | View Publications | ✓ | ✓ | ✓ | ✓ | — | Pública (só `published`) |
| UC16 | View Agenda | ✓ | ✓ | ✓ | ✓ | — | Pública (só `published`) |
| UC17 | View Weekly Highlights | ✓ | ✓ | ✓ | ✓ | — | Pública (só `published`) |
| UC18 | View Project Information | ✓ | ✓ | ✓ | ✓ | — | Pública |
| UC19 | View Privacy Policy | ✓ | ✓ | ✓ | ✓ | ✓ | Pública |

### Frontoffice: formação e gamificação

| UC | Ação | Guest | Registered User | Manager | Administrator | Guardian | Permissão no backend |
|---|---|---|---|---|---|---|---|
| UC20 | Search Training Resources | — | ✓ | ✓ | ✓ | — | Sessão (RF12) |
| UC21 | Enroll in Training Resource | — | P | P | P | — | Sessão + objeto |
| UC22 | View Enrollments | — | P | P | P | — | Sessão + objeto |
| UC23 | View Learning Results | — | P | P | P | — | Sessão + objeto |
| UC24 | Access Training Resource | — | P | P | P | — | Sessão + inscrição + 1.ª tentativa do diagnóstico (RF16) |
| UC25 | Answer Diagnostic Questionnaire | — | P | P | P | — | Sessão + inscrição + `max_attempts` |
| UC26 | Access Level | — | P | P | P | — | Sessão + inscrição + diagnóstico |
| UC27 | Answer Final Questionnaire | — | P | P | P | — | Sessão + inscrição + conteúdo visto (RF20) |
| UC28 | Award Badge and Certificate | — | P (por UC27) | P | P | — | Sistema |
| UC29 | View Badges | — | P | P | P | — | Sessão + objeto |
| UC30 | Download Certificate | — | P | P | P | — | Sessão + objeto (ADR-0004) |

### Backoffice

| UC | Ação | Guest | Registered User | Manager | Administrator | Guardian | Permissão no backend |
|---|---|---|---|---|---|---|---|
| UC31 | *Manage Content* (abstrato) | — | — | ✓ | ✓ | — | `content.manage` |
| UC32 | Manage Training Resources | — | — | ✓ | ✓ | — | `content.manage` |
| UC33 | Manage Health Areas | — | — | ✓ | ✓ | — | `content.manage` |
| UC34 | Manage Categories | — | — | ✓ | ✓ | — | `content.manage` |
| UC35 | Manage Activities | — | — | ✓ | ✓ | — | `content.manage` |
| UC36 | Manage News Items | — | — | ✓ | ✓ | — | `content.manage` |
| UC37 | Manage Publications | — | — | ✓ | ✓ | — | `content.manage` |
| UC38 | Manage Weekly Highlights | — | — | ✓ | ✓ | — | `content.manage` |
| UC39 | Manage Questionnaires | — | — | ✓ | ✓ | — | `questionnaire.manage` |
| UC40 | Change Content Status | — | — | ✓ | ✓ | — | A do conteúdo: `content.manage` ou `questionnaire.manage` |
| UC41 | Translate Content | — | — | ✓ | ✓ | — | A do conteúdo: `content.manage` ou `questionnaire.manage` |
| UC42 | View Usage Indicators | — | — | ✓ | ✓ | — | `indicator.view` |
| UC43 | View Learning Indicators | — | — | ✓ | ✓ | — | `indicator.view` (grupos com menos de 5 Users ocultos, RNF45) |
| UC44 | Compare Groups | — | — | ✓ | ✓ | — | `indicator.view` (grupos com menos de 5 Users ocultos, RNF45) |
| UC45 | Export Results to CSV | — | — | ✓ | ✓ | — | `result.export` (pseudonimizado, RNF45) |
| UC46 | Manage User Accounts | — | — | — | ✓³ | — | `user.manage` |
| UC47 | Change Account Status | — | — | — | ✓³ | — | `user.manage` |
| UC48 | Manage Roles and Permissions | — | — | — | ✓³ | — | `role.manage` |

³ O Administrator não pode alterar o próprio Role nem o estado da própria conta, e tem de ficar sempre pelo menos um Administrator ativo (RF47).

## 3. Verificação da coerência

| Verificação | Resultado |
|---|---|
| Todos os UC01 a UC48 têm uma linha. | Sim: 48 linhas. |
| Cada coluna tem pelo menos as autorizações da coluna à esquerda (herança). | Sim. As únicas restrições dentro de um perfil são de objeto (P) ou de autoproteção do Administrator (RF47), não de perfil. |
| Cada UC do backoffice tem uma permissão da tabela `permissions`. | Sim: as 6 permissões são usadas. |
| As permissões iniciais do `schema.sql` dão ao Manager `content.manage`, `questionnaire.manage`, `indicator.view` e `result.export`, e ao Administrator todas. | Coincide com as colunas Manager e Administrator. |
| O Guardian só acede com token, sem sessão. | Sim: UC05 e UC06 (e a política de privacidade, que é pública). |

## 4. Dados visíveis por perfil

| Perfil | Dados pessoais que vê |
|---|---|
| Guest | Nenhuns. |
| Registered User | Só os seus. O User Profile, os resultados e os certificados não são visíveis a outros Users. |
| Manager | Os seus. Dos outros Users, só indicadores agregados (grupos com 5 ou mais Users) e a exportação pseudonimizada. Não vê nomes, emails nem datas de nascimento. |
| Administrator | Os seus, e os dados de conta dos outros Users para os gerir (nome, email, data de nascimento, ano, Role, estado e datas). Não vê o hash da palavra-passe nem os tokens. Os resultados de aprendizagem só agregados, como o Manager. |

## 5. Alterações às permissões

O Administrator pode mudar as permissões de cada Role (RF34, UC48). A matriz descreve a configuração inicial do `schema.sql`. Cada alteração fica no registo de auditoria (RNF34) e, se der uma permissão de administração (`user.manage`, `role.manage`) a outro Role, deve ser revista pela equipa.
