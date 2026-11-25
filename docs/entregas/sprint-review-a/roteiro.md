# Guião da Sprint Review A

Proposta de apresentação de dez minutos. Os tempos atribuídos aos slides somam 600 segundos.

## Sequência e tempos

| Slide | Tema | Tempo | Tempo acumulado | Intervenção proposta |
|---|---|---:|---:|---|
| 1 | Capa e objetivo da Sprint A | 20 s | 0:20 | Diogo apresenta a equipa e o problema. |
| 2 | Percurso de aprendizagem | 40 s | 1:00 | Diogo liga o público-alvo ao diagnóstico, conteúdo e Final. |
| 3 | Requisitos e linguagem comum | 50 s | 1:50 | Diogo explica IDs, prioridades e origem; João distingue termos ambíguos. |
| 4 | Alterações nos use cases | 60 s | 2:50 | João explica herança e consentimento; Pedro apresenta UC27 e UC28. |
| 5 | Modelos de domínio e relacional | 60 s | 3:50 | Diogo explica Enrollment, Attempt, respostas e traduções. |
| 6 | Arquitetura | 45 s | 4:35 | Diogo apresenta as cinco decisões aceites. |
| 7 | Registo e consentimento | 50 s | 5:25 | João descreve verificação, consentimento e ativação da conta. |
| 8 | Métricas | 65 s | 6:30 | Pedro apresenta o exemplo fictício de 40% no diagnóstico e 85% no Final, o ganho absoluto de 45 p.p. e o ganho normalizado de 0,75. |
| 9 | Mapa das 16 User Stories | 80 s | 7:50 | Diogo apresenta o mapa; cada membro enquadra as suas entregas. |
| 10 | User Stories extra | 45 s | 8:35 | A equipa explica os objetivos de A014, A015 e A016; A015 está fechada. |
| 11 | Próximas etapas | 45 s | 9:20 | Diogo enquadra o relatório A013 e a Sprint B. |
| 12 | Balanço da sprint | 40 s | 10:00 | A equipa resume evidências e oportunidades de melhoria. |

## Pontos de fala

### 1. Objetivo

«Estamos a preparar uma plataforma de literacia em saúde para jovens do 3.º ciclo e do secundário. Nesta sprint trabalhámos sobretudo os requisitos, os modelos e as regras que vão orientar a implementação.»

### 2. Percurso

O diagnóstico mede o conhecimento inicial, o conteúdo dá acesso à formação e o Final permite comparar resultados. Submeter o Final conclui o recurso, qualquer que seja a classificação. O badge e o certificado exigem pelo menos 85%.

### 3. Requisitos

O levantamento contém 49 requisitos funcionais e 46 não funcionais. Cada requisito tem ID, prioridade e origem. O glossário distingue Registration, Enrollment, Role e User Profile. O Guardian decide por email e não precisa de conta.

### 4. Use cases

A versão 1.1 completa a herança dos atores, clarifica o consentimento do Guardian e separa biblioteca pública de formação reservada. UC27 está associado diretamente ao Registered User; UC28 estende-o quando o Score é pelo menos 85%. A descrição de UC27 está integrada.

### 5. Dados

Uma Attempt guarda classificação, número e data; attempt_answers regista a opção escolhida em cada pergunta. O consentimento guarda estados, email do Guardian e datas. As 40 tabelas incluem seis de referência e dez de traduções; o modelo de domínio define 11 agregados. Enrollment contém Attempt, Badge e Certificate. Questionnaire contém Question e AnswerOption. Questionnaire Submission coordena a submissão. enrollments.content_accessed_at regista o acesso sem Levels e attempts.training_resource_id reforça a coerência pelas chaves compostas.

### 6. Arquitetura

Os ADR-0001 a ADR-0005 estão aceites: PostgreSQL, Docker Compose, sessão em cookie, ficheiros num volume com controlo de acesso e SPA React com API REST Flask na mesma origem. A apresentação descreve decisões arquiteturais; não afirma que a aplicação esteja implementada.

### 7. Consentimento

O email pode ser verificado antes ou depois do consentimento, mas um menor só fica ativo quando ambas as condições se verificam. O Guardian não precisa de conta. Recusa, expiração e revogação têm caminhos definidos no BPMN.

### 8. Métricas

A US_A009 define a comparação pela primeira tentativa de diagnóstico e pela primeira tentativa final. O exemplo fictício passa de 40% no diagnóstico para 85% no Final: ganho absoluto de 45 p.p. e ganho normalizado de 0,75. Um pré-score de 100 não produz ganho normalizado; uma inscrição sem Final não recebe um pós-score zero.

### 9. Mapa

O mapa regista responsáveis, estados e percentagens declaradas. Os 100% assinalam uma issue fechada; N/D significa percentagem não registada. A005, A009 e A015 estão fechadas; A010, A013 e A016 estão em curso.

### 10. User Stories extra

A014 documenta decisões e contexto arquitetural. A015 trata privacidade de menores, permissões e ameaças. A016 permite explorar as métricas sobre dados fictícios antes de existirem utilizadores reais.

### 11. Próximas etapas

Consolidar o relatório A013 com os modelos de domínio e relacional. A Sprint B inclui UI/UX, frontend, base de dados e Docker, com a organização interna do backend por definir.

### 12. Balanço

A Sprint A produziu requisitos rastreáveis, modelos relacionais e de domínio, decisões arquiteturais e percursos de consentimento. O trabalho seguinte inclui integração das entregas, validação dos pressupostos com o cliente e preparação da implementação.

## Perguntas de defesa

| Pergunta | Base para a resposta |
|---|---|
| Porque escolheram PostgreSQL? | ADR-0001; suporta os índices parciais e as restrições do modelo. |
| Como impedem uma conta de menor sem consentimento? | A conta só fica ativa depois da verificação do email e do consentimento aceite; o backend verifica o estado. |
| O recurso só fica concluído com 85%? | Não. A conclusão resulta da submissão final; o limiar aplica-se às recompensas. |
| Que tentativas contam para o ganho? | A primeira Diagnostic e a primeira Final, segundo os pressupostos D01 e D04. |
| E se o pré-score for 100%? | Apresentar o ganho absoluto e deixar o normalizado sem valor, evitando divisão por zero. |
| O acerto por pergunta mede discriminação? | Não. Descreve facilidade ou dificuldade nesta amostra; a correlação item-resto é uma análise distinta. |
| O modelo permite comparar anos passados? | Guarda o ano atual do User, sem snapshot associado a cada Attempt. |
| Como interpretar os gráficos da A016? | São resultados de dados fictícios e não descrevem utilizadores reais. |
| Como se relacionam Enrollment e Questionnaire na submissão? | Questionnaire Submission coordena a submissão; os agregados permanecem separados. |
