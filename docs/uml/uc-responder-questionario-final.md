# UC27 — Answer Final Questionnaire

| | |
|---|---|
| User Story | US_A005 ([#5](https://github.com/escobar0304/ProjInter-2-1/issues/5)) |
| Responsável | Pedro Vale (`QuakeXIV`) |
| Versão | 1.0 — Sprint A |
| Nível | Objetivo do utilizador, descrição estruturada fully dressed |
| Sistema | Plataforma de Literacia em Saúde para Jovens, Frontoffice |
| Ator principal | Registered User |
| Trigger | O Registered User escolhe responder ao Final Questionnaire de um Training Resource em que está inscrito. |

## 1. Âmbito e fontes

Detalha o UC27 do [diagrama atualizado v1.1](casos-de-uso.md), usando o [glossário](glossario.md), os [requisitos](../requisitos/furps.md), o [modelo relacional](../base-de-dados/modelo-relacional.md) e o [dicionário de dados](../base-de-dados/dicionario-dados.md).

No diagrama atualizado, UC27 tem associação direta ao Registered User. UC28 Award Badge and Certificate é uma extensão de UC27 com condição `{Score ≥ 85%}`. Não se conserva a relação desatualizada com Access Workshop / Webinars da v1.0 referida na issue.

O [modelo de domínio](modelo-dominio.md) define os agregados Enrollment e Questionnaire e o serviço de domínio Questionnaire Submission. Enrollment contém as entidades Attempt e Certificate e o Value Object Badge. Questionnaire contém as entidades Question e AnswerOption. As referências entre agregados são feitas por identificadores.

## 2. Interessados e interesses

| Interessado | Interesse |
|---|---|
| Registered User | Responder, receber a classificação correta e consultar a comparação com o diagnóstico; obter a recompensa quando cumpre o limiar. |
| Manager | Ter respostas e classificações coerentes para os indicadores e identificar questões a rever. |
| Administrator | Garantir permissões, integridade dos dados e acesso apenas pela conta autorizada. |
| Guardian de um Minor | Garantir que o menor só participa com o consentimento válido e que a revogação impede novos acessos. Não intervém diretamente neste UC. |
| Equipa do projeto / cliente | Medir a aprendizagem a partir das primeiras tentativas e preservar as evidências de cada submissão. |

## 3. Pré-condições

1. O Registered User tem sessão iniciada e conta `active`. Se é Minor, a ativação exigiu verificação do email e Parental Consent aceite.
2. Existe uma Enrollment do User no Training Resource.
3. O Training Resource e o Final Questionnaire estão `published` e disponíveis ao User.
4. O User já submeteu pelo menos uma Attempt do Diagnostic Questionnaire do mesmo recurso e acedeu ao conteúdo (RF18, RF20). Nos recursos sem Levels, esse acesso é registado em `enrollments.content_accessed_at`; nos restantes, usa-se o progresso dos Levels.
5. O Final Questionnaire contém pelo menos uma Question, cada uma com pelo menos duas AnswerOptions e exatamente uma correta, e tem os textos obrigatórios em português.
6. O número de Attempts finais submetidas pelo User nessa Enrollment é inferior a `max_attempts`.

As pré-condições não substituem a validação: o sistema volta a verificá-las ao abrir e ao submeter, porque o estado da conta, o conteúdo e a concorrência podem mudar entretanto.

## 4. Garantias

### Garantia mínima, incluindo insucesso

- Não existe uma Attempt parcialmente gravada. Uma submissão inválida ou uma transação falhada não consome uma tentativa nem altera a conclusão ou as recompensas.
- As tentativas anteriores mantêm as respostas, o Score e a data. Uma falha não apaga trabalho já submetido.
- O sistema não revela a correção nem dados de outro User a um utilizador sem acesso. Os erros técnicos ficam no log, com uma mensagem compreensível na interface.
- Se o browser perder a confirmação após uma gravação bem-sucedida, o sistema não afirma que nada foi gravado; o User pode voltar a consultar os resultados para confirmar o estado.

### Pós-condições de sucesso

- Existe uma nova Attempt final ligada à Enrollment e ao Questionnaire corretos, com número sequencial dentro do limite, `submitted_at`, Score de 0 a 100 e uma Answer por Question.
- O servidor calculou o Score a partir das opções corretas. Guardou a Attempt e todas as Answers numa transação (RNF08).
- A Enrollment está `completed`, mesmo com Score inferior a 85. `completed_at` corresponde à primeira submissão final e não avança numa repetição.
- Quando esta é a primeira Attempt final com Score ≥ 85, existe um Badge e um Certificate para a Enrollment (extensão UC28). Repetir não duplica recompensas nem troca a Attempt que lhes deu origem.
- O User pode consultar o Score desta Attempt e a comparação das primeiras tentativas pré/pós. As repetições não substituem os valores usados no Learning Gain (D01, D04).

## 5. Cenário principal de sucesso

O cenário assume uma submissão válida. O Score resultante pode ficar acima ou abaixo de 85%; a recompensa é condicional e está nas extensões.

1. **Registered User:** escolhe responder ao Final Questionnaire na página do Training Resource em que está inscrito.
2. **Sistema:** valida as pré-condições e apresenta as instruções, o limite de tentativas, as Questions e as Answer Options no idioma disponível, sem indicar as corretas.
3. **Registered User:** escolhe uma Answer Option em cada Question.
4. **Sistema:** valida o preenchimento na interface e assinala eventuais campos por completar, mantendo as escolhas durante esta interação.
5. **Registered User:** pede para rever as respostas antes de submeter.
6. **Sistema:** mostra o resumo das escolhas e indica que a confirmação grava uma Attempt.
7. **Registered User:** confirma a submissão das respostas.
8. **Sistema:** volta a validar a sessão, a conta e o acesso. O serviço Questionnaire Submission consulta Questionnaire, valida Questions e AnswerOptions e calcula o Score; regista a Attempt através de Enrollment, que aplica o limite, a gravação atómica das Answers, a conclusão e a atribuição de Badge e Certificate de UC28 quando se aplica.
9. **Registered User:** escolhe consultar o resultado da submissão.
10. **Sistema:** apresenta o Score, a data, o número da tentativa, as tentativas restantes e a comparação das primeiras Attempts Diagnostic/Final, com as recompensas disponíveis quando existirem.

Cada passo pertence a um só interveniente. A revisão e confirmação dos passos 5 a 7 são uma proposta de interação da equipa a validar no estudo de UI/UX; não impõem um endpoint nem um desenho de ecrã específico.

## 6. Extensões e cenários alternativos

| Ponto | Condição | Comportamento e retorno |
|---|---|---|
| 2a, 8a | Sessão terminada ou conta deixou de estar `active` | Sistema recusa o acesso ou a submissão e encaminha para autenticação quando aplicável. Não grava uma nova Attempt. A revogação de consentimento é refletida na verificação do estado da conta. |
| 2b, 8b | Sem Enrollment ou Diagnostic do mesmo recurso | Sistema indica o passo em falta. User pode inscrever-se ou responder ao diagnóstico; UC27 termina sem submissão. |
| 2c, 8c | Recurso ou Questionnaire deixou de estar publicado | Sistema informa a indisponibilidade e não grava a submissão. |
| 2d, 8d | `max_attempts` atingido, incluindo por outra janela | Sistema rejeita uma tentativa adicional e permite consultar as existentes. O limite é verificado no servidor sob controlo de concorrência. |
| 2e | Tradução inglesa ausente | Sistema usa o texto português e informa o idioma apresentado. É uma proposta de fallback, sujeita a validação com o cliente. |
| 4a | Falta uma resposta | Sistema assinala a Question; User completa-a e retoma o passo 3. A proposta exige todas as perguntas respondidas. |
| 6a | User quer alterar uma escolha | User volta ao preenchimento do passo 3; ainda não existe uma nova Attempt. |
| 7a | User cancela antes de confirmar | UC termina sem consumir tentativa. O modelo atual não promete guardar rascunhos entre sessões. |
| 8e | Opção não pertence à Question, Question não pertence ao Questionnaire ou submissão incompleta | Sistema rejeita o conjunto. Não calcula um Score com dados fornecidos pelo cliente nem grava respostas parciais. |
| 8f | Falha da BD antes do commit | Sistema faz rollback de toda a operação e apresenta mensagem compreensível. Tentativa, conclusão e recompensas mantêm o estado anterior. |
| 8g | Confirmação perde-se na rede depois do commit | Sistema permite consultar as Attempts existentes antes de repetir a submissão. A estratégia técnica para distinguir reenvio de nova tentativa fica por definir no backend, secção 10. |
| 8h | Score < 85 | Enrollment fica concluída; não se cria nova recompensa. Se houver tentativas disponíveis, User pode voltar a UC27. |
| 8i | Score ≥ 85 e ainda sem recompensa | Sistema executa UC28, atribui uma vez o Badge e regista o Certificate ligado a esta Attempt. |
| 8j | Já existe recompensa de uma Attempt anterior | Sistema preserva o Badge e o Certificate existentes. Um Score posterior inferior a 85 não os revoga. |
| 10a | Não existe pré ou o par está inconsistente | Sistema não inventa um ganho. Exibe os resultados válidos e regista a inconsistência para revisão. Este caso não deve resultar de um percurso normal validado. |
| 10b | Primeiro Score Diagnostic = 100 | Sistema apresenta o ganho absoluto e indica que o ganho normalizado não se aplica. |

## 7. Regras e rastreabilidade

| Regra | Referência | Dados / conceitos |
|---|---|---|
| Só acede quem tem sessão e permissões | RF12, RNF24 | User, Role, Permission, Account Status |
| Inscrição e diagnóstico antes do Final | RF14, RF18, RF20 | Enrollment, Diagnostic Questionnaire, Attempt |
| Respostas, Score e data por submissão | RF21, RNF08 | Attempt, Answer, Answer Option, Score |
| Limite configurável de tentativas | D04, modelo relacional | Questionnaire.max_attempts, Attempt.attempt_number |
| Conclusão com qualquer Score final | RF15, RF36, glossário Completion | Enrollment.status, Enrollment.completed_at |
| Recompensa na primeira tentativa final ≥ 85 | RF23 a RF25, D04, D09, UC28 | Badge, Certificate, Attempt |
| Comparação das primeiras tentativas | RF22, RF37, D01, D04, D07 | Learning Gain, Diagnostic Questionnaire, Final Questionnaire |
| Traduções de conteúdos | RF31, RNF13, D08 | Language, Translation |

No domínio, Questionnaire preserva as regras das perguntas e opções; Enrollment preserva a consistência de Attempt, Answer, Score, Badge e Certificate. Questionnaire Submission coordena a submissão entre os dois agregados, respeitando as suas fronteiras.

Correspondência física: `attempts`, `attempt_answers`, `questionnaires`, `questions`, `answer_options`, `enrollments`, `badges` e `certificates`. Os tipos e as restrições mantêm-se no modelo e no dicionário, não se duplicam como atributos de um diagrama de domínio neste documento.

## 8. Requisitos especiais e frequência

- **RNF01, RNF03 e RNF04:** interface responsiva, linguagem adequada aos jovens, perguntas e opções operáveis por teclado, rótulos claros e mensagens acessíveis.
- **RNF05, RNF13 e RF31:** interface e textos traduzíveis, português obrigatório e inglês opcional nos conteúdos.
- **RNF06:** validação no frontend e backend, com indicação da pergunta/campo a corrigir.
- **RNF07 e RNF08:** mensagem compreensível perante falha de BD e submissão indivisível.
- **RNF16 e RNF24:** testes de backend para regras de negócio e autorização em todos os pedidos, incluindo durante a submissão.
- **RNF22, RNF23 e RNF25:** proteção dos dados de menores, credenciais apenas em hash e HTTPS em produção. As respostas e o Score são dados de desempenho do próprio User.
- **RNF14:** resultados e comparação calculados sobre dados persistidos, nunca sobre indicadores fixos.
- **Frequência:** por cada Enrollment que chega ao Final, até ao máximo configurado no Questionnaire. A equipa não dispõe de uma medição de utilização real nesta sprint; não se assume uma frequência numérica.

## 9. Exemplos para revisão e testes futuros

| Situação | Resultado esperado |
|---|---|
| 20 perguntas, 17 corretas | Score 85%; primeira recompensa e Enrollment concluída. |
| 20 perguntas, 16 corretas | Score 80%; Enrollment concluída e sem recompensa. |
| Primeiro Final 80 e segundo Final 90 | Recompensa na segunda Attempt; comparação pré/pós conserva 80 como pós; `completed_at` mantém a primeira submissão. |
| Duas janelas tentam consumir a última tentativa | No máximo uma nova Attempt aceite; a outra recebe o resultado do limite/conflito. |
| Erro ao gravar uma das Answers | Nenhuma parte da nova Attempt, conclusão ou recompensa fica gravada. |
| Opção correta de outra pergunta no payload | Submissão rejeitada, mesmo se a interface tiver sido contornada. |
| Conta suspensa durante o preenchimento | Submissão recusada na verificação do servidor. |

## 10. Questões abertas e limites

- D04, D05 e D07 continuam como pressupostos do glossário até validação com o cliente.
- A exigência de responder a todas as perguntas, a revisão antes da confirmação e o fallback para português são propostas explícitas da descrição, não respostas já obtidas do cliente.
- O acesso ao conteúdo sem Levels é registado em `enrollments.content_accessed_at`, conforme o modelo relacional; o backend usa esse registo para validar RF20. Com Levels, mantém-se a validação do progresso.
- O schema garante unicidade do número de tentativa, mas não define por si só idempotência de reenvios nem o controlo de concorrência de `max_attempts`. A organização interna do backend deve definir esses mecanismos; esta US não acrescenta tabelas nem promete uma implementação existente.
- O modelo relacional estabelece que o backend bloqueia alterações às perguntas e opções de um Questionnaire após a sua primeira Attempt. Esta regra preserva a correção por pergunta; não existe versionamento histórico no schema.
- A geração/descarregamento do PDF do Certificate fica em UC30. A extensão UC28 regista a atribuição; uma falha de download não anula a Attempt.

## 11. Dependências

O cenário usa o [diagrama de use cases](casos-de-uso.md) da US_A002, o [glossário](glossario.md) e o [modelo de domínio](modelo-dominio.md) da US_A004. A correspondência física segue o [modelo relacional](../base-de-dados/modelo-relacional.md) e o [dicionário de dados](../base-de-dados/dicionario-dados.md), incluindo os ajustes de integridade e acesso ao conteúdo.
