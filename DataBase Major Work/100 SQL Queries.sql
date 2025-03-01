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

--Question:21
select * from employees where DATEDIFF(YEAR,hire_date,GETDATE())>27

--Question:22
select * from employees where salary<3500

--Question:23
select emp_name,job_name,salary from employees where job_name='ANALYST'

--Question:24
select * from employees where YEAR(hire_date)=1991

--Question:25
select emp_id,emp_name,hire_date,salary from employees where hire_date<'1991-04-01'

--Question:26
select emp_name,job_name from employees where manager_id IS NULL;

--Question:27
select * from employees where hire_date='1991-05-01'

--Question:28
select emp_id,emp_name,salary,CAST(DATEDIFF(YEAR,hire_date,GETDATE()) AS varchar) + ' Years' AS "Experience" from employees
where manager_id=68319

--Question:29
select emp_id,emp_name,salary,CAST(DATEDIFF(YEAR,hire_date,GETDATE()) AS varchar) + ' Years' AS "Experience" from employees
where (salary/30)>100

--Question:30
select emp_name,hire_date from employees where DATEDIFF(YEAR,hire_date,'2000-01-01')>=8

--Question:31
select * from employees where salary%2=1

--Question:32
select * from employees where LEN(CAST(salary AS INT))=3

--Question:33
select * from employees where MONTH(hire_date)=4

--Question:34
select * from employees where DAY(hire_date)<19

--Question:35
select * from employees where job_name='SALESMAN' and DATEDIFF(MONTH,hire_date,GETDATE())>10

--Question:36
select * from employees where dep_id IN(3001,1001) and YEAR(hire_date)=1991

--Question:37
select * from employees where dep_id IN(1001,2001)

--Question:38
select * from employees where dep_id=2001 and job_name='CLERK'

--Question:39
select * from employees where (commision<=salary and (salary+commision)<34000) and (dep_id=3001 and job_name='SALESMAN')

--Question:40
select * from employees where job_name IN ('CLERK','MANAGER')

--Question:41
select * from employees where MONTH(hire_date)<>02

--Question:42
select * from employees where YEAR(hire_date)=1991

--Question:43
select * from employees where MONTH(hire_date)=06 and YEAR(hire_date)=1991

--Question:44
select * from employees where (salary*12) BETWEEN 24000 and 50000

--Question:45
select * from employees where hire_date IN ('1991-05-01','1991-02-20','1991-12-03')

--Question:46
select * from employees where manager_id IN (63679,68319,66564,69000)

--Question:47
select * from employees where MONTH(hire_date)>06 and YEAR(hire_date)=1991

--Question:48
select * from employees where YEAR(hire_date)>=1990 and YEAR(hire_date)<=1999

--Question:49
select * from employees where job_name='MANAGER' and dep_id IN(1001,2001)

--Question:50
select * from employees where MONTH(hire_date)=02 and salary BETWEEN 1001 and 2000

--Question:51
select * from employees where YEAR(hire_date)<>1991

--Question:52
select e.emp_id,e.emp_name,e.job_name,e.manager_id,e.hire_date,e.salary,e.commision,d.dep_id,d.dep_name 
from employees AS e LEFT JOIN department as d ON e.dep_id=d.dep_id

--Question:53
select e.emp_id,e.emp_name,e.job_name,(e.salary*12) AS "Annual Salary",e.dep_id,s.grade
from employees AS e LEFT JOIN salary_grade as s ON e.salary BETWEEN s.min_salary and s.max_salary
Where (e.salary*12)>=60000 and job_name<>'ANALYST'

--Question:54
select e.emp_id,e.emp_name,e.job_name,e.manager_id,e.salary,m.emp_name AS "Manager Name",m.salary AS "Manager Salary"
from employees AS e LEFT JOIN employees as m ON e.manager_id=m.emp_id WHERE e.salary>m.salary

--Question:55
select e.emp_name,d.dep_id,e.salary,e.commision from employees as e LEFT JOIN department as d ON e.dep_id=d.dep_id
where (e.salary between 2000 and 5000) and d.dep_location<>'PERTH'

--Question:56
select e.emp_name,s.grade,e.dep_id,e.hire_date from employees as e LEFT JOIN salary_grade as s ON e.salary between s.min_salary and s.max_salary
where e.dep_id IN (1001,3001) and s.grade<>4 and e.hire_date<'1991-12-31'

