--Creating table
create TABLE sample(dept int ,salary int,empid int)
-- inserting values in the table
INSERT into sample VALUES
(1,100,1),
(1,200,2),
(2,50,1),
(2,100,2),
(2,150,3),
(2,200,4),
(3,20,1);


select * from sample;

insert into sample values(3,10,1);
-- 2nd Highest Salary
with base as (
	select dept, salary
	from sample s1
	where salary < (select max(salary) from sample s2 where s1.dept = s2.dept)
),
base1 as (
	select dept,max(salary) as salary 
	from base b1  
	group by 1	
),
dept as (
	select distinct dept as deptname  from sample
)
select deptname, base1.salary from dept left join base1  on dept.deptname = base1.dept 



---# 3rd Highest Salary
with base as (
	select dept, salary
	from sample s1
	where salary < (select max(salary) from sample s2 where s1.dept = s2.dept)
),
base1 as (
	select dept, salary
	from base b1
	where salary < (select max(salary) from base b2 where b1.dept = b2.dept)
),
base2 as (
	select dept, max(salary) as salary from base1 group by 1
),
dept as (
	select distinct dept as deptname  from sample
)
select deptname, base2.salary from dept left join base2  on dept.deptname = base2.dept



-- dynamic program for nth highest salary 
--For 1st highest Remove offset
--- for nth highest salary put offset=(n-1)
select * from
  sample as t1
where
  t1.salary = (select
               salary
             from
               sample
             where
             sample.dept = t1.dept ORDER by salary desc limit 1 offset 1);
