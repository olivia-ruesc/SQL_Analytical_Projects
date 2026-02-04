CREATE TABLE Hospitals(
    hos_id number(9) PRIMARY KEY,
    hos_type char(2),
    hos_description varchar(255),
    hos_doc_id number(9),
    hos_place varchar(255),
    FOREIGN KEY (hos_doc_id) REFERENCES Doctors(doc_id)
);

CREATE TABLE Doctors(
    doc_id number(9) PRIMARY KEY,
    doc_name varchar(255),
    doc_address varchar(255),
    doc_contact_no varchar(20),
    doc_email varchar(255)
);

CREATE TABLE treatment (
    treat_id number(9) PRIMARY KEY,
    treat_date date,
    doc_id number(9),
    treat_description varchar(255),
    FOREIGN KEY (doc_id) REFERENCES Doctors(doc_id)
);

CREATE TABLE Patients (
    pat_id number(9) PRIMARY KEY,
    pat_name varchar(255),
    pat_mobile varchar(20),
    pat_address varchar(255),
    pat_contact_no varchar(20),
    pat_email varchar(255)
);

CREATE TABLE treatmentSchedule (
    scheduleID number(9) PRIMARY KEY,
    doctor_id number(9),
    pat_id number(9),
    treat_id number(9),
    schedule_date date,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doc_id),
    FOREIGN KEY (pat_id) REFERENCES Patients(pat_id),
    FOREIGN KEY (treat_id) REFERENCES treatment(treat_id)
);

SELECT * FROM Hospitals;
SELECT * FROM Doctors;
SELECT * FROM Patients;
SELECT * FROM treatment;
SELECT * FROM treatmentSchedule;

CREATE INDEX idx_pat_name ON Patients(pat_name);
CREATE INDEX idx_doc_name ON Doctors(doc_name);

CREATE VIEW PatientDoctorContactReference AS
SELECT 
    p.pat_id,
    p.pat_name, 
    p.pat_mobile, 
    p.pat_contact_no,
    p.pat_email,
    d.doc_name, 
    d.doc_contact_no
FROM Patients p
JOIN TreatmentSchedule ts ON p.pat_id = ts.pat_id
JOIN Doctors d ON ts.doctor_id = d.doc_id;

SELECT * FROM PatientDoctorContactReference;

CREATE VIEW NurseScheduleView AS
SELECT 
    ts.scheduleID, 
    d.doc_name, 
    ts.pat_id, 
    p.pat_name, 
    t.treat_description, 
    ts.schedule_date, 
    TO_CHAR(ts.schedule_date, 'WW') AS week_number,  -- Extract week
    TO_CHAR(ts.schedule_date, 'MM') AS month_number   -- Extract month
FROM TreatmentSchedule ts
JOIN Doctors d ON ts.doctor_id = d.doc_id
JOIN Patients p ON ts.pat_id = p.pat_id
JOIN Treatment t ON ts.treat_id = t.treat_id;

SELECT * FROM NurseScheduleView;

