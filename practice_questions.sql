/* Customer Base by Region Tier: Write a query using the customers table to group customers by
their state. Use a CASE expression within the SELECT and GROUP BY clauses to label 'NY' as
'East Coast', 'CA' as 'West Coast', and any other state as 'Other Region'. Only display region groups
that have a total customer count greater than 30. */

select state, count(customer_id) as total_customers,
case
	when state='TX' then 'East Coast'
	when state='CA' then 'West Coast'
	else 'Other Region'
	end as region_groups
from sales.customers
group by state
having count(customer_id)>30;

/* Product Category Stock Evaluation: Write a query using the products table to group items by
their category ID. Use a CASE expression to count how many products in each category are
'Expensive' (price over $2,000). Filter your final results using a HAVING clause to only show
category IDs that have more than 5 expensive products. */

select * from production.products;

select category_id, count(product_id) as total_products,
count(case when list_price > 2000 then 1 end) as 'Expensive'
from production.products
group by category_id
having count(case when list_price > 2000 then 1 end) > 5;

/* Order Volume by Seasonal Quarters: Write a query using the orders table to analyze order
volumes based on when they were placed. Use a CASE expression to group the order_date values
into 'First Half' (months January through June) and 'Second Half' (months July through December).
Use a WHERE clause to only look at orders from the year 2018, and use a HAVING clause to
only show halves that processed more than 200 orders */

select count(order_id) as total_orders,
case 
	when month(order_date)>=1 and month(order_date)<=6 then 'First Half'
	when month(order_date)>6 and month(order_date)<=12 then 'Second Half'
	end as 'Year'
from sales.orders
where year(order_date) >=2018
group by case 
	when month(order_date)>=1 and month(order_date)<=6 then 'First Half'
	when month(order_date)>6 and month(order_date)<=12 then 'Second Half'
	end
having count(order_id)>200;


