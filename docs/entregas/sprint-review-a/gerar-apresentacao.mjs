// Fonte editável da apresentação da US_A010.
// Dependência: @oai/artifact-tool. O runtime do Codex pode ser indicado em
// ARTIFACT_TOOL_MODULES, sem guardar caminhos pessoais no repositório.
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const sourceDir = path.dirname(fileURLToPath(import.meta.url));
const buildDir = process.env.REVIEW_BUILD_DIR || path.resolve(sourceDir, '../../../.local/sprint-review-a-build');
const packageRoot = process.env.ARTIFACT_TOOL_MODULES;
const { Presentation, PresentationFile } = packageRoot
  ? await import(pathToFileURL(path.join(packageRoot, '@oai/artifact-tool/dist/artifact_tool.mjs')).href)
  : await import('@oai/artifact-tool');
await fs.mkdir(buildDir, { recursive: true });

const font = 'Arial';
const colors = { navy: '#102C3B', ink: '#183E4C', teal: '#087F8C', light: '#F3F7F5', muted: '#526D76', white: '#FFFFFF', gold: '#F2C46D' };
const deck = Presentation.create({ slideSize: { width: 1280, height: 720 } });
const repo = 'https://github.com/escobar0304/ProjInter-2-1';
const schedule = [20, 40, 50, 60, 60, 45, 50, 65, 80, 45, 45, 40];
if (schedule.reduce((a, b) => a + b, 0) !== 600) throw new Error('O guião deve totalizar 10 minutos.');

function text(slide, value, x, y, width, height, size = 26, options = {}) {
  const box = slide.shapes.add({ geometry: 'textbox', position: { left: x, top: y, width, height },
    fill: 'none', line: { fill: 'none', width: 0 }, name: options.name || 'texto' });
  box.text = value;
  box.text.style = { fontFamily: font, fontSize: size, color: options.color || colors.ink, bold: options.bold || false };
  return box;
}
function base(title, index, notes, source) {
  const slide = deck.slides.add();
  slide.background.fill = colors.light;
  text(slide, title, 64, 44, 1148, 100, 42, { bold: true, name: 'titulo' });
  text(slide, 'Sprint A · Rascunho para revisão da equipa', 64, 665, 1000, 24, 15, { color: colors.muted });
  text(slide, String(index).padStart(2, '0'), 1160, 662, 60, 30, 20, { color: colors.teal, bold: true });
  slide.speakerNotes.text = `Tempo previsto: ${schedule[index - 1]} segundos.\n${notes}\nFontes: ${source}\nEstado de referência: 21/11/2026. Atualizar antes da apresentação.`;
  return slide;
}
function columns(slide, leftTitle, leftBody, rightTitle, rightBody) {
  text(slide, leftTitle, 64, 180, 540, 54, 30, { bold: true, color: colors.teal });
  text(slide, leftBody, 64, 248, 530, 340, 27);
  text(slide, rightTitle, 670, 180, 540, 54, 30, { bold: true, color: colors.teal });
  text(slide, rightBody, 670, 248, 530, 340, 27);
}

