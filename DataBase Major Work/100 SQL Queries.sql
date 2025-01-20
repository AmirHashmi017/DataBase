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