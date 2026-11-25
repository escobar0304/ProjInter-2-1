# A013 — Relatório técnico da Sprint A

| | |
|---|---|
| User Story | US_A013 ([issue #13](https://github.com/escobar0304/ProjInter-2-1/issues/13)) |
| Branch | `feature/A013-Relatorio` |
| Responsável | João Crasto |

## Objetivo

Compilar o trabalho da Sprint A no modelo de relatório fornecido pelo docente, preenchendo os capítulos que correspondem a esta sprint.

## O que foi feito

- Relatório em [`docs/entregas/`](../../docs/entregas/), com a fonte em Word ([`.docx`](../../docs/entregas/LEI-SMUL1-PI-SA-R-DiogoEscobar-JoaoCrasto-PedroVale.docx)) e o [PDF](../../docs/entregas/LEI-SMUL1-PI-SA-R-DiogoEscobar-JoaoCrasto-PedroVale.pdf).
- Estrutura do modelo, com os estilos, a capa, a paginação (romana no resumo e nos índices, árabe nos capítulos) e o cabeçalho com o título e os autores:
  - capa, resumo, índice, índice de figuras, índice de tabelas e lista de acrónimos e siglas;
  - capítulo 1, Introdução: enquadramento, objetivos e estrutura do relatório;
  - capítulo 2, Desenvolvimento: 2.1 Planeamento do Projeto (metodologia, cronograma, recursos, gestão do trabalho e repositório) e 2.2 Análise de Sistemas, com uma secção por artefacto;
  - capítulo 3, Conclusão, com as limitações e a secção 3.2 do modelo;
  - referências.
- Todas as US da Sprint A, incluindo as extra (US_A014, US_A015 e US_A016), com a secção de cada uma indicada na tabela das User Stories.
- 13 figuras e 6 tabelas, numeradas com legenda automática e referidas no texto por referências cruzadas. Os diagramas são os SVG de `docs/` e ficam vetoriais no PDF; a figura 13 é um gráfico do [protótipo das métricas](../../docs/metricas/prototipo-metricas.ipynb), identificado como dados fictícios.
- Os diagramas de use cases e o fluxograma do registo passam a ter também a imagem em SVG, ao lado do PNG: [`casos-de-uso-frontoffice.svg`](../../docs/uml/casos-de-uso-frontoffice.svg), [`casos-de-uso-backoffice.svg`](../../docs/uml/casos-de-uso-backoffice.svg) e [`registo-utilizador.svg`](../../docs/bpmn/registo-utilizador.svg).
- Os diagramas largos (BPMN, modelo de domínio, modelo relacional e C4) estão em páginas na horizontal.

## Decisões

- **Fonte em Word, a partir do modelo.** Mantém os estilos, a paginação e as legendas automáticas pedidos no modelo, e os índices atualizam-se com *Atualizar campo*. O modelo em branco não entra no repositório.
- **Só os capítulos da Sprint A.** O Estudo UI/UX (Sprint B) e o Desenvolvimento do Projeto e os Resultados (Sprints B e C) entram nas sprints seguintes. O capítulo «Revisão de Literatura/Estado da Arte», que aparece no índice do modelo mas não no corpo, não foi incluído.
- **Texto a escrever marcado a amarelo**, como as instruções do modelo: o desenvolvimento de cada secção e as conclusões.
- **Nome dos ficheiros** no formato do enunciado: `LEI-SMUL1-PI-SA-R-NOME-NOME-NOME`.

## Como verificar

- Abrir o `.docx` no Word e atualizar os campos (Ctrl+A, F9): os índices e as referências não mudam e não aparece nenhum erro de referência.
- No PDF, as figuras 1 a 13 e as tabelas 1 a 6 aparecem nos índices com a página certa, e cada uma é referida no texto antes de aparecer.
- Os números das secções citados no texto e na tabela das User Stories correspondem ao índice.

## Pendente

- Escrever o desenvolvimento de cada secção e as conclusões (texto a amarelo) e gerar de novo o PDF.
- Acrescentar o cronograma (mapa de Gantt).
- Revisão por pelo menos 2 elementos da equipa.
- Entrega no Moodle e tag `sprint-a`.