--Question:57
select e.emp_id,e.emp_name,e.job_name,e.salary,e.commision,e.manager_id,e.salary,m.emp_name AS "Manager Name"
from employees AS e LEFT JOIN employees as m ON e.manager_id=m.emp_id WHERE m.emp_name='JONAS'

--Question:58
select e.emp_name,e.salary,s.grade,s.max_salary from employees as e LEFT JOIN salary_grade as s 
ON e.salary between s.min_salary and s.max_salary where e.salary=s.max_salary and emp_name='FRANK'

--Question:59
select * from employees where salary between 2000 and 5000 and commision IS NULL and job_name IN ('MANAGER','ANALYST')

--Question:60
select e.emp_id,e.emp_name,d.dep_id,e.salary,d.dep_location FROM employees as e LEFT JOIN department as d 
ON e.dep_id=d.dep_id where d.dep_location IN ('MELBOUNE','PERTH') and DATEDIFF(MONTH,hire_date,GETDATE())>10

--Question:61
select e.emp_id,e.emp_name,d.dep_id,e.salary,e.hire_date,d.dep_location FROM employees as e LEFT JOIN department as d 
ON e.dep_id=d.dep_id where YEAR(hire_date)=1991 and d.dep_location IN ('MELBOUNE','SYDNEY') and 
e.salary BETWEEN 2000 and 5000

--Question:62
select d.dep_id,d.dep_name,d.dep_location,e.emp_id,e.emp_name,e.salary,s.grade 
from department as d LEFT JOIN employees as e ON d.dep_id=e.dep_id
LEFT JOIN salary_grade AS s ON e.salary BETWEEN s.min_salary and s.max_salary
where dep_name='MARKETING' and dep_location IN ('MELBOURNE','PERTH') and s.grade IN (3,4,5) and
DATEDIFF(YEAR,hire_date,GETDATE())>=25

--Question:63
select e.* from employees AS e JOIN employees as m ON e.manager_id=m.emp_id WHERE e.hire_date<m.hire_date

--Question:64
select e.*,s.grade from employees as e JOIN salary_grade as s ON e.salary BETWEEN s.min_salary and s.max_salary 
where s.grade=4

--Question:65
select e.emp_name,e.hire_date,d.dep_name from employees as e LEFT JOIN department as d ON e.dep_id=d.dep_id
where YEAR(hire_date)>1991 and e.emp_name not IN('MARKER','ADELYN') and d.dep_name NOT IN('PRODUCTION','MARKETING')

--Question:66
select emp_id,emp_name ,salary from employees ORDER BY salary ASC

--Question:67
select * from employees ORDER BY dep_id ASC,job_name DESC

--Question:68
select DISTINCT(job_name) from employees ORDER BY job_name DESC

--Question:69
select emp_id,emp_name,salary,(salary/30) AS "Daily_salary",(salary*12) AS "Annual Salary" from employees 
ORDER BY (Salary*12) ASC

--Question:70
select * from employees where job_name IN ('CLERK','ANALYST') ORDER BY job_name DESC

--Question:71
select e.emp_name,d.dep_location from employees as e LEFT JOIN department as d 
on e.dep_id=d.dep_id where e.emp_name='CLARE'

--Question:72
select * from employees where hire_date IN ('1991-05-01','1991-12-03','1990-01-19') ORDER BY hire_date ASC

--Question:73
select * from employees where salary<1000 ORDER BY salary ASC

--Question:74
select * from employees ORDER BY salary ASC

--Question:75
select * from employees ORDER BY job_name ASC,emp_id DESC

--Question:76
select DISTINCT job_name from employees where dep_id in (2001,3001)

--Question:77
select * from employees where job_name not IN ('PRESIDENT','MANAGER') ORDER BY salary ASC

--Question:78
select emp_id,emp_name,salary,(salary*12) AS "Annual Salary" from employees where (salary*12)<25000
ORDER BY Salary ASC

--Question:79
select emp_id,emp_name,job_name,salary,(salary/30) AS "Daily_salary",(salary*12) AS "Annual Salary" from employees 
where job_name='SALESMAN' ORDER BY (Salary*12) ASC

--Question:80
select emp_id,emp_name,job_name,salary,hire_date,GETDATE() AS "Current Date",
DATEDIFF(YEAR,hire_date,GETDATE()) AS "Experience in years" from employees 
ORDER BY "Experience in years" ASC
--The use of calculated one experience below is known as Aliasing.

--Question:81
select * from employees where hire_date>'1991-06-30' ORDER BY job_name ASC

