"""Gera e carrega um conjunto reproduzível de dados sintéticos para US_A016."""

from __future__ import annotations

import argparse
import hashlib
import os
from collections import defaultdict
from datetime import date, datetime, time, timedelta, timezone

import numpy as np
import psycopg
from argon2.low_level import Type, hash_secret
from faker import Faker


SEED = 2026
USER_COUNT = 144
QUESTIONS_PER_QUESTIONNAIRE = 10
BASE_DATE = date(2026, 10, 1)
UTC = timezone.utc

HEALTH_AREAS = (
    "Bem-estar emocional",
    "Alimentação e movimento",
    "Sono e descanso",
)

TRAINING_RESOURCES = (
    ("Estratégias de concentração", 0, "webinar"),
    ("Reconhecer emoções", 0, "workshop"),
    ("Escolhas alimentares", 1, "webinar"),
    ("Movimento diário", 1, "workshop"),
)


def fixed_hash(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def password_hash(user_number: int) -> str:
    salt = hashlib.sha256(f"a016-salt-{user_number}".encode("ascii")).digest()[:16]
    return hash_secret(
        secret=f"a016-synthetic-account-{user_number}".encode("ascii"),
        salt=salt,
        time_cost=2,
        memory_cost=19_456,
        parallelism=1,
        hash_len=32,
        type=Type.ID,
    ).decode("ascii")


def lookup(cursor, query: str, key_column: str, value_column: str) -> dict:
    cursor.execute(query)
    return {row[0]: row[1] for row in cursor.fetchall()}


def insert_attempt(
    cursor,
    *,
    enrollment_id: int,
    questionnaire_id: int,
    training_resource_id: int,
    attempt_number: int,
    correct_count: int,
    submitted_at: datetime,
    question_options: dict[int, list[int]],
    correct_options: dict[int, int],
    rng: np.random.Generator,
) -> int:
    score = round(100 * correct_count / QUESTIONS_PER_QUESTIONNAIRE, 2)
    cursor.execute(
        """
        INSERT INTO attempts (
            enrollment_id, questionnaire_id, training_resource_id,
            attempt_number, score, submitted_at
        )
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING id
        """,
        (
            enrollment_id,
            questionnaire_id,
            training_resource_id,
            attempt_number,
            score,
            submitted_at,
        ),
    )
    attempt_id = cursor.fetchone()[0]

    question_ids = list(question_options)
    correct_questions = set(
        rng.choice(question_ids, size=correct_count, replace=False).tolist()
    )
    for question_id, option_ids in question_options.items():
        if question_id in correct_questions:
            answer_option_id = correct_options[question_id]
        else:
            wrong_options = [
                option_id
                for option_id in option_ids
                if option_id != correct_options[question_id]
            ]
            answer_option_id = int(rng.choice(wrong_options))
        cursor.execute(
            """
            INSERT INTO attempt_answers (attempt_id, question_id, answer_option_id)
            VALUES (%s, %s, %s)
            """,
            (attempt_id, question_id, answer_option_id),
        )
    return attempt_id


def clear_previous_seed(cursor) -> None:
    marker = "Dados fictícios A016:%"
    cursor.execute(
        "DELETE FROM users WHERE email LIKE 'seed-a016-%@dados.invalid'"
    )
    cursor.execute(
        """
        DELETE FROM enrollments
        WHERE training_resource_id IN (
            SELECT resource.id
            FROM training_resources AS resource
            JOIN health_area_translations AS translation
              ON translation.health_area_id = resource.health_area_id
            WHERE translation.language_code = 'pt' AND translation.title LIKE %s
        )
        """,
        (marker,),
    )
    cursor.execute(
        """
        DELETE FROM training_resources
        WHERE health_area_id IN (
            SELECT health_area_id
            FROM health_area_translations
            WHERE language_code = 'pt' AND title LIKE %s
        )
        """,
        (marker,),
    )
    cursor.execute(
        """
        DELETE FROM health_areas
        WHERE id IN (
            SELECT health_area_id
            FROM health_area_translations
            WHERE language_code = 'pt' AND title LIKE %s
        )
        """,
        (marker,),
    )


def create_reference_data(cursor) -> tuple[dict, dict, dict, dict]:
    content_statuses = lookup(
        cursor,
        "SELECT code, id FROM content_statuses",
        "code",
        "id",
    )
    resource_types = lookup(
        cursor,
        "SELECT code, id FROM resource_types",
        "code",
        "id",
    )
    school_years = lookup(
        cursor,
        "SELECT year, id FROM school_years ORDER BY year",
        "year",
        "id",
    )
    account_statuses = lookup(
        cursor,
        "SELECT code, id FROM account_statuses",
        "code",
        "id",
    )
    roles = lookup(cursor, "SELECT code, id FROM roles", "code", "id")
    languages = lookup(cursor, "SELECT code, code FROM languages", "code", "code")

    required = {
        "content_statuses.published": "published" in content_statuses,
        "resource_types": all(
            code in resource_types for code in ("workshop", "webinar")
        ),
        "school_years.7-12": all(year in school_years for year in range(7, 13)),
        "account_statuses.active": "active" in account_statuses,
        "roles.registered_user": "registered_user" in roles,
        "languages.pt": "pt" in languages,
    }
    missing = [name for name, exists in required.items() if not exists]
    if missing:
        raise RuntimeError(
            "Faltam dados de referência no schema: " + ", ".join(missing)
        )

    return content_statuses, resource_types, school_years, account_statuses | roles


def load_seed(dsn: str) -> dict[str, int]:
    rng = np.random.default_rng(SEED)
    fake = Faker("pt_PT")
    fake.seed_instance(SEED)
    counts = defaultdict(int)

    with psycopg.connect(dsn) as connection:
        with connection.transaction():
            with connection.cursor() as cursor:
                clear_previous_seed(cursor)
                (
                    content_statuses,
                    resource_types,
                    school_years,
                    account_statuses_and_roles,
                ) = create_reference_data(cursor)
                account_status_id = account_statuses_and_roles["active"]
                role_id = account_statuses_and_roles["registered_user"]
                published_status_id = content_statuses["published"]

                area_ids = []
                for index, title in enumerate(HEALTH_AREAS):
                    marked_title = f"Dados fictícios A016: {title}"
                    cursor.execute(
                        """
                        INSERT INTO health_areas (content_status_id, created_at, updated_at)
                        VALUES (%s, %s, %s)
                        RETURNING id
                        """,
                        (
                            published_status_id,
                            datetime(2026, 9, 20, tzinfo=UTC) + timedelta(days=index),
                            datetime(2026, 9, 20, tzinfo=UTC) + timedelta(days=index),
                        ),
                    )
                    area_id = cursor.fetchone()[0]
                    area_ids.append(area_id)
                    cursor.execute(
                        """
                        INSERT INTO health_area_translations (
                            health_area_id, language_code, title, subtitle, description
                        ) VALUES (%s, 'pt', %s, %s, %s)
                        """,
                        (
                            area_id,
                            marked_title,
                            "Conteúdo sintético para análise de aprendizagem",
                            "Área fictícia criada para a demonstração de métricas.",
                        ),
                    )
                    counts["áreas"] += 1

                resource_ids = []
                resource_names = {}
                for index, (name, area_index, resource_type) in enumerate(
                    TRAINING_RESOURCES
                ):
                    cursor.execute(
                        """
                        INSERT INTO training_resources (
                            health_area_id, resource_type_id, content_status_id,
                            created_at, updated_at
                        ) VALUES (%s, %s, %s, %s, %s)
                        RETURNING id
                        """,
                        (
                            area_ids[area_index],
                            resource_types[resource_type],
                            published_status_id,
                            datetime(2026, 9, 25, tzinfo=UTC) + timedelta(days=index),
                            datetime(2026, 9, 25, tzinfo=UTC) + timedelta(days=index),
                        ),
                    )
                    resource_id = cursor.fetchone()[0]
                    resource_ids.append(resource_id)
                    resource_names[resource_id] = name
                    cursor.execute(
                        """
                        INSERT INTO training_resource_translations (
                            training_resource_id, language_code, name, description
                        ) VALUES (%s, 'pt', %s, %s)
                        """,
                        (
                            resource_id,
                            f"Dados fictícios A016: {name}",
                            "Recurso fictício usado para validar as consultas de métricas.",
                        ),
                    )
                    counts["recursos"] += 1

                questionnaire_ids = {}
                question_options = {}
                correct_options = {}
                for resource_id in resource_ids:
                    for questionnaire_type in ("diagnostic", "final"):
                        cursor.execute(
                            """
                            INSERT INTO questionnaires (
                                training_resource_id, type, max_attempts, content_status_id
                            ) VALUES (%s, %s, 2, %s)
                            RETURNING id
                            """,
                            (resource_id, questionnaire_type, published_status_id),
                        )
                        questionnaire_id = cursor.fetchone()[0]
                        questionnaire_ids[(resource_id, questionnaire_type)] = (
                            questionnaire_id
                        )
                        cursor.execute(
                            """
                            INSERT INTO questionnaire_translations (
                                questionnaire_id, language_code, title, description
                            ) VALUES (%s, 'pt', %s, %s)
                            """,
                            (
                                questionnaire_id,
                                f"Dados fictícios A016: {questionnaire_type} — {resource_names[resource_id]}",
                                "Questionário fictício com dez perguntas para análise.",
                            ),
                        )

                        for position in range(1, QUESTIONS_PER_QUESTIONNAIRE + 1):
                            cursor.execute(
                                """
                                INSERT INTO questions (questionnaire_id, position)
                                VALUES (%s, %s)
                                RETURNING id
                                """,
                                (questionnaire_id, position),
                            )
                            question_id = cursor.fetchone()[0]
                            cursor.execute(
                                """
                                INSERT INTO question_translations (
                                    question_id, language_code, statement
                                ) VALUES (%s, 'pt', %s)
                                """,
                                (
                                    question_id,
                                    f"Pergunta fictícia {position} — {resource_names[resource_id]}",
                                ),
                            )
                            option_ids = []
                            correct_option_id = None
                            correct_position = int(rng.integers(1, 5))
                            for option_position in range(1, 5):
                                is_correct = option_position == correct_position
                                cursor.execute(
                                    """
                                    INSERT INTO answer_options (
                                        question_id, position, is_correct
                                    ) VALUES (%s, %s, %s)
                                    RETURNING id
                                    """,
                                    (question_id, option_position, is_correct),
                                )
                                option_id = cursor.fetchone()[0]
                                option_ids.append(option_id)
                                if is_correct:
                                    correct_option_id = option_id
                                cursor.execute(
                                    """
                                    INSERT INTO answer_option_translations (
                                        answer_option_id, language_code, text
                                    ) VALUES (%s, 'pt', %s)
                                    """,
                                    (option_id, f"Opção fictícia {option_position}"),
                                )
                            question_options[question_id] = option_ids
                            correct_options[question_id] = correct_option_id
                            counts["perguntas"] += 1
                            counts["opções"] += 4

                user_data = []
                for user_number in range(USER_COUNT):
                    school_year = 7 + user_number % 6
                    cohort_position = user_number // 6
                    created_at = datetime(2026, 9, 1, 9, tzinfo=UTC) + timedelta(
                        days=user_number % 30,
                        hours=user_number % 8,
                    )
                    email_verified_at = created_at + timedelta(hours=2)
                    birth_month = 1 + (user_number * 7) % 10
                    birth_day = 1 + (user_number * 11) % 27
                    age = 5 + school_year
                    birth_date = date(2026 - age, birth_month, birth_day)
                    name = fake.name()[:100]
                    email = f"seed-a016-{user_number + 1:03d}@dados.invalid"
                    last_login_at = datetime(2026, 11, 18, 10, tzinfo=UTC) + timedelta(
                        days=user_number % 7
                    )
                    cursor.execute(
                        """
                        INSERT INTO users (
                            name, email, password_hash, birth_date, school_year_id,
                            preferred_language, role_id, account_status_id,
                            status_changed_at, privacy_accepted_at, email_verified_at,
                            last_login_at, created_at, updated_at
                        ) VALUES (
                            %s, %s, %s, %s, %s, 'pt', %s, %s,
                            %s, %s, %s, %s, %s, %s
                        )
                        RETURNING id
                        """,
                        (
                            name,
                            email,
                            password_hash(user_number + 1),
                            birth_date,
                            school_years[school_year],
                            role_id,
                            account_status_id,
                            created_at + timedelta(days=1),
                            created_at,
                            email_verified_at,
                            last_login_at,
                            created_at,
                            created_at,
                        ),
                    )
                    user_id = cursor.fetchone()[0]
                    cursor.execute(
                        """
                        INSERT INTO parental_consents (
                            user_id, guardian_email, token_hash, revocation_token_hash,
                            status, requested_at, expires_at, decided_at
                        ) VALUES (%s, %s, %s, %s, 'accepted', %s, %s, %s)
                        """,
                        (
                            user_id,
                            f"responsavel-{user_number + 1:03d}@dados.invalid",
                            fixed_hash(f"a016-consent-{user_number + 1}"),
                            fixed_hash(f"a016-revocation-{user_number + 1}"),
                            created_at,
                            created_at + timedelta(days=7),
                            created_at + timedelta(days=1),
                        ),
                    )
                    counts["utilizadores"] += 1
                    user_data.append(
                        {
                            "user_number": user_number,
                            "cohort_position": cohort_position,
                            "school_year": school_year,
                            "user_id": user_id,
                        }
                    )

                group_enrollments = defaultdict(list)
                for user in user_data:
                    position = user["cohort_position"] % 4
                    resource_indexes = {
                        0: (0, 1),
                        1: (2, 3),
                        2: (0, 2),
                        3: (1, 3),
                    }[position]
                    for resource_index in resource_indexes:
                        resource_id = resource_ids[resource_index]
                        group_enrollments[(user["school_year"], resource_index)].append(
                            (user, resource_id)
                        )

                for (school_year, resource_index), rows in group_enrollments.items():
                    rows.sort(key=lambda row: row[0]["cohort_position"])
                    if len(rows) != 12:
                        raise RuntimeError(
                            "A distribuição fixa deve ter doze inscrições por ano e recurso."
                        )
                    resource_id = resource_ids[resource_index]
                    diagnostic_id = questionnaire_ids[(resource_id, "diagnostic")]
                    final_id = questionnaire_ids[(resource_id, "final")]
                    cursor.execute(
                        "SELECT id FROM questions WHERE questionnaire_id = %s ORDER BY position",
                        (diagnostic_id,),
                    )
                    diagnostic_question_ids = [row[0] for row in cursor.fetchall()]
                    cursor.execute(
                        "SELECT id FROM questions WHERE questionnaire_id = %s ORDER BY position",
                        (final_id,),
                    )
                    final_question_ids = [row[0] for row in cursor.fetchall()]
                    diagnostic_question_options = {
                        qid: question_options[qid] for qid in diagnostic_question_ids
                    }
                    final_question_options = {
                        qid: question_options[qid] for qid in final_question_ids
                    }

                    for row_position, (user, _) in enumerate(rows):
                        user_number = user["user_number"]
                        enrollment_at = datetime.combine(
                            BASE_DATE,
                            time(8, tzinfo=UTC),
                        ) + timedelta(
                            days=(user_number * 3 + resource_index * 7) % 40,
                            hours=user_number % 9,
                        )
                        not_started = row_position == 0
                        diagnostic_only = row_position == 1
                        completed = row_position >= 2
                        enrollment_status = "not_started" if not_started else "in_progress"
                        cursor.execute(
                            """
                            INSERT INTO enrollments (
                                user_id, training_resource_id, status, is_favorite,
                                enrolled_at, content_accessed_at, completed_at
                            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                            RETURNING id
                            """,
                            (
                                user["user_id"],
                                resource_id,
                                enrollment_status,
                                bool((user_number + resource_index) % 3 == 0),
                                enrollment_at,
                                None,
                                None,
                            ),
                        )
                        enrollment_id = cursor.fetchone()[0]
                        counts["inscrições"] += 1
                        if not_started:
                            continue

                        baseline = float(
                            np.clip(
                                0.38
                                + 0.035 * (school_year - 7)
                                + 0.035 * resource_index
                                + rng.normal(0, 0.05),
                                0.15,
                                0.78,
                            )
                        )
                        diagnostic_correct = int(
                            rng.binomial(QUESTIONS_PER_QUESTIONNAIRE, baseline)
                        )
                        diagnostic_at = enrollment_at + timedelta(hours=1)
                        insert_attempt(
                            cursor,
                            enrollment_id=enrollment_id,
                            questionnaire_id=diagnostic_id,
                            training_resource_id=resource_id,
                            attempt_number=1,
                            correct_count=diagnostic_correct,
                            submitted_at=diagnostic_at,
                            question_options=diagnostic_question_options,
                            correct_options=correct_options,
                            rng=rng,
                        )
                        counts["tentativas"] += 1
                        counts["respostas"] += QUESTIONS_PER_QUESTIONNAIRE

                        if (user_number + resource_index) % 4 == 0:
                            repeat_correct = int(
                                rng.binomial(
                                    QUESTIONS_PER_QUESTIONNAIRE,
                                    min(0.95, baseline + 0.12),
                                )
                            )
                            insert_attempt(
                                cursor,
                                enrollment_id=enrollment_id,
                                questionnaire_id=diagnostic_id,
                                training_resource_id=resource_id,
                                attempt_number=2,
                                correct_count=repeat_correct,
                                submitted_at=diagnostic_at + timedelta(days=1),
                                question_options=diagnostic_question_options,
                                correct_options=correct_options,
                                rng=rng,
                            )
                            counts["tentativas"] += 1
                            counts["respostas"] += QUESTIONS_PER_QUESTIONNAIRE

                        if diagnostic_only:
                            continue

                        content_accessed_at = diagnostic_at + timedelta(days=2)
                        final_probability = float(
                            np.clip(baseline + 0.22 + rng.normal(0, 0.06), 0.20, 0.98)
                        )
                        final_correct = int(
                            rng.binomial(
                                QUESTIONS_PER_QUESTIONNAIRE,
                                final_probability,
                            )
                        )
                        final_at = content_accessed_at + timedelta(days=1)
                        cursor.execute(
                            """
                            UPDATE enrollments
                            SET content_accessed_at = %s,
                                completed_at = %s,
                                status = 'completed'
                            WHERE id = %s
                            """,
                            (content_accessed_at, final_at, enrollment_id),
                        )
                        insert_attempt(
                            cursor,
                            enrollment_id=enrollment_id,
                            questionnaire_id=final_id,
                            training_resource_id=resource_id,
                            attempt_number=1,
                            correct_count=final_correct,
                            submitted_at=final_at,
                            question_options=final_question_options,
                            correct_options=correct_options,
                            rng=rng,
                        )
                        counts["tentativas"] += 1
                        counts["respostas"] += QUESTIONS_PER_QUESTIONNAIRE
                        counts["conclusões"] += 1

    return dict(counts)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Gera e carrega dados fictícios reproduzíveis para US_A016."
    )
    parser.add_argument(
        "--dsn",
        default=os.environ.get("DATABASE_URL"),
        help="DSN PostgreSQL; por omissão usa a variável DATABASE_URL.",
    )
    arguments = parser.parse_args()
    if not arguments.dsn:
        parser.error("indica --dsn ou define DATABASE_URL")

    counts = load_seed(arguments.dsn)
    print("Carga sintética concluída:")
    for name, count in sorted(counts.items()):
        print(f"- {name}: {count}")


if __name__ == "__main__":
    main()
