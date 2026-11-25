-- US_A009: consultas de leitura sobre o schema v1.1.
-- Primeiras tentativas; ano de escolaridade atual; meses UTC.

WITH first_scores AS (
    SELECT e.id AS enrollment_id, e.user_id, e.training_resource_id,
           r.health_area_id, sy.year AS school_year,
           MAX(a.score) FILTER (WHERE q.type = 'diagnostic') AS pre_score,
           MAX(a.score) FILTER (WHERE q.type = 'final') AS post_score,
           MAX(a.submitted_at) FILTER (WHERE q.type = 'final') AS final_at
    FROM enrollments e
    JOIN users u ON u.id = e.user_id
    LEFT JOIN school_years sy ON sy.id = u.school_year_id
    JOIN training_resources r ON r.id = e.training_resource_id
    LEFT JOIN attempts a ON a.enrollment_id = e.id AND a.attempt_number = 1
    LEFT JOIN questionnaires q ON q.id = a.questionnaire_id
        AND q.training_resource_id = e.training_resource_id
    GROUP BY e.id, e.user_id, e.training_resource_id, r.health_area_id, sy.year
)
SELECT *, post_score - pre_score AS absolute_gain,
       (post_score - pre_score) / NULLIF(100 - pre_score, 0) AS normalized_gain
FROM first_scores
ORDER BY enrollment_id;

-- Aplicar os mesmos filtros de população em cada indicador comparado.
SELECT e.training_resource_id, r.health_area_id, sy.year AS school_year,
       q.type, COUNT(*) AS n, COUNT(DISTINCT e.user_id) AS n_users,
       AVG(a.score) AS mean_score,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY a.score) AS median_score,
       stddev_samp(a.score) AS sample_stddev,
       MIN(a.score) AS minimum_score, MAX(a.score) AS maximum_score
FROM attempts a
JOIN questionnaires q ON q.id = a.questionnaire_id
JOIN enrollments e ON e.id = a.enrollment_id
    AND e.training_resource_id = q.training_resource_id
JOIN training_resources r ON r.id = e.training_resource_id
JOIN users u ON u.id = e.user_id
LEFT JOIN school_years sy ON sy.id = u.school_year_id
WHERE a.attempt_number = 1
GROUP BY e.training_resource_id, r.health_area_id, sy.year, q.type
ORDER BY e.training_resource_id, sy.year NULLS LAST, q.type;

-- LEFT JOIN preserva perguntas sem respostas: proporção NULL e n = 0.
SELECT qn.id AS questionnaire_id, qn.type, qu.id AS question_id,
       COUNT(a.id) AS n, COUNT(DISTINCT e.user_id) AS n_users,
       AVG(CASE WHEN a.id IS NOT NULL THEN ao.is_correct::int END) AS correct_proportion
FROM questionnaires qn
JOIN questions qu ON qu.questionnaire_id = qn.id
LEFT JOIN attempt_answers aa ON aa.question_id = qu.id
LEFT JOIN attempts a ON a.id = aa.attempt_id
    AND a.questionnaire_id = qn.id AND a.attempt_number = 1
LEFT JOIN enrollments e ON e.id = a.enrollment_id
LEFT JOIN answer_options ao ON ao.id = aa.answer_option_id AND ao.question_id = qu.id
GROUP BY qn.id, qn.type, qu.id
ORDER BY qn.id, qu.id;

WITH reference AS (SELECT CURRENT_TIMESTAMP AS at)
SELECT reference.at,
       (SELECT COUNT(*) FROM users WHERE created_at <= reference.at) AS registered_users,
       (SELECT COUNT(*) FROM users WHERE created_at <= reference.at
        AND last_login_at BETWEEN reference.at - INTERVAL '30 days' AND reference.at) AS active_users,
       (SELECT COUNT(*) FROM training_resources r
        JOIN content_statuses s ON s.id = r.content_status_id
        WHERE s.code = 'published' AND r.created_at <= reference.at) AS published_resources,
       COUNT(e.id) AS enrollments,
       COUNT(e.id) FILTER (WHERE e.completed_at <= reference.at) AS completed_enrollments,
       100.0 * COUNT(e.id) FILTER (WHERE e.completed_at <= reference.at)
           / NULLIF(COUNT(e.id), 0) AS completion_rate
FROM reference
LEFT JOIN enrollments e ON e.enrolled_at <= reference.at
GROUP BY reference.at;
