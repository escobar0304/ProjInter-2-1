# Sprint Review A — Apresentação de trabalho

| | |
|---|---|
| User Story | US_A010 ([#10](https://github.com/escobar0304/ProjInter-2-1/issues/10)) |
| Responsável | Pedro Vale (`QuakeXIV`) |
| Estado | Rascunho para revisão da equipa; depende da consolidação do relatório #13 |
| Referência dos estados | GitHub e Projects consultados em 21/11/2026 |

## Ficheiros

- [Apresentação editável em PowerPoint](sprint-review-a.pptx): 12 slides, texto e tabelas editáveis, notas do apresentador e fontes.
- [PDF de segurança](sprint-review-a.pdf): as mesmas 12 páginas renderizadas.
- [Guião, tempos e questões de defesa](roteiro.md).
- [Fonte do gerador](gerar-apresentacao.mjs) e [exportação PDF alternativa](gerar-pdf.py).

## Conteúdo e limites

A apresentação cobre capa, trabalho desenvolvido, mudanças nos use cases e no modelo relacional, arquitetura, consentimento, métricas, mapa das 16 US, justificação das US extra, próximos passos e autoavaliação.

Os tempos previstos totalizam dez minutos. Isto não substitui um ensaio com a equipa. O relatório #13 continua aberto, as percentagens das US abertas não foram fornecidas e a autoavaliação numérica tem de ser decidida pela equipa. Esses pontos estão identificados, sem inventar percentagens ou notas. Os 100% do mapa representam issues fechadas, não uma auditoria independente dos critérios de aceitação.

O diagrama de domínio pedido na #4 ainda não aparece no `main`, embora a issue esteja fechada. A apresentação assinala a necessidade de confirmar esse artefacto. A #16 continua adiada e não tem resultados apresentados como concluídos. Os PR [#28](https://github.com/escobar0304/ProjInter-2-1/pull/28) e [#29](https://github.com/escobar0304/ProjInter-2-1/pull/29) contêm as propostas de #9 e #5, respetivamente, sem duplicar os seus entregáveis nesta branch.

O [README da Sprint A](../../../sprints/SprintA/README.md) indica entrega em 28/11/2026 e apresentação a confirmar; as datas antigas nas issues e no README principal divergem. Confirmar o calendário com o docente antes de fechar a versão para apresentação.

## Reprodução

Requer Node.js, `@oai/artifact-tool` e, para a exportação PDF alternativa, Python com `reportlab`. O runtime de apresentações do Codex fornece estas dependências. Sem esse runtime, a equipa tem de disponibilizar as mesmas dependências no seu ambiente; este gerador não instala pacotes automaticamente.

Executar na raiz do repositório:

```bash
node docs/entregas/sprint-review-a/gerar-apresentacao.mjs
python docs/entregas/sprint-review-a/gerar-pdf.py .local/sprint-review-a-build .local/sprint-review-a-build/sprint-review-a.pdf
```

Se as dependências vierem do runtime do Codex, definir `ARTIFACT_TOOL_MODULES` para a pasta `node_modules` devolvida por `load_workspace_dependencies`. `REVIEW_BUILD_DIR` permite escolher a pasta temporária de geração. Os ficheiros temporários ficam por omissão em `.local/`, ignorada pelo Git. Validar o PPTX gerado antes de substituir a versão entregue.

A exportação PDF nativa falhou no runtime usado por falta de uma fonte interna do exportador. O PDF entregue usa as imagens de alta resolução dos slides e conserva o aspeto; o texto editável está no PPTX. Não confundir o PDF com uma versão editável dos slides.

## Validação realizada

- 12 slides renderizados e inspecionados visualmente, com revisão do cabeçalho da tabela de gestão.
- Integridade do pacote PPTX, geometria, dimensões 16:9, fonte Arial e presença das duas tabelas nativas no slide 9: verificadas sem erros.
- Reimportação do PPTX no Artifact Tool: passou. Não foi realizada uma inspeção no PowerPoint nativo.
- PDF com 12 páginas, gerado das imagens renderizadas; guião com orçamento total de 600 segundos.
- O ensaio, as percentagens em falta, a autoavaliação e a consolidação com #13 continuam pendentes.

## Uso de IA

Codex (OpenAI): apoio à síntese dos artefactos, à organização dos slides e do guião, à geração dos ficheiros e à revisão visual. A equipa deve confirmar a classificação do uso no sistema de semáforos, validar os conteúdos e defender as suas US. A apresentação não substitui essa validação nem o ensaio.
