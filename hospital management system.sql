-- Hospital Management System SQL Project

-- Step 1: Create Tables

CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(15),
    address TEXT
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(15),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status ENUM('Scheduled', 'Completed', 'Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    medicine VARCHAR(100),
    dosage VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

CREATE TABLE Bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    amount DECIMAL(10,2),
    bill_date DATE,
    status ENUM('Unpaid', 'Paid'),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Step 2: Insert Sample Data

INSERT INTO Departments (name) VALUES ('Cardiology'), ('Neurology'), ('Orthopedics');

INSERT INTO Patients (name, age, gender, phone, address) VALUES
('John Doe', 30, 'Male', '1234567890', '123 Main St'),
('Jane Smith', 40, 'Female', '0987654321', '456 Oak Ave');

INSERT INTO Doctors (name, specialization, phone, department_id) VALUES
('Dr. Adams', 'Cardiologist', '1112223333', 1),
('Dr. Baker', 'Neurologist', '4445556666', 2);

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1, 1, '2025-04-10', 'Completed'),
(2, 2, '2025-04-11', 'Scheduled'),
(1, 2, '2025-04-12', 'Scheduled');

INSERT INTO Prescriptions (appointment_id, medicine, dosage, notes) VALUES
(1, 'Aspirin', '75mg', 'Take after meals'),
(2, 'Ibuprofen', '200mg', 'Twice a day');

INSERT INTO Bills (patient_id, amount, bill_date, status) VALUES
(1, 500.00, '2025-04-10', 'Paid'),
(2, 300.00, '2025-04-11', 'Unpaid');

-- Step 3: Sample Queries

-- Most active doctor
SELECT d.name, COUNT(*) AS total_appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC
LIMIT 1;

-- Patients with more than 1 appointment
SELECT p.name, COUNT(*) AS total_appointments
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id
HAVING total_appointments > 1;

-- Step 4: Trigger Example
DELIMITER //
CREATE TRIGGER update_bill_after_prescription
AFTER INSERT ON Prescriptions
FOR EACH ROW
BEGIN
  UPDATE Bills
  SET amount = amount + 100
  WHERE patient_id = (
    SELECT patient_id FROM Appointments WHERE appointment_id = NEW.appointment_id
  );
END;//
DELIMITER ;
