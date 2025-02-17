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

--Create a trigger to prevent a doctor from having overlapping schedules 
--(i.e., two schedules with the same AvailableDate and overlapping StartTime and EndTime). 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger OverlapDoctorSchedule
ON DoctorSchedule AFTER INSERT,UPDATE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted as i JOIN DoctorSchedule AS ds ON i.DoctorID=ds.DoctorID and 
	i.AvailableDate=ds.AvailableDate and ((i.StartTime Between ds.StartTime and ds.EndTime) OR (i.EndTime
	BETWEEN ds.StartTime and ds.EndTime)) WHERE i.ScheduleID<>ds.ScheduleID)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('The Doctor Schedule cannot overlap',16,1);
	END
END;
DROP Trigger OverlapDoctorSchedule;

--Create a trigger to ensure that an appointment's AppointmentTime falls 
--within the doctor's available schedule (StartTime and EndTime). 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger ValidateAppointment 
ON Appointment AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted as i LEFT JOIN DoctorSchedule AS d ON i.DoctorID=d.DoctorID 
	and i.AppointmentDate=d.AvailableDate and i.AppointmentTime BETWEEN d.StartTime and d.EndTime
	WHERE d.DoctorID IS NULL)
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('No mathcing schedule Found',16,1);
	END
END;
DROP Trigger ValidateAppointment;

--Create a trigger to automatically assign a room to a patient when a new PatientRoomBooking is inserted. 
--The room should be assigned based on availability and department.
GO
CREATE Trigger RoomBooking
ON PatientRoomBooking AFTER INSERT AS
BEGIN
	UPDATE pr SET pr.RoomID=r.RoomID FROM PatientRoomBooking as pr JOIN
	inserted as i ON i.PatientID=pr.PatientID  CROSS APPLY (
        SELECT TOP 1 RoomID 
        FROM Room
        WHERE AvailableBeds > 0
		ORDER BY RoomID DESC
    ) AS r WHERE
	pr.RoomID IS NULL;
END;
DROP Trigger RoomBooking;

--Create a trigger to prevent the insertion of a doctor's schedule 
--if the AvailableDate is a weekend (Saturday or Sunday). 
--If such an attempt is made, raise an error and roll back the transaction.
GO
CREATE Trigger PreventWeekends
ON DoctorSchedule AFTER INSERT,UPDATE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted AS i WHERE DATEPART(WEEKDAY,i.AvailableDate) IN (7,1))
	BEGIN
		ROLLBACK Transaction;
		RAISERROR('No schedule can be added for weekends',16,1);
	END
END;
DROP Trigger PreventWeekends;

--Create a trigger to log all changes made to the Patient table 
--(inserts, updates, and deletes) into the PatientLog table. 
--Include the old and new values for updates.
GO
CREATE Trigger LogPatient
ON Patient AFTER INSERT,UPDATE,DELETE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted) and NOT Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
		SELECT i.PatientID ,i.LoginPassword ,i.PatientName,i.DOB,i.Gender,i.PhoneNumber,'Insert' 
		FROM Inserted AS i
	END
	IF EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
		SELECT d.PatientID ,d.LoginPassword ,d.PatientName,d.DOB,d.Gender,d.PhoneNumber,'Before Update' 
		FROM deleted AS d

		INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
		SELECT i.PatientID ,i.LoginPassword ,i.PatientName,i.DOB,i.Gender,i.PhoneNumber,'After Update' 
		FROM Inserted AS i
		
	END
	IF NOT EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PatientLog(PatientID ,LoginPassword ,PatientName,DOB,Gender,PhoneNumber,OperationType)
		SELECT d.PatientID ,d.LoginPassword ,d.PatientName,d.DOB,d.Gender,d.PhoneNumber,'DELETE' 
		FROM deleted AS d
	END
END;
DROP Trigger LogPatient;


