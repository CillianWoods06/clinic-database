-- =============================================================
-- Clinic Appointments Database - schema (SQLite)
-- Normalised to 3NF: each fact is stored once, linked by keys.
-- =============================================================

PRAGMA foreign_keys = ON;

DROP VIEW  IF EXISTS v_appointment_details;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS service;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS doctor;
DROP TABLE IF EXISTS clinic;

CREATE TABLE clinic (
    clinic_id   INTEGER PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
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
    birth_year  INTEGER CHECK (birth_year BETWEEN 1920 AND 2026),
    county      TEXT NOT NULL
);

-- Price lives here, not on each appointment, so a price change is made in one place
CREATE TABLE service (
    service_id  INTEGER PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    fee         REAL NOT NULL CHECK (fee >= 0)
);

CREATE TABLE appointment (
    appointment_id INTEGER PRIMARY KEY,
    patient_id     INTEGER NOT NULL REFERENCES patient(patient_id),
    doctor_id      INTEGER NOT NULL REFERENCES doctor(doctor_id),
    service_id     INTEGER NOT NULL REFERENCES service(service_id),
    booked_on      TEXT NOT NULL,                       -- date the booking was made
    appt_date      TEXT NOT NULL,                       -- date of the appointment
    status         TEXT NOT NULL CHECK (status IN ('attended', 'cancelled', 'no-show')),
    CHECK (appt_date >= booked_on)
);

-- Indexes on the columns used most in joins and filters
CREATE INDEX idx_appointment_date    ON appointment(appt_date);
CREATE INDEX idx_appointment_doctor  ON appointment(doctor_id);
CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_doctor_clinic       ON doctor(clinic_id);
