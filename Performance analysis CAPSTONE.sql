select * from attendance
select * from department
select * from employee
select * from performance
select * from salary
select * from turnover

--PERFORMANCE ANALYSIS

--1.How many employees has left the company?

select d.department_name,count(t.employee_id) as "past employees"
from turnover t
join department d on d.department_id = t.department_id
group by 1
order by "past employees" desc;

select count(turnover_id) as "past employees"
from turnover;

select d.department_name,count(e.employee_id) as total_employees,
	count(t.turnover_id) as "past employees"
from department d
inner join employee e on e.department_id = d.department_id
left join turnover t on t.employee_id = e.employee_id
group by 1
order by "past employees" desc;

select 
  d.department_name,
  extract(year from t.turnover_date) as turnover_year,
  count(distinct t.turnover_id) as annual_turnovers
from department d
join employee e on d.department_id = e.department_id
join turnover t on e.employee_id = t.employee_id
where t.turnover_date is not null
group by 1,2
order by turnover_year desc, d.department_name;

select 
  extract(year from t.turnover_date) as turnover_year,
  count(distinct t.turnover_id) as annual_turnovers
from turnover t
group by 1
order by turnover_year desc;

--2.How many employees have a performance score of 5.0 / below 3.5?

select 'score = 5' as performance, count(distinct employee_id) as "Total employees"
from performance
	where performance_score = 5
group by 1
union all
select 'score < 3.5' as performance, count(distinct employee_id) as "Total employees"
from performance
	where performance_score < 3.5
group by 1;


--3.Which department has the most employees with a performance of 5.0 / below 3.5?

select *
from (
	select 'score = 5' as Performance, d.department_name, count(p.employee_id) as "employee count"
from performance p
join department d on d.department_id = p.department_id
	where p.performance_score = 5
group by d.department_name
order by "employee count" desc
limit 1
	) as "Score 5"
union all
select *
from (
	select 'score < 3.5' as Performance, d.department_name, count(p.employee_id) as "employee count"
from performance p
join department d on d.department_id = p.department_id
	where p.performance_score < 3.5
group by d.department_name
order by "employee count" desc
limit 1
	) as "Score < 3.5";


--4.What is the average performance score by department?
select d.department_name, 
	to_char(avg(p.performance_score), 'FM999.00') as "Avg performance score"
from performance p
left join department d on d.department_id = p.department_id
group by 1
order by "Avg performance score" desc;

select d.department_name,
	round(avg(p.performance_score), 2) as "Avg performance score"
from performance p
left join department d on d.department_id = p.department_id
group by 1
order by "Avg performance score" desc;