# Dicionário de dados (modelo relacional v1.1)

| | |
|---|---|
| User Story | US_A007 ([issue #7](https://github.com/escobar0304/ProjInter-2-1/issues/7)) |
| Versão | 1.1 (Sprint A) |
| Estado | Em revisão pela equipa |
| Modelo | [Modelo relacional](modelo-relacional.md) e [`database/schema.sql`](../../database/schema.sql) (US_A003) |

## 1. Âmbito

Este documento descreve cada tabela e cada coluna do modelo relacional v1.1. Os tipos, a obrigatoriedade, os valores por omissão, as chaves e as restrições correspondem ao `schema.sql`; as descrições e os exemplos explicam o significado de cada dado. Os nomes seguem o [glossário](../uml/glossario.md).

### Como ler

- **Tipo**: tipo do PostgreSQL. `timestamptz` é `timestamp with time zone` (data e hora guardadas em UTC).
- **Tamanho**: número máximo de caracteres (`varchar`) ou dígitos totais e decimais (`numeric`). «—» quando o tipo tem tamanho fixo.
- **Nulo?**: «Não» quando a coluna é obrigatória (`NOT NULL`).
- **Chave**: PK (chave primária) e FK → tabela.coluna (chave estrangeira). `ON DELETE CASCADE` indica que o registo é apagado com o registo referenciado.
- **Restrições**: `UNIQUE` e `CHECK` da coluna. As restrições que envolvem várias colunas estão por baixo da tabela.
- **Dados pessoais**: **DP** assinala um dado pessoal (RGPD). **DP-M** assinala um dado pessoal que identifica um menor ou que descreve o seu desempenho, e que exige cuidado acrescido (§C, RNF22). Ver a [secção 3](#3-dados-pessoais-e-dados-de-menores).

## 2. Tabelas

### Referência

#### `languages`

Idiomas dos conteúdos e da interface (RF31, RNF13). O português é obrigatório. Chave primária: `code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `code` | varchar | 5 | Não | — | PK | — | Código ISO 639-1 do idioma. | `pt` |
| `name` | varchar | 50 | Não | — | — | UNIQUE | Nome do idioma, na própria língua. | `Português` |

#### `genders`

Valores possíveis para o género do User. Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `name` | varchar | 30 | Não | — | — | UNIQUE | Código do género, traduzido na interface. | `female` |

#### `school_years`

Anos de escolaridade do público-alvo, do 7.º ao 12.º (glossário: School Year). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `year` | smallint | — | Não | — | — | UNIQUE<br>CHECK entre 7 e 12 | Ano de escolaridade. | `9` |

#### `account_statuses`

Estados possíveis de uma conta (glossário: Account Status, RF35). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `code` | varchar | 30 | Não | — | — | UNIQUE | Código do estado: `pending_verification`, `pending_consent`, `active`, `suspended` ou `deactivated`. | `active` |

#### `content_statuses`

Estados de publicação de qualquer conteúdo (glossário: Content Status, RF30). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `code` | varchar | 30 | Não | — | — | UNIQUE | Código do estado: `draft`, `published` ou `archived`. | `published` |

#### `resource_types`

Tipos de recurso formativo: workshop ou webinar (glossário: Resource Type). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `code` | varchar | 30 | Não | — | — | UNIQUE | Código do tipo: `workshop` ou `webinar`. | `webinar` |

### Conta e acesso

#### `roles`

Perfis de acesso (glossário: Role, RF33). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `code` | varchar | 30 | Não | — | — | UNIQUE | Código do Role, usado no código: `registered_user`, `manager` ou `administrator`. | `manager` |
| `name` | varchar | 50 | Não | — | — | — | Nome do Role, como aparece no backoffice. | `Manager` |

#### `permissions`

Operações autorizadas, verificadas no backend em todos os pedidos (RF34, RNF24). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | smallint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `code` | varchar | 50 | Não | — | — | UNIQUE | Código da permissão, verificado no backend. | `content.manage` |
| `description` | varchar | 255 | Não | — | — | — | Descrição da permissão para o Administrator. | `Gerir questionários, perguntas e opções de resposta` |

#### `role_permissions`

Permissões de cada Role (associação N:N). Chave primária: `role_id`, `permission_id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `role_id` | smallint | — | Não | — | PK<br>FK → roles.id (ON DELETE CASCADE) | — | Role que tem a permissão. | `2` |
| `permission_id` | smallint | — | Não | — | PK<br>FK → permissions.id (ON DELETE CASCADE) | — | Permissão atribuída ao Role. | `1` |

#### `users`

Pessoas com conta na plataforma, de qualquer Role (glossário: User). Inclui menores. Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `name` | varchar | 100 | Não | — | — | — | **DP** Nome do User. | `Ana Silva` |
| `email` | varchar | 254 | Não | — | — | UNIQUE | **DP** Email, usado para iniciar sessão. Único. | `ana.silva@exemplo.pt` |
| `password_hash` | varchar | 255 | Não | — | — | — | **DP** Hash da palavra-passe (bcrypt ou Argon2). Nunca se guarda a palavra-passe em claro (RNF23). | `$2b$12$...` |
| `birth_date` | date | — | Não | — | — | CHECK ≤ data atual | **DP-M** Data de nascimento. Determina se o User é Minor (menos de 18 anos, D02). | `2011-05-14` |
| `gender_id` | smallint | — | Sim | — | FK → genders.id | — | **DP** Género do User. Opcional. | `1` |
| `school_year_id` | smallint | — | Sim | — | FK → school_years.id | — | **DP-M** Ano de escolaridade. Usado para comparar grupos (RF39, RF41). | `3` (9.º ano) |
| `photo_url` | varchar | 500 | Sim | — | — | — | **DP** Endereço da fotografia de perfil. Opcional. | `/uploads/users/42.jpg` |
| `preferred_language` | varchar | 5 | Não | `'pt'` | FK → languages.code | — | Idioma da interface escolhido pelo User (RNF05). | `pt` |
| `role_id` | smallint | — | Não | — | FK → roles.id | — | Role do User (RF33). | `1` |
| `account_status_id` | smallint | — | Não | — | FK → account_statuses.id | — | Estado da conta. Só uma conta `active` inicia sessão. | `3` |
| `status_changed_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última mudança de estado da conta. Conta os prazos de eliminação (RNF22). | `2026-11-17 18:30:00+00` |
| `privacy_accepted_at` | timestamptz | — | Sim | — | — | — | Data e hora em que o User aceitou a política de privacidade (RNF22). | `2026-11-17 18:25:12+00` |
| `email_verified_at` | timestamptz | — | Sim | — | — | — | Data e hora da verificação do email (RF02). Vazia enquanto não for verificado. | `2026-11-17 18:40:03+00` |
| `last_login_at` | timestamptz | — | Sim | — | — | — | **DP** Data e hora do último início de sessão. Define os Users ativos (D06). | `2026-11-20 09:12:44+00` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `user_tokens`

Links de uso único enviados por email: verificação do email (RF02) e recuperação da palavra-passe (RF06). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `user_id` | bigint | — | Não | — | FK → users.id (ON DELETE CASCADE) | — | User a quem o link foi enviado. | `42` |
| `purpose` | varchar | 30 | Não | — | — | CHECK: `email_verification`, `password_reset` | Finalidade do link. | `email_verification` |
| `token_hash` | varchar | 255 | Não | — | — | UNIQUE | Hash do token enviado no link. O token em claro só existe no email. | `9f86d081884c7d65...` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `expires_at` | timestamptz | — | Não | — | — | — | Data e hora a partir da qual o link deixa de ser válido. | `2026-11-18 18:25:12+00` |
| `used_at` | timestamptz | — | Sim | — | — | — | Data e hora em que o link foi usado. Um link usado não volta a ser aceite. | `2026-11-17 18:40:03+00` |

Restrições da tabela:

- `expires_at` > `created_at`

#### `parental_consents`

Pedidos de consentimento ao encarregado de educação de um Minor e respetiva decisão (RF03, RF04, RF45). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `user_id` | bigint | — | Não | — | FK → users.id (ON DELETE CASCADE) | — | **DP-M** Minor a que o pedido diz respeito. | `42` |
| `guardian_email` | varchar | 254 | Não | — | — | — | **DP** Email do encarregado de educação (dado pessoal de um terceiro, que não tem conta, D11). | `pai.silva@exemplo.pt` |
| `token_hash` | varchar | 255 | Não | — | — | UNIQUE | Hash do token do link enviado ao encarregado de educação para decidir (UC05). Expira. | `2c26b46b68ffc68f...` |
| `revocation_token_hash` | varchar | 255 | Sim | — | — | UNIQUE | Hash do token do link de revogação (UC06), criado quando o pedido é aceite. | `fcde2b2edba56bf4...` |
| `status` | varchar | 20 | Não | `'pending'` | — | CHECK: `pending`, `accepted`, `refused`, `revoked`, `expired`<br>Um só pedido `pending` ou `accepted` por User (índice único parcial `parental_consents_one_open`) | Estado do pedido. | `accepted` |
| `requested_at` | timestamptz | — | Não | `now()` | — | — | Data e hora do pedido. | `2026-11-17 18:25:12+00` |
| `expires_at` | timestamptz | — | Não | — | — | — | Data e hora limite para o encarregado de educação decidir. | `2026-11-24 18:25:12+00` |
| `decided_at` | timestamptz | — | Sim | — | — | — | Data e hora da decisão (aceite ou recusa), exigida pelo RF04. | `2026-11-18 20:02:51+00` |
| `revoked_at` | timestamptz | — | Sim | — | — | — | Data e hora da revogação (RF45). | — |

Restrições da tabela:

- `expires_at` > `requested_at`
- `decided_at` vazia se e só se `status` = `pending` (exceto `expired`)
- `revoked_at` preenchida se e só se `status` = `revoked`
- `revocation_token_hash` preenchido quando `status` é `accepted` ou `revoked`

### Formação

#### `health_areas`

Temas de saúde que agrupam recursos e conteúdos (glossário: Health Area). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `icon_url` | varchar | 500 | Sim | — | — | — | Ícone da área na página pública. | `/img/icons/nutricao.svg` |
| `image_url` | varchar | 500 | Sim | — | — | — | Imagem de destaque da área. | `/img/areas/nutricao.jpg` |
| `video_url` | varchar | 500 | Sim | — | — | — | Vídeo de apresentação da área. Opcional. | `https://videos.exemplo.pt/nutricao` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `health_area_translations`

Textos de cada Health Area em cada idioma. Chave primária: `health_area_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `health_area_id` | bigint | — | Não | — | PK<br>FK → health_areas.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 150 | Não | — | — | — | Título da área. | `Nutrição` |
| `subtitle` | varchar | 255 | Sim | — | — | — | Subtítulo da área. Opcional. | `Comer bem para crescer` |
| `description` | text | — | Sim | — | — | — | Texto da página informativa da área (RF08). | `A alimentação equilibrada...` |

#### `training_resources`

Workshops e webinars (glossário: Training Resource). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `health_area_id` | bigint | — | Não | — | FK → health_areas.id | — | Health Area do recurso. | `1` |
| `resource_type_id` | smallint | — | Não | — | FK → resource_types.id | — | Tipo do recurso. | `2` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |
| `video_url` | varchar | 500 | Sim | — | — | — | Recording do recurso, quando não está organizado em Levels. | `https://videos.exemplo.pt/webinar-12` |
| `image_url` | varchar | 500 | Sim | — | — | — | Imagem do recurso na pesquisa. | `/img/recursos/12.jpg` |
| `badge_image_url` | varchar | 500 | Sim | — | — | — | Imagem do Badge atribuído por este recurso (D09). | `/img/badges/12.svg` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `training_resource_translations`

Textos de cada Training Resource em cada idioma. Chave primária: `training_resource_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `training_resource_id` | bigint | — | Não | — | PK<br>FK → training_resources.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `name` | varchar | 150 | Não | — | — | — | Nome do recurso. | `Saúde mental na adolescência` |
| `description` | text | — | Sim | — | — | — | Descrição do recurso. | `Webinar sobre ansiedade...` |

#### `levels`

Partes sequenciais de um Training Resource (glossário: Level, RF17). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `training_resource_id` | bigint | — | Não | — | FK → training_resources.id (ON DELETE CASCADE) | — | Recurso a que o Level pertence. | `12` |
| `position` | smallint | — | Não | — | — | CHECK ≥ 1 | Ordem do Level no recurso, a começar em 1. Única por recurso. | `2` |
| `video_url` | varchar | 500 | Sim | — | — | — | Recording do Level. | `https://videos.exemplo.pt/webinar-12/2` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |

Restrições da tabela:

- `UNIQUE (training_resource_id, position)`

#### `level_translations`

Textos de cada Level em cada idioma. Chave primária: `level_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `level_id` | bigint | — | Não | — | PK<br>FK → levels.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 150 | Não | — | — | — | Título do Level. | `Gerir a ansiedade` |
| `description` | text | — | Sim | — | — | — | Descrição do Level. | `Técnicas de respiração...` |

#### `support_materials`

Ficheiros de apoio de um recurso ou de um Level (glossário: Support Material, RF16). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `training_resource_id` | bigint | — | Não | — | FK → training_resources.id (ON DELETE CASCADE) | — | Recurso a que o material pertence. | `12` |
| `level_id` | bigint | — | Sim | — | FK → levels.id (ON DELETE CASCADE) | — | Level a que o material pertence. Vazio se for do recurso inteiro. | `34` |
| `language_code` | varchar | 5 | Não | — | FK → languages.code | — | Idioma do ficheiro. | `pt` |
| `title` | varchar | 150 | Não | — | — | — | Título do material. | `Guia de apoio (PDF)` |
| `file_url` | varchar | 500 | Não | — | — | — | Endereço do ficheiro. | `/materiais/12/guia.pdf` |

#### `enrollments`

Inscrição de um User num Training Resource (glossário: Enrollment, RF14, RF15). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `user_id` | bigint | — | Não | — | FK → users.id (ON DELETE CASCADE) | — | **DP-M** User inscrito. | `42` |
| `training_resource_id` | bigint | — | Não | — | FK → training_resources.id | — | Recurso em que o User está inscrito. | `12` |
| `status` | varchar | 20 | Não | `'not_started'` | — | CHECK: `not_started`, `in_progress`, `completed` | Estado da inscrição (RF15). | `in_progress` |
| `is_favorite` | boolean | — | Não | `false` | — | — | Indica se o User marcou o recurso como favorito (v1.0). | `false` |
| `enrolled_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da inscrição. | `2026-11-17 19:00:00+00` |
| `content_accessed_at` | timestamptz | — | Sim | — | — | — | Num recurso sem Levels, data e hora em que o User viu o conteúdo pela primeira vez. É condição para responder ao Final (RF20). Nos recursos com Levels, o progresso fica em `level_progress`. | `2026-11-18 20:10:00+00` |
| `completed_at` | timestamptz | — | Sim | — | — | — | Data e hora da conclusão: submissão do Final, seja qual for o Score. | — |

Restrições da tabela:

- `UNIQUE (user_id, training_resource_id)`
- `UNIQUE (id, training_resource_id)`: alvo da chave estrangeira composta de `attempts`
- `completed_at` preenchida se e só se `status` = `completed`

#### `level_progress`

Progresso de uma inscrição em cada Level (RF17). Chave primária: `enrollment_id`, `level_id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `enrollment_id` | bigint | — | Não | — | PK<br>FK → enrollments.id (ON DELETE CASCADE) | — | Inscrição a que o progresso diz respeito. | `7` |
| `level_id` | bigint | — | Não | — | PK<br>FK → levels.id (ON DELETE CASCADE) | — | Level em causa. | `34` |
| `progress` | smallint | — | Não | `0` | — | CHECK entre 0 e 100 | Percentagem do Level visualizada (0 a 100). | `60` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última atualização do progresso. | `2026-11-18 21:15:00+00` |

### Questionários

#### `questionnaires`

Questionário de diagnóstico ou final de um recurso (glossário: Questionnaire, RF29). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `training_resource_id` | bigint | — | Não | — | FK → training_resources.id (ON DELETE CASCADE) | — | Recurso a que o questionário pertence. | `12` |
| `type` | varchar | 20 | Não | — | — | CHECK: `diagnostic`, `final` | Tipo: diagnóstico (antes do conteúdo) ou final (depois). Um de cada por recurso. | `diagnostic` |
| `max_attempts` | smallint | — | Não | `2` | — | CHECK ≥ 1 | Número máximo de Attempts (D01, D04). | `2` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |

Restrições da tabela:

- `UNIQUE (training_resource_id, type)`
- `UNIQUE (id, training_resource_id)`: alvo da chave estrangeira composta de `attempts`

#### `questionnaire_translations`

Textos de cada Questionnaire em cada idioma. Chave primária: `questionnaire_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `questionnaire_id` | bigint | — | Não | — | PK<br>FK → questionnaires.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 150 | Não | — | — | — | Título do questionário. | `Diagnóstico: saúde mental` |
| `description` | text | — | Sim | — | — | — | Instruções para o User. | `Responde a 10 perguntas...` |

#### `questions`

Perguntas de um Questionnaire (glossário: Question). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `questionnaire_id` | bigint | — | Não | — | FK → questionnaires.id (ON DELETE CASCADE) | — | Questionário a que a pergunta pertence. | `5` |
| `position` | smallint | — | Não | — | — | CHECK ≥ 1 | Ordem da pergunta, a começar em 1. Única por questionário. | `3` |

Restrições da tabela:

- `UNIQUE (questionnaire_id, position)`

#### `question_translations`

Enunciado de cada Question em cada idioma. Chave primária: `question_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `question_id` | bigint | — | Não | — | PK<br>FK → questions.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `statement` | text | — | Não | — | — | — | Enunciado da pergunta. | `Qual destes é um sinal de ansiedade?` |

#### `answer_options`

Alternativas de cada Question, uma delas correta (glossário: Answer Option). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `question_id` | bigint | — | Não | — | FK → questions.id (ON DELETE CASCADE) | — | Pergunta a que a opção pertence. | `51` |
| `position` | smallint | — | Não | — | — | CHECK ≥ 1 | Ordem da opção, a começar em 1. Única por pergunta. | `2` |
| `is_correct` | boolean | — | Não | `false` | — | No máximo uma opção com `true` por pergunta (índice único parcial `answer_options_one_correct`) | Indica se é a resposta correta. | `true` |

Restrições da tabela:

- `UNIQUE (question_id, position)`
- `UNIQUE (id, question_id)`: alvo da chave estrangeira composta de `attempt_answers`

#### `answer_option_translations`

Texto de cada Answer Option em cada idioma. Chave primária: `answer_option_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `answer_option_id` | bigint | — | Não | — | PK<br>FK → answer_options.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `text` | varchar | 500 | Não | — | — | — | Texto da opção. | `Coração acelerado` |

#### `attempts`

Cada submissão completa de um Questionnaire (glossário: Attempt, RF19, RF21). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `enrollment_id` | bigint | — | Não | — | FK composta (enrollment_id, training_resource_id) → enrollments(id, training_resource_id) (ON DELETE CASCADE) | — | **DP-M** Inscrição de quem respondeu (identifica o User). | `7` |
| `questionnaire_id` | bigint | — | Não | — | FK composta (questionnaire_id, training_resource_id) → questionnaires(id, training_resource_id) | — | Questionário respondido. | `5` |
| `training_resource_id` | bigint | — | Não | — | FK composta → enrollments(id, training_resource_id)<br>FK composta → questionnaires(id, training_resource_id) | — | Recurso da inscrição e do questionário. Repete um valor que já existe noutras tabelas, para as duas chaves compostas garantirem que o questionário é do recurso em que o User está inscrito. | `12` |
| `attempt_number` | smallint | — | Não | — | — | CHECK ≥ 1 | Número da tentativa, a começar em 1. Único por inscrição e questionário. | `1` |
| `score` | numeric | 5,2 | Não | — | — | CHECK entre 0 e 100 | **DP-M** Score em percentagem de respostas corretas, calculado no servidor (RF21). | `70.00` |
| `submitted_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da submissão. | `2026-11-18 21:30:00+00` |

Restrições da tabela:

- `UNIQUE (enrollment_id, questionnaire_id, attempt_number)`
- `FOREIGN KEY (enrollment_id, training_resource_id) REFERENCES enrollments (id, training_resource_id) ON DELETE CASCADE`
- `FOREIGN KEY (questionnaire_id, training_resource_id) REFERENCES questionnaires (id, training_resource_id)`

#### `attempt_answers`

Opção escolhida em cada Question de uma Attempt (glossário: Answer, RF21, RF40). Chave primária: `attempt_id`, `question_id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `attempt_id` | bigint | — | Não | — | PK<br>FK → attempts.id (ON DELETE CASCADE) | — | Tentativa a que a resposta pertence. | `88` |
| `question_id` | bigint | — | Não | — | PK<br>FK → questions.id<br>FK composta (answer_option_id, question_id) → answer_options(id, question_id) | — | Pergunta respondida. | `51` |
| `answer_option_id` | bigint | — | Não | — | FK composta (answer_option_id, question_id) → answer_options(id, question_id) | — | Opção escolhida. Tem de pertencer à pergunta respondida. | `204` |

### Gamificação

#### `badges`

Badge atribuído a uma inscrição (glossário: Badge, RF23, RF24). Chave primária: `enrollment_id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `enrollment_id` | bigint | — | Não | — | PK<br>FK → enrollments.id (ON DELETE CASCADE) | — | Inscrição premiada. Um Badge por inscrição. | `7` |
| `attempt_id` | bigint | — | Não | — | FK → attempts.id | UNIQUE | Attempt do Final que deu origem ao Badge (Score ≥ 85%). | `91` |
| `awarded_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da atribuição. | `2026-11-19 10:05:00+00` |

#### `certificates`

Certificado emitido a uma inscrição (glossário: Certificate, RF23, RF25). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `enrollment_id` | bigint | — | Não | — | FK → enrollments.id (ON DELETE CASCADE) | UNIQUE | Inscrição certificada. Um Certificate por inscrição. | `7` |
| `attempt_id` | bigint | — | Não | — | FK → attempts.id | UNIQUE | Attempt do Final que deu origem ao Certificate. | `91` |
| `verification_code` | varchar | 40 | Não | — | — | UNIQUE | Código impresso no PDF para verificar a autenticidade. | `LSJ-2026-7F3K9Q` |
| `issued_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da emissão. | `2026-11-19 10:05:00+00` |

### Biblioteca virtual

#### `categories`

Tipos de Publication (glossário: Category). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |

#### `category_translations`

Nome de cada Category em cada idioma. Chave primária: `category_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `category_id` | bigint | — | Não | — | PK<br>FK → categories.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `name` | varchar | 80 | Não | — | — | — | Nome da categoria. | `Guia` |

#### `publications`

Documentos informativos da biblioteca (glossário: Publication). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `health_area_id` | bigint | — | Não | — | FK → health_areas.id | — | Health Area da publicação. | `1` |
| `category_id` | bigint | — | Não | — | FK → categories.id | — | Categoria da publicação. | `2` |
| `author` | varchar | 150 | Não | — | — | — | Autor da publicação. | `Direção-Geral da Saúde` |
| `url` | varchar | 500 | Não | — | — | — | Endereço do documento. | `https://www.exemplo.pt/guia.pdf` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `publication_translations`

Textos de cada Publication em cada idioma. Chave primária: `publication_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `publication_id` | bigint | — | Não | — | PK<br>FK → publications.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 200 | Não | — | — | — | Título da publicação. | `Guia da alimentação saudável` |
| `description` | text | — | Sim | — | — | — | Resumo da publicação. | `Recomendações para...` |

#### `news_items`

Notícias (glossário: News Item). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `health_area_id` | bigint | — | Sim | — | FK → health_areas.id | — | Health Area da notícia. Opcional. | `1` |
| `author` | varchar | 150 | Não | — | — | — | Autor da notícia. | `Equipa do projeto` |
| `news_date` | date | — | Não | — | — | — | Data da notícia. | `2026-11-16` |
| `image_url` | varchar | 500 | Sim | — | — | — | Imagem da notícia. Opcional. | `/img/noticias/15.jpg` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `news_item_translations`

Textos de cada News Item em cada idioma. Chave primária: `news_item_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `news_item_id` | bigint | — | Não | — | PK<br>FK → news_items.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 200 | Não | — | — | — | Título da notícia. | `Novo webinar sobre sono` |
| `body` | text | — | Não | — | — | — | Texto da notícia. | `No dia 25 de novembro...` |

#### `activities`

Acontecimentos da Agenda (glossário: Activity). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `health_area_id` | bigint | — | Sim | — | FK → health_areas.id | — | Health Area da atividade. Opcional. | `3` |
| `starts_at` | timestamptz | — | Não | — | — | — | Data e hora de início da atividade. | `2026-11-25 17:00:00+00` |
| `url` | varchar | 500 | Sim | — | — | — | Link da atividade. Opcional. | `https://www.exemplo.pt/evento` |
| `content_status_id` | smallint | — | Não | — | FK → content_statuses.id | — | Estado de publicação. Só os conteúdos `published` aparecem no frontoffice (RF30). | `2` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |
| `updated_at` | timestamptz | — | Não | `now()` | — | — | Data e hora da última alteração do registo. | `2026-11-17 18:25:12+00` |

#### `activity_translations`

Textos de cada Activity em cada idioma. Chave primária: `activity_id`, `language_code`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `activity_id` | bigint | — | Não | — | PK<br>FK → activities.id (ON DELETE CASCADE) | — | Registo traduzido. | `1` |
| `language_code` | varchar | 5 | Não | — | PK<br>FK → languages.code | — | Idioma do texto. O português é obrigatório; o inglês é opcional (D08). | `en` |
| `title` | varchar | 200 | Não | — | — | — | Título da atividade. | `Sessão sobre higiene do sono` |
| `description` | text | — | Sim | — | — | — | Descrição da atividade. | `Sessão aberta a...` |

#### `weekly_highlights`

Conteúdos escolhidos pelo Manager para a página inicial durante um período (glossário: Weekly Highlight, RF10, D10). Chave primária: `id`.

| Coluna | Tipo | Tamanho | Nulo? | Valor por omissão | Chave | Restrições | Descrição | Exemplo |
|---|---|---|---|---|---|---|---|---|
| `id` | bigint | — | Não | gerado (identity) | PK | — | Identificador gerado pela base de dados. | `1` |
| `start_date` | date | — | Não | — | — | — | Primeiro dia em destaque. | `2026-11-16` |
| `end_date` | date | — | Não | — | — | — | Último dia em destaque. | `2026-11-22` |
| `position` | smallint | — | Não | `1` | — | CHECK ≥ 1 | Ordem na página inicial, a começar em 1. | `1` |
| `training_resource_id` | bigint | — | Sim | — | FK → training_resources.id (ON DELETE CASCADE) | — | Recurso em destaque (ou vazio). | `12` |
| `publication_id` | bigint | — | Sim | — | FK → publications.id (ON DELETE CASCADE) | — | Publicação em destaque (ou vazio). | — |
| `news_item_id` | bigint | — | Sim | — | FK → news_items.id (ON DELETE CASCADE) | — | Notícia em destaque (ou vazio). | — |
| `activity_id` | bigint | — | Sim | — | FK → activities.id (ON DELETE CASCADE) | — | Atividade em destaque (ou vazio). | — |
| `created_by` | bigint | — | Sim | — | FK → users.id (ON DELETE SET NULL) | — | Manager que criou o destaque. Fica vazio se a conta for eliminada. | `3` |
| `created_at` | timestamptz | — | Não | `now()` | — | — | Data e hora de criação do registo. | `2026-11-17 18:25:12+00` |

Restrições da tabela:

- `end_date` ≥ `start_date`
- Exatamente uma das colunas `training_resource_id`, `publication_id`, `news_item_id`, `activity_id` preenchida

## 3. Dados pessoais e dados de menores

A plataforma destina-se a jovens do 3.º ciclo e do ensino secundário, por isso muitos Users são menores. A especificação (§C) pede atenção especial a estes dados (RNF22).

| Tabela | Colunas | Titular | Notas |
|---|---|---|---|
| `users` | `name`, `email`, `password_hash`, `birth_date`, `gender_id`, `school_year_id`, `photo_url`, `last_login_at` | User (pode ser menor) | `birth_date` determina se o User é Minor (D02). `password_hash` guarda só o hash (RNF23). `gender_id` e `photo_url` são opcionais (minimização). |
| `parental_consents` | `user_id`, `guardian_email` | Minor e encarregado de educação | O encarregado de educação não tem conta (D11); o email serve só para o pedido de consentimento. Os tokens guardam-se como hash. |
| `enrollments`, `level_progress` | Todas, através de `user_id` | User | Revelam os temas de saúde em que o User tem interesse. |
| `attempts`, `attempt_answers`, `badges`, `certificates` | Todas, através de `enrollment_id` | User | Desempenho do User. Os indicadores (RF36 a RF44) usam valores agregados; o conteúdo da exportação em CSV (RF44) fica definido na US_A015. |
| `user_tokens` | `user_id` | User | Tokens guardados como hash, com validade e uso único. |
| `weekly_highlights` | `created_by` | Manager | Fica vazio se a conta do Manager for eliminada. |

Regras que decorrem destes dados (detalhadas na US_A015):

- A conta de um Minor só fica ativa depois do consentimento aceite (RF03, RF04).
- Os registos não concluídos e as contas com consentimento recusado são eliminados ao fim do prazo, contado a partir de `users.status_changed_at`.
- O pedido de eliminação de um User (RF46) apaga em cascata as inscrições, as tentativas, as respostas, os badges, os certificados, os tokens e os pedidos de consentimento.

## 4. Dados de referência

O `schema.sql` cria os valores iniciais das tabelas de referência:

| Tabela | Valores |
|---|---|
| `languages` | `pt` (Português), `en` (English) |
| `genders` | `female`, `male`, `other`, `prefer_not_to_say` |
| `school_years` | 7, 8, 9, 10, 11, 12 |
| `account_statuses` | `pending_verification`, `pending_consent`, `active`, `suspended`, `deactivated` |
| `content_statuses` | `draft`, `published`, `archived` |
| `resource_types` | `workshop`, `webinar` |
| `roles` | `registered_user`, `manager`, `administrator` |
| `permissions` | `content.manage`, `questionnaire.manage`, `indicator.view`, `result.export`, `user.manage`, `role.manage` |
| `role_permissions` | Manager: `content.manage`, `questionnaire.manage`, `indicator.view`, `result.export`. Administrator: todas. |
