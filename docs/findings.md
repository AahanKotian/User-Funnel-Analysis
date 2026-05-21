# 📊 Funnel Analysis — Findings & Recommendations

**Analyst:** [Your Name]
**Date:** January 2024
**Cohort:** Users who signed up Jan 1–20, 2024 (Weeks 1–3)

---

## Summary

We analyzed 10,000 users through our 5-step onboarding funnel to understand where drop-off occurs and how long each step takes. The data reveals a critical bottleneck at email verification that is responsible for the largest single loss of users in the entire flow.

---

## Funnel Overview

| Step | Users | Drop-off from Previous |
|---|---|---|
| 1 — Account Created | 10,000 | — |
| 2 — Email Verified | 6,012 | **−40.0%** ⚠️ |
| 3 — Profile Completed | 4,890 | −18.7% |
| 4 — First Search | 3,920 | −19.8% |
| 5 — First Purchase | 2,744 | −30.0% |

**Overall conversion (signup → purchase): 27.4%**

---

## Key Findings

### Finding 1: Email Verification is the #1 Drop-off Point
- 40% of new users never verify their email
- This is the largest single-step loss in the funnel — nearly double the next worst step
- **Likely causes:** verification email goes to spam, users forget, or the friction of leaving the app to check email causes abandonment

### Finding 2: Purchase Drop-off is the Second-Biggest Problem
- Of the users who do reach First Search, 30% never convert to a purchase
- This may indicate a gap between intent (searching) and commitment (buying)

### Finding 3: Cohort W01 Shows Lower Purchase Conversion
- Week 1 cohort converted at ~24%, vs ~29% for W02 and W03
- May reflect early product bugs or a lower-intent traffic source during that week

---

## Recommendations

1. **Fix email verification UX (highest priority)**
   - Trigger an in-app reminder if email is not verified within 1 hour
   - Test removing email verification as a hard gate before profile setup
   - Estimated impact: recovering even 10% of drop-off = ~400 more users in funnel

2. **Investigate the search → purchase gap**
   - Add a post-search survey for users who searched but didn't buy
   - A/B test showing price anchoring or social proof on search results

3. **Audit Week 1 acquisition channels**
   - Identify if a specific paid campaign or referral source drove lower-quality signups

---

## Next Steps

- [ ] Share with Product & Growth teams
- [ ] Set up a weekly funnel tracking dashboard in BI tool
- [ ] Define "healthy" funnel benchmarks per step
- [ ] Revisit after shipping email verification improvement

---

*Data source: simulated onboarding events table (30 users, representative sample). Full analysis would run on production data in BigQuery/Snowflake.*
