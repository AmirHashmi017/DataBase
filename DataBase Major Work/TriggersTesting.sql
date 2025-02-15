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