--Create a trigger to log all changes made to the Prescription table 
--(inserts, updates, and deletes) into the PrescriptionLog table. 
--Include the old and new values for updates.
GO
CREATE Trigger LogPrescription
ON Prescription AFTER INSERT,UPDATE,DELETE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted) and NOT Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PrescriptionLog(PrescriptionID, PatientID,DoctorID ,Dosage,Medicine,DoctorRemarks,OperationType)
		SELECT i.PrescriptionID,i.PatientID,i.DoctorID ,i.Dosage,i.Medicine,i.DoctorRemarks,'INSERT' 
		FROM inserted AS i
	END
	IF EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PrescriptionLog(PrescriptionID, PatientID,DoctorID ,Dosage,Medicine,DoctorRemarks,OperationType)
		SELECT d.PrescriptionID,d.PatientID,d.DoctorID ,d.Dosage,d.Medicine,d.DoctorRemarks,'Before Update' 
		FROM deleted AS d

		INSERT INTO PrescriptionLog(PrescriptionID, PatientID,DoctorID ,Dosage,Medicine,DoctorRemarks,OperationType)
		SELECT i.PrescriptionID,i.PatientID,i.DoctorID ,i.Dosage,i.Medicine,i.DoctorRemarks,'After Update' 
		FROM inserted AS i
		
	END
	IF NOT EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO PrescriptionLog(PrescriptionID, PatientID,DoctorID ,Dosage,Medicine,DoctorRemarks,OperationType)
		SELECT d.PrescriptionID,d.PatientID,d.DoctorID ,d.Dosage,d.Medicine,d.DoctorRemarks,'Delete' 
		FROM deleted AS d
	END
END;
DROP Trigger LogPrescription;

--Create a trigger to log all changes made to the Admin table 
--(inserts, updates, and deletes) into the AdminLog table. Include the old and new values for updates.
GO
CREATE Trigger LogAdmin
ON Admin AFTER INSERT,UPDATE,DELETE AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted) and NOT Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO AdminLog(AdminID ,LoginPassword ,AdminName,PhoneNumber,Email,OperationType)
		SELECT i.AdminID ,i.LoginPassword ,i.AdminName,i.PhoneNumber,i.Email,'Insert' 
		FROM Inserted AS i
	END
	IF EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO AdminLog(AdminID ,LoginPassword ,AdminName,PhoneNumber,Email,OperationType)
		SELECT d.AdminID ,d.LoginPassword ,d.AdminName,d.PhoneNumber,d.Email,'Before Update' 
		FROM Deleted AS d

		INSERT INTO AdminLog(AdminID ,LoginPassword ,AdminName,PhoneNumber,Email,OperationType)
		SELECT i.AdminID ,i.LoginPassword ,i.AdminName,i.PhoneNumber,i.Email,'After Update' 
		FROM Inserted AS i
		
	END
	IF NOT EXISTS(SELECT 1 FROM inserted) and Exists(SELECT 1 from deleted)
	BEGIN
		INSERT INTO AdminLog(AdminID ,LoginPassword ,AdminName,PhoneNumber,Email,OperationType)
		SELECT d.AdminID ,d.LoginPassword ,d.AdminName,d.PhoneNumber,d.Email,'Delete' 
		FROM Deleted AS d
	END
END;
DROP Trigger LogAdmin;

--DDL Triggers
--Create a DDL trigger that prevents the deletion of the tables Admin, Doctor, and Patient. 
--If someone tries to drop any of these tables, log the attempt in SkylinesLog.
GO
CREATE Trigger PreventDrop 
ON DATABASE FOR DROP_TABLE AS
BEGIN
	DECLARE @EventData XML=EVENTDATA();
	DECLARE @TableName VARCHAR(128);
	DECLARE @OperationType VARCHAR(50);

	SET @TableName=@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','VARCHAR(128)');
	SET @OperationType=@EventData.value('(/EVENT_INSTANCE/EventType)[1]','VARCHAR(50)');


	if @TableName IN ('Admin','Doctor','Patient')
	BEGIN
		ROLLBACK
		RAISERROR('Cannot Drop These Tables',16,1);
	END
	INSERT INTO SkylinesLog(TableName,OperationType)
	VALUES(@TableName,@OperationType)
END;

DROP Trigger PreventDrop ON DATABASE

