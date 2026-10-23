-- Clinic Appointments Database (SQLite)
-- A small relational model for a fictional group of clinics.

DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS doctor;
DROP TABLE IF EXISTS clinic;

CREATE TABLE clinic (
    clinic_id   INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    town        TEXT NOT NULL
);

CREATE TABLE doctor (
    doctor_id   INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    specialty   TEXT NOT NULL,
    clinic_id   INTEGER NOT NULL REFERENCES clinic(clinic_id)
);

CREATE TABLE patient (
    patient_id  INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    birth_year  INTEGER
);

CREATE TABLE appointment (
    appointment_id INTEGER PRIMARY KEY,
    patient_id     INTEGER NOT NULL REFERENCES patient(patient_id),
    doctor_id      INTEGER NOT NULL REFERENCES doctor(doctor_id),
    appt_date      TEXT NOT NULL,
    status         TEXT NOT NULL CHECK (status IN ('attended', 'cancelled', 'no-show'))
);

-- Sample data (fictional)
INSERT INTO clinic VALUES
    (1, 'Galway Central', 'Galway'),
    (2, 'Salthill Health', 'Salthill'),
    (3, 'Oranmore Medical', 'Oranmore');

INSERT INTO doctor VALUES
    (1, 'Dr. Claire Nolan', 'General Practice', 1),
    (2, 'Dr. Mark Doyle', 'Physiotherapy', 1),
    (3, 'Dr. Emma Quinn', 'General Practice', 2),
    (4, 'Dr. Liam Burke', 'Dermatology', 3);

INSERT INTO patient VALUES
    (1, 'Mary O''Brien', 1985),
    (2, 'John Murphy', 1972),
    (3, 'Aoife Kelly', 1999),
    (4, 'Sean Walsh', 1964),
    (5, 'Niamh Byrne', 2001);

INSERT INTO appointment VALUES
    (1, 1, 1, '2026-01-14', 'attended'),
    (2, 2, 3, '2026-01-15', 'cancelled'),
    (3, 3, 1, '2026-01-16', 'no-show'),
    (4, 4, 4, '2026-01-17', 'attended'),
    (5, 5, 2, '2026-01-20', 'attended'),
    (6, 1, 2, '2026-01-22', 'attended'),
    (7, 3, 3, '2026-01-23', 'no-show'),
    (8, 2, 1, '2026-01-27', 'attended');
