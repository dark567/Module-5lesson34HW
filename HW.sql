create database MYBb;

--drop database MYBb;

use MYBb;
go

if not exists (select * from sysobjects where name='Department' and xtype='U')
BEGIN
    create table MYBb.[dbo].[Department]
(
    [Id] [int] primary key IDENTITY (1, 1) NOT NULL,
	[Name] nvarchar(100) NOT NULL,
)
END
--else 
--drop table MYBb.[dbo].[Department]

if not exists (select * from sysobjects where name='Employee' and xtype='U')
BEGIN
create table MYBb.[dbo].[Employee]
(
    [Id] [int] primary key IDENTITY (1, 1) NOT NULL,
	[ChiefId] [int] NULL references Employee(Id),
	[Name] nvarchar(100) NOT NULL,
	[Salary] money not null
)
END
--else 
--drop table MYBb.[dbo].[Employee]
go


alter table MYBb.[dbo].[Employee] add DepartmentId int not null;
alter table MYBb.[dbo].[Employee] ADD foreign key (DepartmentId) references MYBb.[dbo].[Department](Id) 
go



insert into MYBb.[dbo].[Department] ([Name]) values ('Technology');
insert into MYBb.[dbo].[Department] ([Name]) values ('Accountants');
insert into MYBb.[dbo].[Department] ([Name]) values ('Cleaning');
insert into MYBb.[dbo].[Department] ([Name]) values ('Teachers');

--drop table [MYBb].[dbo].[Employee];
--drop table [MYBb].[dbo].[Department];
--select SCOPE_IDENTITY();


insert into [MYBb].[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Boss Niga', 100, 1);
declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Vasya', 110000, 1);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Petya', 20, 1);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Katya', 30, 1);


insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Carl', 100, 2);
declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(SCOPE_IDENTITY(), 'Mick', 10, 2);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Boss Stone', 100, 2);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Mickl', 150, 2);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Clark', 30, 2);


--declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Boss Jone', 100, 3);
declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Dav', 20, 3);
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Larisa', 30, 3);

--declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Marina', 100, 4);
declare @scope int = SCOPE_IDENTITY();
insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(@scope, 'Larisa Petrovna', 300, 4);

insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'Medvedko', 300, 4);

insert into MYBb.[dbo].[Employee] (ChiefId, Name, Salary, DepartmentId)
values(null, 'St.Medvedko', 350, 1);



--delete from MYBb.[dbo].[Department] where id = 1;
--delete from MYBb.[dbo].[Employee] where id = 1;

select * from [Employee];

select * from MYBb.[dbo].[Employee];

/*1 ќтсортированный в обратном пор€дке список отделов с количеством сотрудников*/
select dp.Name, count(e.DepartmentId ) as 'count' from Department dp
join Employee e on e.DepartmentId = dp.id
group by dp.Name
order by 1 desc


/*2 ¬ывести список сотрудников, получающих заработную плату большую чем у непосредственного руководител€ */ 
select * from Employee em
join Employee emB on emB.Id = em.ChiefId and emB.Salary < em.Salary


/*3 ¬ывести список отделов, количество сотрудников в которых не превышает 3 человек */
select dep.name, count(DepartmentId) from Department dep
join Employee em on em.DepartmentId = dep.Id
group by dep.name, DepartmentId
having count(DepartmentId)>3

/*4 ¬ывести список сотрудников, получающих максимальную заработную плату в своем отделе*/
select em.name, em.Salary
from   employee em
where  em.salary = ( select max(salary) from employee emm
                    where  emm.DepartmentId = em.DepartmentId )

select name, Salary from employee em  
join (select DepartmentId, max(salary) as max_salary 
         from employee  
         group by DepartmentId) emm on emm.DepartmentId=em.DepartmentId
where em.salary = emm.max_salary

/*5 Ќайти список отделов с максимальной суммарной зарплатой сотрудников*/

with sum_salary as
  ( select DepartmentId, sum(salary) salary
    from   employee
    group  by DepartmentId )
select DepartmentId
from   sum_salary a       
where  a.salary = ( select max(salary) from sum_salary )

select id
from Department 
where id = (select top 1 DepartmentId, salary  
              from employee 
			  group by DepartmentId, salary
			  order by salary desc)

select DepartmentId, salary  
        from employee 
		group by DepartmentId, salary
		order by salary desc




/*6 ¬ывести список сотрудников, не имеющих назначенного руководител€, работающего в том-же отделе*/

select em.*
from employee em
left join employee emm on emm.id = em.ChiefId and emm.DepartmentId = em.DepartmentId
where  emm.id is null

select em.* from employee em 
where not exists(select null from employee e2 where em.ChiefId = e2.id and em.DepartmentId=e2.DepartmentId)

/*7 SQL-запрос, чтобы найти вторую самую высокую зарплату работника*/

SELECT max(salary) FROM Employee WHERE salary < (SELECT max(salary) FROM Employee);

SELECT TOP 1 salary FROM (SELECT TOP 2 salary FROM Employee ORDER BY salary desc) AS emp ORDER BY salary;