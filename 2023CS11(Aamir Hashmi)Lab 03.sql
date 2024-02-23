--Task 01
--Cross JOIN
Select A.OrderID, B.OrderID
FROM Orders A, Orders B;
--Equi Join
select C.CustomerID,C.CompanyName,O.orderID,O.OrderDate from Customers AS C Join Orders AS O ON C.CustomerID=O.CustomerID AND O.OrderDate='1997-07-04';
--InnerJoin
Select Customers.CustomerID, Orders.OrderID, Orders.OrderDate From Customers Inner Join Orders ON Customers.CustomerID = Orders.CustomerID Where YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) = 7;
--Left/LeftOuterJoin
Select C.CustomerID,Count(O.OrderID) AS TotalOrders From Customers AS C Left Outer Join Orders AS O On C.CustomerID=O.CustomerID GROUP BY C.CustomerID;
--Right/RightOuterJoin
select *
from [Order Details] right outer join Orders
on [Order Details].Quantity = Orders.EmployeeID
select [Order Details].UnitPrice
from [Order Details] full outer join Orders
on [Order Details].UnitPrice = Orders.Freight;
--Task 02
select *
from [Order Details] self cross join [Order Details];

Select A.OrderID, B.OrderID
FROM Orders A, Orders B;
--Task03
Select C.CustomerID,C.CompanyName, O.OrderID, O.OrderDate From Customers AS C Inner Join Orders AS O ON C.CustomerID = O.CustomerID;
--Task04
Select C.CustomerID,O.OrderID,O.OrderDate From Customers AS C Left Join Orders AS O ON C.CustomerID=O.CustomerID;
--Task 05
Select C.CustomerID, O.OrderID, O.OrderDate From Customers AS C Left Join Orders AS O ON C.CustomerID = O.CustomerID Where O.OrderID IS NULL;
--Task 06
Select Customers.CustomerID, Orders.OrderID, Orders.OrderDate From Customers Inner Join Orders ON Customers.CustomerID = Orders.CustomerID Where YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) = 7;
--Task 07
Select C.CustomerID,Count(O.OrderID) AS TotalOrders From Customers AS C Left Join Orders AS O On C.CustomerID=O.CustomerID GROUP BY C.CustomerID;
--Task 08
select * from Employees
Select E.EmployeeID, E.FirstName, E.LastName
From Employees AS E
Cross Join 
    (Select 1 AS num UNION ALL
     Select 2 UNION ALL
     Select 3 UNION ALL
     SELECT 4 UNION ALL
     SELECT 5) AS numbers;
	--Task 09
	Select E.EmployeeID, DATEADD(DAY, d.number, '1996-07-04') AS Date From Employees AS E Cross Join (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS number From Information_Schema.Columns) AS d Where DATEADD(DAY, d.number, '1996-07-04') <= '1997-08-04';
	--Task 10
	Select
    C.CustomerID,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(OD.Quantity) AS TotalQuantity From Customers AS C Join 
    Orders AS O ON C.CustomerID = O.CustomerID Join
    [Order Details] AS OD ON O.OrderID = OD.OrderID
Where
    C.Country = 'USA'
GROUP BY
    C.CustomerID;
--Task 11
select C.CustomerID,C.CompanyName,O.orderID,O.OrderDate from Customers AS C Left Join Orders AS O ON C.CustomerID=O.CustomerID AND O.OrderDate='1997-07-04';
--Task12
Select E.EmployeeID, E.FirstName AS EmployeeFirstName, E.LastName AS EmployeeLastName, E.BirthDate AS EmployeeBirthDate,
    M.EmployeeID AS ManagerID, M.FirstName AS ManagerFirstName, M.LastName AS ManagerLastName, M.BirthDate AS ManagerBirthDate
From Employees AS E
Left Join Employees AS M 
ON E.EmployeeID <> M.EmployeeID
Where E.BirthDate > M.BirthDate OR M.EmployeeID IS NULL;
--Task 13
Select P.ProductName, O.OrderDate
FROM Orders AS O
Join [Order Details] AS OD 
ON O.OrderID = OD.OrderID
Join Products AS P 
ON OD.ProductID = P.ProductID
Where O.OrderDate = '1997-08-08';
--Task 14
Select C.Address, C.City, C.Country
From Orders AS O
Join Customers AS C 
ON O.CustomerID = C.CustomerID
Join Shippers AS S 
ON O.EmployeeID = S.ShipperID
Where O.EmployeeID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Anne') 
    AND O.ShippedDate > O.RequiredDate;
--Task 15
Select Distinct C.Country
From Orders AS O
Join [Order Details] AS OD 
ON O.OrderID = OD.OrderID
Join Products AS P 
ON OD.ProductID = P.ProductID
Join Customers AS C 
ON O.CustomerID = C.CustomerID
Where P.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages');

