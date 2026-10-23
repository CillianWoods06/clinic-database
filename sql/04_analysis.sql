-- =============================================================
-- Business questions. Each query is separated by a "-- name:" line
-- so scripts/run_reports.py can run them and export each to CSV.
-- =============================================================

-- name: clinic_performance
-- How does each clinic compare on volume, no-shows and revenue?
SELECT clinic,
       COUNT(*)                                                  AS appointments,
       SUM(status = 'attended')                                  AS attended,
       ROUND(100.0 * SUM(status = 'no-show') / COUNT(*), 1)      AS no_show_pct,
       ROUND(SUM(revenue), 2)                                    AS revenue
FROM v_appointment_details
GROUP BY clinic
ORDER BY revenue DESC;

-- name: monthly_revenue_trend
-- Revenue per month, with month-on-month change (window function LAG)
WITH monthly AS (
    SELECT appt_month, ROUND(SUM(revenue), 2) AS revenue
    FROM v_appointment_details
    GROUP BY appt_month
)
SELECT appt_month,
       revenue,
       ROUND(revenue - LAG(revenue) OVER (ORDER BY appt_month), 2) AS change_vs_prev_month
FROM monthly
ORDER BY appt_month;

-- name: no_show_by_lead_time
-- Are appointments booked further in advance missed more often?
SELECT CASE
         WHEN lead_days <= 2  THEN '0-2 days'
         WHEN lead_days <= 7  THEN '3-7 days'
         WHEN lead_days <= 14 THEN '8-14 days'
         ELSE '15+ days'
       END                                                       AS booked_ahead,
       COUNT(*)                                                  AS appointments,
       ROUND(100.0 * SUM(status = 'no-show') / COUNT(*), 1)      AS no_show_pct
FROM v_appointment_details
GROUP BY booked_ahead
ORDER BY MIN(lead_days);

-- name: doctor_ranking
-- Rank doctors by revenue within their clinic (window function RANK)
SELECT clinic,
       doctor,
       specialty,
       ROUND(SUM(revenue), 2)                                            AS revenue,
       RANK() OVER (PARTITION BY clinic ORDER BY SUM(revenue) DESC)      AS rank_in_clinic
FROM v_appointment_details
GROUP BY clinic, doctor, specialty
ORDER BY clinic, rank_in_clinic;

-- name: revenue_by_service
-- Which services earn the most, and what share of total revenue?
SELECT service,
       SUM(status = 'attended')                                          AS attended,
       ROUND(SUM(revenue), 2)                                            AS revenue,
       ROUND(100.0 * SUM(revenue) / (SELECT SUM(revenue) FROM v_appointment_details), 1) AS revenue_share_pct
FROM v_appointment_details
GROUP BY service
ORDER BY revenue DESC;

-- name: repeat_no_show_patients
-- Patients with 2+ no-shows: candidates for reminder texts (CTE + HAVING)
WITH missed AS (
    SELECT patient_id, COUNT(*) AS no_shows
    FROM appointment
    WHERE status = 'no-show'
    GROUP BY patient_id
    HAVING COUNT(*) >= 2
)
SELECT p.full_name, p.county, m.no_shows
FROM missed m
JOIN patient p ON p.patient_id = m.patient_id
ORDER BY m.no_shows DESC, p.full_name;
