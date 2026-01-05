USE hospitalDB;
GO

-- Total appointments by month
SELECT
  YEAR(appointment_date) AS yr,
  MONTH(appointment_date) AS mn,
  COUNT(*) AS total_appointments,
  SUM(is_completed) AS completed,
  SUM(is_cancelled) AS cancelled,
  SUM(is_pending) AS pending
FROM analytics.vw_fact_appointments
GROUP BY YEAR(appointment_date), MONTH(appointment_date)
ORDER BY yr, mn;

-- Cancellation rate by department
SELECT
  dep.department_name,
  COUNT(*) AS total,
  SUM(f.is_cancelled) AS cancelled,
  CAST(1.0 * SUM(f.is_cancelled) / NULLIF(COUNT(*),0) AS decimal(10,4)) AS cancellation_rate
FROM analytics.vw_fact_appointments f
JOIN analytics.vw_dim_department dep ON f.DepartmentID = dep.DepartmentID
GROUP BY dep.department_name
ORDER BY cancellation_rate DESC;
