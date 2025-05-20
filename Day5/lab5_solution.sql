--Part-1: Use ITI DB
use iti

--1.	Retrieve number of students who have a value in their age. 

select count(*)
from student
where st_age is not null

--2.	Get all instructors Names without repetition

select distinct ins_name
from Instructor

--3.	Display student with the following Format (use isNull function)

select isnull(st_id,''),concat(isnull(St_Fname,'no first name'),' ',isnull(St_Lname,'no last name'))  [Student Full Name]
             ,isnull(Dept_Name,'')
from student s inner join Department d
on s.Dept_Id=d.Dept_Id


--4.	Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not

select ins_name, dept_name
from Instructor left outer join Department d
on Ins_Id= d.Dept_Id

--5.	Display student full name and the name of the course he is taking
--For only courses which have a grade

select concat(St_Fname,' ',St_Lname)  [Student Full Name], crs_name 
from student s inner join Stud_Course sc
on s.St_Id = sc.st_id
inner join Course c
on sc.Crs_Id = c.Crs_Id and grade is not null


--6.	Display number of courses for each topic name

select top_name,count(crs_id) as [number of courses]
from Course c inner join topic t
on c.top_id = c.Top_Id
group by Top_Name

--7.	Display max and min salary for instructors

select max(salary) [max salary], min(salary) [min salary]
from Instructor

--8.	Display instructors who have salaries less than the average salary of all instructors.

select * 
from Instructor
where salary < (select avg(salary) from Instructor)

--9.	Display the Department name that contains the instructor who receives the minimum salary.

select dept_name
from Department d inner join Instructor i
on i.Dept_Id = d.Dept_Id and salary = (select min (salary) from Instructor)


--10.	 Select max two salaries in instructor table.

select top(2) salary
from Instructor
order by salary desc

--11.	 Select instructor name and his salary but if there is no salary
--display instructor bonus keyword. “use coalesce Function”

select ins_name ,coalesce (convert(varchar(20),salary), 'instructor bonus')
from Instructor

--12.	Select Average Salary for instructors

select avg(salary)
from Instructor

--13.	Select Student first name and the data of his supervisor 

select y.st_fname, x.*
from Student x inner join Student y
on x.St_Id= y.St_super

--14.	Write a query to select the highest two salaries in Each Department for instructors 
--who have salaries. “using one of Ranking Functions”

select salary as [top 2 salaries in each dep] , Rn
from
(select *, ROW_NUMBER() over( partition by dept_id order by salary desc ) as rn 
from Instructor) as newtable
where rn  < = 2 and salary is not null


--15.	 Write a query to select a random student from each department.  “using one of Ranking Functions”

select *
from 
(select *, ROW_NUMBER() over (PARTITION BY dept_id order by newid() ) as Rn
from student)as newtable
where Rn = 1


--Part-2: Use AdventureWorks DB

use AdventureWorks2012

--1.	Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to 
--show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014'


--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)

select ProductID,Name
from Production.Product
where StandardCost < 110

--3.	Display ProductID, Name if its weight is unknown

select ProductID, Name
from Production.Product
where weight is null

--4.	 Display all Products with a Silver, Black, or Red Color

select *
from Production.Product
where color in ('Silver', 'Black', 'Red')

--5.	 Display any Product with a Name starting with the letter B

select *
from Production.Product
where name like 'B%'

--6.	Run the following Query
--UPDATE Production.ProductDescription
--SET Description = 'Chromoly steel_High of defects'
--WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select Description 
from Production.ProductDescription
where Description like '%[_]%'
 
 --7.	Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader
 --table for the period between  '7/1/2001' and '7/31/2014'

 select  OrderDate ,sum(TotalDue) as sum 
 from Sales.SalesOrderHeader
 where OrderDate between '7/1/2001' and '7/31/2014'
 group by OrderDate 

--8. Display the Employees HireDate (note no repeated values are allowed)

select distinct HireDate 
from HumanResources.Employee

--9.	 Calculate the average of the unique ListPrices in the Product table

select avg(distinct ListPrice)
from Production.Product

--10.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format 
--"The [product name] is only! [List price]" (the list will be sorted accordingto its ListPrice value

select concat(name ,' is only! ', listprice) 
from Production.Product
order by ListPrice

--11.	

--a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from 
--Sales.Store table  in a newly created table named [store_Archive]
--Note: Check your database to see the new table and how many rows in it?
--b)	Try the previous query but without transferring the data? 

select rowguid ,Name, SalesPersonID, Demographics into store_Archive
from Sales.Store --701 rows

select rowguid ,Name, SalesPersonID, Demographics into store_Archive1
from Sales.Store
where 1 =2

--12.	Using union statement, retrieve the today’s date in different styles using convert or format funtion.

select format(getdate(), 'yyyy-MM-dd')                  
union
select format(getdate(), 'MMMM-dd-yy')         
union
select format(getdate(), 'dddd-M-yy')  
