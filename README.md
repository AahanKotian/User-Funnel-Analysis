<<<<<<< HEAD
# 🟢 User Funnel Analysis — SQL Portfolio Project

> **Resume line:** *"Analyzed user conversion funnel across 5 onboarding steps, identifying a 40% drop-off at email verification using SQL aggregations and JOINs."*

---

## 📌 Project Overview

This project tracks how users move through a 5-step signup/onboarding flow and identifies where they drop off. It simulates a real-world product analytics task commonly done at tech companies using tools like Mixpanel, Amplitude, or internal data warehouses.

**Business Question:** *Where in our onboarding funnel are we losing the most users — and how bad is it?*

---

## 🗂️ Project Structure

```
user-funnel-analysis/
│
├── README.md
├── data/
│   └── seed_data.sql          # Creates + populates sample tables
│
├── sql/
│   ├── 01_funnel_steps.sql    # Step-by-step user counts
│   ├── 02_dropoff_rates.sql   # Drop-off % between each step
│   ├── 03_cohort_comparison.sql  # Funnel by signup cohort (week)
│   └── 04_time_to_complete.sql   # Avg time spent per step
│
└── docs/
    └── findings.md            # Sample insights writeup
```

---

## 🛠️ Skills Demonstrated

| SQL Concept | Where Used |
|---|---|
| `GROUP BY` + `COUNT` | Counting users at each funnel step |
| `HAVING` | Filtering steps with significant drop-off |
| `LEFT JOIN` | Finding users who never completed a step |
| `CASE WHEN` | Bucketing users by completion status |
| `WITH` (CTE) | Chaining step counts cleanly |
| Date filtering (`WHERE`) | Scoping to a signup cohort |

---

## 📊 The Funnel

```
Step 1: Account Created        → 10,000 users
Step 2: Email Verified         →  6,012 users  ❗ -40% drop
Step 3: Profile Completed      →  4,890 users  -19% drop
Step 4: First Search           →  3,920 users  -20% drop
Step 5: First Booking/Purchase →  2,744 users  -30% drop
```

**Key Finding:** The biggest drop-off (40%) happens at email verification — a common friction point that could be improved with a better confirmation email or in-app reminder.

---

## 🚀 How to Run

### Option A — SQLiteOnline (No Setup)
1. Go to [sqliteonline.com](https://sqliteonline.com/)
2. Paste and run `data/seed_data.sql` first
3. Run each file in `sql/` in order

### Option B — Local SQLite
```bash
sqlite3 funnel.db < data/seed_data.sql
sqlite3 funnel.db < sql/01_funnel_steps.sql
sqlite3 funnel.db < sql/02_dropoff_rates.sql
sqlite3 funnel.db < sql/03_cohort_comparison.sql
sqlite3 funnel.db < sql/04_time_to_complete.sql
```

### Option C — BigQuery / Snowflake / Postgres
The SQL is standard and compatible with most dialects. Minor adjustments may be needed for date functions.

---

## 📁 Dataset

The data is **simulated** using `seed_data.sql`. It creates two tables:

**`users`** — one row per registered user
```
user_id | signed_up_at | cohort_week
```

**`events`** — one row per user action
```
event_id | user_id | event_name | occurred_at
```

`event_name` values: `account_created`, `email_verified`, `profile_completed`, `first_search`, `first_purchase`

---

## 💡 Extensions (Stretch Goals)

- [ ] Add a `device_type` column and compare mobile vs desktop funnels
- [ ] Build a weekly cohort heatmap showing funnel health over time
- [ ] Add a `referral_source` column and compare paid vs organic funnels
- [ ] Export results to CSV and visualize in Google Sheets or Tableau Public

---

## 📝 Findings

See [`docs/findings.md`](docs/findings.md) for a sample write-up of the results as if presenting to a product team.

---

*Built as part of a SQL portfolio series focused on product analytics.*
=======
# User-Funnel-Analysis
This project tracks how users move through a 5-step signup/onboarding flow and identifies where they drop off. It simulates a real-world product analytics task commonly done at tech companies using tools like Mixpanel, Amplitude, or internal data warehouses.
>>>>>>> d1c8cbe41db73065631c463e2b92fc80c88ff258
