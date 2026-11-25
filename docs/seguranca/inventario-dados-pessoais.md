# Inventário de dados pessoais

| | |
|---|---|
| User Story | US_A015 ([issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

Este documento lista os dados pessoais que a Plataforma de Literacia em Saúde para Jovens trata. Para cada dado indica a finalidade, a base legal, o prazo de conservação e quem lhe acede, e assinala os dados de menores.

Parte do [modelo relacional v1.1](../base-de-dados/modelo-relacional.md) e da secção 3 do [dicionário de dados](../base-de-dados/dicionario-dados.md#3-dados-pessoais-e-dados-de-menores), que marca as colunas com dados pessoais (**DP**) e com dados de menores (**DP-M**). Acrescenta os dados que existem fora da base de dados: ficheiros, cookie da sessão, logs e emails.

### Enquadramento legal

- Regulamento Geral sobre a Proteção de Dados (RGPD, Regulamento (UE) 2016/679).
- Lei n.º 58/2019, que executa o RGPD em Portugal. O artigo 16.º fixa em 13 anos a idade a partir da qual um menor pode dar o próprio consentimento para serviços da sociedade da informação. A especificação (§C) é mais exigente: pede o consentimento do encarregado de educação para todos os menores, e a equipa segue-a (pressuposto D02: menos de 18 anos).

Esta análise é técnica: serve para definir os requisitos de segurança e não substitui um parecer jurídico.

### Convenções

- **Classe:** DP é um dado pessoal; DP-M é um dado pessoal que identifica um menor ou descreve o seu desempenho, e que exige cuidado acrescido (dicionário de dados). As colunas sem marca no dicionário que pertencem a um User identificado (ex.: `preferred_language`) também são dados pessoais e aparecem como **DP (associado)**.
- **Menor:** "Sim" quando o dado é de um Minor sempre que o User for Minor. O público-alvo vai do 7.º ao 12.º ano, por isso a maioria dos Users é menor.
- **Bases legais** (artigo 6.º, n.º 1, do RGPD):
  - **Contrato** (al. b): o dado é necessário para prestar o serviço que o titular pediu ao criar a conta (conta, inscrições, questionários, badges e certificados);
  - **Consentimento** (al. a): o titular escolheu dar o dado (ex.: fotografia). No caso de um Minor, todo o tratamento depende do consentimento do encarregado de educação (artigo 8.º e §C);
  - **Obrigação legal** (al. c): o dado é necessário para obter e provar o consentimento parental (artigos 7.º, n.º 1, e 8.º, n.º 2);
  - **Interesse legítimo** (al. f): o dado serve para proteger a plataforma e os seus utilizadores (segurança, prevenção de abusos).
- **Acesso:** quem vê o dado através da plataforma. O backend (Sistema) acede a todos para aplicar as regras e não aparece na coluna. Os perfis são os da [matriz de permissões](matriz-permissoes.md).

## 2. Titulares

| Titular | Descrição | Dados tratados |
|---|---|---|
| User adulto | User com 18 anos ou mais à data do registo. | Conta, inscrições, desempenho. |
| User Minor | User com menos de 18 anos à data do registo (D02). Grupo principal do público-alvo. | Os mesmos do adulto, com proteção acrescida (DP-M). |
| Guardian | Encarregado de educação de um Minor. Não tem conta (D11). | Só o email e a decisão sobre o consentimento. |
| Manager e Administrator | Equipa que gere a plataforma. São Users, por isso têm os dados de uma conta. | Conta e autoria de destaques e de ações registadas na auditoria. |

## 3. Inventário

### Conta (`users`)

| Coluna | Dado | Classe | Menor | Finalidade | Base legal | Conservação | Acesso |
|---|---|---|---|---|---|---|---|
| `name` | Nome | DP | Sim | Identificar o User na plataforma e no Certificate. | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir (S1 a S4) | Próprio; Administrator |
| `email` | Email | DP | Sim | Iniciar sessão, enviar os emails do serviço. | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio; Administrator |
| `password_hash` | Hash da palavra-passe | DP | Sim | Autenticar o User (RNF23). | Contrato | Enquanto a conta existir | Ninguém (só o Sistema) |
| `birth_date` | Data de nascimento | DP-M | Sim | Saber se o User é Minor e se precisa de consentimento (RF03). | Obrigação legal | Enquanto a conta existir | Próprio; Administrator |
| `gender_id` | Género (opcional) | DP | Sim | Comparar grupos nos indicadores (RF41). | Consentimento | Enquanto a conta existir ou até o User o apagar | Próprio; Administrator |
| `school_year_id` | Ano de escolaridade | DP-M | Sim | Adaptar o serviço e comparar grupos (RF39, RF41). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio; Administrator |
| `photo_url` e ficheiro da fotografia | Fotografia (opcional) | DP | Sim | Mostrar no User Profile. | Consentimento | Até o User a apagar ou a conta ser eliminada | Próprio |
| `preferred_language` | Idioma da interface | DP (associado) | Sim | Mostrar a interface no idioma escolhido (RNF05). | Contrato | Enquanto a conta existir | Próprio |
| `role_id` | Role | DP (associado) | Sim | Autorizar as ações (RF33, RNF24). | Contrato | Enquanto a conta existir | Próprio; Administrator |
| `account_status_id`, `status_changed_at` | Estado da conta e data da mudança | DP (associado) | Sim | Controlar o acesso e contar os prazos de eliminação (RNF22). | Contrato; obrigação legal | Enquanto a conta existir | Próprio; Administrator |
| `privacy_accepted_at` | Aceitação da política de privacidade | DP (associado) | Sim | Provar que o titular foi informado (artigo 13.º). | Obrigação legal | Enquanto a conta existir | Administrator |
| `email_verified_at` | Verificação do email | DP (associado) | Sim | Ativar a conta (RF02). | Contrato | Enquanto a conta existir | Administrator |
| `last_login_at` | Último início de sessão | DP | Sim | Contar os Users ativos (RF36, D06) e detetar contas inativas (S3). | Interesse legítimo | Substituído em cada início de sessão; enquanto a conta existir | Administrator |
| `created_at`, `updated_at` | Datas do registo | DP (associado) | Sim | Gestão das contas. | Contrato | Enquanto a conta existir | Administrator |

### Links e consentimento (`user_tokens`, `parental_consents`)

| Coluna | Dado | Classe | Menor | Finalidade | Base legal | Conservação | Acesso |
|---|---|---|---|---|---|---|---|
| `user_tokens.*` | Hash do token, finalidade e datas | DP (associado) | Sim | Verificar o email (RF02) e recuperar a palavra-passe (RF06). | Contrato | Até 30 dias depois de expirar ou de ser usado | Ninguém (só o Sistema) |
| `parental_consents.user_id` | Minor a que o pedido diz respeito | DP-M | Sim | Associar a decisão ao Minor. | Obrigação legal | Enquanto a conta existir (ver [consentimento](consentimento-direitos.md#4-estados-e-consequências)) | Administrator |
| `parental_consents.guardian_email` | Email do encarregado de educação | DP | Não (adulto) | Pedir o consentimento e enviar a confirmação e o link de revogação (RF03, RF45). | Obrigação legal | Enquanto a conta do Minor existir | Administrator |
| `parental_consents.token_hash`, `revocation_token_hash` | Hashes dos links do encarregado | DP (associado) | Sim | Garantir que só quem recebeu o email decide ou revoga. | Obrigação legal | Enquanto a conta do Minor existir | Ninguém (só o Sistema) |
| `parental_consents.status`, `requested_at`, `expires_at`, `decided_at`, `revoked_at` | Decisão e datas | DP (associado) | Sim | Provar o consentimento: o quê e quando (RF04, artigo 7.º, n.º 1). | Obrigação legal | Enquanto a conta do Minor existir | Administrator |

### Formação, questionários e gamificação

| Tabela | Dado | Classe | Menor | Finalidade | Base legal | Conservação | Acesso |
|---|---|---|---|---|---|---|---|
| `enrollments` | Inscrições, estado, favoritos, datas de acesso e de conclusão | DP-M | Sim | Prestar o serviço (RF14 a RF17, RF20). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio; Manager e Administrator só agregado (indicadores) |
| `level_progress` | Progresso em cada Level | DP-M | Sim | Retomar o conteúdo e controlar o acesso ao Final (RF17, RF20). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio |
| `attempts` | Tentativas, Score e datas | DP-M | Sim | Registar os resultados (RF21, RF22) e calcular os indicadores (RF36 a RF43). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio; Manager e Administrator agregado ou pseudonimizado (RNF45) |
| `attempt_answers` | Opção escolhida em cada pergunta | DP-M | Sim | Corrigir a tentativa e calcular a proporção de respostas certas por pergunta (RF40). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio (depois da submissão); Manager e Administrator pseudonimizado (RNF45) |
| `badges` | Badges atribuídos | DP-M | Sim | Gamificação (RF23, RF24). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir | Próprio |
| `certificates` e PDF | Certificado com nome, recurso, data, Score e código de verificação | DP-M | Sim | Comprovar a conclusão (RF25, D05). | Contrato; Minor: consentimento do encarregado | Enquanto a conta existir. O código deixa de ser válido quando a conta é eliminada | Próprio; quem receber o PDF do User |

### Biblioteca virtual

| Tabela | Dado | Classe | Menor | Finalidade | Base legal | Conservação | Acesso |
|---|---|---|---|---|---|---|---|
| `weekly_highlights.created_by` | Manager que criou o destaque | DP | Não | Responsabilidade editorial. | Interesse legítimo | Até a conta do Manager ser eliminada (passa a vazio, `ON DELETE SET NULL`) | Manager; Administrator |

### Fora da base de dados

| Onde | Dado | Classe | Menor | Finalidade | Base legal | Conservação | Acesso |
|---|---|---|---|---|---|---|---|
| Cookie da sessão ([ADR-0003](../arquitetura/ADR-0003-autenticacao-sessao-cookie.md)) | Identificador do User, assinado | DP (associado) | Sim | Manter a sessão iniciada. É um cookie estritamente necessário, sem consentimento de cookies. | Contrato | Até ao fim da sessão (RNF33) | Ninguém (só o Sistema) |
| Registo de auditoria (RNF34) | Autor, ação, alvo e data das ações sensíveis | DP | Sim | Responsabilização e prova (artigo 5.º, n.º 2). | Interesse legítimo; obrigação legal | 1 ano (S5) | Administrator |
| Logs do servidor (Nginx e API) | Endereço IP, pedido, data e erros | DP | Sim | Diagnosticar falhas (RNF07) e detetar ataques. | Interesse legítimo | 30 dias (S5) | Administrator |
| Emails enviados pelo Email Service | Email, nome próprio do Minor e links | DP | Sim | Confirmação, consentimento e recuperação (RNF26). | Contrato; obrigação legal | Conforme o contrato com o fornecedor de email (S6) | Fornecedor do Email Service, como subcontratante (artigo 28.º) |
| Cópias de segurança (RNF09) | Cópia de todos os dados acima | DP e DP-M | Sim | Recuperar de falhas. | Interesse legítimo | 30 dias (RNF44) | Administrator |
| Exportação CSV (RF44) | Respostas e Scores, pseudonimizados | DP-M | Sim | Análise da aprendizagem pela equipa. | Contrato; interesse legítimo | Da responsabilidade de quem exporta; ficheiro registado na auditoria | Manager; Administrator |

## 4. Minimização

- **Não se recolhem** morada, telefone, escola, turma, número de documento nem dados de saúde. Os questionários medem o conhecimento sobre temas de saúde e não perguntam pelo estado de saúde do User.
- **Dados opcionais:** o género e a fotografia não são obrigatórios e o User pode apagá-los a qualquer momento (UC10).
- **Interesses de saúde:** as inscrições revelam os temas que interessam ao User (ex.: saúde mental). Não são dados de saúde (artigo 9.º), mas são tratados como DP-M: o User Profile só é visível ao próprio e os indicadores só mostram valores agregados (RNF45).
- **Data de nascimento:** é necessária completa para aplicar o limite dos 18 anos (D02) no dia certo. Não aparece nos indicadores nem nas exportações.
- **Dados do Guardian:** só o email. Não tem conta nem palavra-passe (D11).
- **Segredos:** palavras-passe e tokens nunca se guardam em claro (RNF23, RNF31).

## 5. Pressupostos

| ID | Pressuposto |
|---|---|
| S1 | Quando o consentimento é revogado, a conta fica suspensa e os dados são eliminados ao fim de 30 dias, se não houver um novo consentimento; o Guardian pode pedir a eliminação imediata (RF49, dúvida D12). |
| S2 | Quando o Minor faz 18 anos, o consentimento parental deixa de ser necessário: o link de revogação deixa de suspender a conta e o User passa a decidir sozinho sobre os seus dados (dúvida D12). |
| S3 | As contas sem início de sessão há 2 anos recebem um aviso por email e são eliminadas 30 dias depois, se o User não iniciar sessão. |
| S4 | Um pedido de eliminação (UC12) corta logo o acesso à conta e é concluído em 30 dias, dentro do prazo de um mês do artigo 12.º, n.º 3. |
| S5 | O registo de auditoria é conservado 1 ano e os logs do servidor 30 dias. |
| S6 | O Email Service é um fornecedor com servidores na União Europeia e um acordo de subcontratação (artigo 28.º). A escolha é feita na Sprint B. |

Os prazos dos registos não concluídos (30 dias) são os do [fluxograma do registo](../bpmn/registo-utilizador.md#8-pressupostos) (P1 a P5).
