--Create a trigger to ensure that the AvailableBeds in the Room table never goes below zero. 
--If an attempt is made to book a room with no available beds, raise an error and prevent the insertion or update.
CREATE Trigger RoomBookingTrigger 
ON PatientRoomBooking
AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT i.RoomID FROM inserted as i JOIN Room AS r ON i.RoomID=r.RoomID WHERE r.AvailableBeds<=0)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The beds are not available in that room',16,1);
	END
	ELSE
	BEGIN
		UPDATE ROOM SET AvailableBeds=(AvailableBeds-1) WHERE RoomID IN (SELECT RoomID FROM inserted) and AvailableBeds>0;
	END

END;
DROP trigger RoomBookingTrigger


--Create a trigger to prevent the deletion of a doctor's schedule if the AvailableDate is less than 2 days away. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE TRIGGER RestrictDoctorScheduleDeletion
ON DoctorSchedule 
AFTER DELETE 
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted WHERE DATEDIFF(DAY,GETDATE(),AvailableDate) < 2)
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('You cannot delete a schedule having less than 2 days remaining', 16, 1);
    END
END;


--Create a trigger to automatically update the AvailableBeds in the Room table 
--whenever a new PatientRoomBooking is inserted or deleted.
GO
CREATE Trigger UpdateRoomAvailability 
ON PatientRoomBooking AFTER INSERT,DELETE AS
BEGIN
	DECLARE @RoomID VARCHAR(50);
	DECLARE @PatientID VARCHAR(50);
	DECLARE @Count INT;
	IF EXISTS(Select 1 from inserted) and NOT EXISTS(Select 1 from deleted)
	BEGIN
		UPDATE Room SET AvailableBeds=AvailableBeds-1 WHERE RoomID IN (SELECT RoomID FROM inserted) and AvailableBeds>0;
	END
	IF EXISTS(Select 1 from deleted) AND NOT Exists(Select 1 from inserted)
	BEGIN
		SELECT @RoomID=RoomID,@PatientID=PatientID from deleted;
		SELECT @Count=COUNT(*) FROM PatientRoomBooking WHERE RoomID=@RoomID and PatientID=@PatientID;
		UPDATE Room SET AvailableBeds=AvailableBeds+@Count WHERE RoomID=@RoomID;
	END
END;

DROP Trigger UpdateRoomAvailability
--Create a trigger to prevent a patient from booking multiple appointments with the same doctor on the same day. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger AppointmentsTrigger
ON Appointment AFTER INSERT AS
BEGIN
	DECLARE @PatientID VARCHAR(50);
	DECLARE @DoctorID VARCHAR(50);
	DECLARE @AppointmentDate DATE;
	DECLARE @Count INT;

	SELECT @PatientID=PatientID FROM inserted;
	SELECT @DoctorID=DoctorID FROM inserted;
	SELECT @AppointmentDate=AppointmentDate FROM inserted;
	SELECT @Count=COUNT(*) FROM Appointment WHERE PatientID=@PatientID 
	and DoctorID=@DoctorID and AppointmentDate=@AppointmentDate
	if(@Count>1)
	BEGIN
		ROLLBACK Transaction;
	RAISERROR('You cannot book two appointments with same doctor on same date',16,1);
	END
END;

--Create a trigger to automatically delete records from the DoctorSchedule table where the AvailableDate is in the past 
--and the EndTime has already passed.
GO
CREATE Trigger DeletePastSchedules
ON DoctorSchedule AFTER INSERT,UPDATE,DELETE AS
BEGIN
	DELETE FROM DoctorSchedule WHERE AvailableDate<GETDATE() OR (AvailableDate=CAST(GetDate() AS DATE) 
	and EndTime<CAST(GETDATE() AS TIME))
END;

--Create a trigger to prevent updates to the DoctorSchedule table if the Status is already set to 'Booked'. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE TRIGGER DoctorScheduleUpdates
ON DoctorSchedule AFTER UPDATE AS
BEGIN
	IF EXISTS(SELECT 1 FROM deleted WHERE status='Booked')
	BEGIN
		ROLLBACK Transaction;
	RAISERROR('You cannot update schedules that are booked.',16,1);
	END
END;
DROP Trigger DoctorScheduleUpdates
--Create a trigger to ensure that a patient is not assigned to a room that belongs 
--to a different department than the one the patient's doctor specializes in. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE TRIGGER AssignRoom
ON PatientRoomBooking AFTER INSERT AS
BEGIN
	DECLARE @DoctorID VARCHAR(50);
	DECLARE @Specialization VARCHAR(50);
	DECLARE @RoomID VARCHAR(50);
	DECLARE @Department VARCHAR(50);
	SELECT @DoctorID=a.DoctorID,@RoomID=i.RoomID FROM Appointment AS a JOIN inserted as i ON a.PatientID=i.PatientID;
	if(@DoctorID IS NULL)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The Patient Without any appointment cannot get room',16,1);
	END
	ELSE
		BEGIN
			SELECT @Specialization=Specialization FROM Doctor Where DoctorID=@DoctorID;
			SELECT @Department=d.DepartmentName FROM Department as d JOIN
			Room as r ON d.DepartmentID=r.DepartmentID WHERE r.RoomID=@RoomID;
			if(@Specialization<>@Department)
			BEGIN
				ROLLBACK Transaction;
				RAISERROR('The Patient Donnot belong to this department.',16,1);
			END
		END
END;

--Create a trigger to automatically update the Status of a doctor's schedule to 'Booked' 
--When an appointment is created with that schedule.
GO
CREATE Trigger ScheduleBooking
ON Appointment AFTER INSERT AS
BEGIN
	DECLARE @DoctorID VARCHAR(50);
	DECLARE @AppointmentDate Date;
	DECLARE @AppointmentTime Time;
	SELECT @DoctorID=DoctorID,@AppointmentDate=AppointmentDate,@AppointmentTime=AppointmentTime
	FROM inserted;
	UPDATE DoctorSchedule SET Status='Booked' WHERE DoctorID=@DoctorID and AvailableDate=@AppointmentDate
	and @AppointmentTime BETWEEN StartTime and EndTime;
END;

--Create a trigger to prevent a nurse from being assigned to a department that does not exist in the Department table.
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger PreventNurseAllocation
ON Nurse AFTER INSERT,UPDATE AS
BEGIN
	DECLARE @DepartmentID VARCHAR(50);
	SELECT @DepartmentID=DepartmentID FROM inserted WHERE DepartmentID IN(SELECT DepartmentID FROM Department);
	if(@DepartmentID IS NULL)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The department you want to allocate nurse doesnot exist.',16,1);
	END
END;

--Create a trigger to ensure that a prescription is not created for a patient 
--who does not exist in the Patient table or a doctor who does not exist in the Doctor table. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger HandlePrescription
ON Prescription AFTER INSERT AS
BEGIN
	DECLARE @DoctorID VARCHAR(50);
	DECLARE @PatientID VARCHAR(50);
	SELECT @DoctorID=DoctorID,@PatientID=PatientID FROM inserted
	WHERE DoctorID IN(SELECT DoctorID FROm Doctor) and PatientID IN (SELECT PatientID FROM Patient);
	IF(@PatientID IS NULL OR @DoctorID IS NULL)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The Doctor and Patient ID Donnot exist',16,1);
	END
END;
		
