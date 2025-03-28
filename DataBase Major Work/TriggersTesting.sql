--Testing Trigger1
	--Test Query Valid
	INSERT INTO PatientRoomBooking (RoomID, PatientID) 
	VALUES ('R004', 'P004');
	SELECT * FROM Room
	SELECT * FROM PatientRoomBooking
	--Test Query Invalid
	INSERT INTO PatientRoomBooking (RoomID, PatientID) 
	VALUES ('R001', 'P004'),('R006','p004');

--Testing Trigger2
	--Test Query Valid
	INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
VALUES ('S002', 'D001', '2025-02-16', '10:00:00', '11:00:00', 'Available');
	SELECT * FROM DoctorSchedule
	DELETE FROM DoctorSchedule WHERE ScheduleID = 'S002';
	SELECT * FROM DoctorSchedule
	--TestQuery Invalid
	INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
	VALUES ('S001', 'D001', '2025-02-14', '10:00:00', '11:00:00', 'Available');
	DELETE FROM DoctorSchedule WHERE ScheduleID = 'S001';
	SELECT * FROM DoctorSchedule
--Testing Trigger 3
	SELECT * FROM Room;
	INSERT INTO PatientRoomBooking (RoomID, PatientID) VALUES ('R002', 'P004'),('R002','p004'),('R004','p004');
	DELETE FROM PatientRoomBooking WHERE RoomID IN('R002','R004') AND PatientID = 'P004';
	DELETE FROM PatientRoomBooking WHERE PatientID = 'P004';
	SELECT * FROM PatientRoomBooking
	


--Testing Trigger 5

	INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime) 
	VALUES ('A008', 'P004', 'D002', '2024-02-22', '11:00:00'),
	('A009', 'P004', 'D002', '2024-02-23', '11:00:00');
	SELECT * FROM Appointment
	
--Testing Trigger 6
	INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
VALUES ('SCH006', 'D001', '2025-03-01', '10:00:00', '11:00:00', 'Available');
INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
VALUES ('SCH005', 'D001', '2024-01-01', '10:00:00', '11:00:00', 'Available');
SELECT * FROM DoctorSchedule

--Testing Trigger 7
SELECT * FROM DoctorSchedule
UPDATE DoctorSchedule SET AvailableDate='2025-02-25' WHERE ScheduleID='S001';

--Testing Trigger 9
INSERT INTO PatientRoomBooking (RoomID, PatientID) 
VALUES ('R001', 'P004'),('R007', 'P004');
INSERT INTO PatientRoomBooking (RoomID, PatientID) 
VALUES ('R004', 'P004');
SELECT * FROM Patient;
SELECT * FROM Appointment;
SELECT * FROM Doctor;
SELECT * FROM Room;
SELECT * FROM Department;
SELECT * FROM PatientRoomBooking;

--Testing Trigger 10
SELECT * FROM DoctorSchedule
INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime) 
VALUES ('A008', 'P004', 'D001', '2026-01-01', '10:30:00'),('A009', 'P004', 'D001', '2026-02-01', '10:30:00');
SELECT * FROM Appointment
INSERT INTO DoctorSchedule(ScheduleID,DoctorID,AvailableDate,StartTime,EndTime,Status)
VALUES('SCH007','D001','2026-02-01','10:00:00','11:00:00','Available');

--Testing Trigger 11
--Valid Data
INSERT INTO Department (DepartmentID, DepartmentName) 
VALUES ('DPT003', 'Pediatrics');
INSERT INTO Nurse (NurseID, NurseName, DepartmentID) 
VALUES ('N006', 'Alice Brown', 'DPT003');
SELECT * FROM Nurse WHERE NurseID = 'N006';
--Invalid Data
INSERT INTO Nurse (NurseID, NurseName, DepartmentID) 
VALUES ('N007', 'Alice Brown', 'DPT009S');

--Testing Trigger 13
SELECT * FROM Doctor
SELECT * FROM Patient
INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, Dosage, Medicine, DoctorRemarks) 
VALUES ('PR006', 'P007', 'DOC999', '1 tablet twice a day', 'Paracetamol', 'Take after meal');

--Testing Trigger 15
INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
	VALUES ('S008', 'D001', '2025-02-14', '09:00:00', '09:30:00', 'Available'),
	('S007', 'D001', '2025-02-14', '09:31:00', '09:59:00', 'Available');
	SELECT * FROM DoctorSchedule;

--Testing Trigger 17
SELECT * FROM DoctorSchedule
INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime) 
VALUES ('A218', 'P005', 'D001', '2025-02-14', '09:29:00'),('A219', 'P005', 'D001', '2026-01-01', '10:32:00');
SELECT * FROM Appointment;
SELECT * FROM Patient;

--Testing Trigger 18
INSERT INTO PatientRoomBooking (RoomID, PatientID) 
	VALUES ('R004', 'P004');
	SELECT * FROM Room
	SELECT * FROM PatientRoomBooking
	--Test Query Invalid
	INSERT INTO PatientRoomBooking (PatientID) 
	VALUES ('P004'),('P004'),('P005');

--Testing Trigger 19
INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status) 
VALUES ('SCHE07', 'D001', '2025-02-17', '10:00:00', '11:00:00', 'Available'),
('SCHE05', 'D001', '2024-01-01', '10:00:00', '11:00:00', 'Available');

SELECT * FROM DoctorSchedule

--Testing Trigger 4
--Patient Testing
INSERT INTO Patient (PatientID, LoginPassword, PatientName, DOB, Gender, PhoneNumber) 
VALUES ('P007', 'pass123', 'Jane Doe', '1990-05-20', 'Female', '1234567890');

UPDATE Patient SET PhoneNumber = '0987654321' WHERE PatientID = 'P007';

DELETE FROM Patient WHERE PatientID = 'P007';

SELECT * FROM PatientLog;

--Testing Trigger 8
INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, Dosage, Medicine, DoctorRemarks) 
VALUES ('PR001', 'P004', 'D001', '1 tablet twice a day', 'Paracetamol', 'Take after meal');

UPDATE Prescription SET Dosage = '1 tablet once a day' WHERE PrescriptionID = 'PR001';

DELETE FROM Prescription WHERE PrescriptionID = 'PR001';

SELECT * FROM PrescriptionLog;

--Testing Trigger 12
INSERT INTO Admin (AdminID, LoginPassword, AdminName, PhoneNumber, Email) VALUES ('A201', 'pass123', 'John Doe', '1234567890', 'admin@example.com');
UPDATE Admin SET PhoneNumber = '0987654321' WHERE AdminID = 'A201';
DELETE FROM Admin WHERE AdminID = 'A201';
SELECT * FROM AdminLog;

--Testing DDL Trigger 1
DROP TABLE Admin;
SELECT * FROM SkylinesLog

--Testing DDL Trigger 2
CREATE TABLE Test(
TestID VARCHAR(50) PRIMARY KEY,
TestName VARCHAR(50)
);
ALTER Table Test DROP COLUMN TestName;
SELECT * FROM SkylinesLog

--Testing DDL Trigger 3

ALTER Table Patient ADD TestName INT;
SELECT * FROM SkylinesLog

--Testing DDL Trigger 4

ALTER Table Patient ALTER COLUMN PhoneNumber VARCHAR(50);
SELECT * FROM SkylinesLog