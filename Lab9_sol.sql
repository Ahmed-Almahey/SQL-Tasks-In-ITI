

--Name: Ahmed Elsayed Almahey

--1.Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 

use iti

create proc getnum 
as 
select count(st_id),dept_name
from Department d inner join student s 
on s.Dept_Id = d.Dept_Id
group by dept_name 


getnum


--2.Create a stored procedure that will check for the # of employees in the project p1 
--if they are more than 3 print message to the user “'The number of employees in the 
--project p1 is 3 or more'” if they are less display a message to the user 
--“'The following employees work for the project p1'” in addition 
--to the first name and last name of each one. [Company DB] 

use SD

create proc CheckEmp_num  
as 
  declare @x int 
  select @x = count(e.empNo)
  from emp e inner join Works_On w
  on e.empNo = w.EmpNo 
  inner join company.project p
  on p.ProjectNo = w.ProjectNo and p.ProjectNo = 'p1'
  if @x >= 3 
      select 'The number of employees in the project p1 is 3 or more'
  else 
    begin
      select 'The following employees work for the project p1' as [emps work in p1]
	  union all
	  select concat(fname ,' ', lname)
	  from emp e inner join Works_On w
      on e.empNo = w.EmpNo 
      inner join company.project p
      on p.ProjectNo = w.ProjectNo and p.ProjectNo = 'p1'
    end 

CheckEmp_num


--3.Create a stored procedure that will be used in case there is an old employee has left the project
--and a new one become instead of him. The procedure should take 3 parameters (old Emp. number,
--new Emp. number and the project number) and it will be used to update works_on table. [Company DB]

use Company_SD

create proc up_emp(@oldemp int,@newemp int, @pnumber int)
as 
update ws 
set essn = @newemp 
from employee e inner join Works_for ws
on e.SSN = ws.ESSn 
inner join project p 
on pno = pnumber and essn = @oldemp and pnumber = @pnumber 

up_emp 112233, 102660, 100



--4.	add column budget in project table and insert any draft values in it  
--then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New  
--p2 	         Dbo 	    2008-01-3        95000       200000 

--This table will be used to audit the update trials on the Budget column (Project table, Company DB)

alter table project add budget float

create table audit(
ProjectNo varchar(10),
UserName varchar(40),
ModifiedDate date,
Budget_Old float,
Budget_New float
)

create trigger t1
on project 
after update 
as 
  if update(budget)
     begin
	    declare @pno varchar(10),@bold float, @bnew float
		   select @pno= pnumber from deleted 
		   select @bold = budget from deleted
		   select @bnew = budget from inserted
		insert into audit 
		values (@pno, suser_name(),getdate(),@bold,@bnew)
	 end
    

--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”

use iti

create trigger t2
on department 
instead of insert 
as
  select 'Print a message for user to tell him that he can’t insert a new record in that table'


--6.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

use Company

create trigger t1  
on employee
instead of insert 
as
  if format(getdate(),'MMMM') = 'march'
    select 'Not allowed'
  else 
    insert into employee 
	select * from inserted 

--7.	Create a trigger on student table after insert to add Row in Student Audit table
--(Server User Name , Date, Note) where note will be “[username] Insert New Row with 
--Key=[Key Value] in table [table name]”

--Server User Name		Date 	Note 

use iti

create table audit (
ServerUserName varchar(100),
Date date,
Note varchar(50)
)

create trigger t6
on student
after insert 
as  
    declare @key int 
	select @key = st_id from inserted
    insert into audit 
	values (suser_name(),getdate(), suser_name() + 'Insert New Row with Key = ' +cast (@key as varchar(20)) + ' in table student')


--8.Create a trigger on student table instead of delete to add Row in Student Audit table
--(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”

create trigger t4
on student 
instead of delete 
as 
  insert into audit 
  values (suser_name(),getdate(),'try to delete row with key = ' + (select st_id from deleted))


--1.Create a sequence object that allow values from 1 to 10 without
--cycling in a specific column and test it.

CREATE SEQUENCE seq_test
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10
NO CYCLE;

CREATE TABLE test_table (
    id INT
);

INSERT INTO test_table (id)
VALUES (NEXT VALUE FOR seq_test);

--2.Create full, differential Backup for SD DB.


--Part2:
--1.	Transform all functions in lab7 to be stored procedures

---1.	Create a scalar function that takes date and returns Month name of that date.

create proc getMonName(@date date)
as
	 select format(@date,'MMMM')
	 
getMonName '10/1/2022'

---2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create proc getRange(@x int,@y int) 
as  
  declare @t table (val int)
    if @x < @y
	begin
     set @x +=1
	 while @x < @y
	  begin
	   insert into @t 
	   select @x
	   set @x += 1
	  end
	end
	else if @y < @x
     begin
	 set @y += 1
	 while @y < @x
	  begin
	   insert into @t 
		 select @y
		  set @y +=1
	   end
	 end
  select * from @t 

  getRange 1,5


---3.Create inline function that takes Student No and returns Department Name with Student full name.

create proc getSt(@x int)
as
   select Dept_Name, concat(St_Fname ,' ',St_Lname )as fullname
   from Student s inner join Department d
   on s.Dept_Id = d.Dept_Id
   where St_Id = @x

getSt 1
 
---4.	Create a scalar function that takes Student ID and returns a message to user 
---a.	If first name and Last name are null then display 'First name & last name are null'
---b.	If First name is null then display 'first name is null'
---c.	If Last name is null then display 'last name is null'
---d.	Else display 'First name & last name are not null'

create proc checkName(@x int)
as
   declare @fname varchar(20), @lname varchar(20),@result varchar(40) 
	select @fname = st_fname , @lname =st_lname from Student
	 where st_id = @x
   if @fname is null and @lname is null
     set @result =  'First name & last name are null'
   else if @fname is null and @lname is not null 
     set @result =  'first name is null'
   else if @fname is not null and @lname is null 
     set @result = 'last name is null'
   else 
     set @result =  'First name & last name are not null'
 select @result     
 
 checkName 5


 
---5.	Create inline function that takes integer which represents manager ID 
--and displays department name, Manager Name and hiring date 

create proc getMgr(@x int)
as
	SELECT dept_name, ins_name, manager_hiredate
	FROM Instructor i inner join Department d
	    ON i.Ins_Id = d.Dept_Manager
		WHERE Dept_Manager = @x

getMgr 5


---6.	Create multi-statements table-valued function that takes a string
---If string='first name' returns student first name
---If string='last name' returns student last name 
---If string='full name' returns Full Name from student table 
---Note: Use “ISNULL” function

create proc stName(@name varchar(10))
AS
declare @t table (
[Students Names] varchar(20)
)
	IF @name = 'first name'
	   INSERT INTO @t
	   SELECT ISNULL(st_fname,' ') FROM Student
	ELSE IF @name = 'last name'
	   INSERT INTO @t
	   SELECT ISNULL(st_Lname,' ') FROM Student
	ELSE IF @name = 'full name'
	   INSERT INTO @t
	   SELECT concat(st_fname,' ',St_Lname) FROM Student
select * from @t

stName 'full name'

