
--1.	Display the Department id, name and id and the name of its manager.

select dnum,dname,mgrssn,concat(fname,' ',lname) as [manager name]
from departments d inner join Employee e
on d.MGRSSN = e.ssn

--2.	Display the name of the departments and the name of the projects under its control.

select dname,pname
from departments d, Project p
where d.dnum = p.dnum

--3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.

select concat(fname,' ',lname) , d.*
from employee e inner join  Dependent d
on ssn = essn

--4.	Display the Id, name and location of the projects in Cairo or Alex city.

select pname,pnumber,plocation
from Project
where city in ('cairo','alex')

--5.	Display the Projects full data of the projects with a name starts with "a" letter.

select *
from project
where pname like 'a%'

--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

select concat(fname,' ',lname) as [employee name]
from employee
where Dno = 30 and salary between 1000 and 2000

--7.	Retrieve the names of all employees in department 10 who works more than or equal 10 
--hours per week on "AL Rabwah" project.

select concat(fname,' ',lname)as [employee name]
from employee inner join Works_for 
on essn = ssn and dno = 10 and Hours >=10 
inner join project
on pno = pnumber and pname = 'AL Rabwah'

--8.	Find the names of the employees who directly supervised with Kamel Mohamed.

select concat(y.fname,' ',y.lname)as [employee name]
from employee x , employee y
where x.ssn = y.Superssn and x.fname = 'kamel' and x.lname = 'mohamed'


--9.	Retrieve the names of all employees and the names of the projects they are working on, 
--sorted by the project name.

select concat(fname,' ',lname)as [employee name], pname
from employee , Works_for, project
where essn = ssn and pnumber = Pno
order by pname

--10.	For each project located in Cairo City , find the project number, the controlling department name 
--,the department manager last name ,address and birthdate.

select pnumber , dname ,lname as [manager last name], address , bdate
from departments d inner join project p
on d.dnum = p.dnum
inner join employee 
on ssn = mgrssn and city = 'cairo' 


--11.	Display All Data of the managers

select e.*
from departments inner join employee e
on mgrssn = ssn 

--12.	Display All Employees data and the data of their dependents even if they have no dependents

select * 
from employee left outer join dependent 
on essn = ssn 

--13.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672,
--Superssn = 112233, salary=3000.

insert into employee (dno, ssn,superssn , salary) 
values (30,102672, 112233, 3000)

--14.	Insert another employee with personal data your friend as new employee in department number
--30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.

insert into employee (dno,ssn)
values (30,102660)

--15.	Upgrade your salary by 20 % of its last value.

update employee 
set salary *=1.2  
where ssn = 102672

