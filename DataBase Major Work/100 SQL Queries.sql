use SQLPractice

--100 SQL Queries Pracice

--Question:01
select * From employees

--Question:02
select salary From employees

--Question:03
select DISTINCT job_name From employees

--Question:04
SELECT emp_name, '$' + FORMAT(((salary + (0.15 * salary)) / 290), 'N2') AS "15% Increased Salary in Dollars" FROM employees;

--Question:05
SELECT emp_name+' & '+job_name AS "Employee & Job" FROM employees;

--Question:06
SELECT emp_name+'('+job_name+')' AS Employee FROM employees;

--Question:07
SELECT emp_id,emp_name,salary,FORMAT(hire_date,'MMMM dd,yyyy') AS "Hire Date" 
FROM employees where FORMAT(hire_date,'MMMM dd, yyyy')='February 22, 1991';

--Question:08
SELECT emp_name,LEN(Replace(emp_name,' ','')) AS "Employee Name Length" FROM employees 

--Question:09
SELECT emp_id,salary,commision FROM employees

--Question:10
SELECT DISTINCT job_name,dep_id FROM employees

--Question:11
SELECT * FROM employees WHERE dep_id<>2001

--Question:12
SELECT * FROM employees WHERE hire_date<'1991-01-01'

--Question:13
SELECT AVG(salary) AS "Average ANALYST Salary" FROM employees WHERE job_name='ANALYST'

--Question:14
SELECT * FROM employees WHERE emp_name='BLAZE'

--Question:15
SELECT * FROM employees WHERE commision>salary

--Question:16
SELECT * FROM employees WHERE (salary +salary*0.25)>3000

--Question:17
SELECT emp_name FROM employees WHERE LEN(emp_name)=6

--Question:18
SELECT * FROM employees WHERE MONTH(hire_date)=01

--Question:19
SELECT e.emp_name +' works for '+ ISNULL(m.emp_name,'No one') AS "Employee Manager Relationship" 
FROM employees e LEFT JOIN employees m ON e.manager_id=m.emp_id;

--Question:20
SELECT * FROM employees WHERE job_name='CLERK'