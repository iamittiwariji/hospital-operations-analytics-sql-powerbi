USE hospitalDB;
GO

CREATE SCHEMA analytics;
GO

CREATE OR ALTER VIEW analytics.vw_fact_appointments AS
SELECT
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    doc.DepartmentID,
    CAST(a.appointment_date AS date) AS appointment_date,
    a.appointment_time,
    a.status,
    CASE WHEN a.status='completed' THEN 1 ELSE 0 END AS is_completed,
    CASE WHEN a.status='cancelled' THEN 1 ELSE 0 END AS is_cancelled,
    CASE WHEN a.status='pending' THEN 1 ELSE 0 END AS is_pending
FROM Appointments a
JOIN Doctors doc ON a.doctor_id = doc.doctor_id;
GO

CREATE OR ALTER VIEW analytics.vw_dim_doctor AS
SELECT doctor_id, full_name, specialty, DepartmentID
FROM Doctors;
GO

CREATE OR ALTER VIEW analytics.vw_dim_department AS
SELECT DepartmentID, department_name
FROM Departments;
GO

CREATE OR ALTER VIEW analytics.vw_dim_patient AS
SELECT patient_id, full_name, date_of_birth, RegistrationDate, active
FROM Patients;
GO
