-- Business questions answered with SQL

-- 1. How many appointments did each clinic have?
SELECT c.name AS clinic, COUNT(a.appointment_id) AS appointments
FROM clinic c
LEFT JOIN doctor d ON d.clinic_id = c.clinic_id
LEFT JOIN appointment a ON a.doctor_id = d.doctor_id
GROUP BY c.name
ORDER BY appointments DESC;

-- 2. What is the no-show rate per clinic?
SELECT c.name AS clinic,
       ROUND(100.0 * SUM(a.status = 'no-show') / COUNT(*), 1) AS no_show_pct
FROM appointment a
JOIN doctor d ON d.doctor_id = a.doctor_id
JOIN clinic c ON c.clinic_id = d.clinic_id
GROUP BY c.name
ORDER BY no_show_pct DESC;

-- 3. Which patients have missed an appointment?
SELECT DISTINCT p.full_name
FROM patient p
JOIN appointment a ON a.patient_id = p.patient_id
WHERE a.status = 'no-show';

-- 4. Busiest doctor by attended appointments
SELECT d.full_name, d.specialty, COUNT(*) AS attended
FROM appointment a
JOIN doctor d ON d.doctor_id = a.doctor_id
WHERE a.status = 'attended'
GROUP BY d.doctor_id
ORDER BY attended DESC
LIMIT 1;
