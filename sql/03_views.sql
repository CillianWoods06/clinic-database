-- A single wide view joining all tables, so reports (and Power BI)
-- don't have to repeat the same joins.

CREATE VIEW v_appointment_details AS
SELECT
    a.appointment_id,
    a.appt_date,
    strftime('%Y-%m', a.appt_date)                        AS appt_month,
    a.booked_on,
    julianday(a.appt_date) - julianday(a.booked_on)       AS lead_days,
    a.status,
    c.name                                                AS clinic,
    d.full_name                                           AS doctor,
    d.specialty,
    s.name                                                AS service,
    CASE WHEN a.status = 'attended' THEN s.fee ELSE 0 END AS revenue,
    p.patient_id,
    p.county
FROM appointment a
JOIN doctor  d ON d.doctor_id  = a.doctor_id
JOIN clinic  c ON c.clinic_id  = d.clinic_id
JOIN service s ON s.service_id = a.service_id
JOIN patient p ON p.patient_id = a.patient_id;
