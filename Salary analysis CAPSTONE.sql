select * from attendance
select * from department
select * from employee
select * from performance
select * from salary
select * from turnover

--SALARY ANALYSIS

--1.What is the total salary expense for the company?

select count(e.employee_id) as total_employees,
	to_char(sum(s.salary_amount),'FM$999,999,999.00') as "Total salary expense"
from salary s
join employee e on e.employee_id = s.employee_id;


select d.department_name,
	to_char(sum(s.salary_amount),'FM$999,999,999.00') as "Total salary expense"
from salary s
join department d on d.department_id = s.depaartment_id
join employee e on e.employee_id = s.employee_id;
group by 1;

--highest
select d.department_name, e.job_title,
	to_char(sum(s.salary_amount),'FM$999,999,999.00') as "Total salary expense"
from salary s
join department d on d.department_id = s.depaartment_id
join employee e on e.employee_id = s.employee_id
group by 1,2
order by sum(s.salary_amount) desc
limit 5;

--lowest
select d.department_name, e.job_title,
	to_char(sum(s.salary_amount),'FM$999,999,999.00') as "Total salary expense"
from salary s
join department d on d.department_id = s.depaartment_id
join employee e on e.employee_id = s.employee_id
group by 1,2
order by sum(s.salary_amount)
limit 5;



--2.What is the average salary by job title?

select e.job_title,
	to_char(avg(s.salary_amount),'$FM999,999,999.00') as "Avg salary"
from salary s
join employee e on e.employee_id = s.employee_id
group by 1
order by avg(s.salary_amount) desc;


select e.job_title,
	'$'|| to_char(avg(s.salary_amount),'FM999,999,999.00') as "Avg salary"
from salary s
join employee e on e.employee_id = s.employee_id
group by 1
order by avg(s.salary_amount) desc;


--3.How many employees earn above 80,000?

select 'salary > $80,000' as category,count(distinct employee_id) as "employees"
from salary
	where salary_amount > 80000
group by 1
union all
select 'salary <= $80,000' as category,count(distinct employee_id) as "employees"
from salary
	where salary_amount <= 80000
group by 1;


--4.How does performance correlate with salary across departments?

select d.department_name, 
	round(avg(p.performance_score),2) as "Avg performance score",
	to_char(avg(s.salary_amount),'$FM999,999,999.00') as "Avg salary"
from salary s
join performance p on p.employee_id = s.employee_id
join department d on d.department_id = p.department_id
group by 1
order by avg(p.performance_score) desc;


select d.department_name, 
	round(avg(p.performance_score),2) as "Avg performance score",
	'$'|| to_char(avg(s.salary_amount),'FM999,999,999.00') as "Avg salary"
from salary s
join performance p on p.employee_id = s.employee_id
join department d on d.department_id = p.department_id
group by 1
order by "Avg performance score" desc;

--5. Who are the top 5 highest paid employees?

select e.employee_id, e.first_name ||' '||e.last_name as "full name",
	e.job_title, d.department_name,
	'$'|| to_char(s.salary_amount,'FM999,999,999.00') as "Salary"
from employee e
join salary s on s.employee_id = e.employee_id
join department d on d.department_id = e.department_id
order by s.salary_amount desc
limit 10;

--lowest paid employees

select e.employee_id, e.first_name ||' '||e.last_name as "full name",
	e.job_title, d.department_name,
	'$'|| to_char(s.salary_amount,'FM999,999,999.00') as "Salary"
from employee e
join salary s on s.employee_id = e.employee_id
join department d on d.department_id = e.department_id
order by s.salary_amount
limit 10;

