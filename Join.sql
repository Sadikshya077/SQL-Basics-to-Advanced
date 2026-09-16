/*
	SQL JOIN
	--------------
	1. inner join /join (gives common data only)
	2. left join
	3. right join
	4. outer join
	5. self join / join
	6. cross join
	7. natural join

	syntax
	-------------
	select col1, col2, col3, col4
	from table1
	join table2
	on table1.pk = table2.fk;
*/

-- Find customers and their order details.
select sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, so.order_status, so.order_date
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where sc.state= 'TX' and so.order_status=3;

select sc.customer_id, concat(sc.first_name, sc.last_name) as customer_name,
case
	when so.order_status = 1 then 'Pending'
	when so.order_status = 2 then 'Processing'
	when so.order_status = 3 then 'Rejected'
	when so.order_status = 4 then 'Completed'
	end as status_label,
order_date,
soi.list_price, soi.quantity, soi.discount,
((soi.list_price * soi.quantity) * (1-soi.discount)) as total_price
from sales.customers sc
join sales.orders so
on sc.customer_id = so.order_id
join sales.order_items soi
on so.order_id = soi.order_id;

-- Find customer name, total orders and total items in order of customers.

select concat(sc.first_name,' ', sc.last_name) as customer_name,
count(distinct so.order_id) as total_orders,
count(soi.item_id) as total_item
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
group by concat(sc.first_name,' ',sc.last_name) ;


select * from sales.order_items;

-- self join
-- Find staff name and manager names
select concat(s1.first_name,' ',s1.last_name) as manager_name,
concat(s2.first_name,' ',s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- cross join -> cross join is performed in the background of all joins
-- customer_id 1 searches for all customer_id 1 in order table and gives output, similarly for all.
-- cartesian product
select * from sales.customers
cross join sales.orders --takes time to execute

-- we use filter
select * from sales.customers sc
cross join sales.orders so
where (sc.customer_id=1 and so.customer_id=1)
	or (sc.customer_id=2 and so.customer_id=2) --does for all id when we run without using filter
order by 2 desc; -- second column is ordered in descending order

-- Find total staffs, total orders and total customers managed by managers

select 
concat(s1.first_name,' ',s1.last_name) as manager_name,
count(distinct s2.staff_id) as total_staffs,
count(distinct so.order_id) as total_orders,
count(distinct sc.customer_id) as total_customers
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id
join sales.orders so
on s1.staff_id = so.staff_id
join sales.customers sc
on sc.customer_id = so.customer_id
group by concat (s1.first_name,' ',s1.last_name);

-- left join
select * 
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id

-- right join
select *
from sales.staffs s1
right join sales.staffs s2
on s1.staff_id = s2.staff_id

-- outer join
select *
from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id