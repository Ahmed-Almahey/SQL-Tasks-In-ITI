use company_sd

--1.	Display (Using Union Function)
--a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
--b.	 And the male dependence that depends on Male Employee.

select Dependent_name, d.Sex 
from dependent d inner join employee e
on ssn = ESSN and d.sex = 'F' and e.sex = 'f'
union all 
select Dependent_name, d.Sex 
from dependent d inner join employee e
on ssn = ESSN and d.sex = 'm' and e.sex = 'm'

--2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.

select pname , sum(hours)
from employee inner join Works_for
on ssn = essn
inner join project 
on pnumber = Pno
group by pname



--3.	Display the data of the department which has the smallest employee ID over all employees' ID.

select d.* 
from Departments d inner join employee e 
on dno = Dnum
where ssn = (select min(ssn) from employee)

--4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

select dname , max(salary) as [max salary], min(salary) as [min salary], avg(salary) as [average salary]
from Departments inner join Employee
on dno = Dnum
group by dname 


--5.	List the full name of all managers who have no dependents.

select concat(fname,' ',lname) as [manager name]
from employee inner join Departments
on MGRSSN= ssn
where MGRSSN not in (select essn from dependent)


--6.	For each department-- if its average salary is less than the average salary of all employees
-- display its number, name and number of its employees.

select dname, dnum , count(ssn) [number of employees]
from Departments inner join Employee
on dnum = dno
group by dname, Dnum
having avg(salary) <(select avg(salary) from employee)


--7.	Retrieve a list of employee’s names and the projects names they are working on ordered by department number
 --and within each department, ordered alphabetically by last name, first name.

 select pname , concat(fname,' ',lname) as [employee name]
 from employee inner join Works_for 
 on essn = ssn 
 inner join project
 on Pno = Pnumber
 order by Dno,fname,lname


 --8.	Try to get the max 2 salaries using sub query

 select max(salary) as [max two salaries] from employee 
union all 
select max(salary)
from employee
where Salary < (select max(salary) from employee) 


--9.	Get the full name of employees that is similar to any dependent name

select concat(fname,' ',lname) as [employee name]
from employee inner join Dependent
on essn = SSN
where concat(fname,' ',lname) = Dependent_name

--10.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.

select ssn , concat(fname,' ',lname) as [employee name]
from employee
where exists(
select 6
from dependent 
where essn = ssn
)

--11.	In the department table insert new department called "DEPT IT”, with id 100, employee with
--SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'

insert into Departments 
values('DEPT IT',100,112233,'1/11/2006')


--12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to 
--be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
--a.	First try to update her record in the department table
--b.	Update your record to be department 20 manager.
--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

update departments 
set mgrssn = 968574 , [MGRStart Date] = getdate()
where dnum = 100

update departments 
set mgrssn = 102672 , [MGRStart Date] = getdate()
where dnum = 20

update employee 
set superssn =  102672
where ssn = 102660


--13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete 
--his data from your database in case you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or 
--works in any projects and handle these cases).

delete from dependent 
where essn = 223344

delete from Works_for
where essn = 223344

update  Departments
set mgrssn = 102672
where mgrssn = 223344



update employee
set superssn = 102672
where Superssn = 223344

delete from employee
where ssn = 223344


--14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%

update employee 
set salary *=1.3
from employee , Works_for,Project
where ssn = essn and pnumber = Pno and pname = 'Al Rabwah'
