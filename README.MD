Hospital Operations Analytics

SQL Server + Power BI Dashboard

📌 Project Overview

This project demonstrates how operational hospital data can be transformed into actionable insights using Microsoft SQL Server and Power BI.
The focus is on appointments performance, cancellations, doctor utilisation, and patient trends, similar to real-world operational analytics roles.

🎯 Business Problem

Hospitals need visibility into:

Appointment volumes and trends

Cancellation rates by department

Doctor utilisation and workload

Operational bottlenecks affecting patient care

This project answers these questions through a structured analytics layer and interactive dashboards.

🛠️ Tools & Technologies

Microsoft SQL Server

SQL Server Management Studio (SSMS)

Power BI Desktop

DAX (for KPIs)

Synthetic data generation

🗄️ Database Design

The system is designed in two layers:

1️⃣ OLTP Layer (Transactional)

Patients

Doctors

Departments

Appointments

Diagnoses

Medications

Reviews

This simulates a real hospital management system.

2️⃣ Analytics Layer (Reporting)

Created using SQL views for Power BI:

analytics.vw_fact_appointments

analytics.vw_dim_patient

analytics.vw_dim_doctor

analytics.vw_dim_department

This separation mirrors industry best practices.

📊 Key KPIs & Metrics

The following KPIs were developed using SQL and DAX:

Total Appointments

Completed Appointments

Cancelled Appointments

Cancellation Rate (%)

Appointment Trends by Month

Doctor Utilisation (completed appointments)

Cancellation Rate by Department

Patient Age Band Analysis

📈 Power BI Dashboard Pages
🔹 Executive Summary

Overall appointment volume

Completion vs cancellation overview

Key operational KPIs

🔹 Operations Trend

Monthly appointment trends

Department-wise performance

🔹 Doctor Utilisation

Completed appointments per doctor

Specialty-level workload analysis

🔹 Cancellations Analysis

Cancellation rate by department

Deep-dive filtering using slicers

🧠 Key Insights

Certain departments show consistently higher cancellation rates

Doctor workload varies significantly by specialty

Appointment volumes fluctuate seasonally

Operational inefficiencies can be identified using data-driven KPIs

📂 Repository Structure
/sql/
  01_create_tables.sql
  02_analytics_views.sql
  03_kpi_queries.sql

/powerbi/
  hospital-operations-analytics.pbix

/visuals/
  executive_summary.png
  operations_trend.png
  doctor_utilisation.png
  cancellations_analysis.png

/docs/
  data_dictionary.md

README.md

🚀 How to Run This Project

Run SQL scripts in order using SSMS:

01_create_tables.sql

02_analytics_views.sql

03_kpi_queries.sql

Open hospital-operations-analytics.pbix in Power BI Desktop

Refresh data connection

Explore dashboards

💼 Why This Project Matters

This project demonstrates:

Strong SQL querying & modelling

Understanding of analytics vs transactional systems

KPI design aligned with business questions

End-to-end workflow from database → dashboard

It reflects skills required for Data Analyst / Business Intelligence roles.

👤 Author

Amit Tiwari
Aspiring Data Analyst | SQL | Power BI | Data Analytics