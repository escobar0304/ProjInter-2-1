# A016 — Dados sintéticos e protótipo das métricas

| | |
|---|---|
| User Story | US_A016 ([#16](https://github.com/escobar0304/ProjInter-2-1/issues/16)) |
| Branch | `feature/A016-Dados-Sinteticos` |
| Responsável | Pedro Vale (`QuakeXIV`) |

## Objetivo

Gerar dados fictícios que respeitam `database/schema.sql` e calcular, a partir de PostgreSQL, as métricas de aprendizagem definidas em `docs/metricas/metricas.md`.

## Dados sintéticos

O script `database/seed/gerar_dados.py` usa uma seed fixa (`2026`) e pode ser executado novamente sem acumular os registos que cria. Gera 144 Users fictícios, três Health Areas, quatro Training Resources e inscrições distribuídas pelos anos 7.º a 12.º. Cada recurso tem Questionnaires de diagnóstico e final, dez Questions com quatro Answer Options cada, e Attempts com respostas completas. Há Users sem início, inscrições sem Final e segundas Attempts de diagnóstico.

Os emails usam o domínio reservado `.invalid`; os dados não correspondem a contas ou contactos reais. As contas sintéticas têm Parental Consent aceite, email verificado e hash Argon2id determinístico. A carga usa IDs consultados às tabelas de referência e as duas chaves estrangeiras compostas de `attempts`.

Usa Python 3.12 ou superior. A partir da raiz do repositório, cria um ambiente virtual e instala as dependências:

```bash
py -3.14 -m venv .venv
.venv/Scripts/python -m pip install -r database/seed/requirements.txt
```

Cria uma base local com PostgreSQL 18, aplica o schema e carrega os dados:

```bash
docker run --name a016-metricas -e POSTGRES_PASSWORD=local-synthetic -e POSTGRES_DB=metricas_a016 -p 5432:5432 -d postgres:18
docker cp database/schema.sql a016-metricas:/tmp/schema.sql
docker exec a016-metricas psql -U postgres -d metricas_a016 -v ON_ERROR_STOP=1 -f /tmp/schema.sql
.venv/Scripts/python database/seed/gerar_dados.py --dsn "postgresql://postgres:local-synthetic@localhost:5432/metricas_a016"
```

O script apaga apenas os Users com o prefixo de email `seed-a016-` e os recursos associados às Health Areas sintéticas marcadas por esta US. Não altera o schema nem outros registos.

## Métricas e gráficos

O notebook `docs/metricas/prototipo-metricas.ipynb` executa as quatro consultas de `docs/metricas/consultas-metricas.sql`. Apresenta ganhos absoluto e normalizado, estatísticas por Training Resource, Health Area e School Year atual, proporções corretas por Question, indicadores de utilização e comparação entre dois anos por recurso, com bootstrap percentil de 95% e teste por permutação. A contagem de Users por grupo aplica o RNF45: grupos com menos de cinco não mostram contagens nem métricas, apenas a indicação «grupo demasiado pequeno»; grupos de cinco a nove são assinalados como pequenos. O endereço da base pode ser definido pela variável `DATABASE_URL`.

Para executar todas as células e guardar os resultados no notebook:

```bash
.venv/Scripts/jupyter nbconvert --to notebook --execute --inplace docs/metricas/prototipo-metricas.ipynb
```

Os três gráficos mostram a distribuição dos Scores de diagnóstico e finais, o ganho absoluto médio por Health Area e a proporção correta média por Question. Cada gráfico identifica a amostra como dados fictícios.

## Lacunas do modelo de dados

- `users.school_year_id` guarda apenas o ano atual. O modelo não permite recuperar o School Year à data de uma Attempt; a análise histórica por ano exige um snapshot associado à submissão.
- `attempt_answers.question_id` não tem uma chave estrangeira que garanta a pertença da Question ao Questionnaire da Attempt. O backend tem de validar essa relação antes de gravar as respostas.
- A chave de `attempt_answers` impede respostas duplicadas à mesma Question numa Attempt, mas não garante que todas as Questions do Questionnaire foram respondidas. A validação da submissão completa fica no backend.
- `answer_options.is_correct` não tem histórico nem versão. A análise histórica por pergunta depende da regra de bloquear alterações às Questions e Answer Options após a primeira Attempt, atualmente delegada ao backend.
- Os estados atuais de conta, Role e publicação não têm histórico suficiente para reconstruir os indicadores como eram numa data passada.
