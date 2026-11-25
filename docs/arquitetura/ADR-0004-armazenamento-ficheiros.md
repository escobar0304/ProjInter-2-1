# ADR-0004: Ficheiros multimédia num volume, servidos com verificação de acesso

| | |
|---|---|
| Estado | Aceite |
| Data | Sprint A (novembro de 2026) |
| Requisitos | RF12, RF16, RF25, RF26, RNF10, RNF22 |

## Contexto

A plataforma guarda três tipos de ficheiros:

- **imagens** públicas: ícones e imagens das áreas de saúde, dos recursos, das notícias e dos badges;
- **documentos** (sobretudo PDF): materiais de apoio e certificados;
- **vídeos**: as gravações dos recursos e dos níveis (§D.1). Não há transmissão em direto (W01).

As gravações e os materiais de apoio só podem ser vistos por quem está inscrito no recurso e já respondeu ao diagnóstico (RF12, RF16). Os utilizadores são, na maioria, menores (RNF22). O modelo de dados (US_A003) guarda o endereço de cada ficheiro em colunas `*_url` (ex.: `support_materials.file_url`).

## Decisão

Guardar os ficheiros num **volume do servidor**, fora da base de dados e fora da pasta pública, organizado por tipo (ex.: `uploads/images/`, `uploads/materials/`, `uploads/videos/`, `uploads/certificates/`):

- a base de dados guarda só o caminho relativo do ficheiro;
- as **imagens públicas** são servidas diretamente pelo servidor web (Nginx);
- os **ficheiros reservados** (gravações, materiais de apoio e certificados) são pedidos à API. O backend verifica a sessão, a inscrição e o diagnóstico e, se o acesso for permitido, pede ao Nginx que envie o ficheiro (cabeçalho `X-Accel-Redirect`). O Nginx suporta pedidos parciais (`Range`), por isso os vídeos podem avançar e recuar sem descarregar o ficheiro inteiro;
- o Manager carrega os ficheiros no backoffice (RF26). O backend valida o tipo e o tamanho máximo antes de os guardar.

## Alternativas consideradas

| Alternativa | Vantagens | Porque não foi escolhida |
|---|---|---|
| Ficheiros dentro da base de dados (`bytea`) | Um só sítio para as cópias de segurança | A base de dados cresce muito com os vídeos, as cópias ficam lentas e cada vídeo passa pelo backend. |
| Armazenamento de objetos (ex.: Amazon S3 ou MinIO) | Escala bem; links temporários assinados | Mais um serviço para configurar e manter; o volume previsto de ficheiros não o justifica. Pode ser um ADR futuro se a plataforma crescer. |
| Vídeos numa plataforma externa (ex.: YouTube, Vimeo) | Sem custos de armazenamento e de largura de banda | Um link não listado pode ser partilhado com quem não está inscrito (RF16); as plataformas recolhem dados de navegação de menores (RNF22); a disponibilidade fica nas mãos de terceiros. |

## Consequências

- O controlo de acesso aos ficheiros reservados fica no backend, como o resto das regras (RNF24), e o Nginx trata do envio eficiente dos ficheiros grandes (RNF10).
- As cópias de segurança (RNF09) têm de incluir o volume dos ficheiros, além da base de dados.
- O espaço em disco do servidor limita o número e o tamanho dos vídeos. A equipa define um tamanho máximo por ficheiro na Sprint B.
- Apagar um registo na base de dados não apaga o ficheiro: o backend tem de o remover também.