--Create a trigger that logs any CREATE, ALTER, or DROP operation performed on any table in the database. 
--Log the operation type and table name in SkylinesLog.
GO
CREATE Trigger LogSchemaChanges
ON DATABASE FOR Create_Table,Drop_Table,Alter_Table AS
BEGIN
	DECLARE @EventData XML=EVENTDATA();
	DECLARE @TableName VARCHAR(128);
	DECLARE @OperationType VARCHAR(50);

	Set @TableName=@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','VARCHAR(128)')
	SET @OperationType=@EventData.value('(/EVENT_INSTANCE/EventType)[1]','VARCHAR(50)')

	INSERT INTO SkylinesLog(TableName,OperationType)
	VALUES(@TableName,@OperationType);
END;
DROP TRIGGER LogSchemaChanges ON DATABASE;

--Prevent adding new columns to the Patient table. 
--If a user tries to add a column, roll back the transaction and display an error message.
GO
CREATE Trigger PreventAddingColumn
ON DATABASE FOR Alter_table AS
BEGIN
DECLARE @EventData XML=EVENTDATA();
	DECLARE @TableName VARCHAR(128);
	DECLARE @OperationType VARCHAR(50);
	DECLARE @TSQLCommand VARCHAR(50);
	DECLARE @Alteroperation VARCHAR(10);
	DECLARE @Altercolumn VARCHAR(20);

	Set @TableName=@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','VARCHAR(128)')
	SET @OperationType=@EventData.value('(/EVENT_INSTANCE/EventType)[1]','VARCHAR(50)')
	SET @TSQLCommand=LOWER(@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]','VARCHAR(50)'))
	
	if CHARINDEX('add',@TSQLCommand)>0
		SET @Alteroperation='ADD COLUMN';

	if(@TableName='Patient' and @Alteroperation='ADD COLUMN')
	BEGIN
		ROLLBACK;
		RAISERROR('Cannot Add column To Patient Table',16,1);
	END

END;

DROP TRIGGER PreventAddingColumn ON DATABASE;

--Create a DDL trigger that prevents the modification of the data type of 
--PhoneNumber in any table (e.g., Patient, Doctor, Admin).
GO
CREATE Trigger PreventChangingColumn
ON DATABASE FOR Alter_table AS
BEGIN
DECLARE @EventData XML=EVENTDATA();
	DECLARE @TableName VARCHAR(128);
	DECLARE @OperationType VARCHAR(50);
	DECLARE @TSQLCommand VARCHAR(50);
	DECLARE @Alteroperation VARCHAR(20);
	DECLARE @Altercolumn VARCHAR(20);
	DECLARE @NewDataType VARCHAR(10);

	Set @TableName=@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','VARCHAR(128)')
	SET @OperationType=@EventData.value('(/EVENT_INSTANCE/EventType)[1]','VARCHAR(50)')
	SET @TSQLCommand=LOWER(@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]','VARCHAR(50)'))
	if CHARINDEX('alter column',@TSQLCommand)>0
		SET @Alteroperation='MODIFY COLUMN';
	IF @Alteroperation = 'MODIFY COLUMN'
    BEGIN
        SET @Altercolumn = SUBSTRING(
            @TSQLCommand,
            CHARINDEX(' alter column ', @TSQLCommand) + 14, 
            CHARINDEX(' ', @TSQLCommand + ' ', CHARINDEX(' alter column ', @TSQLCommand) + 14) - CHARINDEX(' alter column ', @TSQLCommand) - 14
        );
    END

	SET @NewDataType = LTRIM(SUBSTRING(
        @TSQLCommand,
        CHARINDEX(@Altercolumn, @TSQLCommand) + LEN(@Altercolumn) + 1, 
        LEN(@TSQLCommand)
    ));
	if(@Altercolumn='PhoneNumber' and  @NewDataType IS NOT NULL)
	BEGIN
		ROLLBACK;
		RAISERROR('Cannot Change Datatype of column Phone Number',16,1);
	END

END;

DROP TRIGGER PreventChangingColumn ON DATABASE;
