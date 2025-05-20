
--Name : Ahmed Elsayed Almahey

Use ITI 

--1. Create a view that displays student full name, course name if the student has a grade more than 50. 

create view Vs
as 
 select concat(st_fname,' ',st_lname) as [Full Name], Crs_Name
 from student s inner join Stud_Course sc 
 on s.St_Id = sc.St_Id 
 inner join Course c
 on c.Crs_Id = sc.Crs_Id and Grade > 50

 select * from vs

 --2. Create an Encrypted view that displays manager names and the topics they teach. 

 create view Mg
 with encryption 
 as
 select ins_name , Top_name
 from department inner join Instructor i
 on Dept_Manager = Ins_Id
 inner join Ins_Course as si
 on i.ins_id = si.ins_id
 inner join course c
 on c.crs_id = si.crs_id
 inner join topic t
 on c.top_id = si.top_id

 select * from Mg


 --3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 

 create view ins_dpm 
 as 
  select ins_name, dept_name
  from Instructor i inner join Department d
  on d.Dept_Id = i.Dept_Id
  where Dept_Name in ('SD','Java')

  select * from ins_dpm 

  
--4. Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

create view v1
as 
 select * from Student
 where St_Address in ('alex','cairo')
 with check option

 select * from v1

Update V1 set st_address='tanta'
Where st_address='alex'


--5.Create a view that will display the project name and the number of employees work on it. “Use SD database”

use sd

create view pro
as 
select projectName, count(w.empNo) as [number of employees] 
from emp e inner join works_on w
on e.empNo = w.empNo
inner join company.project p
on P.ProjectNo = w.ProjectNo
group by projectName

select * from pro

--6.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?

create clustered index in_hd --error
on department(manager_hiredate)

--7.Create index that allow u to enter unique ages in student table. What will happen? 

create unique index i --error
on student(st_age)

--8.	Using Merge statement between the following two tables [User ID, Transaction Amount]

create table dailytransactions (user_id int, tran_amount float)
create table lasttransactions (user_id int, tran_amount float)

merge into lasttransactions as T
using dailytransactions as s 
on s.user_id = t.user_id
when matched then 
   update 
   set t.tran_amount = s.tran_amount
when not matched then 
   insert 
   values(s.user_id,s.tran_amount) 
output $action;


--9.	Create a cursor for Employee table that increases Employee salary by 10% if 
--Salary <3000 and increases it by 20% if Salary >=3000. Use company DB

use company_sd

declare c1 cursor 
for select salary from employee 
for update
declare @sal int 
open c1 
fetch c1 into @sal
while @@FETCH_STATUS = 0
    begin
	   if @sal < 3000
	    update employee 
		set salary = @sal *1.1
		where current of c1
	   else if @sal >= 3000
	    update employee 
		set salary = @sal * 1.2
		where current of c1
	 fetch c1 into @sal
	end
close c1 
deallocate c1


--10.Display Department name with its manager name using cursor. Use ITI DB

declare c1 cursor
for select dname , concat(fname,' ',lname) as [full name] from Departments inner join employee
on mgrssn = ssn
for read only
declare @dn varchar(10), @mn varchar(20)
open c1 
fetch c1 into @dn , @mn
while @@FETCH_STATUS = 0 
    begin
	  select @dn, @mn
	  fetch c1 into @dn,@mn
    end
close c1
deallocate c1


--11.Try to display all students first name in one cell separated by comma. Using Cursor 

use iti

declare c1 cursor 
for select distinct st_fname from student where st_fname is not null
for read only
declare @name varchar(20), @allnames varchar(300)
open c1 
fetch c1 into @name
while @@FETCH_STATUS = 0
    begin
	  set @allnames = concat(@allnames,',',@name)
	  fetch c1 into @name
	end 
select @allnames
close c1 
deallocate c1

--12.Try to generate script from DB ITI that describes all tables and views in this DB

--done

--13.	Use import export wizard to display student’s data (ITI DB) in excel sheet


--Part2: use SD_DB

--1)Create view named   “v_clerk” that will display employee#,project#,
--the date of hiring of all the jobs of the type 'Clerk'.

use sd

create view v_clerk 
as
select e.empNo ,p.ProjectNo,enter_date 
from emp e inner join Works_On w
on e.empNo = w.EmpNo 
inner join company.project p
on w.ProjectNo = p.ProjectNo

select * from v_clerk

--2)Create view named  “v_without_budget” that will display all the projects data 
--without budget

create view v_without_budget 
as
select ProjectNo, ProjectName 
from company.project

select * from v_without_budget


--3)Create view named  “v_count “ that will display the project name and the # of jobs in it

create view v_count 
as 
select ProjectName , count(job) as [number of jobs]
from company.project p inner join Works_On w
on p.ProjectNo = w.ProjectNo
group by projectName

select * from v_count


--4) Create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’
--use the previously created view  “v_clerk”

create view v_project_p2 
as 
select e.empNo ,ProjectNo, ProjectName from v_clerk 
where ProjectNo = 'p2'

select * from v_project_p2


--5) modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 

alter view v_without_budget 
as
select ProjectNo, ProjectName 
from company.project
where ProjectNo in ('p1','p2')

select * from v_without_budget

--6) Delete the views  “v_ clerk” and “v_count”

drop view v_clerk , v_count

--7) Create view that will display the emp# and emp lastname who works on dept# is ‘d2’

create view dd 
as
select empNo, lname 
from company.department  inner join emp 
on dep_no = deptNo and deptNo = 'd2'


select * from dd

--8) Display the employee lastname that contains letter “J”
--Use the previous view created in Q#7

select lname from dd
where lname like '%j%'

--9) Create view named “v_dept” that will display the department# and department name.

create view v_dept 
as select deptName , dep_no
from company.department

select * from v_dept

--10)using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’

insert into v_dept 
values ('Devlopment', 'd4')



--11)	Create view name “v_2006_check” that will display employee#, the project #where he works and 
--the date of joining the project which must be from the first of January and the last of December 2006.

create view v_2006_check 
as 
select e.empNo, p.projectNo,location , enter_date
from emp e inner join company.department
on deptNo =dep_no
inner join works_on w
on w.EmpNo = e.empNo
inner join company.project p
on w.projectNo = p.projectNo and enter_date between '1/1/2006' and '12/31/2006'


select * from v_2006_check 
