-- =============================================================
-- 04_time_to_complete.sql
-- How long does it take users to move through each funnel step?
--
-- Concepts used: self-JOIN on the same table, datetime math,
--                AVG, MIN, MAX, ROUND, filtering with WHERE
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Average hours between consecutive funnel steps
-- Reveals friction: a long gap = users are hesitating or confused
-- ---------------------------------------------------------------
SELECT
    next_step.event_name                                    AS to_step,
    ROUND(AVG(
        (JULIANDAY(next_step.occurred_at)
       - JULIANDAY(prev_step.occurred_at)) * 24
    ), 2)                                                   AS avg_hours_to_reach,
    ROUND(MIN(
        (JULIANDAY(next_step.occurred_at)
       - JULIANDAY(prev_step.occurred_at)) * 24
    ), 2)                                                   AS min_hours,
    ROUND(MAX(
        (JULIANDAY(next_step.occurred_at)
       - JULIANDAY(prev_step.occurred_at)) * 24
    ), 2)                                                   AS max_hours,
    COUNT(*)                                                AS user_count

FROM events prev_step
JOIN events next_step
    ON  prev_step.user_id = next_step.user_id
    AND (
        -- Map each step to its successor
        (prev_step.event_name = 'account_created'   AND next_step.event_name = 'email_verified')    OR
        (prev_step.event_name = 'email_verified'    AND next_step.event_name = 'profile_completed') OR
        (prev_step.event_name = 'profile_completed' AND next_step.event_name = 'first_search')      OR
        (prev_step.event_name = 'first_search'      AND next_step.event_name = 'first_purchase')
    )

GROUP BY next_step.event_name
ORDER BY
    CASE next_step.event_name
        WHEN 'email_verified'     THEN 1
        WHEN 'profile_completed'  THEN 2
        WHEN 'first_search'       THEN 3
        WHEN 'first_purchase'     THEN 4
    END;


-- ---------------------------------------------------------------
-- Query 2: Total time from account creation to first purchase
-- for users who completed the full funnel
-- ---------------------------------------------------------------
SELECT
    ROUND(AVG(
        (JULIANDAY(purchase.occurred_at)
       - JULIANDAY(created.occurred_at)) * 24
    ), 1)   AS avg_hours_full_funnel,
    COUNT(*) AS completed_users
FROM events created
JOIN events purchase
    ON  created.user_id  = purchase.user_id
    AND created.event_name  = 'account_created'
    AND purchase.event_name = 'first_purchase';


-- ---------------------------------------------------------------
-- Query 3: Users who signed up but never verified email
-- These are the 40% drop-off — who are they?
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.cohort_week,
    u.signed_up_at
FROM users u
LEFT JOIN events e
    ON  u.user_id    = e.user_id
    AND e.event_name = 'email_verified'
WHERE e.user_id IS NULL        -- no email_verified event found
ORDER BY u.signed_up_at;
