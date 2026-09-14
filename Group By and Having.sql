/*
	Group By and Having
	=======================
	Syntax
	---------
	select col_name1, col_name, agg(col_name)
	from table_name
	group by non_agg_columns; in this case group by col_name1, col_name2

	Rule - Group by
	-----------------------
	1. If any non-aggregate columns are defined with aggregate columns then non-aggregate columns
		must be defined on group by clause
	2. If we remove the non-agg columns in the select and since they are still in the table, it doesn't throw error,
		it just don't get displayed in output

	Having
	------------
	1. used to filter aggregate column data
	2. having only filters those columns which are defined in group by clause

	Difference between having and where
	------------------------------------
	1. where is used to filter non-agg columns while having for agg columns
	2. To use having clause, the column must be defined in group by clause while for where
		it's possible to filter even if the columns just exist in the table

	Execution Flow
	------------------------------------
	From, Join, Where, Group by, Having, Select, Distinct, Order by, limit/top/offset fetch

	SQL Relational Algebra
	--------------------------------
	Projection (Pie) - Join (X) - Selection (Sigma)
*/

-- Find total customers from each state and city
select state, count(customer_id) as total_customer 
from sales.customers
group by state, City
having count(customer_id)>10;


-- Order by, top, offset fetch
-----------------------------------------------------

-- top and offset fetch is only used in sql not limit
select top 5
state, count(customer_id) as total_customer 
from sales.customers
group by state, City
order by total_customer desc;

-- Offset fetch
-- offset -> set rows value to skip
-- fetch -> shows specific number of rows after skipping

select City, state, count(customer_id) as total_customer
from sales.customers
group by city, state
order by total_customer desc
offset 10 rows fetch next 10 rows only; -- first 10 rows are skipped and next 10 rows are given

-- SQL CASE
/*
	select
		case
			when condition then value
			when condition then value
			when condition then value / else value
		End as label
	from table name;
*/

select
	distinct order_status,
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
		else 'Rejected'
	end as status_label
from sales.orders;

--------------------------------------------------
select
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
		else 'Rejected'
	end as status_label,
	count(order_id) as total_orders
from sales.orders
group by
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
		else 'Rejected'
	end;

-- or we can do it as : 

select
	distinct order_status,
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
		else 'Rejected'
	end as status_label,
	count(order_id) as total_orders
from sales.orders
group by order_status;

-- another method to do this: 
-- sum case / count case
select
	sum(case when order_status =1 then 1 else 0 end) as Pending,
	-- here if order_status = 1 then it sets it to 1 and add, 0 for others
	sum(case when order_status = 2 then 1 else 0 end) as Processing,
	-- here if order_status = 2 then it sets it to 1 and add, 0 for others
	sum(case when order_status = 3 then 1 else 0 end) as Rejeceted,
	sum(case when order_status = 4 then 1 else 0 end) as Completed
from sales.orders;
-- or
select 
	count(case when order_status=1 then 1 end) as Pending,
	count(case when order_status =2 then 1 end) as Processing,
	count(case when order_status = 3 then 1 end) as Rejected,
	count(case when order_status =4 then 1 end) as Completed
from sales.orders;