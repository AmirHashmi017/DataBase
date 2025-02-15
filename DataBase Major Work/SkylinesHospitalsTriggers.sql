--To set the execution order of two triggers on same table you can use:
--EXEC sp_settriggerorder  
--    @triggername = 'RoomBookingTrigger',  
--    @order = 'First',  
--    @stmttype = 'INSERT',  
--    @namespace = 'DATABASE';
--But in it you can only use First and Last so if 3 to 4 triggers then don't specify for remaining they will
--be executed in between first and last.
--By Default trigger execution order is based on their creation sequence.
--If a table has two triggers and the first trigger rolledback the transaction then the 2nd trigger
--will not be called.

--Create a trigger to ensure that the AvailableBeds in the Room table never goes below zero. 
--If an attempt is made to book a room with no available beds, raise an error and prevent the insertion or update.
CREATE Trigger RoomBookingTrigger 
ON PatientRoomBooking
AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT i.RoomID FROM inserted as i JOIN Room AS r ON i.RoomID=r.RoomID
	GROUP BY i.RoomID,r.AvailableBeds HAVING COUNT(i.RoomID)>r.AvailableBeds)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The beds are not available in that room',16,1);
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
DROP trigger RestrictDoctorScheduleDeletion

--Create a trigger to automatically update the AvailableBeds in the Room table 
--whenever a new PatientRoomBooking is inserted or deleted.
GO
CREATE Trigger UpdateRoomAvailability 
ON PatientRoomBooking AFTER INSERT,DELETE AS
BEGIN
	IF EXISTS(Select 1 from inserted) and NOT EXISTS(Select 1 from deleted)
	BEGIN
		UPDATE r SET r.AvailableBeds=r.AvailableBeds-c.BookingCount FROM Room AS r JOIN
		(SELECT RoomID,COUNT(*) AS BookingCount FROM inserted GROUP BY RoomID) AS c ON r.RoomID=c.RoomID;
	END
	IF EXISTS(Select 1 from deleted) AND NOT Exists(Select 1 from inserted)
	BEGIN
		UPDATE r SET r.AvailableBeds=r.AvailableBeds+c.BookingCount FROM Room AS r JOIN
		(SELECT RoomID,COUNT(*) AS BookingCount FROM deleted GROUP BY RoomID) AS c ON r.RoomID=c.RoomID;
	END
END;

DROP Trigger UpdateRoomAvailability
--Create a trigger to prevent a patient from booking multiple appointments with the same doctor on the same day. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger AppointmentsTrigger
ON Appointment AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT 1 FROM Appointment AS a JOIN inserted AS i ON a.PatientID=i.PatientID and
	a.DoctorID=i.DoctorID and a.AppointmentDate=i.AppointmentDate WHERE a.AppointmentID <> i.AppointmentID)
	BEGIN
		ROLLBACK Transaction;
	RAISERROR('You cannot book two appointments with same doctor on same date',16,1);
	END
END;
DROP Trigger AppointmentsTrigger
--Create a trigger to automatically delete records from the DoctorSchedule table where the AvailableDate is in the past 
--and the EndTime has already passed.
GO
CREATE Trigger DeletePastSchedules
ON DoctorSchedule AFTER INSERT,UPDATE,DELETE AS
BEGIN
	DELETE FROM DoctorSchedule WHERE AvailableDate<GETDATE() OR (AvailableDate=CAST(GetDate() AS DATE) 
	and EndTime<CAST(GETDATE() AS TIME))
END;
DROP Trigger DeletePastSchedules
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
	IF EXISTS(SELECT 1 FROM inserted as i JOIN Patient AS p ON i.PatientID=p.PatientID JOIN Appointment AS a
	ON a.PatientID=p.PatientID JOIN Doctor AS d ON a.DoctorID=d.DoctorID JOIN Room as r ON
	i.RoomID=r.RoomID JOIN Department AS dep ON r.DepartmentID=dep.DepartmentID
	GROUP BY i.PatientID,i.RoomID HAVING 
	SUM(CASE WHEN d.Specialization=dep.DepartmentName THEN 1 ELSE 0 END)=0)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The Patient Donnot belong to this department.',16,1);
	END
END;
DROP trigger AssignRoom

--Create a trigger to automatically update the Status of a doctor's schedule to 'Booked' 
--When an appointment is created with that schedule.
GO
CREATE Trigger ScheduleBooking
ON Appointment AFTER INSERT AS
BEGIN
	UPDATE DS SET DS.Status='Booked' FROM DoctorSchedule AS DS JOIN inserted AS i ON i.DoctorID=DS.DoctorID
	and i.AppointmentDate=DS.AvailableDate and i.AppointmentTime BETWEEN DS.StartTime and DS.EndTime;
END;
DROP Trigger ScheduleBooking
--Create a trigger to prevent a nurse from being assigned to a department that does not exist in the Department table.
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger PreventNurseAllocation
ON Nurse AFTER INSERT,UPDATE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted as i WHERE NOT EXISTS (SELECT 1 FROM Department as d WHERE
	i.DepartmentID=d.DepartmentID))
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The department you want to allocate nurse doesnot exist.',16,1);
	END
END;
DROP Trigger PreventNurseAllocation
--Create a trigger to ensure that a prescription is not created for a patient 
--who does not exist in the Patient table or a doctor who does not exist in the Doctor table. 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger HandlePrescription
ON Prescription AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted as i WHERE (NOT EXISTS(SELECT 1 FROM Doctor as d 
	WHERE i.DoctorID=d.DoctorID) or NOT Exists(SELECT 1 FROM Patient as p WHERE i.PatientID=p.PatientID)))
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The Doctor and Patient ID Donnot exist',16,1);
	END
END;
DROP Trigger HandlePrescription;
		
