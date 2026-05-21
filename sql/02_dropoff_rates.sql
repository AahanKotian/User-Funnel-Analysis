-- =============================================================
-- 02_dropoff_rates.sql
-- Calculate the drop-off % between each consecutive funnel step
--
-- Concepts used: CTEs (WITH), LEFT JOIN, ROUND, CAST,
--                subqueries, calculated columns
-- =============================================================

-- ---------------------------------------------------------------
-- Step 1: Build a CTE that counts users at each step
-- ---------------------------------------------------------------
WITH step_counts AS (
    SELECT
        CASE event_name
            WHEN 'account_created'    THEN 1
            WHEN 'email_verified'     THEN 2
            WHEN 'profile_completed'  THEN 3
            WHEN 'first_search'       THEN 4
            WHEN 'first_purchase'     THEN 5
        END                           AS step_num,
        CASE event_name
            WHEN 'account_created'    THEN 'Account Created'
            WHEN 'email_verified'     THEN 'Email Verified'
            WHEN 'profile_completed'  THEN 'Profile Completed'
            WHEN 'first_search'       THEN 'First Search'
            WHEN 'first_purchase'     THEN 'First Purchase'
        END                           AS step_name,
        COUNT(DISTINCT user_id)       AS users_at_step
    FROM events
    GROUP BY event_name
)

-- ---------------------------------------------------------------
-- Step 2: Self-join to compare each step to the previous one
-- ---------------------------------------------------------------
SELECT
    curr.step_num,
    curr.step_name,
    curr.users_at_step,
    prev.users_at_step                                  AS prev_step_users,

    -- Users lost between this step and the previous
    (prev.users_at_step - curr.users_at_step)           AS users_lost,

    -- Drop-off rate as a percentage
    ROUND(
        100.0 * (prev.users_at_step - curr.users_at_step)
        / CAST(prev.users_at_step AS REAL),
        1
    )                                                   AS dropoff_pct,

    -- Retention rate (inverse of drop-off)
    ROUND(
        100.0 * curr.users_at_step
        / CAST(prev.users_at_step AS REAL),
        1
    )                                                   AS retention_pct

FROM step_counts curr
LEFT JOIN step_counts prev
    ON curr.step_num = prev.step_num + 1

ORDER BY curr.step_num;


-- ---------------------------------------------------------------
-- BONUS: Flag the single worst drop-off step
-- Useful for pinpointing where to focus product improvements
-- ---------------------------------------------------------------
WITH step_counts AS (
    SELECT
        CASE event_name
            WHEN 'account_created'    THEN 1
            WHEN 'email_verified'     THEN 2
            WHEN 'profile_completed'  THEN 3
            WHEN 'first_search'       THEN 4
            WHEN 'first_purchase'     THEN 5
        END                           AS step_num,
        CASE event_name
            WHEN 'account_created'    THEN 'Account Created'
            WHEN 'email_verified'     THEN 'Email Verified'
            WHEN 'profile_completed'  THEN 'Profile Completed'
            WHEN 'first_search'       THEN 'First Search'
            WHEN 'first_purchase'     THEN 'First Purchase'
        END                           AS step_name,
        COUNT(DISTINCT user_id)       AS users_at_step
    FROM events
    GROUP BY event_name
),
dropoffs AS (
    SELECT
        curr.step_name,
        ROUND(
            100.0 * (prev.users_at_step - curr.users_at_step)
            / CAST(prev.users_at_step AS REAL),
            1
        ) AS dropoff_pct
    FROM step_counts curr
    LEFT JOIN step_counts prev ON curr.step_num = prev.step_num + 1
    WHERE prev.users_at_step IS NOT NULL
)

SELECT
    step_name         AS worst_dropoff_step,
    dropoff_pct       AS dropoff_pct
FROM dropoffs
ORDER BY dropoff_pct DESC
LIMIT 1;
