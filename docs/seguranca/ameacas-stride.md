# Modelação de ameaças (STRIDE)

| | |
|---|---|
| User Story | US_A015 ([issue #15](https://github.com/escobar0304/ProjInter-2-1/issues/15)) |
| Versão | 1.0 (Sprint A) |
| Estado | Em revisão pela equipa |

## 1. Âmbito

Este documento analisa as ameaças à plataforma com o método STRIDE, nos quatro fluxos pedidos na US_A015: registo, início de sessão, consentimento parental e acesso aos dados de outros utilizadores. Acrescenta as ameaças aos ficheiros, ao backoffice e à exportação de dados, porque também expõem dados de menores.

Cada ameaça relevante tem uma mitigação e um requisito verificável no [levantamento de requisitos](../requisitos/furps.md) (US_A001). Os requisitos novos são o RF47 a RF49 e o RNF29 a RNF46.

### Categorias

| Categoria | Propriedade violada | Pergunta |
|---|---|---|
| **S**poofing | Autenticidade | Alguém consegue fazer-se passar por outra pessoa? |
| **T**ampering | Integridade | Alguém consegue alterar dados ou pedidos sem autorização? |
| **R**epudiation | Responsabilização | Alguém consegue negar uma ação que fez? |
| **I**nformation disclosure | Confidencialidade | Alguém consegue ver dados que não devia? |
| **D**enial of service | Disponibilidade | Alguém consegue impedir os outros de usar a plataforma? |
| **E**levation of privilege | Autorização | Alguém consegue fazer ações de um perfil que não tem? |

### Componentes

Os componentes são os contentores do [modelo C4](../arquitetura/c4.md): a aplicação web (SPA React), o servidor web (Nginx), a API (Flask), a base de dados (PostgreSQL), os ficheiros multimédia (volume) e o Email Service (sistema externo).

### Impacto

- **Alto:** expõe ou altera dados de menores, ou dá acesso a uma conta ou ao backoffice.
- **Médio:** afeta um User ou um conteúdo, ou degrada o serviço durante algum tempo.
- **Baixo:** revela informação pouco sensível, ou tem efeito limitado e fácil de corrigir.

## 2. Ameaças

### Registo

| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |
|---|---|---|---|---|---|
| **T01** Um Minor indica uma data de nascimento falsa (18 anos ou mais) para não precisar de consentimento. | Spoofing | API | Alto | Aviso claro no formulário. A data de nascimento não pode ser alterada pelo User depois do registo; se o Administrator a corrigir e o User passar a ser Minor, é feito o pedido de consentimento. Risco residual aceite: a plataforma não verifica documentos. | RF48 |
| **T02** Um Minor indica como email do Guardian um segundo email que ele próprio controla e aceita o próprio consentimento. | Spoofing | API, Email Service | Alto | O email do Guardian tem de ser diferente do do Minor (P7). O pedido identifica o Minor e explica o tratamento; a confirmação traz o link de revogação. Risco residual aceite (sem verificação de identidade, D11); ver o [consentimento](consentimento-direitos.md#limites-da-prova). | RNF35, RNF46, RF45 |
| **T03** Alguém faz muitos registos ou reenvios para inundar de emails o endereço de um terceiro (ex.: pedidos de consentimento). | Denial of service | API, Email Service | Médio | Limite de pedidos por IP e por email nos pedidos que enviam emails; no máximo 2 reenvios do pedido de consentimento (P5). | RNF41 |
| **T04** Alguém descobre se um email tem conta, pela mensagem «email já registado» do registo (P2). | Information disclosure | API | Baixo | Limite de pedidos por IP. A mensagem do registo é mantida por usabilidade (P2); o início de sessão e a recuperação da palavra-passe não revelam se o email existe. | RNF32, RNF41 |
| **T05** O pedido de registo é alterado para incluir campos como o Role ou o estado da conta (ex.: `role = administrator`). | Elevation of privilege | API | Alto | O backend só aceita os campos previstos em cada pedido e ignora os restantes. Uma conta nova é sempre `registered_user` e `pending_verification`. | RNF37, RNF06 |

### Início de sessão e recuperação da palavra-passe

| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |
|---|---|---|---|---|---|
| **T06** Ataque de força bruta ou com listas de palavras-passe roubadas noutros sites. | Spoofing | API | Alto | Bloqueio temporário depois de 5 falhas em 15 minutos, por conta e por IP. Palavras-passe com 8 ou mais caracteres e recusadas se forem comuns. Hash com Argon2. | RNF29, RNF30, RNF23 |
| **T07** Roubo do cookie da sessão por XSS ou na rede. | Spoofing | SPA, servidor web | Alto | Cookie `HttpOnly`, `Secure` e `SameSite=Lax` (ADR-0003); HTTPS em produção; Content-Security-Policy e texto sempre escapado. | RNF25, RNF33, RNF39 |
| **T08** Fixação da sessão: o atacante leva a vítima a usar um identificador de sessão que ele conhece. | Spoofing | API | Médio | O identificador da sessão é renovado no início de sessão. | RNF33 |
| **T09** Pedido forjado a partir de outro site (CSRF), com a sessão da vítima. | Tampering | SPA, API | Médio | `SameSite=Lax` e token CSRF nos pedidos que alteram dados (ADR-0003). | RNF33 |
| **T10** O link de recuperação da palavra-passe é adivinhado, reutilizado ou intercetado. | Spoofing | API, Email Service | Alto | Token aleatório de 128 bits, guardado em hash, de uso único e válido 1 hora. Mudar a palavra-passe termina as outras sessões. | RNF31, RNF33 |
| **T11** As mensagens de início de sessão ou de recuperação revelam se o email tem conta. | Information disclosure | API | Baixo | Mensagem igual para email inexistente e palavra-passe errada; a recuperação responde sempre «se o email existir, receberá um link». | RNF32 |
| **T12** Uma sessão esquecida aberta num computador partilhado (ex.: na escola) é usada por outra pessoa. | Spoofing | API | Médio | A sessão expira depois de 30 minutos sem atividade e ao fim de 12 horas. | RNF33 |

### Consentimento parental

| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |
|---|---|---|---|---|---|
| **T13** Alguém adivinha o token do pedido de consentimento e aceita em nome do Guardian. | Spoofing | API | Alto | Token aleatório de 128 bits, guardado em hash, de uso único e válido 7 dias. Limite de pedidos por IP. | RNF31, RNF41 |
| **T14** O link do pedido é reutilizado depois da decisão ou do prazo, para mudar a decisão. | Tampering | API | Médio | O token é marcado como usado; um pedido decidido ou expirado não muda (E9 do fluxograma). | RNF31, RF04 |
| **T15** O Guardian nega ter dado o consentimento, ou o Minor nega ter pedido a eliminação dos dados. | Repudiation | API, base de dados | Alto | Guarda-se a decisão, as datas e a versão do texto lido, e cada decisão, revogação e pedido de eliminação fica no registo de auditoria. | RNF34, RNF35 |
| **T16** O email do pedido vai para um endereço errado e revela dados do Minor a um estranho. | Information disclosure | Email Service | Médio | O email só tem o nome próprio do Minor, o email de registo e a informação do tratamento; nada de data de nascimento, ano ou resultados. | RNF46 |
| **T17** Depois da revogação, o Minor continua a usar a sessão que já tinha aberta. | Elevation of privilege | API | Médio | O estado da conta é lido em cada pedido: a conta `suspended` perde o acesso no pedido seguinte (ADR-0003). | RF45, RNF24 |

### Acesso aos dados de outros utilizadores

| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |
|---|---|---|---|---|---|
| **T18** Um Registered User muda o identificador num pedido para ver os dados, as tentativas ou o certificado de outro User (IDOR). | Information disclosure | API | Alto | Em cada pedido a dados de um User, o backend confirma que pertencem ao User da sessão. Testes automáticos para estes casos. | RNF36, RNF16 |
| **T19** Um Registered User chama diretamente os endpoints do backoffice. | Elevation of privilege | API | Alto | As permissões do Role são verificadas no backend em todos os pedidos, não só na interface. | RNF24 |
| **T20** Um Administrator retira a si próprio ou a todos os Administrators o acesso, ou um Role recebe permissões de administração por engano. | Elevation of privilege | API | Médio | O Administrator não pode mudar o próprio Role nem o estado da própria conta, e fica sempre um Administrator ativo. As alterações de permissões ficam na auditoria. | RF47, RNF34 |
| **T21** Alguém acede a gravações, materiais de apoio ou certificados pelo endereço do ficheiro, sem estar inscrito. | Information disclosure | Servidor web, ficheiros | Médio | Os ficheiros reservados estão fora da pasta pública e só são enviados depois de a API verificar o acesso (ADR-0004). | RNF38, RF16 |
| **T22** A exportação CSV ou os indicadores por grupo permitem identificar um Minor e os seus resultados (ex.: o único aluno do 7.º ano num recurso). | Information disclosure | API | Alto | A exportação identifica o User só por um código pseudónimo, sem nome, email nem data de nascimento. Os indicadores e as exportações por grupo com menos de 5 Users não mostram valores. | RNF45 |
| **T23** A API devolve campos a mais (ex.: o hash da palavra-passe, tokens, ou as respostas corretas antes da submissão). | Information disclosure | API | Alto | Cada resposta da API tem uma lista fechada de campos; as opções corretas só são enviadas depois da submissão da tentativa. | RNF37 |

### Ficheiros, backoffice e infraestrutura

| Ameaça | Categoria | Componente | Impacto | Mitigação | Requisito |
|---|---|---|---|---|---|
| **T24** Injeção de SQL num campo de pesquisa ou num formulário. | Tampering | API, base de dados | Alto | Só consultas parametrizadas (ou ORM); a API liga-se à base de dados com um utilizador sem privilégios de administração. | RNF40 |
| **T25** XSS armazenado: um texto com código (ex.: no nome do User ou num conteúdo do backoffice) é executado no browser de outros Users. | Tampering | SPA, API | Médio | Os textos são mostrados escapados; o HTML dos conteúdos, se existir, é filtrado; Content-Security-Policy. | RNF39 |
| **T26** Um ficheiro malicioso é carregado como imagem ou material de apoio (ex.: HTML ou SVG com código). | Tampering | API, ficheiros | Médio | Só os tipos previstos, verificados pelo conteúdo; tamanho máximo; nome gerado pelo servidor; sem SVG. | RNF38 |
| **T27** O browser envia um Score alterado ou escolhe as respostas a partir das opções corretas recebidas. | Tampering | SPA, API | Médio | O Score é calculado no servidor (RF21) e as opções corretas não são enviadas antes da submissão. | RF21, RNF37 |
| **T28** Um Manager nega ter alterado o estado de um conteúdo ou exportado dados. | Repudiation | API | Baixo | As alterações de estado de conteúdo e as exportações ficam no registo de auditoria. | RNF34 |
| **T29** As mensagens de erro mostram detalhes técnicos (consultas, caminhos, versões). | Information disclosure | API | Baixo | Mensagem compreensível sem detalhes técnicos; o detalhe fica só no log do servidor. | RNF07 |
| **T30** Uma fuga da base de dados ou de uma cópia de segurança, ou credenciais publicadas no repositório. | Information disclosure | Base de dados | Alto | Palavras-passe e tokens só em hash; segredos fora do repositório (o repositório é público); cópias de segurança cifradas e com prazo de 30 dias. | RNF23, RNF31, RNF42, RNF44 |
| **T31** Pedidos muito grandes ou muitos pedidos seguidos esgotam a API ou o disco. | Denial of service | Servidor web, API | Médio | Limite de tamanho dos pedidos e dos ficheiros; limite de pedidos nos pontos públicos. | RNF38, RNF41 |
| **T32** O Email Service falha e os registos ficam bloqueados. | Denial of service | Email Service | Baixo | Mais 3 tentativas de envio e reenvio a pedido do Guest (P6). Os prazos de eliminação aplicam-se na mesma. | RNF26 |
| **T33** Dados de contas eliminadas ou fora de prazo continuam guardados. | Information disclosure | Base de dados, ficheiros | Médio | Tarefa agendada diária que aplica os prazos do inventário e apaga também os ficheiros. | RNF43 |

## 3. Cobertura das categorias

| Categoria | Ameaças | Total |
|---|---|---|
| Spoofing | T01, T02, T06, T07, T08, T10, T12, T13 | 8 |
| Tampering | T09, T14, T24, T25, T26, T27 | 6 |
| Repudiation | T15, T28 | 2 |
| Information disclosure | T04, T11, T16, T18, T21, T22, T23, T29, T30, T33 | 10 |
| Denial of service | T03, T31, T32 | 3 |
| Elevation of privilege | T05, T17, T19, T20 | 4 |

Todas as categorias têm ameaças relevantes, por isso nenhuma foi excluída. Os ataques de negação de serviço distribuídos (DDoS) em grande escala não se resolvem na aplicação: dependem do fornecedor de alojamento, escolhido na Sprint B.

## 4. Riscos aceites

| Ameaça | Porque fica | O que reduz o risco |
|---|---|---|
| T01 (idade falsa) | Verificar a idade com documentos recolhia mais dados de menores do que os que se quer proteger. | Aviso no formulário; correção pelo Administrator (RF48). |
| T02 (Guardian falso) | Sem conta do Guardian (D11), a plataforma só prova o controlo do email. | Email diferente (P7), texto claro, link de revogação (RF45). |
| T04 (email já registado) | A mensagem explícita no registo foi uma decisão de usabilidade (P2). | Limite de pedidos (RNF41). |

Estes riscos devem ser validados com o cliente na resposta às dúvidas D02 e D11.