{
  const slide = deck.slides.add();
  slide.background.fill = colors.navy;
  text(slide, 'Literacia em saúde\npara jovens', 72, 104, 1120, 220, 68, { bold: true, color: colors.white });
  text(slide, 'Sprint Review A', 76, 366, 1000, 65, 38, { color: colors.gold });
  text(slide, 'Diogo Escobar · João Crasto · Pedro Vale\nISTEC Porto · Engenharia Informática · 2026/2027', 76, 472, 1100, 90, 25, { color: colors.white });
  text(slide, 'Rascunho de trabalho · data da apresentação a confirmar', 76, 642, 1120, 36, 19, { color: '#C0D5D9' });
  slide.speakerNotes.text = `Tempo previsto: 20 segundos. Apresentar a equipa e o objetivo da sprint: requisitos, modelos e planeamento. Não apresentar a aplicação como implementada. Fonte: ${repo}/blob/main/README.md e sprints/SprintA/README.md. A data da review ainda carece de confirmação.`;
}
{
  const slide = base('O percurso liga formação e aprendizagem', 2,
    'Explicar o público-alvo do 7.º ao 12.º ano e a sequência diagnóstico, conteúdo, final. A biblioteca é pública. Gravações e questionários são reservados. Conclusão e recompensa têm regras diferentes.',
    `${repo}/blob/main/docs/uml/glossario.md`);
  text(slide, 'Diagnóstico', 64, 204, 350, 68, 40, { bold: true, color: colors.teal });
  text(slide, 'Conhecimento inicial', 64, 290, 350, 120, 29);
  text(slide, 'Conteúdo', 467, 204, 350, 68, 40, { bold: true, color: colors.teal });
  text(slide, 'Workshops e webinars\nem vídeo', 467, 290, 350, 120, 29);
  text(slide, 'Questionário final', 870, 204, 350, 100, 36, { bold: true, color: colors.teal });
  text(slide, 'Resultado e comparação', 870, 328, 340, 120, 29);
  text(slide, 'Badge e certificado na primeira tentativa final com pelo menos 85%', 64, 535, 1135, 92, 32, { bold: true });
}
{
  const slide = base('Requisitos e linguagem comum', 3,
    'Mostrar que a equipa separou requisitos funcionais e não funcionais, com IDs estáveis, origem e prioridade. Explicar a cadeia de herança dos atores. O Guardian decide por email, sem conta. Usar Role e User Profile, Registration e Enrollment como exemplos de ambiguidades resolvidas.',
    `${repo}/blob/main/docs/requisitos/furps.md ; ${repo}/blob/main/docs/uml/glossario.md`);
  columns(slide, '46 requisitos funcionais', 'Registo e consentimento\nConteúdo e formação\nQuestionários e recompensas\nGestão e indicadores',
    '28 requisitos não funcionais', 'Validação e integridade\nPermissões no backend\nPrivacidade de menores\nReact, Flask e PostgreSQL');
  text(slide, 'Guest, Registered User, Manager e Administrator partilham uma hierarquia de acesso', 64, 586, 1120, 52, 23, { color: colors.muted });
}
{
  const slide = base('Os use cases passam a cobrir o percurso completo', 4,
    'Comparar a versão fornecida com a v1.1 através das mudanças documentadas, sem incorporar materiais dos docentes no repositório público. Distinguir relações include/extend. UC27 é direto do Registered User e UC28 é condicional. A descrição estruturada da #5 está em PR e ainda requer revisão.',
    `${repo}/blob/main/docs/uml/casos-de-uso.md ; ${repo}/pull/29`);
  columns(slide, 'Problemas da versão inicial', 'Herança incompleta\nRegisto associado ao login\nConsentimento duplicado\nObjetivos sem ator direto',
    'Alterações na v1.1', '48 UC com IDs e rastreabilidade\nGuardian e Email Service\nConteúdo público separado\nUC27 e recompensa condicional');
}
{
  const slide = base('O modelo guarda respostas e tentativas', 5,
    'Explicar a Enrollment como ligação entre User e Training Resource. Attempts guardam Score, data e número. attempt_answers regista a opção por pergunta. Um booleano não bastava para consentimento. As 40 tabelas incluem referência e traduções, não 40 entidades de domínio. A #4 está fechada no GitHub, mas falta no main o diagrama de domínio pedido.',
    `${repo}/blob/main/docs/base-de-dados/modelo-relacional.md`);
  columns(slide, '40 tabelas no schema v1.1', '24 tabelas de domínio\n6 tabelas de referência\n10 tabelas de traduções\nRestrições verificadas no SQL',
    'Mudanças com efeito no produto', 'Uma linha por Attempt\nUma Answer por Question\nConsentimento com estados e datas\nBadge e Certificate atribuídos');
  text(slide, 'O diagrama de domínio e a tabela de agregados ainda precisam de confirmação', 64, 590, 1135, 50, 23, { color: colors.muted });
}
{
  const slide = base('A arquitetura separa interface, regras e dados', 6,
    'React e Flask são requisitos. PostgreSQL e Docker estão aceites nos ADR. A autenticação por cookie, o armazenamento de ficheiros e a API na mesma origem ainda aparecem como propostas nos documentos. Não afirmar que a aplicação já corre em Docker: frontend e backend só têm estrutura inicial.',
    `${repo}/blob/main/docs/arquitetura/README.md ; ${repo}/blob/main/docs/arquitetura/c4.md`);
  columns(slide, 'Decisões aceites', 'React e Python com Flask\nPostgreSQL 18\nDocker Compose a partir da Sprint B\nSchema como fonte de verdade',
    'Propostas documentadas', 'SPA e API na mesma origem\nSessão em cookie e CSRF\nFicheiros fora da pasta pública\nAPI verifica o acesso aos ficheiros');
}
{
  const slide = base('A conta de um menor exige duas confirmações', 7,
    'Descrever o gateway inclusivo do BPMN: o email é sempre verificado e o consentimento só se aplica a menores. Qualquer ordem é válida. Mencionar recusa, expiração e revogação. Os prazos são pressupostos da equipa. A análise RGPD/STRIDE da #15 continua pendente.',
    `${repo}/blob/main/docs/bpmn/registo-utilizador.md`);
  text(slide, 'Email verificado', 64, 204, 530, 100, 48, { bold: true, color: colors.teal });
  text(slide, 'Consentimento aceite', 670, 204, 540, 100, 43, { bold: true, color: colors.teal });
  text(slide, 'A conta só fica ativa quando as duas condições se verificam', 64, 380, 1140, 130, 40, { bold: true });
  text(slide, 'Guardian sem conta · decisão registada · revogação suspende o acesso', 64, 574, 1135, 72, 25, { color: colors.muted });
}
{
  const slide = base('As primeiras tentativas medem a evolução', 8,
    'Exemplo aritmético fictício, não resultado de utilizadores: 40 para 85 dá 45 pontos percentuais e ganho normalizado 0,75. Pré=100 deixa o normalizado sem valor. Não conclusão não vira Score zero. A #9 está em PR. A #16, ainda no Backlog e adiada, não foi desenvolvida e não existem resultados empíricos para apresentar.',
    `${repo}/pull/28 ; ${repo}/blob/main/docs/uml/glossario.md`);
  text(slide, '40% no diagnóstico\n85% no primeiro final', 64, 188, 550, 180, 42, { bold: true, color: colors.teal });
  text(slide, '45 p.p. de ganho absoluto\n0,75 de ganho normalizado', 670, 188, 540, 180, 37, { bold: true });
  text(slide, 'Média, mediana e dispersão\nAnálise por pergunta e comparação de grupos', 64, 430, 1140, 130, 31);
  text(slide, 'Exemplo fictício de fórmula. A #16 permanece adiada', 64, 590, 1120, 42, 23, { color: colors.muted });
}
{
  const slide = base('Mapa das 16 US e dos responsáveis', 9,
    'Percentagens: 100% identifica apenas uma issue fechada, não uma auditoria independente de todos os critérios. A equipa tem de confirmar percentagens reais das US abertas antes da review. #4 requer confirmação do diagrama de domínio. #5 e #9 estão em PR. #10 tem uma preparação em curso mas depende do relatório #13, da atualização dos estados, da autoavaliação e do ensaio.',
    `${repo}/issues ; https://github.com/users/escobar0304/projects/2/views/1`);
  const records = [
    ['A001','Diogo','Fechada','100%*'],['A002','João','Fechada','100%*'],
    ['A003','Diogo','Fechada','100%*'],['A004','João','Fechada','100%*'],
    ['A005','Pedro','Em PR','N/D'],['A006','Diogo','Fechada','100%*'],
    ['A007','Diogo','Fechada','100%*'],['A008','João','Fechada','100%*'],
    ['A009','Pedro','Em PR','N/D'],['A010','Pedro','Em preparação','N/D'],
    ['A011','Diogo','Fechada','100%*'],['A012','Diogo','Fechada','100%*'],
    ['A013','João','Aberta','N/D'],['A014','Diogo','Fechada','100%*'],
    ['A015','João','Ready','N/D'],['A016','Pedro','Backlog','N/D'],
  ];
  for (const [side, rows] of [records.slice(0,8),records.slice(8)].entries()) {
    const values = [['US','Pessoa','Estado','Conclusão'], ...rows];
    const table = slide.tables.add({ rows: values.length, columns: 4,
      left: 64 + side * 600, top: 182, width: 552, height: 368,
      columnWidths: [76,126,218,132], values });
    table.borders.assign({ fill: '#D4E1E0', width: 1, style: 'solid' });
    for (let row=0;row<values.length;row++) {
      for(let column=0;column<4;column++) {
        const cell=table.getCell(row,column);
        cell.fill=row===0 ? colors.navy : (row%2 ? colors.white : '#E7EFED');
        cell.text.style={fontFamily:font,fontSize:19,color:row===0?colors.white:colors.ink,bold:row===0};
      }
    }
  }
  text(slide, '* 100% = issue fechada. N/D = percentagem por confirmar pela equipa.\nA #4 ainda exige confirmar os artefactos de domínio. Referência: 21/11/2026', 64, 573, 1135, 73, 21, { color: colors.muted });
}
{
  const slide = base('As US extra reduzem riscos antes da aplicação', 10,
    'Justificação perante o cliente: #14 documenta decisões e o contexto, #15 trata proteção de menores e permissões, #16 permitirá testar as métricas antes do backend. Só #14 está fechada. #15 ainda está Ready e #16 continua adiada. Não apresentar o protótipo como já executado.',
    `${repo}/issues/14 ; ${repo}/issues/15 ; ${repo}/issues/16`);
  text(slide, 'A014 · Arquitetura', 64, 184, 1150, 62, 34, { bold: true, color: colors.teal });
  text(slide, 'ADR e modelo C4 registam as escolhas e os seus custos', 64, 254, 1135, 58, 28);
  text(slide, 'A015 · Privacidade e segurança', 64, 337, 1150, 62, 34, { bold: true, color: colors.teal });
  text(slide, 'Análise pendente de dados de menores, permissões e ameaças', 64, 407, 1135, 58, 28);
  text(slide, 'A016 · Dados sintéticos e métricas', 64, 490, 1150, 62, 34, { bold: true, color: colors.teal });
  text(slide, 'Trabalho adiado que permitirá validar o modelo e os indicadores', 64, 560, 1135, 62, 28);
}
{
  const slide = base('A entrega depende de revisão e consolidação', 11,
    'Explicar as dependências sem prometer datas não confirmadas. O README da Sprint A indica entrega em 28/11 e apresentação a confirmar, enquanto issues antigas e README principal têm outras datas. Confirmar com o docente. #13 é do João, não foi desenvolvida neste trabalho. Não criar tag de entrega nem submeter no Moodle antes da revisão da equipa.',
    `${repo}/issues/13 ; ${repo}/blob/main/sprints/SprintA/README.md`);
  columns(slide, 'Antes da review', 'Rever os PR de A005 e A009\nConfirmar o domínio de A004\nConsolidar o relatório A013\nAtualizar mapa, avaliação e ensaio',
    'Na Sprint B', 'Estudo de UI/UX\nEstrutura do frontend\nBase de dados e Docker\nOrganização interna do backend');
  text(slide, 'O relatório A013 continua aberto. A data da apresentação precisa de confirmação', 64, 590, 1135, 52, 23, { color: colors.muted });
}
{
  const slide = base('Balanço da sprint e autoavaliação', 12,
    'A equipa deve discutir o desempenho e atribuir a sua autoavaliação, com justificação de cada membro. Não foram inventadas notas. Pontos observáveis: documentação rastreável, BD validada em CI, regras de consentimento claras. Melhorias: alinhamento entre estado do quadro e artefactos, confirmação dos pressupostos e integração das entregas. Ensaio de 10 minutos ainda pendente. Declarar Claude e Codex e confirmar semáforos no enunciado.',
    `${repo}/blob/main/README.md ; ${repo}/issues/10 ; ${repo}/issues/13`);
  columns(slide, 'Evidências disponíveis', 'Requisitos com origem e IDs\nModelo relacional e dicionário\nCI e decisões de arquitetura\nPercurso e consentimento descritos',
    'Pontos a melhorar', 'Coerência entre estados e entregáveis\nValidação com o cliente\nRevisão e consolidação\nEnsaio e distribuição da fala');
  text(slide, 'Autoavaliação numérica e contributos individuais: a equipa ainda precisa de os validar', 64, 590, 1135, 54, 23, { color: colors.muted });
}

for (const [index, slide] of deck.slides.items.entries()) {
  const png = await deck.export({ slide, format: 'png', scale: 2 });
  await fs.writeFile(path.join(buildDir, `slide-${String(index+1).padStart(2,'0')}.png`), new Uint8Array(await png.arrayBuffer()));
}
await (await PresentationFile.exportPptx(deck)).save(path.join(buildDir, 'sprint-review-a-candidate.pptx'));
try {
  const pdf = await deck.export({ format: 'pdf' });
  await fs.writeFile(path.join(buildDir, 'sprint-review-a.pdf'), new Uint8Array(await pdf.arrayBuffer()));
} catch (error) {
  console.warn('A exportação PDF deste runtime não está disponível. Usar gerar-pdf.py sobre os PNG renderizados.');
}
await fs.writeFile(path.join(buildDir, 'presentation.json'), JSON.stringify(deck.toProto()));
console.log(`Criadas ${deck.slides.items.length} páginas. Guião: 600 segundos. Rascunho: ${buildDir}`);
