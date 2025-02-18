create database SkylinesTransactions
use SkylinesTransactions
create table Department
(
DepartmentID VARCHAR(50) Primary Key,
DepartmentName VARCHAR(50)
);
create table Room
(
RoomID VARCHAR(50) PRIMARY KEY,
DepartmentID VARCHAR(50),
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
TotalBeds INT,
AvailableBeds INT
);
create table Admin
(
AdminID VARCHAR(50) PRIMARY KEY,
LoginPassword VARCHAR(50),
AdminName VARCHAR(50),
PhoneNumber VARCHAR(50),
Email VARCHAR(50)
);
--Admin Log Table
create table AdminLog
(
AdminID VARCHAR(50),
LoginPassword VARCHAR(50),
AdminName VARCHAR(50),
PhoneNumber VARCHAR(50),
Email VARCHAR(50),
OperationType TEXT,
ModifiedAt DateTime Default GetDate(),
ModifiedBY VARCHAR(100) DEFAULT SUSER_NAME()
);
create table Nurse
(
NurseID VARCHAR(50) PRIMARY KEY,
NurseName VARCHAR(50),
DepartmentID VARCHAR(50),
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
PhoneNumber VARCHAR(50),
Salary FLOAT
);

create table Patient
(
PatientID VARCHAR(50) PRIMARY KEY,
LoginPassword VARCHAR(50),
PatientName VARCHAR(50),
DOB DATE,
Gender VARCHAR(50),
PhoneNumber VARCHAR(50)
);

--Log Table For Patient
CREATE Table PatientLog
(
PatientID VARCHAR(50),
LoginPassword VARCHAR(50),
PatientName VARCHAR(50),
DOB DATE,
Gender VARCHAR(50),
PhoneNumber VARCHAR(50),
OperationType TEXT,
ModifiedAt DateTime DEFAULT GetDate(),
ModifiedBy VARCHAR(100) DEFAULT SUSER_NAME()
);

create table Doctor
(
DoctorID VARCHAR(50) PRIMARY KEY,
LoginPassword VARCHAR(50),
DoctorName VARCHAR(50),
Specialization VARCHAR(50),
Email VARCHAR(50),
PhoneNumber VARCHAR(50),
Salary FLOAT
);

CREATE TABLE AppointmentLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID VARCHAR(50),
    PatientID VARCHAR(50),
    DoctorID VARCHAR(50),
    AppointmentDate DATETIME,
    AppointmentTime TIME,
    OperationType VARCHAR(50),
    OperationTime DATETIME DEFAULT GETDATE(),
    ModifiedBy VARCHAR(100) DEFAULT SUSER_NAME()
);

create table Prescription
(
PrescriptionID VARCHAR(50) PRIMARY KEY,
PatientID VARCHAR(50),
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
DoctorID VARCHAR(50),
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
Dosage VARCHAR(150),
Medicine VARCHAR(150),
DoctorRemarks VARCHAR(250)
);
--Prescription Log Table
create table PrescriptionLog
(
PrescriptionID VARCHAR(50),
PatientID VARCHAR(50),
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
DoctorID VARCHAR(50),
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
Dosage VARCHAR(150),
Medicine VARCHAR(150),
DoctorRemarks VARCHAR(250),
OperationType TEXT,
ModifiedAt DateTime Default GetDate(),
ModifiedBY VARCHAR(100) DEFAULT SUSER_NAME()
);

create table PatientRoomBooking
(
RoomID VARCHAR(50),
FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
PatientID VARCHAR(50),
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE DoctorSchedule (
    ScheduleID VARCHAR(50) PRIMARY KEY,
    DoctorID VARCHAR(50),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    AvailableDate DATE,
    StartTime TIME,
    EndTime TIME,
    Status VARCHAR(50) CHECK (Status IN ('Available', 'Booked'))
);

--Create Table Appointment
create table Appointment
(
AppointmentID VARCHAR(50) PRIMARY KEY,
PatientID VARCHAR(50),
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
DoctorID VARCHAR(50),
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
AppointmentDate Date,
AppointmentTime Time
);

--Creating table For logging of all database
CREATE TABLE SkylinesLog
(
TableName varchar(128),
OperationType varchar(50),
ChangedBy varchar(100) DEFAULT SUSER_NAME(),
ChangedAt DATETIME DEFAULT GETDATE()
);