--Question:82
select e.emp_name,d.dep_id,d.dep_name,d.dep_location from employees as e LEFT JOIN department as d
ON e.dep_id=d.dep_id where d.dep_name IN ('FINANCE','AUDIT') ORDER BY d.dep_id ASC

--Question:83
select e.emp_id,e.emp_name,e.salary,s.grade from employees as e LEFT JOIN salary_grade as s
ON e.salary BETWEEN s.min_salary and s.max_salary ORDER BY s.grade ASC

--Question:84
select e.emp_id,e.emp_name,e.job_name,d.dep_id,d.dep_name,e.salary,s.grade 
from department as d JOIN employees as e ON d.dep_id=e.dep_id LEFT JOIN salary_grade as s
ON e.salary BETWEEN s.min_salary and s.max_salary ORDER BY d.dep_name ASC

--Question:85
select e.emp_id,e.emp_name,e.job_name,d.dep_id,d.dep_name,e.salary,s.grade 
from department as d JOIN employees as e ON d.dep_id=e.dep_id LEFT JOIN salary_grade as s
ON e.salary BETWEEN s.min_salary and s.max_salary where job_name<>'CLERK' ORDER BY e.salary DESC

--Question:86
select e.emp_id,e.emp_name,e.job_name,d.dep_id,d.dep_name,e.salary,s.grade 
from department as d JOIN employees as e ON d.dep_id=e.dep_id LEFT JOIN salary_grade as s
ON e.salary BETWEEN s.min_salary and s.max_salary where job_name<>'CLERK' ORDER BY e.salary DESC

--Question:87
select e.*,d.dep_name,d.dep_location from employees as e LEFT JOIN department as d ON d.dep_id=e.dep_id

--Question:88
select e.*,m.hire_date AS "Manager Hire Date" from employees as e JOIN employees as m 
ON e.manager_id=m.emp_id where e.hire_date<m.hire_date

--Question:89
select * from employees where dep_id=1001 ORDER BY salary ASC

--Question:90
select MAX(salary) AS "Maximum Salary" FROM employees

--Question:91
select AVG(salary) AS "Average Salary",AVG(salary+ISNULL(commision,0)) AS "Average Remuneration"
from employees GROUP BY job_name

--Question:92
select job_name ,SUM(salary*12) AS "Total Annual Salary" FROM employees AS "Annual Salary" 
WHERE YEAR(hire_date)=1991 GROUP BY job_name

--Question:93
select e.emp_id,e.emp_name,d.dep_id,d.dep_name,d.dep_location from employees as e 
LEFT JOIN department as d ON d.dep_id=e.dep_id

--Question:94
select e.emp_id,e.emp_name,d.dep_id,d.dep_name,d.dep_location from employees as e 
LEFT JOIN department as d ON d.dep_id=e.dep_id where d.dep_id IN (1001,2001)

--Question:95
select e.emp_id,e.emp_name,e.salary,s.grade from employees as e LEFT JOIN salary_grade as s 
ON e.salary BETWEEN s.min_salary and s.max_salary

--Question:96
select m.emp_id AS "ManagerID",m.emp_name AS "Manager Name", COUNT(e.emp_id) AS "Number of Employees Under"
FROM employees as m JOIN employees AS e ON m.emp_id=e.manager_id GROUP BY m.emp_id,m.emp_name 
ORDER BY "Number of Employees Under" ASC

--Question:97
select dep_id,job_name,COUNT(emp_id) AS "No. of Employees" from employees GROUP BY dep_id,job_name 

--Question:98
select dep_id,COUNT(emp_id) AS "No. of Employees" from employees GROUP BY dep_id HAVING COUNT(emp_id)>=2

--Question:99
select s.grade,s.max_salary,COUNT(e.emp_id) AS "No. Of Employees" FROM salary_grade AS s LEFT JOIN employees AS e 
ON e.salary BETWEEN s.min_salary and s.max_salary GROUP BY s.grade,s.max_salary

--Question:100
select d.dep_name,s.grade,COUNT(e.emp_id) AS "No. Of Employees" FROM department AS d LEFT JOIN employees AS e 
ON d.dep_id=e.dep_id LEFT JOIN salary_grade AS s
ON e.salary BETWEEN s.min_salary and s.max_salary WHERE e.job_name='SALESMAN' GROUP BY d.dep_id,d.dep_name,s.grade HAVING 
COUNT(e.emp_id)>=2

