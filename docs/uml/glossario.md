# Glossário (linguagem ubíqua)

| | |
|---|---|
| User Story | US_A004 ([issue #4](https://github.com/escobar0304/ProjInter-2-1/issues/4)), 1.ª parte |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

Este glossário define a linguagem ubíqua da Plataforma de Literacia em Saúde para Jovens: um só termo para cada conceito do domínio, usado da mesma forma nos requisitos, nos use cases, no modelo de domínio, no modelo relacional e no código.

### Fontes

| Referência | Fonte |
|---|---|
| §B, §C, §C.1, §D, §D.1, §D.2, §D.3 | Secções da especificação do sistema (Parte 02) |
| FURPS §n, RFnn, RNFnn, Wnn, Dnn | [Levantamento de requisitos](../requisitos/furps.md) (US_A001) |
| UC v1.0 | Diagrama de use cases fornecido (versão 1.0) |
| MR v1.0 | Modelo relacional fornecido (versão 1.0) |

### Convenções

- **Língua.** Os termos estão em inglês, por decisão da equipa: os diagramas v1.0 já estão em inglês e os nomes passam diretamente para o código e para a base de dados. As definições estão em português. Entre parênteses fica o termo português usado no levantamento de requisitos.
- **Evitar.** Sinónimos e termos ambíguos que não se usam. Quando aparecem numa fonte (ex.: no UC v1.0 ou no MR v1.0), correspondem ao termo do glossário.
- **Pressupostos.** As definições que dependem de uma dúvida ainda sem resposta do cliente estão marcadas com "(pressuposto Dnn)" e listadas na secção 3.

## 2. Termos

### A. Atores

| Termo | Definição | Evitar | Fonte |
|---|---|---|---|
| **Guest** (convidado) | Visitante sem sessão iniciada. Consulta o conteúdo público e pode registar-se. | Visitor, Unregistered User | §C.1; FURPS §2 |
| **Registered User** (utilizador registado) | User com conta ativa e sessão iniciada. Acede ao Restricted Content. Herda de Guest. | Student, Learner, Member | §C.1; FURPS §2 |
| **Manager** (gestor de conteúdos) | Registered User com acesso ao Backoffice. Gere os conteúdos e os Questionnaires e consulta os Indicators. | Editor, Content Admin | §C.1; FURPS §2 |
| **Administrator** (administrador) | Manager com acesso total ao sistema. Gere os Users, os Roles, as Permissions e os Account Status. | Admin, Superuser | §C.1; FURPS §2 |
| **Guardian** (encarregado de educação) | Adulto responsável por um Minor. Aceita, recusa ou revoga o Parental Consent através do link recebido por email. Não tem conta na plataforma (pressuposto D11). | Parent, Tutor | §C; FURPS §2; D11 |
| **Minor** (menor) | User com menos de 18 anos à data da Registration (pressuposto D02). | Child, Underage User | §C; RF03; D02 |
| **Email Service** (serviço de email) | Sistema externo (SMTP) que envia os emails de confirmação, de consentimento e de recuperação da palavra-passe. | Mailer, Mail Server | RNF26; FURPS §2 |

### B. Conta e acesso

| Termo | Definição | Evitar | Fonte |
|---|---|---|---|
| **User** (utilizador) | Pessoa com conta na plataforma, seja qual for o Role. Tem Personal Data, credenciais, um Role e um Account Status. | Account (como conceito à parte), Member | RF01, RF32; MR v1.0 (`users`) |
| **Registration** (registo) | Processo em que o Guest cria a conta: introduz os Personal Data, faz a Email Verification e, se for Minor, aguarda o Parental Consent. | Sign-up, Enrollment | §C, §C.1; RF01–RF04 |
| **Personal Data** (dados pessoais) | Nome, email, data de nascimento, género, School Year e fotografia do User. | Profile, User Info | §D; RF01, RF07 |
| **School Year** (ano de escolaridade) | Ano que o User frequenta, do 7.º ao 12.º ano (3.º ciclo e ensino secundário). | Grade (em inglês confunde-se com classificação), Class, Academic Year | §C, §D; RF01, RF39; MR v1.0 (`schoolyears`) |
| **Account Status** (estado de conta) | Situação da conta: Pending Verification, Pending Consent, Active, Suspended ou Deactivated. Só uma conta Active pode iniciar sessão. | User State, Status (sozinho) | §C; RF32, RF35, RF45; MR v1.0 (`userstates`) |
| **Email Verification** (verificação do email) | Confirmação de que o email pertence ao User, feita ao abrir o link do email de confirmação. | Validation, Activation | RF02; MR v1.0 (`email_verified_at`) |
| **Account Activation** (ativação da conta) | Passagem da conta a Active, depois da Email Verification e, no caso de um Minor, do Parental Consent aceite. | Verification, Approval | §C; RF04 |
| **User Profile** (página de perfil) | Página do User com os Personal Data, os Badges e os Certificates. | Profile (no sentido de Role), Dashboard | §C; RF24 |
| **Role** (perfil de acesso) | Conjunto de Permissions atribuído a um User: Registered User, Manager ou Administrator. | Access Profile, Profile, User Type | §C, §C.1; RF33; MR v1.0 (`roles`) |
| **Permission** (permissão) | Autorização para executar uma operação (ex.: gerir Questionnaires). É atribuída a Roles e verificada no backend em todos os pedidos. | Privilege, Right | §C.1; RF34; RNF24 |
| **Parental Consent** (consentimento parental) | Decisão do Guardian sobre a Registration de um Minor. Guarda o email do Guardian, o estado (Pending, Accepted, Refused, Revoked ou Expired) e as datas do pedido, da decisão e da revogação. O pedido é enviado por email, com um link único que expira. Se for Revoked, a conta do Minor fica Suspended. | Authorization, Consent (sozinho), Consent Email | §C; RF03, RF04, RF45; D11 |
