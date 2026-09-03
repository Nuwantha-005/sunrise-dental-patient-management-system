
CREATE DATABASE IF NOT EXISTS sunrise_dental;
USE sunrise_dental;

-- Users (Admin / Staff login)
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100),
    contact_no    VARCHAR(20),
    password_hash VARCHAR(64)  NOT NULL,
    role          VARCHAR(20)  DEFAULT 'ADMIN',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dentists
CREATE TABLE dentists (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    dentist_code   VARCHAR(20) UNIQUE,
    name           VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    contact        VARCHAR(20)
);

-- Patients
CREATE TABLE patients (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    address      VARCHAR(255),
    contact      VARCHAR(20),
    email        VARCHAR(100)
);

-- Appointments
CREATE TABLE appointments (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    appointment_no   VARCHAR(20) NOT NULL UNIQUE,
    patient_id       INT NOT NULL,
    dentist_id       INT NOT NULL,
    treatment_type   VARCHAR(100),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status           VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (dentist_id) REFERENCES dentists(id)
);

-- Bills
CREATE TABLE bills (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    bill_no        VARCHAR(20) NOT NULL UNIQUE,
    appointment_id INT NOT NULL UNIQUE,
    total_amount   DECIMAL(10,2) NOT NULL DEFAULT 0,
    bill_date      DATE NOT NULL,
    status         VARCHAR(20) DEFAULT 'Unpaid',
    FOREIGN KEY (appointment_id) REFERENCES appointments(id)
);

-- Bill line items
CREATE TABLE bill_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    bill_id     INT NOT NULL,
    description VARCHAR(200) NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE
);

-- Contact messages from public website
CREATE TABLE contact_messages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(255) NOT NULL,
    phone       VARCHAR(30)  DEFAULT NULL,
    subject     VARCHAR(255) NOT NULL,
    message     TEXT         NOT NULL,
    is_read     TINYINT(1)   NOT NULL DEFAULT 0,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Default admin: username=admin, password=admin123
INSERT INTO users (full_name, username, email, contact_no, password_hash, role) VALUES
('System Administrator', 'admin', 'admin@sunrisedental.com', '0771234567',
 '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN');

-- Sample receptionist: username=receptionist, password=password123
INSERT INTO users (full_name, username, email, contact_no, password_hash, role) VALUES
('Sarah Jenkins', 'receptionist', 'reception@sunrisedental.com', '0779998888',
 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'RECEPTIONIST');

INSERT INTO dentists (dentist_code, name, specialization, contact) VALUES
('DOC-001', 'Dr. Kamal Perera', 'Oral & Maxillofacial', '0771111111'),
('DOC-002', 'Dr. Nimali Silva', 'Cosmetic Dentistry', '0772222222'),
('DOC-003', 'Dr. Ruwan Jayasuriya', 'Orthodontics', '0773333333');

INSERT INTO patients (patient_name, address, contact_no, email) VALUES
('John Doe', '123 Main St, Colombo', '0774444444', 'john@email.com'),
('Jane Smith', '456 Lake Rd, Kandy', '0775555555', 'jane@email.com'),
('Michael Brown', '789 Hill Ave, Galle', '0776666666', 'michael@email.com');

-- Treatments & Pricing (Managed per Dentist)
CREATE TABLE treatments (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    dentist_id     INT NOT NULL,
    treatment_name VARCHAR(150) NOT NULL,
    price          DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    description    VARCHAR(255) DEFAULT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dentist_id) REFERENCES dentists(id) ON DELETE CASCADE
);

INSERT INTO treatments (dentist_id, treatment_name, price, description) VALUES
(1, 'Oral Surgery & Extraction', 8500.00, 'Surgical tooth extraction and minor oral surgery'),
(1, 'Root Canal Therapy', 12000.00, 'Advanced endodontic root canal procedure'),
(1, 'Dental Checkup & Consultation', 2000.00, 'Oral examination, diagnostic assessment and checkup'),
(2, 'Teeth Whitening', 9500.00, 'Laser dental bleaching and cosmetic teeth whitening'),
(2, 'Composite Tooth Filling', 3500.00, 'Tooth-colored aesthetic composite resin filling'),
(2, 'Teeth Cleaning & Scaling', 4000.00, 'Full mouth ultrasonic scaling and polishing'),
(3, 'Braces Consultation & Fitting', 35000.00, 'Orthodontic assessment and braces installation'),
(3, 'Braces Monthly Adjustment', 4500.00, 'Wire tightening, bracket check and adjustment'),
(3, 'Dental Checkup', 2000.00, 'General dental inspection and checkup');

INSERT INTO appointments (appointment_no, patient_id, dentist_id, treatment_type, appointment_date, appointment_time, status) VALUES
('APT-1001', 1, 1, 'Root Canal Therapy', CURDATE(), '09:00:00', 'Confirmed'),
('APT-1002', 2, 2, 'Teeth Whitening', CURDATE(), '10:30:00', 'Pending'),
('APT-1003', 3, 1, 'Dental Checkup & Consultation', CURDATE(), '14:00:00', 'Confirmed'),
('APT-1004', 1, 3, 'Braces Monthly Adjustment', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00', 'Pending');
