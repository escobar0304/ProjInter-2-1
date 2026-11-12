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

## 3. Requisitos funcionais (F)

| ID | Área | Descrição | Prioridade | Origem |
|---|---|---|---|---|
| RF01 | AUT | O Convidado cria uma conta com nome, email, palavra-passe, data de nascimento, género e ano de escolaridade. | M | §C.1, §D |
| RF02 | AUT | O sistema envia um email de confirmação e só dá o email como verificado depois de o utilizador abrir o link recebido. | M | UC v1.0, MR v1.0 |
| RF03 | AUT | Se o utilizador tiver menos de 18 anos à data do registo, o sistema pede o email do encarregado de educação e envia-lhe um pedido de consentimento informado. | M | §C |
| RF04 | AUT | O sistema regista a decisão do encarregado de educação (aceita ou recusa), com data e hora, e só ativa a conta de um menor depois de o consentimento ser aceite. | M | §C |
| RF05 | AUT | O utilizador inicia e termina sessão com email e palavra-passe. | M | UC v1.0 |
| RF06 | AUT | O utilizador recupera a palavra-passe através de um link enviado por email. | M | UC v1.0 |
| RF07 | AUT | O Utilizador Registado consulta e atualiza os seus dados pessoais. | M | §C.1 |
| RF08 | PUB | Qualquer visitante consulta as áreas de informação de saúde. | M | §C.1 |
| RF09 | PUB | Qualquer visitante consulta as notícias, as publicações e a agenda de atividades. | M | §B, §C.1 |
| RF10 | PUB | Qualquer visitante consulta os destaques da semana. | M | §B, §C |
| RF11 | PUB | Qualquer visitante consulta a informação geral do projeto e a política de privacidade. | M | §C.1 |
| RF12 | PUB | O conteúdo reservado (recursos formativos, questionários, badges e certificados) só é acessível com sessão iniciada; o restante conteúdo é público. | M | §C |
| RF13 | REC | O Utilizador Registado pesquisa workshops e webinars por texto, área de saúde, tipo e nível. | M | §C.1, §D |
| RF14 | REC | O Utilizador Registado inscreve-se num workshop ou webinar. | M | §C, §C.1 |
| RF15 | REC | O Utilizador Registado vê a lista dos recursos em que está inscrito, com o estado de cada um (por iniciar, em curso, concluído) e a classificação final. | S | UC v1.0 |
| RF16 | REC | O utilizador só acede às gravações e aos materiais de apoio de um recurso em que esteja inscrito e cujo questionário de diagnóstico já tenha respondido. | M | §C, §D.1 |
| RF17 | REC | Um recurso pode estar organizado por níveis, e o utilizador acede a cada nível em separado. | S | §D.1, UC v1.0 |
| RF18 | QST | Antes de aceder ao conteúdo de um recurso, o utilizador responde ao questionário de diagnóstico desse recurso. | M | §C, §D.1 |
| RF19 | QST | O questionário de diagnóstico pode ter uma 2.ª oportunidade de resposta (ver dúvida D01). | S | §D.1 |
| RF20 | QST | Depois de aceder ao conteúdo, o utilizador responde ao questionário final, sobre as mesmas dimensões de conhecimento do diagnóstico. | M | §C, §D.1 |
| RF21 | QST | Em cada resposta a um questionário, o sistema regista as respostas dadas, a classificação obtida e a data. | M | §C, §D.1 |
| RF22 | QST | O utilizador vê a classificação de cada questionário e a comparação entre o diagnóstico e o final. | M | §D.3 |
| RF23 | GAM | O utilizador que conclui o questionário final de um recurso com 85% ou mais recebe o badge e o certificado desse recurso. | M | §D.1 |
| RF24 | GAM | Os badges e os certificados obtidos aparecem no perfil do utilizador. | M | §C, §D.3 |
| RF25 | GAM | O utilizador descarrega em PDF o certificado de um recurso concluído. | S | §C.1 (formato PDF proposto pela equipa) |
| RF26 | GES | O Manager cria, edita e remove recursos formativos (workshops e webinars), com os respetivos níveis, vídeos e materiais de apoio. | M | §C.1 |
| RF27 | GES | O Manager gere as áreas de saúde e as categorias. | M | §C.1 |
| RF28 | GES | O Manager gere as atividades da agenda, as notícias, as publicações e os destaques da semana. | M | §C, §C.1 |
| RF29 | GES | O Manager cria e gere os questionários de diagnóstico e final de cada recurso: perguntas, opções de resposta e resposta correta. | M | §C.1, §D |
| RF30 | GES | O Manager define o estado de cada conteúdo (ex.: rascunho, publicado, arquivado), e só os conteúdos publicados aparecem no frontoffice. | S | MR v1.0 |
| RF31 | GES | O Manager introduz os textos dos conteúdos em português e em inglês. | S | §C |
| RF32 | ADM | O Administrador cria, edita e desativa contas de utilizador. | M | §C, §C.1 |
| RF33 | ADM | O Administrador gere os perfis de acesso e atribui um perfil a cada utilizador. | M | §C, §C.1 |
| RF34 | ADM | O Administrador define as permissões de cada perfil. | M | §C.1 |
| RF35 | ADM | O Administrador altera o estado das contas (ex.: pendente de verificação, pendente de consentimento, ativa, suspensa). | M | §C, MR v1.0 |
| RF36 | EST | O Manager e o Administrador consultam indicadores de utilização: utilizadores registados e ativos, recursos publicados, inscrições e taxa de conclusão. | M | §D.3 |
| RF37 | EST | O sistema calcula o ganho de aprendizagem de cada utilizador em cada recurso, em valor absoluto (pós − pré) e normalizado: g = (pós − pré) / (máximo − pré). | M | §D.2 |
| RF38 | EST | O sistema apresenta o ganho médio por recurso e por área de saúde. | M | §D.3 |
| RF39 | EST | O sistema calcula a média, a mediana, o desvio-padrão, o mínimo e o máximo das classificações por recurso, por área de saúde e por ano de escolaridade. | M | §D.2 |
| RF40 | EST | O sistema mostra, para cada pergunta, a proporção de respostas corretas, para identificar perguntas demasiado fáceis, demasiado difíceis ou pouco discriminantes. | S | §D.2 |
| RF41 | EST | O sistema compara os resultados de dois grupos (ex.: dois anos de escolaridade) com intervalos de confiança e testes de hipóteses. | S | §D.2 |
| RF42 | EST | Quando a amostra é pequena, o sistema estima a incerteza dos indicadores por reamostragem ou simulação. | C | §D.2 |
| RF43 | EST | Os indicadores de aprendizagem são apresentados em gráficos, incluindo a distribuição das classificações e a evolução ao longo do tempo. | M | §D.3 |
| RF44 | EST | O Manager e o Administrador exportam os registos de respostas e classificações em CSV. | M | §D.3 |
| RF45 | AUT | O encarregado de educação pode revogar o consentimento; nesse caso, a conta do menor fica suspensa. | S | Equipa (US_A015) |
| RF46 | AUT | O utilizador pode pedir a exportação e a eliminação dos seus dados pessoais. | C | Equipa (US_A015, RGPD) |
