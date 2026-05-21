-- =============================================================
-- 03_cohort_comparison.sql
-- Compare funnel performance across weekly signup cohorts
--
-- Concepts used: JOIN, GROUP BY multiple columns,
--                HAVING, CASE WHEN, cohort analysis
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Funnel counts broken down by cohort week
-- Tells you: "Is our funnel getting better or worse over time?"
-- ---------------------------------------------------------------
SELECT
    u.cohort_week,
    e.event_name,
    COUNT(DISTINCT e.user_id)   AS users_reached
FROM events e
JOIN users u ON e.user_id = u.user_id
GROUP BY u.cohort_week, e.event_name
ORDER BY u.cohort_week,
    CASE e.event_name
        WHEN 'account_created'    THEN 1
        WHEN 'email_verified'     THEN 2
        WHEN 'profile_completed'  THEN 3
        WHEN 'first_search'       THEN 4
        WHEN 'first_purchase'     THEN 5
    END;


-- ---------------------------------------------------------------
-- Query 2: Pivot — one row per cohort, one column per step
-- Easier to compare cohorts side by side
-- ---------------------------------------------------------------
SELECT
    u.cohort_week,
    COUNT(DISTINCT CASE WHEN e.event_name = 'account_created'   THEN e.user_id END) AS step1_created,
    COUNT(DISTINCT CASE WHEN e.event_name = 'email_verified'    THEN e.user_id END) AS step2_verified,
    COUNT(DISTINCT CASE WHEN e.event_name = 'profile_completed' THEN e.user_id END) AS step3_profile,
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_search'      THEN e.user_id END) AS step4_search,
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_purchase'    THEN e.user_id END) AS step5_purchase
FROM events e
JOIN users u ON e.user_id = u.user_id
GROUP BY u.cohort_week
ORDER BY u.cohort_week;


-- ---------------------------------------------------------------
-- Query 3: Overall purchase conversion rate per cohort
-- Use HAVING to surface only cohorts with low conversion
-- ---------------------------------------------------------------
SELECT
    u.cohort_week,
    COUNT(DISTINCT u.user_id)                                        AS total_signups,
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_purchase'
                        THEN e.user_id END)                          AS total_purchasers,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN e.event_name = 'first_purchase'
                                    THEN e.user_id END)
        / CAST(COUNT(DISTINCT u.user_id) AS REAL),
        1
    )                                                                AS purchase_conversion_pct
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY u.cohort_week
HAVING purchase_conversion_pct < 30          -- flag underperforming cohorts
ORDER BY purchase_conversion_pct ASC;
