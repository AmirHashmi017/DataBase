--Write a procedure to register a new patient and allocate a room to them. 
--Ensure that the room's AvailableBeds is updated. 
--Use a transaction to ensure both operations succeed or fail together

CREATE PROCEDURE RegisterPatientWithRoom
(
	@p_PatientID VARCHAR(50),
	@p_LoginPassword VARCHAR(50),
	@p_PatientName VARCHAR(50),
	@p_DOB DATE,
	@p_Gender VARCHAR(50),
	@p_PhoneNumber VARCHAR(50),
	@p_RoomID VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Patient(PatientID,LoginPassword,PatientName,DOB,Gender,PhoneNumber)
			VALUES(@p_PatientID,@p_LoginPassword,@p_PatientName,@p_DOB,@p_Gender,@p_PhoneNumber);
			
			INSERT INTO PatientRoomBooking(RoomID,PatientID)
			VALUES(@p_RoomID,@p_PatientID);

			UPDATE Room SET AvailableBeds=AvailableBeds-1 WHERE RoomID=@p_RoomID;

		COMMIT;			
		SELECT 'Patient Registered and Room Booked Successfully' AS Message;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH
END;

DROP PROCEDURE RegisterPatientWithRoom;

--Create a procedure to book an appointment for a patient with a doctor. 
--Check if the doctor is available on the requested date and time (using DoctorSchedule). 
--If the appointment is successful, log the details in AppointmentLog.
GO
CREATE PROCEDURE BookAppointment
(
	@p_AppointmentID VARCHAR(50),
	@p_PatientID VARCHAR(50),
	@p_DoctorID VARCHAR(50),
	@p_AppointmentDate Date,
	@p_AppointmentTime Time
)
AS
BEGIN
	BEGIN TRY
		BEGIN Transaction
			IF NOT EXISTS(SELECT 1 FROM DoctorSchedule WHERE DoctorID=@p_DoctorID and 
			AvailableDate=@p_AppointmentDate and @p_AppointmentTime BETWEEN StartTime and EndTime)
			BEGIN
				ROLLBACK;
				SELECT 'No Matching Doctor Schedule Found.' AS Message;
				RETURN;
			END
			INSERT INTO Appointment(AppointmentID,PatientID,DoctorID,AppointmentDate,AppointmentTime)
			VALUES(@p_AppointmentID,@p_PatientID,@p_DoctorID,@p_AppointmentDate,@p_AppointmentTime);

			INSERT INTO AppointmentLog(AppointmentID,PatientID,DoctorID,AppointmentDate,AppointmentTime,
			OperationType)
			VALUES(@p_AppointmentID,@p_PatientID,@p_DoctorID,@p_AppointmentDate,@p_AppointmentTime,'Insert');

		COMMIT;
		SELECT 'Appointment Booked Successfully.' AS Message;
	END TRY

	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH

END;

DROP PROCEDURE BookAppointment;

--Write a procedure to update a patient's details (e.g., phone number, email). 
--Log the old and new values in the PatientLog table. 
--Use a transaction to ensure both the update and logging succeed.
GO
CREATE PROCEDURE UpdatePatient
(
	@p_PatientID VARCHAR(50),
	@p_LoginPassword VARCHAR(50)=NULL,
	@p_PatientName VARCHAR(50)=NULL,
	@p_DOB DATE=NULL,
	@p_Gender VARCHAR(50)=NULL,
	@p_PhoneNumber VARCHAR(50)=NULL
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS(SELECT 1 FROM Patient WHERE PatientID=@p_PatientID)
			BEGIN
				ROLLBACK;
				SELECT 'Error: No Matched Patient Found' AS Message;
				RETURN;
			END
			DECLARE @oldLoginPassword VARCHAR(50);
			DECLARE @oldPatientName	  VARCHAR(50);
			DECLARE @oldDOB			  VARCHAR(50);
			DECLARE @oldGender		  VARCHAR(50);
			DECLARE @oldPhoneNumber	  VARCHAR(50);

			SELECT @oldLoginPassword=LoginPassword, @oldPatientName=PatientName,@oldDOB=DOB,@oldGender=Gender,
			@oldPhoneNumber=PhoneNumber FROM Patient WHERE PatientID=@p_PatientID;


			UPDATE Patient 
			SET
			LoginPassword = COALESCE(@p_LoginPassword, LoginPassword),
            PatientName = COALESCE(@p_PatientName, PatientName),
            DOB = COALESCE(@p_DOB, DOB),
            Gender = COALESCE(@p_Gender, Gender),
            PhoneNumber = COALESCE(@p_PhoneNumber, PhoneNumber)
			WHERE PatientID=@p_PatientID;

			DECLARE @newLoginPassword VARCHAR(50);
			DECLARE @newPatientName	  VARCHAR(50);
			DECLARE @newDOB			  VARCHAR(50);
			DECLARE @newGender		  VARCHAR(50);
			DECLARE @newPhoneNumber	  VARCHAR(50);

			SELECT @newLoginPassword=LoginPassword, @newPatientName=PatientName,@newDOB=DOB,@newGender=Gender,
			@newPhoneNumber=PhoneNumber FROM Patient WHERE PatientID=@p_PatientID;

			INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
			VALUES(@p_PatientID,@oldLoginPassword,@oldPatientName,@oldDOB,@oldGender,@oldPhoneNumber,
			'Before Update');

			INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
			VALUES(@p_PatientID,@newLoginPassword,@newPatientName,@newDOB,@newGender,@newPhoneNumber,
			'After Update');

		COMMIT;
		SELECT 'Patient Updated Successfully.' AS Message;

	END TRY

	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH
END;

DROP Procedure UpdatePatient;

--Create a procedure to add a new prescription for a patient. Ensure that the PatientID and DoctorID exist. 
--Log the prescription details in PrescriptionLog. Use a transaction to ensure data consistency.
GO
CREATE PROCEDURE AddPrescription
(
	@p_PrescriptionID VARCHAR(50),
	@p_PatientID VARCHAR(50),
	@p_DoctorID VARCHAR(50),
	@p_Dosage VARCHAR(150),
	@p_Medicine VARCHAR(150),
	@p_DoctorRemarks VARCHAR(250)
)
AS
BEGIN
	BEGIN TRY
		BEGIN Transaction
			IF (NOT EXISTS(SELECT 1 FROM Doctor WHERE DoctorID=@p_DoctorID) OR 
			NOT EXISTS(SELECT 1 FROM Patient WHERE PatientID=@p_PatientID))
			BEGIN
				ROLLBACK;
				SELECT 'Error: No such Doctor and Patient Found.' AS Message;
				RETURN;
			END
			INSERT INTO Prescription(PrescriptionID,PatientID,DoctorID,Dosage,Medicine,DoctorRemarks)
			VALUES(@p_PrescriptionID,@p_PatientID,@p_DoctorID,@p_Dosage,@p_Medicine,@p_DoctorRemarks);

			INSERT INTO PrescriptionLog(PrescriptionID,PatientID,DoctorID,Dosage,Medicine,DoctorRemarks,
			OperationType)
			VALUES(@p_PrescriptionID,@p_PatientID,@p_DoctorID,@p_Dosage,@p_Medicine,@p_DoctorRemarks,
			'Insert');

		COMMIT;
		SELECT 'Prescription Added Successfully.' AS Message;
	END TRY

	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH

END;

DROP PROCEDURE AddPrescription;

--Write a procedure to reallocate a patient from one room to another. 
--Update the AvailableBeds for both rooms. Use a transaction to ensure both updates succeed.
GO
CREATE PROCEDURE RoomReAllocation
(
	@p_PatientID VARCHAR(50),
	@p_RoomID VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS(SELECT 1FROM PatientRoomBooking WHERE PatientID=@p_PatientID)
			BEGIN
				ROLLBACK;
				SELECT 'No Booking Found for patient' AS Message;
				RETURN;
			END
			DECLARE @oldRoomID VARCHAR(50);
			SELECT @oldRoomID=RoomID FROM PatientRoomBooking WHERE PatientID=@p_PatientID;
			UPDATE PatientRoomBooking SET RoomID=@p_RoomID WHERE PatientID=@p_PatientID;

			UPDATE Room SET AvailableBeds=AvailableBeds-1 WHERE RoomID=@p_RoomID;

			UPDATE Room SET AvailableBeds=AvailableBeds+1 WHERE RoomID=@oldRoomID;

		COMMIT;			
		SELECT 'Room Reallocated to patient successfuly.' AS Message;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH
END;

DROP PROCEDURE RoomReAllocation;

--Create a procedure to delete a patient's record. 
--Ensure that all related records (e.g., appointments, prescriptions, room bookings) are also deleted. 
--Use a transaction to maintain data integrity.
GO
CREATE PROCEDURE DeletePatient
(
	@p_PatientID VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS(SELECT 1 FROM Patient WHERE PatientID=@p_PatientID)
			BEGIN
				ROLLBACK;
				SELECT 'No such patient found.' AS Message;
				RETURN;
			END
			IF EXISTS(SELECT 1 FROM Appointment WHERE PatientID=@p_PatientID)
			BEGIN
				DELETE FROM Appointment WHERE PatientID=@p_PatientID;
			END
			IF EXISTS(SELECT 1 FROM Prescription WHERE PatientID=@p_PatientID)
			BEGIN
				DELETE FROM Prescription WHERE PatientID=@p_PatientID;
			END
			IF EXISTS(SELECT 1 FROM PatientRoomBooking WHERE PatientID=@p_PatientID)
			BEGIN
				DELETE FROM PatientRoomBooking WHERE PatientID=@p_PatientID;
			END
			DELETE FROM Patient WHERE PatientID=@p_PatientID;

		COMMIT;			
		SELECT 'Patient deleted successfuly.' AS Message;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH
END;

DROP PROCEDURE DeletePatient;

--Write a procedure to register multiple patients in a single transaction. 
--If any patient registration fails, roll back the entire transaction.
GO
CREATE TYPE PatientRegisterationHolder AS TABLE
(
	PatientID VARCHAR(50) PRIMARY KEY,
	LoginPassword VARCHAR(50),
	PatientName VARCHAR(50),
	DOB DATE,
	Gender VARCHAR(50),
	PhoneNumber VARCHAR(50),
	RoomID VARCHAR(50)
);
GO
CREATE PROCEDURE RegisterMultiplePatientWithRoom
(
	@Patients PatientRegisterationHolder READONLY
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Patient(PatientID,LoginPassword,PatientName,DOB,Gender,PhoneNumber)
			SELECT PatientID,LoginPassword,PatientName,DOB,Gender,PhoneNumber FROM @Patients;
			
			INSERT INTO PatientRoomBooking(RoomID,PatientID)
			SELECT RoomID,PatientID FROM @Patients;

			UPDATE R SET R.AvailableBeds=R.AvailableBeds-p.PatientCount FROM Room AS R 
			JOIN (SELECT RoomID,COUNT(*) AS PatientCount FROM @Patients GROUP BY RoomID) AS P 
			ON P.RoomID=R.RoomID

		COMMIT;			
		SELECT 'All Patients Registered and Room Booked Successfully' AS Message;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE() AS Message;
	END CATCH
END;

DROP Procedure RegisterMultiplePatientWithRoom;

--Transaction with savepoint
BEGIN TRANSACTION;

DECLARE @Count INT;
SET @Count = 0;

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES ('1123', 'Cardiology');

SAVE TRANSACTION L1;
INSERT INTO Admin (AdminID, LoginPassword, AdminName, PhoneNumber, Email)
VALUES ('1443', '123', 'Amir Hash', '03284136880', 'am@gmail.com');

SET @Count = (SELECT COUNT(*) FROM Department WHERE DepartmentName = 'Cardiology');

IF @Count > 1
BEGIN
    ROLLBACK TRANSACTION L1;
    PRINT 'Duplicate department found, rolling back to savepoint L1';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully';
END
SELECT * FROM Admin