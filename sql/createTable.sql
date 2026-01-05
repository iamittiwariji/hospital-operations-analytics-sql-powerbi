
-- Creating hospital database with the name hospitalDB 
CREATE DATABASE hospitalDB;

--used to switch the current database context  named "hospitalDB".

USE hospitalDB;
go


----Patients Table (

CREATE TABLE Patients (
  patient_id INT PRIMARY KEY IDENTITY(1,1),
  full_name NVARCHAR(255) NOT NULL,
  address NVARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  RegistrationDate DATE NOT NULL,
  DateLeft DATE,
  phone_number NVARCHAR(20),
  email NVARCHAR(255) UNIQUE,  -- Unique email address
  active BIT DEFAULT 1  -- Flag to indicate active status (1 for true, 0 for false)
);

-- PatientInsurance table
CREATE TABLE PatientInsurance (
	insuranceID INT PRIMARY KEY IDENTITY(1,1),
	policyNumber NVARCHAR(255) NOT NULL,
	patient_id INT FOREIGN KEY (patient_id)
REFERENCES Patients(patient_id)
);

-- login table

CREATE TABLE LoginDB (
	loginID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Username NVARCHAR(40) NOT NULL,
	PasswordHash BINARY(64) NOT NULL,
	Salt UNIQUEIDENTIFIER,
);

Alter table LoginDB
ADD  patient_id INT;

ALTER TABLE LoginDB
ADD CONSTRAINT FK_login_Patient FOREIGN KEY (patient_id)
REFERENCES Patients(patient_id);


--Departments Table:

CREATE TABLE Departments (
  DepartmentID INT PRIMARY KEY IDENTITY(1,1),
  department_name NVARCHAR(255) NOT NULL  -- NVARCHAR for Unicode character support
);

--Doctors Table:

CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY IDENTITY(1,1),
  full_name NVARCHAR(255) NOT NULL,        -- NVARCHAR for Unicode character support
  specialty NVARCHAR(255),
  DepartmentID INT FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID)
);


--Appointments Table (Modified):

CREATE TABLE Appointments (
  appointment_id INT PRIMARY KEY IDENTITY(1,1),
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id) NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'cancelled', 'completed')),
  is_available BIT NOT NULL DEFAULT(0)
);

-- Appointmentsrecovery table
CREATE TABLE Appointmentsrecovery (
  appointment_id INT,
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id) NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'cancelled', 'completed')),
  is_available BIT NOT NULL DEFAULT(0)
);


INSERT INTO Appointmentsrecovery (appointment_id, patient_id, doctor_id,appointment_date,appointment_time,status,is_available)
SELECT appointment_id, patient_id, doctor_id,appointment_date,appointment_time,status,is_available
FROM Appointments;

--We can add a new table to store doctor schedules:

CREATE TABLE Doctor_Schedules ( 
	schedule_id INT PRIMARY KEY IDENTITY(1,1), 
	doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id), 
	day_of_week NVARCHAR(20), 
	start_time TIME, 
	end_time TIME 
);

--Diagnoses Table:

CREATE TABLE Diagnoses (
  diagnosis_id INT PRIMARY KEY IDENTITY(1,1),
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  appointment_id INT FOREIGN KEY REFERENCES Appointments(appointment_id),
  diagnosis_name NVARCHAR(255) NOT NULL  -- Detailed diagnosis information
);

--Medications

CREATE TABLE Medications (
  medication_id INT PRIMARY KEY IDENTITY(1,1),
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  appointment_id INT FOREIGN KEY REFERENCES Appointments(appointment_id),
  medication_name NVARCHAR(255) NOT NULL,  -- Medication name
  dosage NVARCHAR(255)  -- Dosage information (optional)
);

--Allergies 

CREATE TABLE Allergies (
  allergy_id INT PRIMARY KEY IDENTITY(1,1),
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  allergen NVARCHAR(255) NOT NULL  -- Allergen name
);


--Reviews 

CREATE TABLE Reviews (
  review_id INT PRIMARY KEY IDENTITY(1,1),
  patient_id INT FOREIGN KEY REFERENCES Patients(patient_id) NOT NULL,
  doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id) NOT NULL,
  appointment_id INT FOREIGN KEY REFERENCES Appointments(appointment_id),
  rating INT CHECK (rating >= 1 AND rating <= 5),  -- Rating between 1 (poor) and 5 (excellent)
  review_text TEXT  -- Optional review text
);


-- insert query's for inserting sample data into table's

--login Store PROCEDURE 

CREATE PROCEDURE uspAddLoginDB1
	@username NVARCHAR(50),
	@password NVARCHAR(50)
		
AS
DECLARE 
	@salt UNIQUEIDENTIFIER=NEWID()
	INSERT INTO LoginDB (
					Username, 
					PasswordHash, 
					Salt)
					VALUES(@username, HASHBYTES('SHA2_512',@password+CAST(@salt AS NVARCHAR(36))), @salt);

