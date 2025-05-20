

--Name: Ahmed Elsayed Almahey



create table department (
dep_no varchar(10) primary key ,
deptName varchar(20),
location varchar(10),
)

create rule r1 as @x in ('NY','DS','KW')

sp_bindrule r1,'department.location'
sp_unbindrule 'company.department.location'

create default def1 as 'NY'

sp_addtype loc, 'nchar(2)'

sp_bindrule r1,loc

sp_bindefault def1,loc

alter table company.department 
alter column location loc


create table employee(
empNo int primary key,
fname varchar(20) not null,
lname varchar(20) not null,
deptNo varchar(10),
salary float
constraint c1 foreign key (deptNo) references department(dep_No)
constraint c2 unique (salary)
)

create rule r2 as @x < 6000

sp_bindrule r2, 'employee.salary'

--inserting the values into tables

insert into Department (dep_no, DeptName, Location)
values  ('d1', 'Research', 'NY'),
  ('d2', 'Accounting', 'DS'),
  ('d3', 'Marketing', 'KW')

insert into Employee (EmpNo, Fname, Lname, DeptNo, Salary)
values  (25348, 'Mathew', 'Smith', 'd3', 2500),
 (10102, 'Ann', 'Jones', 'd3', 3000),
 (18316, 'John', 'Barrimore', 'd1', 2400),
 (29346, 'James', 'James', 'd2', 2800)

 insert into project (ProjectNo, ProjectName, Budget)
values 
  ('p1', 'Apollo', 120000),
  ('p2', 'Gemini', 95000),
  ('p3', 'Mercury', 185600);

 insert into WORKIS_ON (EmpNo, ProjectNo, Job, Enter_Date)
values (10102, 'p1', 'Analyst', '10/1/2006'),
  (10102, 'p3', 'Manager', '1/1/2012'),
  (25348, 'p2', 'Clerk', '2/15/2007'),
  (18316, 'p2', NULL, '6/1/2007');

   --Testing Referential Integrity
  --1
  insert into works_on (empNo) -- error because ProjectNo is part of the pk and doesn't allow null
  values (1111)

 --2
 update works_on -- error because EmpNo is a fk in works_on and 11111 doesn't exist in the parent table 
  set EmpNo = 11111 
  where EmpNo =10102
  
  --3
  update employee -- error because 10102 is a value that's used in the child table works_on 
  set EmpNo =  22222
  where  EmpNo = 10102 

  --4
  delete from employee -- error because we cann't delete a parent that has a child in another table
  where empNO = 10102

  --Table modification
  --1 
  alter table employee
  add  TelephoneNumber int

  --2
  alter table employee
  drop column TelephoneNumber

  --3 the diagram was built


 -- 2.	Create the following schema and transfer the following tables to it 

 --a.	Company Schema 
 --i.	Department table (Programmatically)

 create schema company

 alter schema company transfer department

 --b. Human Resource Schema
--i.  Employee table (Programmatically)

create schema Human_Resource 

alter schema Human_Resource transfer employee

--3. Write query to display the constraints for the Employee table.

 Sp_helpconstraint 'human_resource.employee'

--4. Create Synonym for table Employee as Emp and then run the following queries and describe the results

create synonym emp for Human_Resource.employee

--a.	
Select * from Employee

--b.	
Select * from [Human_Resource].Employee

--c.
Select * from emp

--d.
Select * from [Human Resource].Emp

--5.	Increase the budget of the project where the manager number is 10102 by 10%.

update company.Project
set budget *= 1.1
from company.project p inner join Works_On w
on p.ProjectNo = w.ProjectNo 
where EmpNo = 10102

--6.	Change the name of the department for which the employee named James works.The new department name is Sales.

update company.department
set deptName = 'sales'
from emp , company.department
where dep_no= deptNo and fname = 'james'


--7.	Change the enter date for the projects for those employees who work in project p1 and 
--belong to department ‘Sales’. The new date is 12.12.2007.

update Works_On 
set Enter_Date = '12/12/2007'
from Works_On w, emp e , company.department d
where e.empNo = w.EmpNo and dep_no = deptNo and deptName = 'sales' and ProjectNo = 'p1'


--8. Delete the information in the works_on table for all employees who work for the department located in KW.

delete Works_On
from Works_On w inner join emp e  
on w.EmpNo = e.empNo
inner join company.department d
on dep_no = deptNo and location = 'KW'

--9.	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB 
--then allow him to select and insert data into tables and deny Delete and update .(Use ITI DB)


