--Insertion Stetements
INSERT INTO Department (DepartmentID, DepartmentName) 
VALUES ('DPT001', 'Cardiology');

--Room Testing
INSERT INTO Room (RoomID, DepartmentID, TotalBeds, AvailableBeds) VALUES ('R002', 'DPT001', 20, 10);

--Admin Testing
INSERT INTO Admin (AdminID, LoginPassword, AdminName, PhoneNumber, Email) VALUES ('A001', 'pass123', 'John Doe', '1234567890', 'admin@example.com');

--Nurse Testing
INSERT INTO Nurse (NurseID, NurseName, DepartmentID, PhoneNumber, Salary) VALUES ('N001', 'Alice Brown', 'DPT001', '9876543210', 50000);

--Patient Testing
INSERT INTO Patient (PatientID, LoginPassword, PatientName, DOB, Gender, PhoneNumber) 
VALUES ('P001', 'pass123', 'Jane Doe', '1990-05-20', 'Female', '1234567890');


--Doctor Testing
INSERT INTO Doctor (DoctorID, DoctorName, Specialization, PhoneNumber, Salary) 
VALUES ('D001', 'Dr. Smith', 'Cardiology', '1234567890', 100000);

--Appointment Testing
INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime) 
VALUES ('A001', 'P002', 'D001', '2024-02-07','10:00:00');

--Prescription Testing
INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, Dosage, Medicine, DoctorRemarks) 
VALUES ('PR001', 'P002', 'D001', '1 tablet twice a day', 'Paracetamol', 'Take after meal');


--PatientRoomBooking Testing
INSERT INTO PatientRoomBooking (RoomID, PatientID) 
VALUES ('R001', 'P002');

--Doctor Schedule Testing

INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status)
VALUES ('SCH003', 'DOC123', '2025-02-10', '10:00:00', '11:00:00', 'Available');

--Checking my Restrict Delete Trigger
INSERT INTO DoctorSchedule (ScheduleID, DoctorID, AvailableDate, StartTime, EndTime, Status)
VALUES ('SCH0067', 'DOC123', '2025-02-16', '10:00:00', '11:00:00', 'Available');


--Testing Transaction 01
EXEC RegisterPatientWithRoom
    'P1001', 'password123', 'John Doe', '1990-01-01', 'Male', '1234567890', 'R001';
	SELECT * FROM Patient;
	SELECT * FROM PatientRoomBooking;
	SELECT * FROM Room;
	
--Testing Transaction 02
	INSERT INTO DoctorSchedule (ScheduleID,DoctorID, AvailableDate, StartTime, EndTime) 
	VALUES ('SC001','D001', '2025-02-20', '09:00:00', '17:00:00');
	
	EXEC BookAppointment 'A1001', 'P001', 'D001', '2025-02-20', '10:00:00';
	SELECT * FROM Appointment
	SELECT * FROM AppointmentLog
	
--Testing Transaction 03
	EXEC UpdatePatient
	    'P1001', '12345678', 'Ali Raza';
	SELECT * FROM Patient;
	SELECT * FROM PatientLog;

--Testing Transaction 04
	EXEC AddPrescription
	    'PR001', 'P001', 'D001', '1 tablet twice a day', 'Paracetamol', 'Take after meal';
	SELECT * FROM Prescription;
	SELECT * FROM PrescriptionLog;

--Testing Transaction 05
	EXEC RoomReAllocation
	    'P1001','R002';
	SELECT * FROM Patient;
	SELECT * FROM PatientRoomBooking;
	SELECT * FROM Room;

--Testing Transaction 07
	DECLARE @PatientList  PatientRegisterationHolder;
	
	INSERT INTO @PatientList (PatientID, LoginPassword, PatientName, DOB, Gender, PhoneNumber, RoomID)
	VALUES 
	    ('P001', 'pass123', 'Alice Doe', '1995-06-15', 'Female', '1234567890', 'R001'),
	    ('P002', 'pass456', 'Bob Smith', '1990-12-10', 'Male', '9876543210', 'R002'),
	    ('P003', 'pass789', 'Charlie Brown', '1985-03-25', 'Male', '4561237890', 'R001');

	EXEC RegisterMultiplePatientWithRoom @PatientList;
	SELECT * FROM Patient;
	SELECT * FROM PatientRoomBooking;
	SELECT * FROM Room;


--Testing Transaction 08
	EXEC DeletePatient
	    'P001';
	SELECT * FROM Patient;
	SELECT * FROM PatientRoomBooking;
	SELECT * FROM Appointment;
	SELECT * FROM Prescription;