EXECUTE uspAddLoginDB1 
	@username = 'Amit113', 
	@password ='Amit@ssword!' 
	
	

SELECT * FROM LoginDB

-- inser into insert sample data in tables

INSERT INTO Patients (full_name, address, date_of_birth, RegistrationDate, phone_number, email)
VALUES
  ('John Smith', '123 Main St, Anytown, CA 12345', '1980-03-15', GETDATE(), '555-123-4567', 'john.smith@gmail.com'),
  ('Emily Johnson', '456 Elm St, Anytown, CA 12345', '1975-08-20', '2024-04-20', '555-234-5678', 'emily.johnson@gmail.com'),
  ('Michael Brown', '789 Oak St, Anytown, CA 12345', '1990-06-10', '2024-04-18', '555-345-6789', 'michael.brown@gmail.com'),
  ('Olivia Davis', '1011 Pine St, Anytown, CA 12345', '1985-12-09', '2024-04-16', '555-456-7890', 'olivia.davis@gmail.com'),
  ('William Wilson', '1213 Spruce St, Anytown, CA 12345', '1978-05-23', GETDATE(), '555-567-8901', 'william.wilson@gmail.com'),
  ('Sophia Martinez', '1415 Maple St, Anytown, CA 12345', '1995-09-04', '2024-04-12', '555-678-9012', 'sophia.martinez@gmail.com'),
  ('David Anderson', '1617 Elm St, Anytown, CA 12345', '1982-02-17', '2024-04-10', '555-789-0123', 'david.anderson@gmail.com'),
  ('Amanda Taylor', '1819 Oak St, Anytown, CA 12345', '1992-06-06', '2024-04-08', '555-890-1234', 'amanda.taylor@gmail.com'),
  ('Daniel Garcia', '2021 Pine St, Anytown, CA 12345', '1979-11-20', '2024-04-06', '555-901-2345', 'daniel.garcia@gmail.com'),
  ('Elizabeth Hernandez', '2223 Spruce St, Anytown, CA 12345', '1988-04-11', GETDATE(), '555-012-3456', 'elizabeth.hernandez@gmail.com');

 
  select * from Patients;


  INSERT INTO Departments (department_name)
VALUES
('Cardiology'),
('Dermatology'),
('Endocrinology'),
('Gastroenterology'),
('Geriatrics'),
('Hematology'),
('Immunology'),
('Infectious Diseases'),
('Neurology'),
('Nephrology');


INSERT INTO Doctors (full_name, specialty, DepartmentID)
VALUES
('Dr. John Doe', 'Cardiology', 1),
('Dr. Jane Smith', 'Dermatology', 2),
('Dr. Jim Brown', 'Endocrinology', 3),
('Dr. Jake White', 'Gastroenterology', 4),
('Dr. Jill Black', 'Geriatrics', 5),
('Dr. Joe Green', 'Hematology', 6),
('Dr. Jessica Blue', 'Immunology', 7),
('Dr. James Yellow', 'Infectious Diseases', 8),
('Dr. Joyce Purple', 'Neurology', 9),
('Dr. Juan Red', 'Nephrology', 10);

select * from doctors;

UPDATE doctors
SET specialty = 'Gastroenterologists'
WHERE doctor_id = 4;


INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
 (13, 2, '2024-04-25', '10:00:00', 'pending'),  -- John Doe with Dr. Smith (patient_id 1, doctor_id 2)
  (14, 1, '2024-04-27', '14:00:00', 'pending'),  -- Michael Lee with Dr. Jones (patient_id 3, doctor_id 1)
  (15, 3, '2024-05-02', '11:30:00', 'pending'),  -- William Miller with Dr. Garcia (patient_id 5, doctor_id 3)
  (17, 2, '2024-05-09', '09:15:00', 'cancelled'), -- David Hernandez with Dr. Smith (patient_id 7, doctor_id 2) Cancelled appointment
  (16, 1, '2024-05-14', '16:00:00', 'pending'), -- Daniel Johnson with Dr. Jones (patient_id 9, doctor_id 1)
  (13, 4, '2024-04-25', '10:00:00', 'completed'),  -- John Doe with Dr. Smith (patient_id 1, doctor_id 2)
  (14, 4, '2024-04-27', '14:00:00', 'completed'),  -- Michael Lee with Dr. Jones (patient_id 3, doctor_id 1)
  (15, 4, '2024-05-02', '11:30:00', 'completed'),  -- William Miller with Dr. Garcia (patient_id 5, doctor_id 3)
  (17, 4, '2024-05-09', '09:15:00', 'completed'), -- David Hernandez with Dr. Smith (patient_id 7, doctor_id 2) Cancelled appointment
  (16, 4, '2024-05-14', '16:00:00', 'completed') -- Daniel Johnson with Dr. Jones (patient_id 9, doctor_id 1)
