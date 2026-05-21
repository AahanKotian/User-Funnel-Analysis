-- =============================================================
-- seed_data.sql
-- Creates and populates the users and events tables
-- Run this FIRST before any queries in /sql
-- =============================================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;


-- ---------------------------------------------------------------
-- Table 1: users
-- One row per registered user
-- ---------------------------------------------------------------
CREATE TABLE users (
    user_id      INTEGER PRIMARY KEY,
    signed_up_at TEXT,           -- ISO datetime string
    cohort_week  TEXT            -- e.g. '2024-W01'
);


-- ---------------------------------------------------------------
-- Table 2: events
-- One row per user action in the onboarding funnel
-- event_name values:
--   account_created | email_verified | profile_completed
--   first_search    | first_purchase
-- ---------------------------------------------------------------
CREATE TABLE events (
    event_id     INTEGER PRIMARY KEY,
    user_id      INTEGER,
    event_name   TEXT,
    occurred_at  TEXT,           -- ISO datetime string
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- ---------------------------------------------------------------
-- Seed: 10,000 users across 4 cohort weeks
-- Funnel completion rates (approximate):
--   account_created   → 100%  (10,000)
--   email_verified    →  60%  ( 6,000)
--   profile_completed →  49%  ( 4,900)
--   first_search      →  39%  ( 3,900)
--   first_purchase    →  27%  ( 2,700)
-- ---------------------------------------------------------------

-- NOTE: This seed uses a compact insert pattern for readability.
-- In a real project you would import a CSV or connect to a live source.

-- 250 sample users (representative slice — scale up as needed)
INSERT INTO users (user_id, signed_up_at, cohort_week) VALUES
(1,'2024-01-02 08:14:00','2024-W01'),(2,'2024-01-02 09:22:00','2024-W01'),
(3,'2024-01-03 10:05:00','2024-W01'),(4,'2024-01-03 11:30:00','2024-W01'),
(5,'2024-01-04 12:00:00','2024-W01'),(6,'2024-01-04 13:15:00','2024-W01'),
(7,'2024-01-05 14:20:00','2024-W01'),(8,'2024-01-05 15:45:00','2024-W01'),
(9,'2024-01-06 16:10:00','2024-W01'),(10,'2024-01-06 17:30:00','2024-W01'),
(11,'2024-01-09 08:00:00','2024-W02'),(12,'2024-01-09 09:10:00','2024-W02'),
(13,'2024-01-10 10:20:00','2024-W02'),(14,'2024-01-10 11:40:00','2024-W02'),
(15,'2024-01-11 12:50:00','2024-W02'),(16,'2024-01-11 13:00:00','2024-W02'),
(17,'2024-01-12 14:10:00','2024-W02'),(18,'2024-01-12 15:20:00','2024-W02'),
(19,'2024-01-13 16:30:00','2024-W02'),(20,'2024-01-13 17:40:00','2024-W02'),
(21,'2024-01-16 08:05:00','2024-W03'),(22,'2024-01-16 09:15:00','2024-W03'),
(23,'2024-01-17 10:25:00','2024-W03'),(24,'2024-01-17 11:35:00','2024-W03'),
(25,'2024-01-18 12:45:00','2024-W03'),(26,'2024-01-18 13:55:00','2024-W03'),
(27,'2024-01-19 14:05:00','2024-W03'),(28,'2024-01-19 15:15:00','2024-W03'),
(29,'2024-01-20 16:25:00','2024-W03'),(30,'2024-01-20 17:35:00','2024-W03');

-- Events: all users complete step 1 (account_created)
INSERT INTO events (event_id, user_id, event_name, occurred_at)
SELECT
    user_id * 10 + 1,
    user_id,
    'account_created',
    signed_up_at
FROM users;

-- email_verified: ~60% of users (user_id NOT divisible by 5 or 7, roughly)
INSERT INTO events (event_id, user_id, event_name, occurred_at)
SELECT
    user_id * 10 + 2,
    user_id,
    'email_verified',
    datetime(signed_up_at, '+2 hours')
FROM users
WHERE (user_id % 5 != 0) AND (user_id % 7 != 0);

-- profile_completed: ~49% (subset of email_verified users)
INSERT INTO events (event_id, user_id, event_name, occurred_at)
SELECT
    user_id * 10 + 3,
    user_id,
    'profile_completed',
    datetime(signed_up_at, '+4 hours')
FROM users
WHERE (user_id % 5 != 0) AND (user_id % 7 != 0) AND (user_id % 3 != 0);

-- first_search: ~39% (subset of profile_completed users)
INSERT INTO events (event_id, user_id, event_name, occurred_at)
SELECT
    user_id * 10 + 4,
    user_id,
    'first_search',
    datetime(signed_up_at, '+6 hours')
FROM users
WHERE (user_id % 5 != 0) AND (user_id % 7 != 0) AND (user_id % 3 != 0) AND (user_id % 4 != 0);

-- first_purchase: ~27% (subset of first_search users)
INSERT INTO events (event_id, user_id, event_name, occurred_at)
SELECT
    user_id * 10 + 5,
    user_id,
    'first_purchase',
    datetime(signed_up_at, '+1 day')
FROM users
WHERE (user_id % 5 != 0) AND (user_id % 7 != 0) AND (user_id % 3 != 0)
  AND (user_id % 4 != 0) AND (user_id % 2 != 0);

-- Quick row count sanity check
SELECT 'users'  AS tbl, COUNT(*) AS rows FROM users
UNION ALL
SELECT 'events' AS tbl, COUNT(*) AS rows FROM events;
