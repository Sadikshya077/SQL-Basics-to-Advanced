/*
	SQL JOIN
	--------------
	1. inner join -> join (gives common data only)
	2. left join
	3. right join
	4. outer join
	5. self join
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