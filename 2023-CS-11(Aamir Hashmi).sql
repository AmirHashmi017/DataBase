Activity One:-
1.
CREATE TABLE Student (
    RegNo INT,
    FirstName VARCHAR(10),
    LastName VARCHAR(10),
    GPA FLOAT,
    Contact VARCHAR(10)
);
2.
INSERT INTO Student (RegNo, FirstName, LastName, GPA, Contact)
VALUES
    (11, 'Amir', 'Hashmi', 3.68, '0328-4136880'),
    (28, 'Mobeen', 'Butt', NULL, '0300-7696400'), -- Student with undefined GPA
    (17, 'Mustafa', 'Noor', 3.73, '0321-4111365'),
    (6, 'Anas', 'Sahi', NULL, '0301-4544864'), -- Student with undefined GPA
    (14, 'Asad', 'Tayab', 3.42, '0304-4314533');
3.
Select * from Student;
4.
Select Contact, LastName from  Student;
5.
Select * from Student where GPA>3.5;
Select * from Student where GPA<=3.5;
6.
The above two queries do not cover all the data because there are two students whose GPA is Null i.e Undefined and these 2 queries are not showing them.
7.
Select FirstName + LastName AS FullName From Student;

Activity 02:-
1.
Select GPA+30/10 AS Result From Student;
Select (GPA+30)/10 AS Result From Student;
They give different answers due to precedence.In first case the expression 30/10 will be solved first where in 2nd case the expression in braces will be solved first which will result in different answers.
2.
Select GPA*3 AS Result From Student;
Null value remains null even after mathematical operation as in this case after multiplication.

3.Distinct Clause
Select Distinct FirstName from Student;


4.Comarison Operators
Select * from Products where UnitsInStock = 5;
Select * from Products where UnitsInStock <>5;
Select * from Products where UnitsInStock >5;
Select * from Products where UnitsInStock <50;
Select * from Products where UnitsInStock >=5;
Select * from Products where UnitsInStock <=50;
5.Logical Operators
Select City from Employees where LastName IS NULL;
Select ProductName, UnitPrice from Products where ReorderLevel BETWEEN 5 AND 10;
Select * from Employees where Country IN ('USA','UK');
Select * from Employees where City Like ('lo%') ;
Select * from Employees where  Not City = 'London';
Select * from Products where UnitsInStock = 5 ctOr UnitsInStock=50;
Select * from Products where UnitsInStock >5 and UnitsInStock<50;
6.Order By Clause
Select ProductName, from Products order by UnitsInStock ASC;
Select ProductName, from Products order by UnitsInStock DESC;
Select ProductName,ReorderLevel from Products order by ReorderLevel DESC ;
7.Top N Clause
Select TOP 10 ProductName,from Products order by UnitsInStock ASC;
Select TOP 10 ProductName, from Products order by UnitsInStock DESC;
Select TOP 10 ProductName,ReorderLevel from Products order by ReorderLevel DESC ;
