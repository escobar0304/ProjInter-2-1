# Guião da Sprint Review A

Proposta de apresentação de dez minutos para revisão da equipa. Os tempos são um orçamento, não a medição de um ensaio já realizado. O debate com o cliente acontece depois do pitch.

## Sequência e tempos

| Slide | Tema | Tempo | Tempo acumulado | Intervenção proposta |
|---|---|---|---|---|
| 1 | Capa e objetivo da Sprint A | 20 s | 0:20 | Diogo apresenta a equipa e o problema. |
| 2 | Percurso de aprendizagem | 40 s | 1:00 | Diogo liga o público-alvo ao diagnóstico, conteúdo e Final. |
| 3 | Requisitos e linguagem comum | 50 s | 1:50 | Diogo explica IDs, prioridades e origem; João distingue os termos ambíguos. |
| 4 | Alterações nos use cases | 60 s | 2:50 | João explica herança, Guardian e relações; Pedro enquadra UC27 em revisão. |
| 5 | Modelos de domínio e relacional | 60 s | 3:50 | Diogo explica Enrollment, Attempt, respostas e traduções. |
| 6 | Arquitetura | 45 s | 4:35 | Diogo distingue decisões aceites e propostas. |
| 7 | Registo e consentimento | 50 s | 5:25 | João descreve os dois ramos e a ativação da conta. |
| 8 | Métricas | 65 s | 6:30 | Pedro apresenta as primeiras tentativas, o exemplo fictício e os casos-limite. |
| 9 | Mapa das 16 US | 80 s | 7:50 | Diogo apresenta o estado global e cada membro confirma os seus dados. |
| 10 | Justificação das US extra | 45 s | 8:35 | A equipa justifica A014, A015 e A016, distinguindo os estados. |
| 11 | Próximos passos e dependências | 45 s | 9:20 | Diogo identifica a consolidação do relatório e a passagem à Sprint B. |
| 12 | Balanço e autoavaliação | 40 s | 10:00 | A equipa apresenta a avaliação que ainda tem de acordar. |

## Pontos de fala

### 1. Objetivo

«Estamos a preparar uma plataforma de literacia em saúde para jovens do 3.º ciclo e do secundário. Nesta sprint trabalhámos sobretudo os requisitos, os modelos e as regras que vão orientar a implementação.» Confirmar os nomes e o calendário antes da apresentação.

### 2. Percurso

O diagnóstico mede o conhecimento inicial, o conteúdo dá acesso à formação e o Final permite comparar resultados. Submeter o Final conclui o recurso, qualquer que seja a classificação. O badge e o certificado exigem pelo menos 85%.

### 3. Requisitos

O levantamento contém 46 RF e 28 RNF. Cada requisito tem ID, prioridade e origem. O glossário resolve ambiguidades: Registration é o registo na plataforma e Enrollment é a inscrição num recurso; Role é o perfil de acesso e User Profile é a página pessoal.

### 4. Use cases