;

select * from appointments



INSERT INTO Diagnoses (patient_id, appointment_id, diagnosis_name)
VALUES
(12, 2, 'cancer'),
(21, 3, 'Diabetes Mellitus'),
(13, 4, 'Asthma'),
(14, 5, 'Osteoarthritis'),
(15, 6, 'Depression'),
(16, 7, 'cancer'),
(17, 8, 'cancer'),
(18, 9, 'Hyperlipidemia'),
(19, 10, 'Gastroesophageal Reflux Disease (GERD)'),
(20, 11, 'Thyroid Disorders');


INSERT INTO Medications (patient_id, appointment_id, medication_name, dosage)
VALUES
(12, 1, 'Paracetamol', '1 tablet twice daily'),
(13, 2, 'Paracetamol', '1 capsule once daily'),
(14, 3, 'Salbutamol Inhaler', '1 inhaler twice daily'),
(15, 4, 'Bisacodyl', '1 suppository three times daily'),
(16, 5, 'Insulin', '1 injection once daily'),
(17, 6, 'Hydrocortisone Cream', '1 cream apply topically twice daily'),
(18, 7, 'Nicotine Patch', '1 patch apply once daily'),
(19, 8, 'GTN Spray', '1 spray in the nose twice daily'),
(20, 9, 'Beclometasone Nasal Spray', '1 spray in the nose twice daily'),
(21, 10, 'Ciprofloxacin Ear Drops', '1 ear drop twice daily');


INSERT INTO Allergies (patient_id, allergen)
VALUES
(21, 'Penicillin'),
(12, 'Peanuts'),
(13, 'Eggs'),
(14, 'Shellfish'),
(15, 'Strawberries'),
(16, 'Pollen'),
(17, 'Dust Mites'),
(18, 'Cats'),
(19, 'Dogs'),
(20, 'Latex');


INSERT INTO Reviews (patient_id, doctor_id, appointment_id, rating, review_text)
VALUES
(21, 1, 1, 5, 'Excellent care, very knowledgeable and professional.'),
(12, 3, 2, 3, 'The doctor was okay, but the wait time was too long.'),
(13, 5, 3, 4, 'The doctor was very helpful and explained everything clearly.'),
(14, 7, 4, 5, 'I had a great experience, the doctor was very caring and attentive.'),
(15, 9, 5, 2, 'The doctor did not seem interested in my concerns, and the appointment was rushed.'),
(16, 2, 6, 5, 'The doctor was fantastic, I am very satisfied with the care I received.'),
(17, 4, 7, 4, 'The doctor was knowledgeable and helpful, but the appointment was too short.'),
(18, 6, 8, 5, 'Excellent care, I would highly recommend this doctor to others.'),
(19, 8, 9, 3, 'The doctor was not very friendly, and I did not feel comfortable.'),
(20, 10, 10, 4, 'The doctor was very professional and provided good care.');



--q2Add the constraint to check that the appointment date is not in the past

FROM INFORMATION_SCHEMA TABLE_CONSTRAINTS 6 WHERE TABLE_NAME = 'Appointments' AND CONSTRAINT_NAME='CHK_AppointmentDate';



ALTER TABLE Appointments
ADD CONSTRAINT chk_AppointmentDate CHECK (appointment_date >= CAST(GETDATE() AS DATE));

SELECT *
FROM Appointments
WHERE appointment_date <GETDATE();

--q3 List all the patients with older than 40 and have Cancer in diagnosis.

SELECT p.patient_id, p.full_name, p.date_of_birth
FROM Patients p
JOIN Diagnoses d ON p.patient_id = d.patient_id
WHERE DATEDIFF(year, p.date_of_birth, GETDATE()) > 40
AND d.diagnosis_name LIKE '%Cancer%';


--q4Search the database of the hospital for matching character strings by name of
--medicine. Results should be sorted with most recent medicine prescribed date first. 

CREATE PROCEDURE st_P_for_SearchMedicinesByName (
	@medicine_name NVARCHAR(255)
)
AS
BEGIN
  SELECT m.medication_name, p.full_name AS patient_name, a.appointment_date
  FROM Medications m
  INNER JOIN Appointments a ON m.appointment_id = a.appointment_id
  INNER JOIN Patients p ON a.patient_id = p.patient_id
  WHERE m.medication_name LIKE '%' + @medicine_name + '%'
  ORDER BY a.appointment_date DESC;
END;

EXEC st_P_for_SearchMedicinesByName 'Paracetamol';

/*B Return a full list of diagnosis and allergies for a specific patient who has an
appointment today*/

