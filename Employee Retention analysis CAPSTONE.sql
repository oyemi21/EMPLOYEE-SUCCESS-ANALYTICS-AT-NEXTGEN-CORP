select * from attendance
select * from department
select * from employee
select * from performance
select * from salary
select * from turnover

--EMPLOYEE RETENTION ANALYSIS

--1.Who are the top 5 highest serving employees?

select
     e.employee_id,
	 e.first_name  || ' ' || e.last_name as Full_Name,
	 e.hire_date, e.job_title, d.department_name, to_char(s.salary_amount, '$FM999,999.00') as salary_amount,
	 CURRENT_DATE - e.hire_date as Days_served
 from employee e
 join department d ON d.department_id = e.department_id
 join salary s on s.employee_id = e.employee_id
 order by e.hire_date
 limit 5;

select
     e.employee_id,
	 e.first_name  || ' ' || e.last_name as Full_Name,
	 e.hire_date, e.job_title, d.department_name, to_char(s.salary_amount, '$FM999,999.00') as salary_amount,
	 CURRENT_DATE - e.hire_date as Days_served
 from employee e
 join department d ON d.department_id = e.department_id
 join salary s on s.employee_id = e.employee_id
 order by e.hire_date desc
 limit 5;
 
--2.What is the turnover rate for each department?

select d.department_name, 
	count(t.turnover_id) as turnover_count,
	count(e.employee_id) as total_employees,
	round(count(t.turnover_id) * 100.0 / count(distinct e.employee_id), 2) || '%' as "turnover rate"
from department d
left join employee e on e.department_id = d.department_id
left join turnover t on e.employee_id = t.employee_id
group by 1
order by "turnover rate" desc;


select d.department_name, 
	count(t.turnover_id) as turnover_count,
	count(e.employee_id) as total_employees,
	to_char(count(t.employee_id) * 100.0 / count(e.employee_id), 'FM999.00') || '%' as "turnover rate"
from employee e
left join turnover t on t.employee_id = e.employee_id
join department d on e.department_id = d.department_id
group by 1
order by "turnover rate" desc;

--3.Which employees are at risk of leaving based on their performance?
select 
  e.employee_id,
  e.first_name || ' ' || e.last_name as full_name,
  d.department_name,
  p.performance_score,
  e.hire_date,
  p.performance_date,
   count(case when a.attendance_status = 'Absent' then 1 end) AS Absences_over_2months,
  (extract(year from p.performance_date) - e.hire_year) * 12 +
	(extract(month from p.performance_date) - extract(month from e.hire_date)) as tenure_month,
case
	when p.performance_score < 3.5 then 'High Risk'
	else 'Low Risk'
	end as "Risk level"
from employee e
join performance p on e.employee_id = p.employee_id
join department d on e.department_id = d.department_id
left join attendance a on a.employee_id = e.employee_id
left join turnover t on e.employee_id = t.employee_id
where t.employee_id is null
  and p.performance_score < 3.5
  and p.performance_date = (
    select max(p2.performance_date)
    from performance p2
    where p2.employee_id = e.employee_id
  )
group by 1,2,3,4,5,6
order by p.performance_score asc,Absences_over_2months desc;

--4.What are the main reasons employees are leaving the company?

select reason_for_leaving, count(turnover_id) as "Number of past employees",
    round(count(turnover_id) * 100.0 / (
	select count(*) from turnover),2) || '%' as "Percentage of total"
from turnover
group by 1
order by "Number of past employees" desc;

select reason_for_leaving, count(turnover_id) as "Number of past employees",
   to_char(count(turnover_id) * 100.0 / (
	select count(*) from turnover), 'FM999.00') || '%' as "Percentage of total"
from turnover
group by 1
order by "Number of past employees" desc;


select reason_for_leaving,
	count(turnover_id) as "Number of past employees"
from turnover
group by 1
order by "Number of past employees" desc;