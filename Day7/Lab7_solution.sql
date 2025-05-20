
Name: Ahmed Elsayed Almahey

USE ITI

---1.	Create a scalar function that takes date and returns Month name of that date.
create function getMonName(@date date)
returns varchar(10)
as
	begin
		return format(@date,'MMMM')
	end

SELECT dbo.getMonName('10/1/2022') 


---2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
alter function getRange(@x int,@y int)
 returns @t table 
      ([range Of Values] int)
as  
  begin
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
   return
  end
 
select * from getRange(1,8)

---3.	 Create inline function that takes Student No and returns Department Name with Student full name.
create function getSt(@x int)
returns table
as
	 return
		 (
		 select Dept_Name, concat(St_Fname ,' ',St_Lname )as fullname
		 from Student s inner join Department d
			on s.Dept_Id = d.Dept_Id
			where St_Id = @x)

SELECT * FROM getSt(12)

---4.	Create a scalar function that takes Student ID and returns a message to user 
---a.	If first name and Last name are null then display 'First name & last name are null'
---b.	If First name is null then display 'first name is null'
---c.	If Last name is null then display 'last name is null'
---d.	Else display 'First name & last name are not null'

create function checkName(@x int)
returns varchar(40)
begin
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
 return @result
 end                       

select dbo.checkName(5) as [checking result]

---5.	Create inline function that takes integer which represents manager ID 
--and displays department name, Manager Name and hiring date 

create function getMgr(@x int)
returns table as return(
	SELECT dept_name, ins_name, manager_hiredate
	FROM Instructor i inner join Department d
		ON i.Ins_Id = d.Dept_Manager
		WHERE Dept_Manager = @x)


SELECT * FROM getMgr(5)

---6.	Create multi-statements table-valued function that takes a string
---If string='first name' returns student first name
---If string='last name' returns student last name 
---If string='full name' returns Full Name from student table 
---Note: Use “ISNULL” function
create function stName(@name varchar(10))
returns @t table
(
[Students Names] varchar(20)
)
AS
BEGIN
	IF @name = 'first name'
	   INSERT INTO @t
	   SELECT ISNULL(st_fname,' ') FROM Student
	ELSE IF @name = 'last name'
	   INSERT INTO @t
	   SELECT ISNULL(st_Lname,' ') FROM Student
	ELSE IF @name = 'full name'
	   INSERT INTO @t
	   SELECT concat(st_fname,' ',St_Lname) FROM Student
	RETURN
END


SELECT * FROM stName('full name')

---7.	Write a query that returns the Student No and Student first name without the last char
SELECT st_id, SUBSTRING(st_fname, 1, len(st_fname) - 1) AS fname
FROM Student

---8.	Write query to delete all grades for the students Located in SD Department 
delete sc 
from student s inner join Stud_Course sc
 ON sc.St_Id = s.St_Id 
 inner join Department d
ON s.Dept_Id = d.Dept_Id and  d.Dept_Name = 'SD'

--I think this is the right solution because the question mentioned deleting just grades not the entire rows
UPDATE sc
SET sc.grade = NULL
FROM Stud_Course sc
INNER JOIN Student s ON sc.St_Id = s.St_Id
INNER JOIN Department d ON s.Dept_Id = d.Dept_Id and d.Dept_Name = 'SD'


Bonus:
--1.	Give an example for hierarchyid Data type
--2.	Create a batch that inserts 3000 rows in the student 
--table(ITI database). The values of the st_id column should be unique and between 3000 and 6000.
--All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.


--1
CREATE TABLE Org (
  ID INT,
  Name VARCHAR(30),
  Position HIERARCHYID
)

INSERT INTO Org VALUES 
(1, 'CEO', hierarchyid::GetRoot()),
(2, 'Manager', hierarchyid::GetRoot().GetDescendant(NULL, NULL))

SELECT  ID, Name, Position.ToString() AS PositionPath
FROM  Org
ORDER BY Position;


--2
DECLARE @iterator int = 3000  
WHILE @iterator <6000
	BEGIN
	INSERT INTO Student(St_Id,St_Fname,St_Lname)
	VALUES(@iterator,'Jane','Smith')
	SET @iterator+=1
	END

