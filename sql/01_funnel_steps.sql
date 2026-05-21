-- =============================================================
-- 01_funnel_steps.sql
-- Count how many DISTINCT users reached each funnel step
--
-- Concepts used: GROUP BY, COUNT(DISTINCT), ORDER BY
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Raw user count per funnel step
-- ---------------------------------------------------------------
SELECT
    event_name,
    COUNT(DISTINCT user_id)   AS users_reached
FROM events
GROUP BY event_name
ORDER BY
    CASE event_name
        WHEN 'account_created'    THEN 1
        WHEN 'email_verified'     THEN 2
        WHEN 'profile_completed'  THEN 3
        WHEN 'first_search'       THEN 4
        WHEN 'first_purchase'     THEN 5
    END;


-- ---------------------------------------------------------------
-- Query 2: Same result, but label the step number explicitly
-- Makes it easier to read in a spreadsheet or BI tool
-- ---------------------------------------------------------------
SELECT
    CASE event_name
        WHEN 'account_created'    THEN '1 - Account Created'
        WHEN 'email_verified'     THEN '2 - Email Verified'
        WHEN 'profile_completed'  THEN '3 - Profile Completed'
        WHEN 'first_search'       THEN '4 - First Search'
        WHEN 'first_purchase'     THEN '5 - First Purchase'
    END                           AS funnel_step,
    COUNT(DISTINCT user_id)       AS users_reached
FROM events
GROUP BY event_name
ORDER BY funnel_step;
