--Activity One:

--Aggregate Functions:

--1. Average
Select AVG(UnitPrice) from Products

--2.Minimum
Select MIN(UnitPrice) from Products

--3.Sum
Select SUM(UnitPrice)from Products

--4. Count
Select COUNT(UnitPrice) from Products

--5.Standard Deviation
Select STDEV(UnitPrice) from Products

--6.Standard Deviation Population
Select STDEVP(UnitPrice) from Products

--7.Variance
Select VAR(UnitPrice) from Products

--8.Variance Population
Select VARP(UnitPrice) from Products

--9.Maximum
Select MAX(UnitPrice) from Products


--Activity Two:

--Group Functions Using Having Clause:

--1.Average
Select ProductID, AVG(UnitPrice) from Products Group by ProductID having AVG(UnitPrice)>30;

--2.Minimum
Select ProductID, Min(UnitPrice) from Products Group by ProductName having MIN(UnitPrice)>70;

--3.Sum
Select ProductID, Sum(UnitPrice) from Products as TotalPrice Group by ProductName having Sum(UnitPrice)>15;

--4.Count
SELECT Title, COUNT(*) FROM Employees GROUP BY Title HAVING COUNT(*)>1

--5.Standard Deviation
Select ProductID, STDEV(UnitPrice) from Products as STD group by ProductID having STDEV(UnitPrice)>15; 

--6.Standard Deviation Population
Select ProductID, STDEVP(UnitPrice) from Products as STD group by ProductID having STDEVP(UnitPrice)>15;

--7.Variance
Select ProductID, VAR(UnitPrice) from Products as STD group by ProductID having VAR(UnitPrice)>15;

--8.Variance Population
Select ProductID, VARP(UnitPrice) from Products as STD group by ProductID having VARP(UnitPrice)>15;

--9.Maximum
Select ProductName, MAX(UnitPrice) from Products Group by ProductName having MAX(UnitPrice)>40;

--Activity Three:

--1.Aliasing Columns
Select ContactName as AlternateName from Suppliers
--2.Aliasing Tables
Select * from Shippers as Shippings