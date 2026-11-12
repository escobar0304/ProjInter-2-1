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

## 4. Requisitos não funcionais

### Usabilidade (U)

| ID | Descrição | Prioridade | Origem |
|---|---|---|---|
| RNF01 | A interface adapta-se a ecrãs entre 360 px e 1920 px de largura, sem scroll horizontal. | M | §C |
| RNF02 | As funcionalidades principais (pesquisar recursos, responder a questionários, ver badges e certificados) ficam a, no máximo, 3 cliques da página inicial. | S | §C (critério proposto pela equipa) |
| RNF03 | Os textos da interface usam linguagem simples, adequada a jovens dos 12 aos 18 anos, e são revistos por outro elemento da equipa antes de publicados. | S | §C |
| RNF04 | A interface cumpre o nível AA das WCAG 2.1 nos pontos essenciais: contraste, texto alternativo nas imagens e navegação por teclado. | S | Equipa |
| RNF05 | O utilizador escolhe o idioma da interface (português ou inglês). | S | §C |

### Fiabilidade (R)

| ID | Descrição | Prioridade | Origem |
|---|---|---|---|
| RNF06 | Todos os dados introduzidos são validados no frontend e no backend. Um dado inválido é rejeitado com uma mensagem que indica o campo e o que corrigir. | M | §C |
| RNF07 | Se a base de dados falhar, o utilizador vê uma mensagem de erro compreensível, sem detalhes técnicos, e o erro fica registado no log do servidor. | M | §C |
| RNF08 | A submissão de um questionário é gravada por inteiro ou não é gravada: nunca fica registada só em parte. | S | Equipa (§D.1) |
| RNF09 | Em produção, é feita uma cópia de segurança diária da base de dados. | C | Equipa |

### Desempenho (P)

| ID | Descrição | Prioridade | Origem |
|---|---|---|---|
| RNF10 | As páginas principais carregam em menos de 3 segundos numa ligação de 10 Mbit/s. | S | Equipa |
| RNF11 | Os indicadores estatísticos são calculados em menos de 5 segundos com até 10 000 respostas registadas. | S | Equipa (§D.2) |
| RNF12 | O sistema suporta pelo menos 50 utilizadores em simultâneo sem degradação visível. | C | Equipa |

### Suportabilidade (S)

| ID | Descrição | Prioridade | Origem |
|---|---|---|---|
| RNF13 | A estrutura de conteúdos suporta mais do que um idioma: acrescentar um idioma não obriga a alterar o código. | M | §C |
| RNF14 | Os indicadores são sempre calculados a partir da base de dados, nunca a partir de valores fixos no código. | M | §D.2 |
| RNF15 | Cada Pull Request é validado automaticamente pelo CI antes de entrar no `main`. | S | Equipa (US_A012) |
| RNF16 | As regras de negócio principais (ex.: consentimento antes da ativação, regra dos 85%) têm testes automáticos no backend. | S | Equipa |

### Restrições (+)

| ID | Tipo | Descrição | Prioridade | Origem |
|---|---|---|---|---|
| RNF17 | Design | A arquitetura separa a apresentação (React), a lógica de negócio e controlo (Python com Flask) e os dados, seguindo a programação orientada a objetos. | M | §C, §E |
| RNF18 | Implementação | O frontend é desenvolvido em React. | M | §C, §E |
| RNF19 | Implementação | O backend é desenvolvido em Python com Flask. | M | §C, §E |
| RNF20 | Implementação | O SGBD é o PostgreSQL. A especificação indica MySQL ou SQL Server; a mudança foi validada pelo orientador. | M | Equipa (§E) |
| RNF21 | Implementação | A aplicação e a base de dados correm em contentores Docker, com Docker Compose (a partir da Sprint B). | S | Equipa |
| RNF22 | Legal | O sistema cumpre o RGPD, com particular atenção aos dados de menores: recolhe só os dados necessários, exige o consentimento do encarregado de educação e tem a política de privacidade pública. | M | §C |
| RNF23 | Segurança | As palavras-passe são guardadas com uma função de hash adequada (ex.: bcrypt ou Argon2), nunca em claro. | M | §C |
| RNF24 | Segurança | As permissões de cada perfil são verificadas no backend em todos os pedidos, e não só na interface. | M | §C.1, Equipa (US_A015) |
| RNF25 | Segurança | Em produção, a comunicação entre o browser e o servidor usa HTTPS. | S | Equipa |
| RNF26 | Interface | Os emails de confirmação, de consentimento e de recuperação da palavra-passe são enviados através de um serviço de email externo (SMTP). | M | UC v1.0 |
| RNF27 | Interface | O CSV exportado usa a codificação UTF-8 e tem na primeira linha o nome de cada coluna. | S | §D.3 |
| RNF28 | Física | A aplicação funciona nas versões atuais do Chrome, Firefox, Edge e Safari, sem instalação. | S | Equipa |

