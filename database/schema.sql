-- =============================================================================
-- Plataforma de Literacia em Saúde para Jovens
-- Modelo relacional v1.1 (US_A003), PostgreSQL 16 ou superior
--
-- Os nomes seguem o glossário (docs/uml/glossario.md). As regras que a base de
-- dados não consegue garantir sozinha estão em docs/base-de-dados/modelo-relacional.md.
-- O CI cria uma base de dados vazia a partir deste ficheiro em cada Pull Request.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Tabelas de referência
-- -----------------------------------------------------------------------------

-- Idiomas dos conteúdos (RF31, RNF13). O português é obrigatório.
CREATE TABLE languages (
    code varchar(5)  PRIMARY KEY,
    name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE genders (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE
);

-- Do 7.º ao 12.º ano (glossário: School Year).
CREATE TABLE school_years (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    year smallint NOT NULL UNIQUE CHECK (year BETWEEN 7 AND 12)
);

-- pending_verification, pending_consent, active, suspended, deactivated (RF35).
CREATE TABLE account_statuses (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code varchar(30) NOT NULL UNIQUE
);

-- draft, published, archived (RF30). Substitui resourcestates e qastates da v1.0.
CREATE TABLE content_statuses (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code varchar(30) NOT NULL UNIQUE
);

-- -----------------------------------------------------------------------------
-- 2. Conta e acesso
-- -----------------------------------------------------------------------------

-- registered_user, manager, administrator (RF33).
CREATE TABLE roles (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code varchar(30) NOT NULL UNIQUE,
    name varchar(50) NOT NULL
);

-- Operações autorizadas, verificadas no backend em todos os pedidos (RF34, RNF24).
CREATE TABLE permissions (
    id          smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code        varchar(50)  NOT NULL UNIQUE,
    description varchar(255) NOT NULL
);

CREATE TABLE role_permissions (
    role_id       smallint NOT NULL REFERENCES roles (id) ON DELETE CASCADE,
    permission_id smallint NOT NULL REFERENCES permissions (id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Cada User tem um só Role (RF33), por isso role_user da v1.0 deixa de existir.
CREATE TABLE users (
    id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name               varchar(100) NOT NULL,
    email              varchar(254) NOT NULL UNIQUE,
    password_hash      varchar(255) NOT NULL,                     -- bcrypt ou Argon2 (RNF23)
    birth_date         date         NOT NULL,
    gender_id          smallint     REFERENCES genders (id),
    school_year_id     smallint     REFERENCES school_years (id),
    photo_url          varchar(500),
    preferred_language varchar(5)   NOT NULL DEFAULT 'pt' REFERENCES languages (code),
    role_id            smallint     NOT NULL REFERENCES roles (id),
    account_status_id  smallint     NOT NULL REFERENCES account_statuses (id),
    status_changed_at  timestamptz  NOT NULL DEFAULT now(),       -- prazos de eliminação (RNF22)
    privacy_accepted_at timestamptz,                              -- aceitação da política de privacidade (RNF22)
    email_verified_at  timestamptz,
    last_login_at      timestamptz,                               -- User ativo: últimos 30 dias (D06)
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now(),
    CHECK (birth_date <= CURRENT_DATE)
);

-- Links de uso único enviados por email: verificação do email (RF02) e
-- recuperação da palavra-passe (RF06). Guarda-se só o hash do token.
CREATE TABLE user_tokens (
    id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id    bigint       NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    purpose    varchar(30)  NOT NULL CHECK (purpose IN ('email_verification', 'password_reset')),
    token_hash varchar(255) NOT NULL UNIQUE,
    created_at timestamptz  NOT NULL DEFAULT now(),
    expires_at timestamptz  NOT NULL,
    used_at    timestamptz,
    CHECK (expires_at > created_at)
);

-- Pedido de consentimento ao Guardian de um Minor (RF03, RF04, RF45).
-- Substitui users.parental_consent da v1.0. O Guardian não tem conta (D11).
CREATE TABLE parental_consents (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        bigint       NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guardian_email varchar(254) NOT NULL,
    token_hash     varchar(255) NOT NULL UNIQUE,                  -- link do pedido (UC05), expira
    revocation_token_hash varchar(255) UNIQUE,                    -- link de revogação (UC06), criado ao aceitar
    status         varchar(20)  NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending', 'accepted', 'refused', 'revoked', 'expired')),
    requested_at   timestamptz  NOT NULL DEFAULT now(),
    expires_at     timestamptz  NOT NULL,
    decided_at     timestamptz,
    revoked_at     timestamptz,
    CHECK (expires_at > requested_at),
    CHECK ((status = 'pending') = (decided_at IS NULL) OR status = 'expired'),
    CHECK ((status = 'revoked') = (revoked_at IS NOT NULL)),
    CHECK (status NOT IN ('accepted', 'revoked') OR revocation_token_hash IS NOT NULL)
);

-- Só pode haver um pedido pendente ou aceite de cada vez por User.
CREATE UNIQUE INDEX parental_consents_one_open
    ON parental_consents (user_id) WHERE status IN ('pending', 'accepted');

-- -----------------------------------------------------------------------------
-- 3. Formação
-- -----------------------------------------------------------------------------

CREATE TABLE health_areas (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    icon_url          varchar(500),
    image_url         varchar(500),
    video_url         varchar(500),
    content_status_id smallint    NOT NULL REFERENCES content_statuses (id),
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE health_area_translations (
    health_area_id bigint       NOT NULL REFERENCES health_areas (id) ON DELETE CASCADE,
    language_code  varchar(5)   NOT NULL REFERENCES languages (code),
    title          varchar(150) NOT NULL,
    subtitle       varchar(255),
    description    text,
    PRIMARY KEY (health_area_id, language_code)
);

-- workshop, webinar (glossário: Resource Type).
CREATE TABLE resource_types (
    id   smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code varchar(30) NOT NULL UNIQUE
);

CREATE TABLE training_resources (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    health_area_id    bigint      NOT NULL REFERENCES health_areas (id),
    resource_type_id  smallint    NOT NULL REFERENCES resource_types (id),
    content_status_id smallint    NOT NULL REFERENCES content_statuses (id),
    video_url         varchar(500),                               -- Recording do recurso sem Levels
    image_url         varchar(500),
    badge_image_url   varchar(500),                               -- um Badge por recurso (D09)
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE training_resource_translations (
    training_resource_id bigint       NOT NULL REFERENCES training_resources (id) ON DELETE CASCADE,
    language_code        varchar(5)   NOT NULL REFERENCES languages (code),
    name                 varchar(150) NOT NULL,
    description          text,
    PRIMARY KEY (training_resource_id, language_code)
);

CREATE TABLE levels (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    training_resource_id bigint      NOT NULL REFERENCES training_resources (id) ON DELETE CASCADE,
    position             smallint    NOT NULL CHECK (position >= 1),
    video_url            varchar(500),
    content_status_id    smallint    NOT NULL REFERENCES content_statuses (id),
    UNIQUE (training_resource_id, position)
);

CREATE TABLE level_translations (
    level_id      bigint       NOT NULL REFERENCES levels (id) ON DELETE CASCADE,
    language_code varchar(5)   NOT NULL REFERENCES languages (code),
    title         varchar(150) NOT NULL,
    description   text,
    PRIMARY KEY (level_id, language_code)
);

-- Ficheiros de apoio de um recurso ou de um dos seus Levels (RF16).
-- Substitui resourcelevels.pdf_url da v1.0, que só permitia um ficheiro.
CREATE TABLE support_materials (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    training_resource_id bigint       NOT NULL REFERENCES training_resources (id) ON DELETE CASCADE,
    level_id             bigint       REFERENCES levels (id) ON DELETE CASCADE,
    language_code        varchar(5)   NOT NULL REFERENCES languages (code),
    title                varchar(150) NOT NULL,
    file_url             varchar(500) NOT NULL
);

-- Inscrição de um User num recurso (RF14, RF15). Substitui resource_user.
CREATE TABLE enrollments (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id              bigint      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    training_resource_id bigint      NOT NULL REFERENCES training_resources (id),
    status               varchar(20) NOT NULL DEFAULT 'not_started'
                         CHECK (status IN ('not_started', 'in_progress', 'completed')),
    is_favorite          boolean     NOT NULL DEFAULT false,
    enrolled_at          timestamptz NOT NULL DEFAULT now(),
    content_accessed_at  timestamptz,                             -- recurso sem Levels: quando viu o conteúdo (RF20)
    completed_at         timestamptz,
    UNIQUE (user_id, training_resource_id),
    UNIQUE (id, training_resource_id),                            -- alvo da FK composta de attempts
    CHECK ((status = 'completed') = (completed_at IS NOT NULL))
);

-- Progresso em cada Level (RF17). Substitui resourcelevel_user.
CREATE TABLE level_progress (
    enrollment_id bigint      NOT NULL REFERENCES enrollments (id) ON DELETE CASCADE,
    level_id      bigint      NOT NULL REFERENCES levels (id) ON DELETE CASCADE,
    progress      smallint    NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    updated_at    timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (enrollment_id, level_id)
);

-- -----------------------------------------------------------------------------
-- 4. Questionários
-- -----------------------------------------------------------------------------

-- Um Diagnostic e um Final por recurso. O tipo substitui a tabela quiztypes.
CREATE TABLE questionnaires (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    training_resource_id bigint      NOT NULL REFERENCES training_resources (id) ON DELETE CASCADE,
    type                 varchar(20) NOT NULL CHECK (type IN ('diagnostic', 'final')),
    max_attempts         smallint    NOT NULL DEFAULT 2 CHECK (max_attempts >= 1),   -- D01, D04
    content_status_id    smallint    NOT NULL REFERENCES content_statuses (id),
    UNIQUE (training_resource_id, type),
    UNIQUE (id, training_resource_id)                             -- alvo da FK composta de attempts
);

CREATE TABLE questionnaire_translations (
    questionnaire_id bigint       NOT NULL REFERENCES questionnaires (id) ON DELETE CASCADE,
    language_code    varchar(5)   NOT NULL REFERENCES languages (code),
    title            varchar(150) NOT NULL,
    description      text,
    PRIMARY KEY (questionnaire_id, language_code)
);

CREATE TABLE questions (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    questionnaire_id bigint   NOT NULL REFERENCES questionnaires (id) ON DELETE CASCADE,
    position         smallint NOT NULL CHECK (position >= 1),
    UNIQUE (questionnaire_id, position)
);

CREATE TABLE question_translations (
    question_id   bigint     NOT NULL REFERENCES questions (id) ON DELETE CASCADE,
    language_code varchar(5) NOT NULL REFERENCES languages (code),
    statement     text       NOT NULL,
    PRIMARY KEY (question_id, language_code)
);

-- Alternativas de uma Question. Substitui answers da v1.0.
CREATE TABLE answer_options (
    id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    question_id bigint   NOT NULL REFERENCES questions (id) ON DELETE CASCADE,
    position    smallint NOT NULL CHECK (position >= 1),
    is_correct  boolean  NOT NULL DEFAULT false,
    UNIQUE (question_id, position),
    UNIQUE (id, question_id)                                      -- alvo da FK composta de attempt_answers
);

-- No máximo uma opção correta por Question.
CREATE UNIQUE INDEX answer_options_one_correct
    ON answer_options (question_id) WHERE is_correct;

CREATE TABLE answer_option_translations (
    answer_option_id bigint       NOT NULL REFERENCES answer_options (id) ON DELETE CASCADE,
    language_code    varchar(5)   NOT NULL REFERENCES languages (code),
    text             varchar(500) NOT NULL,
    PRIMARY KEY (answer_option_id, language_code)
);

-- Cada submissão completa de um Questionnaire (RF19, RF21). Substitui quiz_user.
-- Ligada à Enrollment: só responde quem está inscrito no recurso.
-- training_resource_id repete o recurso da Enrollment e do Questionnaire: as duas
-- FK compostas garantem que o Questionnaire é do recurso em que o User está inscrito.
CREATE TABLE attempts (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id        bigint       NOT NULL,
    questionnaire_id     bigint       NOT NULL,
    training_resource_id bigint       NOT NULL,
    attempt_number       smallint     NOT NULL CHECK (attempt_number >= 1),
    score                numeric(5,2) NOT NULL CHECK (score BETWEEN 0 AND 100),
    submitted_at         timestamptz  NOT NULL DEFAULT now(),
    UNIQUE (enrollment_id, questionnaire_id, attempt_number),
    FOREIGN KEY (enrollment_id, training_resource_id)
        REFERENCES enrollments (id, training_resource_id) ON DELETE CASCADE,
    FOREIGN KEY (questionnaire_id, training_resource_id)
        REFERENCES questionnaires (id, training_resource_id)
);

-- Answer Option escolhida em cada Question de uma Attempt. Nova face à v1.0,
-- necessária para a proporção de respostas corretas por pergunta (RF40).
CREATE TABLE attempt_answers (
    attempt_id       bigint NOT NULL REFERENCES attempts (id) ON DELETE CASCADE,
    question_id      bigint NOT NULL REFERENCES questions (id),
    answer_option_id bigint NOT NULL,
    PRIMARY KEY (attempt_id, question_id),
    FOREIGN KEY (answer_option_id, question_id) REFERENCES answer_options (id, question_id)
);

-- -----------------------------------------------------------------------------
-- 5. Gamificação
-- -----------------------------------------------------------------------------

-- Badge atribuído na primeira Attempt do Final com 85% ou mais (RF23, D04, D09).
CREATE TABLE badges (
    enrollment_id bigint      PRIMARY KEY REFERENCES enrollments (id) ON DELETE CASCADE,
    attempt_id    bigint      NOT NULL UNIQUE REFERENCES attempts (id),
    awarded_at    timestamptz NOT NULL DEFAULT now()
);

-- Certificate em PDF (RF25, D05). O código permite verificar a autenticidade.
CREATE TABLE certificates (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id     bigint      NOT NULL UNIQUE REFERENCES enrollments (id) ON DELETE CASCADE,
    attempt_id        bigint      NOT NULL UNIQUE REFERENCES attempts (id),
    verification_code varchar(40) NOT NULL UNIQUE,
    issued_at         timestamptz NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- 6. Biblioteca virtual
-- -----------------------------------------------------------------------------

-- Tipo de Publication. Substitui contenttypes.
CREATE TABLE categories (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    content_status_id smallint NOT NULL REFERENCES content_statuses (id)
);

CREATE TABLE category_translations (
    category_id   bigint      NOT NULL REFERENCES categories (id) ON DELETE CASCADE,
    language_code varchar(5)  NOT NULL REFERENCES languages (code),
    name          varchar(80) NOT NULL,
    PRIMARY KEY (category_id, language_code)
);

-- Substitui contents.
CREATE TABLE publications (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    health_area_id    bigint       NOT NULL REFERENCES health_areas (id),
    category_id       bigint       NOT NULL REFERENCES categories (id),
    author            varchar(150) NOT NULL,
    url               varchar(500) NOT NULL,
    content_status_id smallint     NOT NULL REFERENCES content_statuses (id),
    created_at        timestamptz  NOT NULL DEFAULT now(),
    updated_at        timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE publication_translations (
    publication_id bigint       NOT NULL REFERENCES publications (id) ON DELETE CASCADE,
    language_code  varchar(5)   NOT NULL REFERENCES languages (code),
    title          varchar(200) NOT NULL,
    description    text,
    PRIMARY KEY (publication_id, language_code)
);

-- Substitui news.
CREATE TABLE news_items (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    health_area_id    bigint       REFERENCES health_areas (id),
    author            varchar(150) NOT NULL,
    news_date         date         NOT NULL,
    image_url         varchar(500),
    content_status_id smallint     NOT NULL REFERENCES content_statuses (id),
    created_at        timestamptz  NOT NULL DEFAULT now(),
    updated_at        timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE news_item_translations (
    news_item_id  bigint       NOT NULL REFERENCES news_items (id) ON DELETE CASCADE,
    language_code varchar(5)   NOT NULL REFERENCES languages (code),
    title         varchar(200) NOT NULL,
    body          text         NOT NULL,
    PRIMARY KEY (news_item_id, language_code)
);

-- Acontecimentos da Agenda.
CREATE TABLE activities (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    health_area_id    bigint       REFERENCES health_areas (id),
    starts_at         timestamptz  NOT NULL,
    url               varchar(500),
    content_status_id smallint     NOT NULL REFERENCES content_statuses (id),
    created_at        timestamptz  NOT NULL DEFAULT now(),
    updated_at        timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE activity_translations (
    activity_id   bigint       NOT NULL REFERENCES activities (id) ON DELETE CASCADE,
    language_code varchar(5)   NOT NULL REFERENCES languages (code),
    title         varchar(200) NOT NULL,
    description   text,
    PRIMARY KEY (activity_id, language_code)
);

-- Conteúdo escolhido pelo Manager para a página inicial durante um período
-- (RF10, D10). Aponta para exatamente um conteúdo.
CREATE TABLE weekly_highlights (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    start_date           date        NOT NULL,
    end_date             date        NOT NULL,
    position             smallint    NOT NULL DEFAULT 1 CHECK (position >= 1),
    training_resource_id bigint      REFERENCES training_resources (id) ON DELETE CASCADE,
    publication_id       bigint      REFERENCES publications (id) ON DELETE CASCADE,
    news_item_id         bigint      REFERENCES news_items (id) ON DELETE CASCADE,
    activity_id          bigint      REFERENCES activities (id) ON DELETE CASCADE,
    created_by           bigint      REFERENCES users (id) ON DELETE SET NULL,
    created_at           timestamptz NOT NULL DEFAULT now(),
    CHECK (end_date >= start_date),
    CHECK (num_nonnulls(training_resource_id, publication_id, news_item_id, activity_id) = 1)
);

-- -----------------------------------------------------------------------------
-- 7. Índices para as chaves estrangeiras mais consultadas
-- -----------------------------------------------------------------------------

CREATE INDEX users_role_idx                    ON users (role_id);
CREATE INDEX users_account_status_idx          ON users (account_status_id);
CREATE INDEX user_tokens_user_idx              ON user_tokens (user_id);
CREATE INDEX training_resources_health_area_idx ON training_resources (health_area_id);
CREATE INDEX support_materials_resource_idx    ON support_materials (training_resource_id);
CREATE INDEX enrollments_resource_idx          ON enrollments (training_resource_id);
CREATE INDEX attempts_questionnaire_idx        ON attempts (questionnaire_id);
CREATE INDEX attempt_answers_question_idx      ON attempt_answers (question_id);
CREATE INDEX publications_health_area_idx      ON publications (health_area_id);
CREATE INDEX news_items_date_idx               ON news_items (news_date DESC);
CREATE INDEX activities_starts_at_idx          ON activities (starts_at);
CREATE INDEX weekly_highlights_period_idx      ON weekly_highlights (start_date, end_date);

-- -----------------------------------------------------------------------------
-- 8. Dados de referência
-- -----------------------------------------------------------------------------

INSERT INTO languages (code, name) VALUES
    ('pt', 'Português'),
    ('en', 'English');

INSERT INTO genders (name) VALUES
    ('female'), ('male'), ('other'), ('prefer_not_to_say');

INSERT INTO school_years (year) VALUES (7), (8), (9), (10), (11), (12);

INSERT INTO account_statuses (code) VALUES
    ('pending_verification'), ('pending_consent'), ('active'), ('suspended'), ('deactivated');

INSERT INTO content_statuses (code) VALUES
    ('draft'), ('published'), ('archived');

INSERT INTO resource_types (code) VALUES
    ('workshop'), ('webinar');

INSERT INTO roles (code, name) VALUES
    ('registered_user', 'Registered User'),
    ('manager',         'Manager'),
    ('administrator',   'Administrator');

INSERT INTO permissions (code, description) VALUES
    ('content.manage',       'Gerir recursos, áreas de saúde, categorias, biblioteca e destaques'),
    ('questionnaire.manage', 'Gerir questionários, perguntas e opções de resposta'),
    ('indicator.view',       'Consultar indicadores de utilização e de aprendizagem'),
    ('result.export',        'Exportar respostas e classificações em CSV'),
    ('user.manage',          'Gerir contas de utilizador e o respetivo estado'),
    ('role.manage',          'Gerir perfis de acesso e permissões');

-- O Manager tem as permissões de gestão de conteúdos; o Administrator tem todas.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p
  ON r.code = 'administrator'
  OR (r.code = 'manager' AND p.code IN ('content.manage', 'questionnaire.manage', 'indicator.view', 'result.export'));