CREATE FUNCTION retrieve_PatientDiagnosisAndAllergies
(
  @PatientId INT
)
RETURNS TABLE
AS
RETURN
(
  SELECT d.diagnosis_name, a.appointment_date, a.appointment_time, aa.allergen
  FROM Diagnoses d
  JOIN Appointments a ON d.appointment_id = a.appointment_id
  LEFT JOIN Allergies aa ON aa.patient_id = @PatientId
  WHERE a.patient_id = @PatientId
  AND a.appointment_date = CAST(GETDATE() AS DATE)
);
select * from Patients

INSERT INTO Patients (full_name, address, date_of_birth, RegistrationDate, phone_number, email)
VALUES
('Amit T', '123 Main St', '1980-01-01', 
GETDATE(), '555-123-4567', 'amit.doe@gmail.com')
select * from Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
(22, 1, GETDATE(), '10:00:00', 'pending')
INSERT INTO Diagnoses (patient_id, appointment_id, diagnosis_name)
VALUES
(22, 10, 'cancer')

SELECT * FROM retrieve_PatientDiagnosisAndAllergies(22);


-- c ) Update the details for an existing doctor


CREATE PROCEDURE sp_for_UpdateDoctorDetailsinDB (
  @doctor_id INT,
  @full_name NVARCHAR(255),
  @specialty NVARCHAR(255)
)
AS
BEGIN
  UPDATE Doctors
  SET full_name = @full_name,
    specialty = @specialty
  WHERE doctor_id = @doctor_id;
END;

select * from Doctors


EXEC sp_for_UpdateDoctorDetailsinDB 1,'Dr. Amit Tiwari', 'Cardiology';

select * from Doctors

--d Delete the appointment who status is already completed

UPDATE Appointments SET status = 'completed' WHERE appointment_id =2;

select * from Appointments;


CREATE PROCEDURE DeleteComAppointment3 
AS 
BEGIN 
-- Delete associated medications 
	DELETE Medications WHERE appointment_id IN ( SELECT appointment_id FROM Appointments WHERE status = 'completed' );

-- Delete associated reviews 
	DELETE Reviews WHERE appointment_id IN ( SELECT appointment_id FROM Appointments WHERE status = 'completed' );

-- Delete associated diagnoses 
	DELETE Diagnoses WHERE appointment_id IN ( SELECT appointment_id FROM Appointments WHERE status = 'completed' );
-- Delete completed appointments 
	DELETE Appointments WHERE status = 'completed'; 
END;


EXEC DeleteComAppointment3;

select * from Appointments

-- 5 e hospitals wants to view the appointment date and time, showing all previous

CREATE VIEW vw_DoctorAppointmentsReviews 
AS 
SELECT 
	a.appointment_id, 
	a.appointment_date, 
	a.appointment_time, 
	p.full_name AS patient_name, 
	d.department_name, 
	doc.full_name AS doctor_name, 
	doc.specialty, r.rating, 
	r.review_text 
FROM Appointments a 
INNER JOIN Doctors doc ON a.doctor_id = doc.doctor_id 
INNER JOIN Departments d ON doc.DepartmentID = d.DepartmentID 
LEFT JOIN Patients p ON a.patient_id = p.patient_id 
LEFT JOIN Reviews r ON a.appointment_id = r.appointment_id;


SELECT * FROM vw_DoctorAppointmentsReviews;

--6 Create a trigger so that the current state of an appointment can be changed

CREATE TRIGGER update_appointment_state
ON Appointments
AFTER DELETE
AS
BEGIN
  UPDATE Appointments
  SET is_available = 1
  WHERE  Appointments.status = 'cancelled';
END;

--7Write a select query which allows the hospital to identify the number of
--completed appointments with the specialty of doctors as ‘Gastroenterologists’.

SELECT COUNT(*) AS num_completed_appointments
FROM Appointments a
INNER JOIN Doctors doc ON a.doctor_id = doc.doctor_id
WHERE a.status = 'completed'
  AND doc.specialty = 'Gastroenterologists';



  -- create login and password
CREATE LOGIN AMITTIWARI
WITH PASSWORD = 'Amit!1234';

-- create use
CREATE USER AMITTIWARI 
FOR LOGIN AMITTIWARI;
GO
-- create role
CREATE ROLE Appointments;

-- alter the role
ALTER ROLE Appointments ADD MEMBER AMITTIWARI

-- grant
GRANT SELECT ON Appointments TO AMITTIWARI;
-- backup database
BACKUP DATABASE HospitalDB
TO DISK ='C:\amit\HospitalDB_BACKUP\HospitalDB_Backupcheck.bak'
WITH CHECKSUM;
-- verify restore
RESTORE VERIFYONLY
FROM DISK='C:\amit\HospitalDB_BACKUP\HospitalDB_Backupcheck.bak'
WITH CHECKSUM;