Apresentar duas ou três alterações da v1.1 e o seu motivo: herança completa, consentimento do Guardian e separação entre biblioteca pública e formação reservada. UC27 tem associação direta ao Registered User; UC28 estende-o com condição de Score ≥ 85%. A descrição estruturada de UC27 ainda está em revisão no [PR #29](https://github.com/escobar0304/ProjInter-2-1/pull/29).

### 5. Dados

Uma Attempt guarda classificação, número e data; `attempt_answers` regista a opção escolhida em cada pergunta. O consentimento precisa de estados, email do Guardian e datas, em vez de um booleano. As 40 tabelas incluem seis de referência e dez de traduções; não são 40 agregados de domínio. O modelo de domínio define 11 agregados. Enrollment contém Attempt, Badge e Certificate; Questionnaire contém Question e AnswerOption. Questionnaire Submission coordena a submissão entre ambos. `enrollments.content_accessed_at` regista o acesso sem Levels e `attempts.training_resource_id` garante a coerência do recurso pelas chaves compostas.

### 6. Arquitetura

React, Flask e PostgreSQL separam a apresentação, as regras e os dados. PostgreSQL e Docker têm ADR aceites. Os documentos ainda marcam os ADR de autenticação, ficheiros e API como propostas. A Sprint A não demonstra a aplicação já implementada.

### 7. Consentimento

O email pode ser verificado antes ou depois do consentimento, mas um menor só fica ativo quando ambos se verificam. O Guardian não precisa de conta. Recusa, expiração e revogação têm caminhos definidos no BPMN. A análise de privacidade e ameaças de #15 ainda está pendente.

### 8. Métricas

Usar o exemplo fictício 40%/85%: ganho absoluto de 45 p.p. e normalizado 0,75. As primeiras tentativas contam para a comparação; a melhor tentativa pode gerar uma recompensa, mas não substitui a medição inicial. Pré = 100 deixa o ganho normalizado sem valor. Uma inscrição sem Final não recebe um pós de zero. A definição está no [PR #28](https://github.com/escobar0304/ProjInter-2-1/pull/28); o protótipo #16 continua adiado.

### 9. Gestão

O mapa identifica as 16 US e os responsáveis. Os 100% assinalam issues fechadas; as restantes percentagens precisam de confirmação. Atualizar os estados e validar os artefactos antes da versão final. Não apresentar N/D como zero nem inventar percentagens de progresso.

### 10. US extra

A014 permite justificar decisões e alterações futuras. A015 reduz o risco de implementar tarde regras para dados de menores e permissões. A016 permitirá testar se o modelo suporta as métricas. Justificar a utilidade não significa afirmar que as três já estão concluídas.

### 11. Próximos passos

A apresentação depende da consolidação do relatório #13. Consolidar o relatório com os modelos de domínio e relacional atualizados, confirmar percentagens e datas e só depois fechar a entrega. A Sprint B prevê UI/UX, frontend, BD e Docker, com organização interna do backend por decidir.

### 12. Avaliação

A equipa deve acordar a autoavaliação e a contribuição de cada membro, com evidências. Há documentação rastreável e validação do schema em CI. Melhorias: alinhar estados e artefactos, confirmar pressupostos com o cliente e ensaiar a apresentação. A autoavaliação numérica será acordada pela equipa.

## Perguntas prováveis para a defesa

| Pergunta | Base para a resposta |
|---|---|
| Porquê PostgreSQL em vez do SGBD inicial? | ADR-0001, validado pelo orientador; permite os índices únicos parciais e as restrições usadas no modelo. |
| Como impedem uma conta de menor sem consentimento? | Só ativar depois de email verificado e consentimento aceite; validar o estado no backend em cada pedido. |
| O recurso só fica concluído com 85%? | Não. Completion resulta da submissão final. O limiar aplica-se às recompensas. |
| Que tentativa conta para o ganho? | A primeira Diagnostic e a primeira Final, conforme os pressupostos D01 e D04. |
| E se pré for 100%? | Mostrar ganho absoluto e deixar o normalizado sem valor, evitando a divisão por zero. |
| A proporção correta mede discriminação? | Mede facilidade/dificuldade nessa amostra. A proposta de #9 distingue a correlação item-resto. |
| O modelo suporta comparar anos no passado? | Guarda o ano atual do User, sem snapshot por Attempt. O limite está registado na proposta das métricas. |
| As US extra já estão concluídas? | A014 está fechada. A015 continua pendente e A016 adiada. Explicar os respetivos benefícios e estados. |
| O modelo de domínio está completo? | O diagrama e a tabela de 11 agregados estão em docs/uml/modelo-dominio.md. Enrollment e Questionnaire são coordenados por Questionnaire Submission na submissão das respostas. |
| Que uso fizeram de IA? | O README principal, na secção «Uso de IA generativa», declara Claude e Codex. A equipa revê e valida os resultados; cada membro deve conseguir explicar o seu trabalho. |

## Lista de fecho antes da apresentação

- [ ] Integrar o relatório #13 e confirmar que a apresentação corresponde à versão entregue.
- [ ] Integrar o resultado da análise de privacidade #15 quando estiver disponível.
- [ ] Atualizar o estado de cada US e obter da equipa as percentagens em falta.
- [ ] Acordar e justificar a autoavaliação e os contributos individuais.
- [ ] Confirmar as datas com o docente.
- [ ] Rever o conteúdo e obter aprovação da equipa.
- [ ] Ensaiar com cronómetro, ajustar os tempos e confirmar quem fala em cada slide.
- [ ] Abrir o PPTX no computador da apresentação e guardar o PDF como plano B.
