# Métricas de utilização e de aprendizagem

| | |
|---|---|
| User Story | US_A009 ([#9](https://github.com/escobar0304/ProjInter-2-1/issues/9)) |
| Responsável | Pedro Vale (`QuakeXIV`) |
| Versão | 1.0 — Sprint A |
| Estado | Proposta para revisão da equipa |

## 1. Âmbito e fontes

Definição dos indicadores das secções D.2 e D.3, a partir dos [requisitos RF15 e RF21 a RF44](../requisitos/furps.md), do [glossário](../uml/glossario.md), do [modelo relacional](../base-de-dados/modelo-relacional.md) e do [dicionário de dados](../base-de-dados/dicionario-dados.md). Os cálculos usam o [schema PostgreSQL](../../database/schema.sql), sem depender de valores de indicadores fixos no código.

As decisões D01, D04, D06 e D07 continuam a ser pressupostos da equipa, sujeitos a confirmação do cliente. As convenções analíticas adicionais deste documento são propostas para revisão, não respostas já obtidas do cliente.

## 2. População, unidades e convenções

- Uma observação de aprendizagem é uma **Enrollment** com a primeira Attempt de Diagnostic e a primeira de Final do mesmo Training Resource. Nunca emparelhar pessoas ou recursos diferentes.
- `pré` e `pós` são `attempts.score` quando `attempt_number = 1`, separados por `questionnaires.type`. Uma repetição pode gerar uma recompensa, mas não substitui o resultado usado para medir a evolução (D01, D04).
- Classificações em percentagem de respostas corretas, de 0 a 100; diferenças em **pontos percentuais (p.p.)**. Cada Question tem o mesmo peso. Score = `100 × corretas / total de perguntas`, arredondado a duas casas decimais na gravação.
- Ganho normalizado é adimensional. Não o designar por percentagem de classificação; pode ser negativo. Com pré = 100, é `NULL`, mesmo se pós = 100 (D07).
- Uma inscrição sem Final não tem pós nem ganho. Não imputar zero. Apresentar os números de inscritos, de pares completos e de ganhos normalizados válidos, para tornar visível a não conclusão e o efeito da exclusão de pré = 100.
- A média do ganho normalizado é a **média dos ganhos individuais**, não `(média pós − média pré) / (100 − média pré)`. Não confundir essas duas estatísticas.
- Por área de saúde, cada Enrollment tem o mesmo peso; uma pessoa inscrita em dois recursos contribui duas observações descritivas. A inferência reamostra por User para respeitar essa dependência.
- As estatísticas de Scores usam a primeira Attempt de cada tipo, separando Diagnostic e Final. Podem incluir diagnósticos sem Final; comparar pré e pós apenas nos pares completos quando a pergunta for evolução individual.
- O ano de escolaridade vem do valor **atual** de `users.school_year_id`. O modelo não guarda o ano à data da Attempt; os gráficos devem dizer «ano de escolaridade atual». Valores em falta formam o grupo «não indicado», não são convertidos num ano válido.
- Um intervalo temporal usa início inclusivo e fim exclusivo `[início, fim)`, com instantes UTC. O mês da evolução de aprendizagem é o mês UTC da primeira Attempt final. Comparar médias de pares pertencentes a cada mês; não interpretar como seguimento da mesma coorte.
- Nos contadores atuais de utilização, a data de referência `t` é explícita. Não apresentar uma reconstrução histórica de estados sem histórico desses estados.
- Média, mediana, mínimo e máximo ficam sem valor para `n = 0`; o desvio-padrão é **amostral**, com denominador `n − 1`, e fica sem valor para `n < 2`. Exibir sempre `n` e as exclusões.

## 3. Catálogo e mapeamento

Na tabela, `I(condição)` vale 1 quando a condição é verdadeira e 0 caso contrário. `N` é a contagem da população indicada, depois dos filtros. `s` identifica os Scores selecionados na secção 2.

| Métrica | Objetivo | Fórmula | Variáveis | Origem (tabela.coluna) | Agregação |
|---|---|---|---|---|---|
| Score de uma Attempt (RF21, RF22) | Mostrar a classificação de cada submissão | `100 × corretas / Q`, Q > 0 | Q: perguntas; corretas: opções escolhidas corretas; Score persistido | `questions.id`, `questions.questionnaire_id`, `attempt_answers.attempt_id`, `attempt_answers.question_id`, `attempt_answers.answer_option_id`, `answer_options.is_correct`, `attempts.score`, `attempts.submitted_at` | Utilizador, inscrição, tipo e tentativa |
| Comparação pré/pós (RF22) | Mostrar o ponto de partida e de chegada | Par `(pré, pós)` da mesma inscrição | Scores das primeiras tentativas | `attempts.enrollment_id`, `attempts.attempt_number`, `attempts.score`, `questionnaires.id`, `questionnaires.type`, `enrollments.user_id`, `enrollments.training_resource_id` | Utilizador e recurso |
| Ganho absoluto (RF37) | Quantificar a mudança individual | `pós − pré` | pré, pós | `attempts.score`, `attempts.enrollment_id`, `attempts.questionnaire_id`, `attempts.attempt_number`, `questionnaires.type` | Inscrição; unidade p.p. |
| Ganho normalizado (RF37) | Medir a fração do ganho possível | `(pós − pré) / (100 − pré)` se pré < 100; `NULL` se pré = 100 | pré, pós, máximo = 100 por definição do Score | Mesmas colunas do ganho absoluto | Inscrição; adimensional |
| Ganho médio absoluto e normalizado (RF38) | Comparar a evolução entre recursos e áreas | `Σ ganho / N válido` para cada medida | ganhos individuais, recurso, área | `attempts.score`, `attempts.attempt_number`, `questionnaires.type`, `enrollments.training_resource_id`, `training_resources.health_area_id` | Recurso, área de saúde, ano atual; com N válido |
| Distribuição dos Scores (RF39, RF43) | Descrever centro, dispersão e extremos | média `Σs/n`; mediana; `sqrt(Σ(s−média)²/(n−1))`; mínimo; máximo | primeira classificação, tipo, grupo | `attempts.score`, `attempts.attempt_number`, `questionnaires.type`, `enrollments.training_resource_id`, `training_resources.health_area_id`, `enrollments.user_id`, `users.school_year_id`, `school_years.year` | Por tipo, recurso, área e ano atual |
| Proporção correta por pergunta (RF40) | Identificar perguntas com acerto muito baixo ou alto | `Σ I(is_correct) / N de respostas` | uma resposta por User e pergunta na primeira Attempt | `attempt_answers.question_id`, `attempt_answers.answer_option_id`, `answer_options.id`, `answer_options.is_correct`, `attempt_answers.attempt_id`, `attempts.id`, `attempts.attempt_number` | Question, Questionnaire e tipo; proporção de 0 a 1 |
| Discriminação da pergunta (RF40) | Distinguir facilidade de discriminação | Correlação de Pearson entre acerto (0/1) e total de acertos **nas outras perguntas** da mesma Attempt | acerto do item e total sem o item | `attempt_answers.attempt_id`, `attempt_answers.question_id`, `attempt_answers.answer_option_id`, `answer_options.is_correct`, `attempts.attempt_number` | Pergunta, dentro do mesmo Questionnaire |
| Diferença entre dois grupos (RF41) | Comparar a evolução de dois anos de escolaridade | `média(ganho absoluto A) − média(ganho absoluto B)` | pares completos, grupo atual, User | `users.school_year_id`, `school_years.year`, `enrollments.user_id`, `enrollments.training_resource_id`, `attempts.score`, `attempts.attempt_number`, `questionnaires.type` | Dois anos atuais distintos, por recurso, cada um com pelo menos 5 Users (RNF45); p.p. |
| IC e teste de hipótese (RF41, RF42) | Quantificar incerteza da diferença | IC percentil bootstrap 95%; teste bilateral por permutação, secção 4 | ganhos, grupos e identificador do User | Mesmas colunas da comparação de grupos | Recurso; área apenas com agrupamento por User |
| Utilizadores registados (RF36) | Contar as contas existentes | `COUNT(users.id)` com `created_at <= t` | User, Role, instante de criação | `users.id`, `users.created_at`, `users.role_id`, `roles.code` | Global; por Role se solicitado |
| Utilizadores ativos (RF36, D06) | Medir atividade recente por login | `COUNT(id)` com `t − 30 dias <= last_login_at <= t` | última sessão iniciada | `users.id`, `users.last_login_at`, `users.created_at`, `users.role_id` | Global; mostrar os mesmos filtros de Role do contador de registos |
| Recursos publicados (RF36) | Contar oferta formativa visível | `COUNT(id)` com estado atual `published` e criação até t | recurso e estado atual | `training_resources.id`, `training_resources.created_at`, `training_resources.content_status_id`, `content_statuses.id`, `content_statuses.code` | Global, recurso/área |
| Inscrições (RF36) | Medir procura | `COUNT(enrollments.id)` com `enrolled_at <= t` | inscrição, recurso, User | `enrollments.id`, `enrollments.enrolled_at`, `enrollments.training_resource_id`, `enrollments.user_id` | Global, recurso, área, ano atual |
| Taxa de conclusão (RF15, RF36) | Medir a fração de inscrições concluídas | `100 × N concluídas até t / N inscrições até t` | conclusão pela submissão do primeiro Final, qualquer Score | `enrollments.id`, `enrollments.enrolled_at`, `enrollments.completed_at`, `enrollments.status`, `enrollments.training_resource_id` | Global, recurso, área, ano atual; sem valor se denominador zero |
| Badge obtido (RF23, RF24) | Mostrar o reconhecimento atribuído | Existe registo ligado à primeira Attempt Final com Score ≥ 85 | inscrição premiada, tentativa e data | `badges.enrollment_id`, `badges.attempt_id`, `badges.awarded_at`, `attempts.score`, `questionnaires.type`, `training_resources.badge_image_url` | Perfil do próprio User e recurso |
| Certificate obtido (RF23 a RF25) | Mostrar e permitir descarregar o certificado | Existe registo ligado à primeira Attempt Final com Score ≥ 85 | inscrição, tentativa, data e código | `certificates.id`, `certificates.enrollment_id`, `certificates.attempt_id`, `certificates.issued_at`, `certificates.verification_code`, `attempts.score`, `enrollments.user_id`, `users.name` | Perfil do próprio User e recurso |
| Evolução temporal (RF43) | Observar alterações ao longo do tempo | Média dos ganhos dos pares com primeiro Final no mês; N por mês | data do primeiro Final e ganhos | `attempts.submitted_at`, `attempts.attempt_number`, `questionnaires.type`, `attempts.score`, `enrollments.training_resource_id`, `training_resources.health_area_id` | Mês UTC e recurso/área |
| Exportação de respostas e Scores (RF44) | Permitir análise externa autorizada | Uma linha por resposta submetida, com Score e metadados da Attempt | código pseudónimo do User, recurso, tipo, tentativa, pergunta, resposta e data | `attempts.id`, `attempts.enrollment_id`, `attempts.questionnaire_id`, `attempts.attempt_number`, `attempts.score`, `attempts.submitted_at`, `attempt_answers.question_id`, `attempt_answers.answer_option_id`, `enrollments.training_resource_id` | CSV UTF-8 com cabeçalhos; todas as tentativas; sem nome, email nem data de nascimento (RNF45) |

Não contar linhas de respostas para obter número de Attempts, Enrollments ou Users: esses joins multiplicam registos. Agregar primeiro na unidade adequada ou contar IDs distintos.

## 4. Incerteza, testes e interpretação

Proposta analítica para validação na Sprint A:

1. Comparar dois anos de escolaridade atuais distintos dentro do **mesmo recurso**, usando os ganhos absolutos dos pares completos. Não misturar tipos de questionário nem substituir primeiras tentativas por melhores classificações.
2. Usar bootstrap percentil com 5 000 reamostragens e seed fixa (por omissão 2026). Reamostrar Users com reposição, separadamente em cada grupo. Num recurso, existe no máximo uma Enrollment por User, pelo que isto equivale a reamostrar os ganhos desse grupo. Ao juntar recursos numa área, manter todas as inscrições da pessoa juntas em cada seleção.
3. IC de 95%: percentis 2,5 e 97,5 das diferenças de médias bootstrap. Publicar a diferença observada, o intervalo, N de Users de cada grupo, seed, número de reamostragens e filtros.
4. Hipótese nula: as distribuições dos ganhos são permutáveis entre os grupos. Permutar as etiquetas dos grupos por User, preservando os tamanhos dos grupos; calcular 5 000 diferenças. Valor-p bilateral Monte Carlo: `(1 + número de |diferenças permutadas| >= |observada|) / (5000 + 1)`. Nível exploratório α = 0,05.
5. Se algum grupo tiver menos de 5 Users, não mostrar a diferença, o IC nem o valor-p; devolver «grupo demasiado pequeno» (RNF45). Grupos com 5 a 9 Users são assinalados como pequenos; bootstrap não corrige falta de representatividade. Amostras constantes podem produzir IC de largura zero: assinalar a degenerescência.
6. Não concluir que o ano escolar ou o recurso **causou** o ganho: a amostra é observacional e só os pares completos entram. Registar possível viés de seleção, ausência de confundidores e multiplicidade das comparações. Os valores-p são exploratórios, sem alegar controlo de erro para muitas comparações simultâneas.

Uma proporção correta próxima de 0 ou 1 sugere, respetivamente, um item difícil ou fácil naquela amostra, mas **não mede discriminação**. Para a correlação item-resto são necessárias pelo menos duas perguntas, três respostas completas e variância não nula nos dois vetores; caso contrário fica sem valor. Não fixar limiares de qualidade pedagógica sem validação do cliente.

## 5. Consulta de referência e casos-limite

O ficheiro [consultas-metricas.sql](consultas-metricas.sql) contém consultas apenas de leitura para pares, ganhos, estatísticas, proporção de acerto e utilização atual. As médias são calculadas a partir das linhas da BD. A comparação de grupos por reamostragem pertence ao protótipo da US_A016.

| Caso | Resultado esperado |
|---|---|
| pré = 40 e pós = 85 | ganho absoluto = 45 p.p.; normalizado = 0,75 |
| pré = 80 e pós = 60 | −20 p.p.; −1; não truncar a zero |
| pré = 100 e pós = 90 | −10 p.p.; normalizado sem valor; contar a exclusão |
| Diagnóstico 40, repetição 70, primeiro Final 80, repetição 90 | pré/pós = 40/80; ganho = 40 p.p.; normalizado ≈ 0,6667; prémio na repetição Final com 90 |
| Só diagnóstico | diagnóstico entra na sua distribuição; inscrição continua no denominador de conclusão; sem par nem ganho |
| Final com 60 | inscrição concluída; sem recompensa |
| Nenhuma inscrição | taxa de conclusão sem valor; contagem = 0 |
| Uma observação | média/mediana/mínimo/máximo definidos; desvio-padrão sem valor |
| Nenhuma resposta a uma pergunta | proporção e discriminação sem valor; apresentar N = 0 |
| Dois recursos por User na mesma área | duas observações na descrição; manter o User como unidade de reamostragem |

## 6. Adequação e limites do modelo

As variáveis do catálogo existem no schema atual. Os ajustes ao modelo relacional reforçam a integridade entre recursos e tentativas e registam o acesso a conteúdos sem Levels. Mantêm-se os seguintes limites:

- **Histórico das perguntas:** `attempt_answers` aponta para `answer_options.is_correct`, sem versões. O [modelo relacional](../base-de-dados/modelo-relacional.md) estabelece como regra do backend o bloqueio de alterações às perguntas e opções após a primeira Attempt do Questionnaire. O Score persistido preserva a classificação; a análise por item depende do cumprimento dessa regra. Versionamento histórico continua a ser uma decisão futura.
- **Grupo escolar histórico:** o ano de escolaridade é o atual do User. Análise pelo ano à data da resposta exigiria um snapshot adicional; não prometer esse resultado com o modelo atual.
- **Acesso ao conteúdo:** `level_progress` regista o progresso nos recursos com Levels. Para recursos sem Levels, `enrollments.content_accessed_at` regista o primeiro acesso ao conteúdo e permite ao backend validar a pré-condição do Final (RF20). Esse acesso não mede tempo de leitura nem comprova aprendizagem.
- **Coerência entre tabelas:** as chaves compostas em `attempts`, com `training_resource_id`, garantem que a Attempt, a Enrollment e o Questionnaire pertencem ao mesmo Training Resource. A BD não garante que as perguntas respondidas pertencem ao Questionnaire da Attempt; o backend deve validar essa pertença antes da transação.
- **Estado histórico:** `last_login_at` só permite atividade recente em relação ao estado observado; não reconstrói logins de meses anteriores. Publicação, Role e estado de conta também não têm histórico completo.
- **População após eliminação:** as contagens refletem registos existentes; a eliminação em cascata remove também o desempenho. Não apresentar totais históricos imutáveis sem uma política própria de agregação e conservação.

## 7. Acesso e apresentação

- Registered User consulta apenas os próprios resultados, badges e certificados (UC23, UC29, UC30).
- Manager e Administrator consultam indicadores com `indicator.view` e exportam com `result.export` (UC42 a UC45). O backend verifica as permissões em cada pedido.
- Mostrar unidade, período, filtros, N de observações e exclusões em cada gráfico. Grupos sem dados distinguem-se de valores zero.
- **Pequenos grupos (RNF45):** um indicador ou uma exportação por grupo (recurso, área, ano de escolaridade, pergunta) com menos de 5 Users não mostra os valores, só a indicação «grupo demasiado pequeno». Assim não é possível deduzir o resultado de um menor a partir de um grupo com 1 ou 2 pessoas.
- **Exportação CSV (RF44, RNF45):** cada User é identificado só por um código pseudónimo, estável dentro da exportação, sem nome, email, data de nascimento, hashes nem tokens. A correspondência entre o código e a conta fica só na base de dados. A [análise de privacidade e segurança](../seguranca/README.md) justifica estas regras.
- Para a review, usar apenas dados fictícios claramente identificados.
- Os indicadores são calculados no backend a partir da BD (RNF14); erros técnicos ficam no log e o utilizador recebe uma mensagem compreensível.

## 8. Dependências e validação

A definição baseia-se nos [requisitos](../requisitos/furps.md), no [modelo relacional](../base-de-dados/modelo-relacional.md) e no [dicionário de dados](../base-de-dados/dicionario-dados.md). Fornece as convenções analíticas para o protótipo de dados sintéticos da US_A016. Os pressupostos analíticos permanecem sujeitos a confirmação pelo cliente.
