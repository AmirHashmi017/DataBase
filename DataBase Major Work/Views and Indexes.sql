--Creating view of two tables Department and Nurse for simplifying query logic in future
CREATE VIEW NurseDepartment AS SELECT n.NurseID,n.NurseName,n.Salary,d.DepartmentName 
FROM Nurse as n JOIN Department as d
ON n.DepartmentID=d.DepartmentID;

--Test
SELECT DepartmentName FROM NurseDepartment WHERE Salary>10000

--Creating Indexes of different types to optimize queries

--1. Clustered indexes: actual physical storage of records. A table can have only one clustered index
--In case of primary key it is automatically created
CREATE CLUSTERED INDEX idx_depid ON
Department(DepartmentID)

--2. Non-Clustered indexes: There can be many on one table stores sorted columns 
--seperately along with keys pointing actual records
CREATE NONCLUSTERED INDEX idx_nurse ON
Nurse(NurseName)

--3. Composite Indexes: Non-Clustered Indexes On multiple columns
CREATE INDEX idx_nursecom ON
Nurse(NurseName,PhoneNumber)

--4. Covering Indexes: Non-Clustered Indexes which also covers data needed for query and don't need to go
--to actual table
CREATE INDEX idx_nursecovering ON
Nurse(PhoneNumber) INCLUDE(NurseName,DepartmentID)

--5. Unique Indexes: Used for primary key enforcement
CREATE UNIQUE INDEX unique_num ON 
NURSE(PhoneNumber)
SELECT * FROM Nurse
INSERT INTO Nurse(NurseID,NurseName,DepartmentID,PhoneNumber,Salary)
VALUES('N003','ASM','DPT001','9876543210',2000)

--6. Filtered Indexes: Non Clustered Indexes based on filtering rows
CREATE INDEX idx_nursefilter ON Nurse(Salary)
WHERE Salary>20000