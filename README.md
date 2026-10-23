# Clinic Appointments Database

A small relational database for a fictional group of clinics, designed from an ERD and queried with SQL to answer business questions.

## ERD
```mermaid
erDiagram
    CLINIC ||--o{ DOCTOR : employs
    DOCTOR ||--o{ APPOINTMENT : handles
    PATIENT ||--o{ APPOINTMENT : books

    CLINIC { int clinic_id PK
             string name
             string town }
    DOCTOR { int doctor_id PK
             string full_name
             string specialty
             int clinic_id FK }
    PATIENT { int patient_id PK
              string full_name
              int birth_year }
    APPOINTMENT { int appointment_id PK
                  int patient_id FK
                  int doctor_id FK
                  string appt_date
                  string status }
```

## Questions answered (`queries.sql`)
1. Appointments per clinic
2. No-show rate per clinic
3. Patients who have missed an appointment
4. Busiest doctor by attended appointments

## Run it
```bash
sqlite3 clinic.db < schema.sql
sqlite3 -header -column clinic.db < queries.sql
```

## Skills shown
Data modelling (ERD), normalisation, primary/foreign keys, constraints, joins, aggregation.

*All data is fictional.*