## 5. Fora de âmbito nesta versão (W)

| ID | Descrição | Origem |
|---|---|---|
| W01 | Transmissão de webinars em direto dentro da plataforma. Os recursos são disponibilizados em vídeo (§D.1). | Equipa |
| W02 | Aplicação móvel nativa. A plataforma é web e responsiva (RNF01). | Equipa |
| W03 | Pagamentos ou conteúdos pagos. | Equipa |

## 6. Dúvidas para esclarecer com o cliente

| ID | Dúvida | Requisitos afetados |
|---|---|---|
| D01 | A 2.ª oportunidade no diagnóstico é dada sempre ou por decisão do Manager? Que tentativa conta como "pré" no cálculo do ganho? | RF19, RF37 |
| D02 | A idade-limite para pedir consentimento é 18 anos ("menor de idade") ou outra? | RF03 |
| D03 | Os professores e os profissionais de saúde que dinamizam as atividades são Utilizadores Registados, Managers ou um perfil próprio? | §2, RF33 |
| D04 | Quem fica abaixo dos 85% no questionário final pode repeti-lo? Quantas vezes? | RF20, RF23 |
| D05 | O certificado é gerado pela plataforma? Que dados contém (nome, recurso, data, classificação)? | RF25 |
| D06 | O que conta como utilizador "ativo" (ex.: sessão iniciada nos últimos 30 dias)? | RF36 |
| D07 | Como se trata o ganho normalizado quando a classificação pré já é a máxima (divisão por zero)? | RF37 |
| D08 | O inglês aplica-se só à interface ou também aos recursos e aos questionários? | RF31, RNF05 |
| D09 | Há só um badge por recurso, ou também outros (ex.: por área de saúde)? | RF23 |
| D10 | Os destaques da semana são escolhidos pelo Manager ou calculados automaticamente? | RF10, RF28 |
| D11 | O encarregado de educação precisa de conta própria, ou basta responder pelo link do email? | §2, RF04, RF45 |

## 7. Alterações face ao levantamento fornecido (§C)

- Os requisitos genéricos foram reescritos de forma verificável (ex.: "UI clara, intuitiva e responsiva" deu origem a RNF01 a RNF03).
- Os requisitos compostos foram divididos (ex.: "inscrição em workshops e webinars e acesso às gravações" deu origem a RF14 e RF16).
- As funcionalidades por ator (§C.1) e as do diagrama de use cases v1.0 passaram a requisitos (ex.: RF05 a RF07, RF15, RF17).
- O percurso de aprendizagem, as métricas e os resultados (§D.1 a §D.3) passaram a requisitos (RF18 a RF25 e RF36 a RF44).
- O SGBD passou a ser o PostgreSQL, em vez de MySQL ou SQL Server (RNF20), com validação do orientador.
- Foram acrescentados requisitos da equipa: Docker (RNF21), segurança e RGPD (RF45, RF46, RNF24, RNF25), acessibilidade (RNF04), fiabilidade (RNF08, RNF09), desempenho (RNF10 a RNF12) e qualidade (RNF15, RNF16).
- Ficaram explícitos os limites de âmbito (W01 a W03).

## 8. Ligação às US extra

| US extra | Requisitos relacionados |
|---|---|
| US_A014: decisões de arquitetura (ADR) e modelo C4 | RNF17 a RNF21 |
| US_A015: privacidade e segurança | RF03, RF04, RF45, RF46, RNF22 a RNF25 |
| US_A016: dados sintéticos e protótipo das métricas | RF36 a RF44, RNF14 |
